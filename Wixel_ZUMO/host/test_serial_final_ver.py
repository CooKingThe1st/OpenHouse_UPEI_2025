"""
================= PYTHON TEST CODE WITH OPTITRACK INTEGRATION =================

MINIMAL INTEGRATION:
- Added OptiTrack client (receives positions in background)
- Replace generate_random_position() with optitrack.get_position()
- Everything else IDENTICAL to working code

=====================================================================
"""

import serial
import time
import random
import struct
import sys
import math
import threading
import socket
from datetime import datetime

# Waypoint bridge integration
try:
    from waypoint_bridge import WaypointBridge
    WAYPOINT_BRIDGE_AVAILABLE = True
except ImportError:
    WAYPOINT_BRIDGE_AVAILABLE = False
    print("[WARNING] waypoint_bridge.py not found - 'l' command will not work")

# Workaround: ensure SerialException is defined
try:
    SerialException = serial.SerialException
except Exception:
    try:
        from serial.serialutil import SerialException
    except Exception:
        SerialException = Exception

# ==================== CONFIGURATION ====================

SERIAL_PORT = "COM9"
BAUD_RATE = 9600
SERIAL_TIMEOUT = 1.0

# OptiTrack
OPTITRACK_SERVER_IP = "192.168.0.100"
OPTITRACK_PORT = 5400
OPTITRACK_BUFFER_SIZE = 8192

# Log files
SENT_LOG_FILE = "sent_packets.log"
RECEIVED_LOG_FILE = "received_packets.log"
OPTITRACK_LOG_FILE = "optitrack.log"  # <-- ADDED

# Command definitions
CMD_STOP = 0x10
CMD_GO_TO = 0x11
CMD_PREP = 0x12
CMD_RUN = 0x13
CMD_AUX = 0x14
CMD_CALIBRATE = 0x15  # <-- ADDED

# Protocol definitions
MESSAGE_DELIMITER = 0xFF
BYTES_PER_SLAVE = 16

# Position bounds and resolution
POS_MIN = -3.0
POS_MAX = 3.0
POS_RESOLUTION = 0.01

# Waypoint generation
MAX_WAYPOINTS = 20

# Coordinate system transformation
# Path planner canvas: (0, 0) to (2000, 2000) mm
# Actual workspace: X(-2467 to -105), Y(-347 to -2166) mm
CANVAS_MIN_X = 0.0
CANVAS_MAX_X = 2000.0
CANVAS_MIN_Y = 0.0
CANVAS_MAX_Y = 2000.0

WORKSPACE_MIN_X = -2467.0  # mm
WORKSPACE_MAX_X = -105.0   # mm
WORKSPACE_MIN_Y = -347.0   # mm
WORKSPACE_MAX_Y = -2166.0  # mm

# PREP loop timing
PREP_LOOP_DURATION = 5.0  # <-- NO LONGER USED BY CMD_PREP
PREP_PACKETS_PER_LOOP = 7 # <-- NO LONGER USED BY CMD_PREP

# Background AUX thread
AUX_SEND_INTERVAL = 0.5
AUX_THREAD_RUNNING = True

# ==================== LOGGING FUNCTIONS ====================

def log_sent_packet(packet_data, label=""):
    """Log sent packet to file with hex dump"""
    try:
        with open(SENT_LOG_FILE, 'a') as f:
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
            f.write(f"\n{'='*70}\n")
            f.write(f"[{timestamp}] {label}\n")
            f.write(f"Length: {len(packet_data)} bytes\n")
            
            # Hex dump (16 bytes per line)
            for i in range(0, len(packet_data), 16):
                hex_part = ' '.join(f'{b:02X}' for b in packet_data[i:i+16])
                ascii_part = ''.join(chr(b) if 32 <= b < 127 else '.' for b in packet_data[i:i+16])
                f.write(f"{i:04X}: {hex_part:<48} {ascii_part}\n")
            
            # Decode per-slave packets
            num_slaves = len(packet_data) // BYTES_PER_SLAVE
            for slave_idx in range(num_slaves):
                offset = slave_idx * BYTES_PER_SLAVE
                slave_data = packet_data[offset:offset+BYTES_PER_SLAVE]
                
                addr = slave_data[0]
                x = (slave_data[1] << 8) | slave_data[2]
                y = (slave_data[3] << 8) | slave_data[4]
                theta = slave_data[5]
                cmd = slave_data[6]
                
                # Convert to signed int16
                if x > 32767:
                    x -= 65536
                if y > 32767:
                    y -= 65536
                
                # <-- MODIFIED: Added CMD_CALIBRATE to name lookup
                cmd_name = {
                    0x10: "STOP", 0x11: "GO_TO", 0x12: "PREP", 0x13: "RUN", 0x14: "AUX", 0x15: "CALIBRATE"
                }.get(cmd, f"UNKNOWN(0x{cmd:02X})")
                
                f.write(f"  Slave {slave_idx+1} (ADD=0x{addr:02X}): Pos=({x/1000:.2f}, {y/1000:.2f}, {theta}) CMD={cmd_name}\n")
            f.flush()
    except Exception as e:
        print(f"[LOG ERROR] Failed to write sent log: {e}")

def log_received_data(data, label=""):
    """Log received data to file"""
    try:
        with open(RECEIVED_LOG_FILE, 'a') as f:
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
            f.write(f"[{timestamp}] {label}\n")
            f.write(f"{data}\n")
            f.flush()
    except Exception as e:
        print(f"[LOG ERROR] Failed to write received log: {e}")

# <-- ADDED FUNCTION
def log_optitrack_data(robots):
    """Log received OptiTrack positions to file"""
    try:
        with open(OPTITRACK_LOG_FILE, 'a') as f:
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
            f.write(f"\n@@ {timestamp}\n")
            
            if not robots:
                f.write("No robots detected.\n")
                return

            for robot in robots:
                # Format: robot_id posx posy theta
                f.write(f"{robot['id']}\t{robot['x']:.4f}\t{robot['y']:.4f}\t{robot['rotation']:.2f}\n")
            
            f.flush()
    except Exception as e:
        print(f"[LOG ERROR] Failed to write OptiTrack log: {e}")

def initialize_log_files():
    """Clear log files at startup"""
    try:
        with open(SENT_LOG_FILE, 'w') as f:
            f.write(f"SENT PACKETS LOG - Started at {datetime.now()}\n")
            f.write("="*70 + "\n")
        
        with open(RECEIVED_LOG_FILE, 'w') as f:
            f.write(f"RECEIVED DATA LOG - Started at {datetime.now()}\n")
            f.write("="*70 + "\n")
        
        # <-- ADDED BLOCK
        with open(OPTITRACK_LOG_FILE, 'w') as f:
            f.write(f"OPTITRACK POSITION LOG - Started at {datetime.now()}\n")
            f.write("="*70 + "\n")
        
        print(f"✓ Log files initialized: {SENT_LOG_FILE}, {RECEIVED_LOG_FILE}, {OPTITRACK_LOG_FILE}") # <-- MODIFIED
    except Exception as e:
        print(f"✗ Failed to initialize log files: {e}")

# ==================== OPTITRACK CLIENT ====================

class OptiTrackClient:
    """Connect to OptiTrack server and get real-time position data"""
    
    def __init__(self, server_ip, port):
        self.server_ip = server_ip
        self.port = port
        self.sock = None
        self.connected = False
        self.robot_positions = {}
        self.position_lock = threading.Lock()
        
        # Internal state for print_robots
        self.last_print_time = 0
        self.frame_count = 0
        self.start_time = time.time()
        self.debug = False # Set to True for raw data
    
    def connect(self):
        """Connect to OptiTrack server"""
        try:
            print(f"[OptiTrack] Connecting to {self.server_ip}:{self.port}...")
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.sock.settimeout(5.0)
            self.sock.connect((self.server_ip, self.port))
            self.sock.settimeout(0.5)
            self.connected = True
            print(f"✓ Connected to OptiTrack server!")
            return True
        except Exception as e:
            print(f"✗ OptiTrack connection failed: {e}")
            return False
    
    def disconnect(self):
        """Disconnect from OptiTrack"""
        if self.sock:
            try:
                self.sock.close()
            except:
                pass
        self.connected = False
    
    def parse_robot_data(self, raw_data):
        """Parse OptiTrack format: id,x,y,z,rotation;..."""
        if not raw_data or len(raw_data) < 5:
            return []
        
        try:
            parts = raw_data.split(';')
            robots = []
            seen_robot_ids = set()
            
            for part in parts:
                part = part.strip()
                if not part:
                    continue
                
                values = [v.strip() for v in part.split(',')]
                
                try:
                    if len(values) == 5:
                        robot_id = int(values[0])
# must trust em
                        x = float(values[1])
                        y = float(values[2])
                        z = float(values[3])
                        rotation = float(values[4])
                        
                        if robot_id in seen_robot_ids:
                            continue
                        
                        if any(v != v for v in [x, y, z, rotation]):
                            continue
                        
                        seen_robot_ids.add(robot_id)
                        
                        robot = {
                            'id': robot_id,
                            'x': x,
                            'y': y,
                            'z': z,
                            'rotation': rotation
                        }
                        robots.append(robot)
                
                except (ValueError, IndexError):
                    continue
            
            robots.sort(key=lambda r: r['id'])
            return robots
        
        except Exception as e:
            return []
    

    def print_robots(self, robots, raw_data=""):
        """Print robot positions in a clean format"""
        current_time = time.time()
       
        # Print at most once every 0.1 seconds (10 Hz) to avoid flooding terminal
        if current_time - self.last_print_time < 0.1:
            return
       
        self.last_print_time = current_time
        self.frame_count += 1
       
        # Clear previous lines (for cleaner output)
        # Note: This works on most terminals but might not work on all
        if self.frame_count > 1 and not self.debug:
            # Move cursor up by number of robots + 3 header lines (+ 2 if debug)
            lines_to_clear = len(robots) + 3
            if not robots:
                lines_to_clear = 4 # Header + "No robots" line
            if self.debug and raw_data:
                lines_to_clear += 2  # Raw data takes 2 lines
            sys.stdout.write(f"\033[{lines_to_clear}A")
       
        # Calculate FPS
        elapsed = current_time - self.start_time
        fps = self.frame_count / elapsed if elapsed > 0 else 0
       
        # Print header
        timestamp = datetime.now().strftime("%H:%M:%S.%f")[:-3]
        print(f"[{timestamp}] Frame: {self.frame_count:6d} | FPS: {fps:6.2f} | Robots: {len(robots)}")
        print("-" * 80)
       
        # Debug: Show raw data
        if self.debug and raw_data:
            print(f"RAW: {raw_data[:200]}{'...' if len(raw_data) > 200 else ''}")
            print("-" * 80)
       
        if not robots:
            print("No robots detected ")
        else:
            # Print each robot
            for robot in robots:
                print(f"Robot {robot['id']:2d} | "
                      f"X: {robot['x']:8.4f} | "
                      f"Y: {robot['y']:8.4f} | "
                      f"Z: {robot['z']:8.4f} | "
                      f"Rot: {robot['rotation']:8.2f}°")
       
        print("-" * 80)
        sys.stdout.flush()

    def receive_positions(self):
        """Background thread: receive position updates"""
        print("[OptiTrack Thread] Started - receiving position data...")
        
        while self.connected and AUX_THREAD_RUNNING:
            try:
                data = self.sock.recv(OPTITRACK_BUFFER_SIZE)
                
                if not data:
                    print("[OptiTrack] Server disconnected")
                    self.connected = False
                    break
                
                decoded = data.decode('utf-8', errors='ignore')
                cleaned = decoded.replace('\x00', '').strip()
                
                robots = self.parse_robot_data(cleaned)
                
                # <-- ADDED
                log_optitrack_data(robots)
                
                # You can uncomment this if you want console output too
                # self.print_robots(robots, cleaned if self.debug else "")

                with self.position_lock:
                    self.robot_positions = {r['id']: r for r in robots}
            
            except socket.timeout:
                continue
            except Exception as e:
                print(f"[OptiTrack ERROR] {e}")
                self.connected = False
                break
    
    def get_position(self, robot_id):
        """Get latest position for a robot (thread-safe)"""
        with self.position_lock:
            if robot_id in self.robot_positions:
                pos = self.robot_positions[robot_id]
                return pos['x'], pos['y'], int(pos['rotation'])
        # Fallback if robot_id not found
        return 0.0, 0.0, 0

# ==================== GLOBAL STATE ====================

class SlaveState:
    def __init__(self, slave_id):
        self.slave_id = slave_id
        self.current_cmd = CMD_STOP  # DEFAULT: STOP for all slaves
        self.data = [0] * 14  # Data0-Data13
        self.position_x = 0.0
        self.position_y = 0.0
        self.position_theta = 0
        # Manual override support
        self.manual_override = False
        self.manual_x = 0.0
        self.manual_y = 0.0
        self.manual_theta = 0


    
    def get_packet(self):
        """
        Get 16-byte packet for this slave
        Format: [ADD] [X_high] [X_low] [Y_high] [Y_low] [Theta] [Cmd] [Data0..Data6] [Delimiter]
                [0]   [1]      [2]     [3]      [4]     [5]     [6]   [7..14]        [15]
        
        ---
        MODIFICATION: Corrected comment to reflect Data0-Data7 (8 bytes)
        ---
        """
        packet = bytearray(BYTES_PER_SLAVE)
        
        x_mm = int(self.position_x * 1000)
        y_mm = int(self.position_y * 1000)
        
        packet[0] = self.slave_id                          # ADD
        packet[1] = (x_mm >> 8) & 0xFF                     # X high byte
        packet[2] = x_mm & 0xFF                            # X low byte
        packet[3] = (y_mm >> 8) & 0xFF                     # Y high byte
        packet[4] = y_mm & 0xFF                            # Y low byte
        # --- START CHANGE: MAP RADIANS TO 1 BYTE ---
        
        # Normalize theta to [0, 360) range
        theta_norm_360 = self.position_theta % 360.0
        
        # Convert to radians [0, 2*pi)
        # theta_rad = math.radians(theta_norm_360)
        
        # Map [0, 2*pi) to [0, 255]
        # (Note: 2*pi is approx 6.283185)
        # theta_byte = int((theta_rad / (2.0 * math.pi)) * 255.0)

        # Map [0, 360) to [0, 256)
        # (e.g., 0 -> 0, 359.9 -> 255)
        theta_byte = int((theta_norm_360 / 360.0) * 256.0)
        
        packet[5] = theta_byte & 0xFF                      # Theta (mapped 0-255 from 0-360 degrees)

        # --- END CHANGE ---


        packet[6] = self.current_cmd                       # Cmd
        
        # Data0-Data7 (indices 7-14 in packet, indices 0-7 in self.data array)
        for i in range(8):
            packet[7 + i] = self.data[i] if i < len(self.data) else 0
        
        packet[15] = MESSAGE_DELIMITER                     # Delimiter
        
        return packet

def get_effective_position(slave_index):
    """Return position for a slave (manual override > optitrack > fallback)"""
    slave = slaves[slave_index]
    if slave.manual_override:
        return slave.manual_x, slave.manual_y, slave.manual_theta
    else:
        # Get OptiTrack data for robot ID (index + 1)
        x, y, theta = optitrack.get_position(slave_index + 1)
        
        # Fallback if OptiTrack returns (0,0,0) - e.g. robot not seen
        if x == 0.0 and y == 0.0 and theta == 0:
             # Use last known good position if available
            if slave.position_x != 0.0 or slave.position_y != 0.0:
                return slave.position_x, slave.position_y, slave.position_theta
             # Final fallback
            return 0.0, 0.0, 0
        
        return x, y, theta


# Global slave states
num_slaves = 4
slaves = [SlaveState(i+1) for i in range(4)]
current_r_id = 0

# Waypoint storage
loaded_waypoints = {}

optitrack = None
ser = None
serial_lock = threading.Lock()

# ==================== SERIAL FUNCTIONS ====================

def open_serial_connection():
    """Open and verify serial connection"""
    global ser
    try:
        ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=SERIAL_TIMEOUT)
        time.sleep(2)
        print(f"✓ Connected to {SERIAL_PORT} at {BAUD_RATE} baud")
        return True
    except SerialException as e:
        print(f"✗ Failed to open serial port {SERIAL_PORT}: {e}")
        return False

def send_packet_to_master(packet_data, label=""):
    """Send complete packet to master Wixel (thread-safe)"""
    try:
        with serial_lock:
            if ser and ser.is_open:
                ser.write(packet_data)
                log_sent_packet(packet_data, label)
                # if label:
                #     print(f"✓ [{label}] Sent {len(packet_data)} bytes to master")
                return True
    except SerialException as e:
        print(f"✗ Failed to send packet: {e}")
        return False

def read_serial_response():
    """Read any response from master Wixel"""
    try:
        with serial_lock:
            if ser and ser.is_open and ser.in_waiting > 0:
                response = ser.read(ser.in_waiting).decode('utf-8', errors='ignore')
                if response.strip():
                    print(f"[Master] {response.strip()}")
                    log_received_data(response.strip(), "Master Response")
    except:
        pass

# ==================== POSITION/WAYPOINT GENERATION ====================

def generate_random_position():
    """Generate random position and orientation (fallback if OptiTrack unavailable)"""
    x = round(random.uniform(POS_MIN, POS_MAX), 2)
    y = round(random.uniform(POS_MIN, POS_MAX), 2)
    theta = random.randint(0, 359)
    return x, y, theta

def generate_waypoint():
    """Generate single random waypoint"""
    x = round(random.uniform(POS_MIN, POS_MAX), 2)
    y = round(random.uniform(POS_MIN, POS_MAX), 2)
    return x, y

def waypoint_to_bytes(order, x, y):
    """Convert waypoint to 5 bytes: order, x_high, x_low, y_high, y_low"""
    x_mm = int(x * 1000)
    y_mm = int(y * 1000)
    return [order, (x_mm >> 8) & 0xFF, x_mm & 0xFF, (y_mm >> 8) & 0xFF, y_mm & 0xFF]

def transform_canvas_to_workspace(x_canvas_mm, y_canvas_mm):
    """
    Transform coordinates from path planner canvas to actual workspace.
    
    Canvas coordinate system (path planner):
      - Top-left: (0, 0)
      - Bottom-right: (2000, 2000)
    
    Actual workspace (OptiTrack):
      - Top-left: X=-2467, Y=-347
      - Bottom-right: X=-105, Y=-2166
    
    Args:
        x_canvas_mm: X coordinate from canvas (0 to 2000)
        y_canvas_mm: Y coordinate from canvas (0 to 2000)
    
    Returns:
        (x_workspace_mm, y_workspace_mm): Transformed coordinates in workspace
    """
    # Linear interpolation from canvas range to workspace range
    # x_workspace = map(x_canvas, [0, 2000] -> [-2467, -105])
    x_workspace_mm = WORKSPACE_MIN_X + (x_canvas_mm - CANVAS_MIN_X) * \
                     (WORKSPACE_MAX_X - WORKSPACE_MIN_X) / (CANVAS_MAX_X - CANVAS_MIN_X)
    
    # y_workspace = map(y_canvas, [0, 2000] -> [-347, -2166])
    y_workspace_mm = WORKSPACE_MIN_Y + (y_canvas_mm - CANVAS_MIN_Y) * \
                     (WORKSPACE_MAX_Y - WORKSPACE_MIN_Y) / (CANVAS_MAX_Y - CANVAS_MIN_Y)
    
    return x_workspace_mm, y_workspace_mm

# ==================== COMMAND HANDLERS ====================

def update_all_slave_positions():
    """Update positions for ALL slaves from effective source"""
    for i in range(num_slaves):
        slaves[i].position_x, slaves[i].position_y, slaves[i].position_theta = get_effective_position(i)

def build_and_send(label=""):
    """Update all positions, build complete packet, and send it"""
    update_all_slave_positions()
    
    complete_packet = bytearray()
    for s in slaves:
        complete_packet.extend(s.get_packet())
        
    send_packet_to_master(complete_packet, label)
    if label:
        print(f"✓ [{label}] Sent {len(complete_packet)} bytes")

def cmd_stop():
    """Press 'a': STOP current robot, increment r_id"""
    global current_r_id
    
    slaves[current_r_id].current_cmd = CMD_STOP
    slaves[current_r_id].data = [0] * 14
    
    print(f"\n[CMD_STOP] Robot {current_r_id + 1} STOP")
    build_and_send(f"CMD_STOP (Robot {current_r_id + 1})")

def cmd_select_next_robot():
    """Press 's': Select next robot"""
    global current_r_id
    current_r_id = (current_r_id + 1) % num_slaves
    print(f"\n[SELECT] Current target: Robot {current_r_id + 1}")

def cmd_go_to_origin():
    """Press 'f': GO_TO origin (0, 0)"""
    global current_r_id
    
    target_x = 0.0
    target_y = 0.0
    
    x_mm = int(target_x * 1000)
    y_mm = int(target_y * 1000)
    
    slaves[current_r_id].current_cmd = CMD_GO_TO
    slaves[current_r_id].data = [0] * 14 # Clear data first
    slaves[current_r_id].data[0] = (x_mm >> 8) & 0xFF
    slaves[current_r_id].data[1] = x_mm & 0xFF
    slaves[current_r_id].data[2] = (y_mm >> 8) & 0xFF
    slaves[current_r_id].data[3] = y_mm & 0xFF
    
    # Get current position for logging
    x_now, y_now, _ = get_effective_position(current_r_id)
    
    print(f"\n[CMD_GO_TO] Robot {current_r_id + 1} -> Origin (0.00, 0.00)")
    print(f"  Current position: x: {x_now:.2f}, y: {y_now:.2f}")
    
    build_and_send(f"CMD_GO_TO_ORIGIN (Robot {current_r_id + 1})")

def cmd_prep():
    """Press 'j': PREP mode - send 20 waypoints (from loaded data or fallback rectangle)."""
    global current_r_id, loaded_waypoints
    
    robot_id = current_r_id + 1
    waypoints = []
    
    # Check if we have loaded waypoints for this robot
    if robot_id in loaded_waypoints and loaded_waypoints[robot_id]:
        print(f"\n[CMD_PREP] Robot {robot_id} - Using LOADED waypoints from path planner")
        
        loaded = loaded_waypoints[robot_id]
        
        # Use loaded waypoints (already in format: (order, x_mm, y_mm))
        for i in range(min(len(loaded), MAX_WAYPOINTS)):
            order, x_mm, y_mm = loaded[i]
            
            # Transform from canvas coordinates to actual workspace coordinates
            x_workspace_mm, y_workspace_mm = transform_canvas_to_workspace(x_mm, y_mm)
            
            # Convert mm to meters
            x_m = x_workspace_mm / 1000.0
            y_m = y_workspace_mm / 1000.0
            waypoints.append((order, x_m, y_m))
        
        # Pad with last waypoint if needed
        if len(waypoints) < MAX_WAYPOINTS:
            last_order, last_x, last_y = waypoints[-1]
            for i in range(len(waypoints), MAX_WAYPOINTS):
                waypoints.append((i, last_x, last_y))
    
    else:
        # Fallback: Use rectangle pattern
        print(f"\n[CMD_PREP] Robot {robot_id} - Using FALLBACK rectangle waypoints")
        print("  (Use 'l' to load waypoints from path planner)")
        
        # Define the rectangle bounds
        x_min, y_min = -0.5, -0.5
        x_max, y_max = 0.5, 0.5
        x_mid = round((x_min + x_max) / 2.0, 2)
        y_mid = round((y_min + y_max) / 2.0, 2)

        distinct_waypoints_coords = [
            (x_min, y_min),
            (x_min, y_mid),
            (x_min, y_max),
            (x_mid, y_max),
            (x_max, y_max),
            (x_max, y_mid),
            (x_max, y_min),
            (x_mid, y_min)
        ]
        
        for i in range(len(distinct_waypoints_coords)):
            x, y = distinct_waypoints_coords[i]
            x = round(x, 2)
            y = round(y, 2)
            waypoints.append((i, x, y))

        last_x, last_y = distinct_waypoints_coords[-1]
        last_x = round(last_x, 2)
        last_y = round(last_y, 2)

        for i in range(len(distinct_waypoints_coords), MAX_WAYPOINTS):
            waypoints.append((i, last_x, last_y))
    
    # Send waypoints (1 per packet)
    print(f"Sending {MAX_WAYPOINTS} waypoints (1 per packet)...")
    
    slaves[current_r_id].current_cmd = CMD_PREP

    packet_count = 0
    
    for packet_idx in range(MAX_WAYPOINTS):
        waypoint_data = []
        
        order, x, y = waypoints[packet_idx]
        waypoint_data.extend(waypoint_to_bytes(order, x, y))
        
        while len(waypoint_data) < 14:
            waypoint_data.append(0)
        
        slaves[current_r_id].data = waypoint_data[:14]
        
        build_and_send(f"CMD_PREP packet {packet_idx + 1}/{MAX_WAYPOINTS}")
        packet_count += 1
        
        time.sleep(0.1)
    
    print(f"[PREP Complete] Sent {packet_count} packets with waypoints")

def cmd_run():
    """Press 'k': RUN operation"""
    global current_r_id
    
    slaves[current_r_id].current_cmd = CMD_RUN
    slaves[current_r_id].data = [0] * 14
    
    print(f"\n[CMD_RUN] Robot {current_r_id + 1} START execution")
    build_and_send(f"CMD_RUN (Robot {current_r_id + 1})")

# <-- ADDED FUNCTION
def cmd_calibrate():
    """Press 'c': CALIBRATE current robot"""
    global current_r_id
    
    slaves[current_r_id].current_cmd = CMD_CALIBRATE
    slaves[current_r_id].data = [0] * 14
    
    print(f"\n[CMD_CALIBRATE] Robot {current_r_id + 1} START calibration sequence")
    build_and_send(f"CMD_CALIBRATE (Robot {current_r_id + 1})")

def cmd_load_waypoints():
    """Press 'l': Load waypoints from waypoint_bridge"""
    global loaded_waypoints
    
    if not WAYPOINT_BRIDGE_AVAILABLE:
        print("\n✗ [LOAD ERROR] waypoint_bridge.py not found!")
        print("  Make sure waypoint_bridge.py is in the same directory.")
        return
    
    try:
        bridge = WaypointBridge()
        loaded_waypoints = bridge.load()
        
        if not loaded_waypoints:
            print("\n✗ [LOAD ERROR] No waypoints found in waypoints.json")
            print("  Run the path planner and export waypoints first.")
            return
        
        print(f"\n✓ [LOAD SUCCESS] Loaded waypoints for {len(loaded_waypoints)} robot(s)")
        for robot_id in sorted(loaded_waypoints.keys()):
            waypoints = loaded_waypoints[robot_id]
            print(f"  Robot {robot_id}: {len(waypoints)} waypoints")
        
        print("\n→ Use '9' to send robots to first waypoint")
        print("→ Use '8' to PREP all robots, or 'j' to PREP current robot")
        
    except FileNotFoundError:
        print("\n✗ [LOAD ERROR] waypoints.json not found!")
        print("  Run the path planner and click 'Send to Robots' first.")
    except Exception as e:
        print(f"\n✗ [LOAD ERROR] {e}")

# <-- ADDED FUNCTION
def cmd_go_to_first_waypoints():
    """Press '9': Send all robots to their first loaded waypoint"""
    global loaded_waypoints
    
    if not loaded_waypoints:
        print("\n✗ [GO_TO_FIRST_WP ERROR] No waypoints loaded!")
        print("  Use 'l' to load waypoints first.")
        return
    
    print(f"\n[CMD_GO_TO_FIRST_WP] Sending all {num_slaves} robots to their first waypoint...")
    
    for i in range(num_slaves):
        robot_id = i + 1
        
        if robot_id in loaded_waypoints and loaded_waypoints[robot_id]:
            # Get the first waypoint: (order, x_mm_canvas, y_mm_canvas)
            try:
                order, x_mm_canvas, y_mm_canvas = loaded_waypoints[robot_id][0]
                
                # Transform from canvas coordinates to actual workspace coordinates
                x_workspace_mm, y_workspace_mm = transform_canvas_to_workspace(x_mm_canvas, y_mm_canvas)
                
                # Packet needs mm
                x_mm_packet = int(x_workspace_mm)
                y_mm_packet = int(y_workspace_mm)

                slaves[i].current_cmd = CMD_GO_TO
                slaves[i].data = [0] * 14
                slaves[i].data[0] = (x_mm_packet >> 8) & 0xFF
                slaves[i].data[1] = x_mm_packet & 0xFF
                slaves[i].data[2] = (y_mm_packet >> 8) & 0xFF
                slaves[i].data[3] = y_mm_packet & 0xFF
                
                print(f"  Robot {robot_id} -> First WP ({x_workspace_mm/1000.0:.3f}m, {y_workspace_mm/1000.0:.3f}m)")
            
            except Exception as e:
                print(f"  ✗ Robot {robot_id}: Error processing waypoint data: {e}. Sending STOP.")
                slaves[i].current_cmd = CMD_STOP
                slaves[i].data = [0] * 14
        else:
            print(f"  ⚠ Robot {robot_id}: No waypoints found, sending STOP")
            slaves[i].current_cmd = CMD_STOP
            slaves[i].data = [0] * 14

    # Send all in single packet
    build_and_send(f"CMD_GO_TO_FIRST_WP (All {num_slaves} robots)")
    
    print(f"✓ [GO_TO_FIRST_WP Complete] All robots sent to destinations!")


def cmd_prep_all():
    """Press '8': PREP ALL robots with loaded waypoints"""
    global loaded_waypoints
    
    if not loaded_waypoints:
        print("\n✗ [PREP_ALL ERROR] No waypoints loaded!")
        print("  Use 'l' to load waypoints first.")
        return
    
    print(f"\n[CMD_PREP_ALL] Sending PREP to ALL {num_slaves} robots with loaded waypoints...")
    
    for i in range(num_slaves):
        robot_id = i + 1
        
        if robot_id not in loaded_waypoints:
            print(f"  ⚠ Robot {robot_id}: No waypoints found, skipping")
            continue
        
        waypoints = loaded_waypoints[robot_id]
        
        if len(waypoints) < MAX_WAYPOINTS:
            print(f"  ⚠ Robot {robot_id}: Only {len(waypoints)} waypoints (expected {MAX_WAYPOINTS})")
        
        print(f"\n  Robot {robot_id}: Sending {min(len(waypoints), MAX_WAYPOINTS)} waypoints...")
        
        # Set PREP mode for this slave
        slaves[i].current_cmd = CMD_PREP
        
        # Send waypoints (1 per packet)
        for packet_idx in range(min(len(waypoints), MAX_WAYPOINTS)):
            waypoint_data = []
            
            # Get waypoint (order, x_mm, y_mm)
            order, x_mm, y_mm = waypoints[packet_idx]
            
            # Transform from canvas coordinates to actual workspace coordinates
            x_workspace_mm, y_workspace_mm = transform_canvas_to_workspace(x_mm, y_mm)
            
            # Convert mm to meters for waypoint_to_bytes
            x_m = x_workspace_mm / 1000.0
            y_m = y_workspace_mm / 1000.0
            
            waypoint_data.extend(waypoint_to_bytes(order, x_m, y_m))
            
            # Pad to 14 bytes
            while len(waypoint_data) < 14:
                waypoint_data.append(0)
            
            slaves[i].data = waypoint_data[:14]
            
            build_and_send(f"PREP_ALL Robot {robot_id} packet {packet_idx + 1}/{MAX_WAYPOINTS}")
            
            time.sleep(0.05)  # 50ms delay between packets
        
        print(f"  ✓ Robot {robot_id}: PREP complete")
    
    print(f"\n✓ [PREP_ALL Complete] All robots prepared!")
    print("→ Use '7' to RUN all robots simultaneously")

def cmd_run_all():
    """Press '7': RUN ALL robots simultaneously (no bias!)"""
    print(f"\n[CMD_RUN_ALL] Sending RUN command to ALL {num_slaves} robots simultaneously...")
    
    # Set CMD_RUN for all slaves
    for i in range(num_slaves):
        slaves[i].current_cmd = CMD_RUN
        slaves[i].data = [0] * 14
    
    # Send all in single packet
    build_and_send(f"CMD_RUN_ALL (All {num_slaves} robots)")
    
    print(f"✓ [RUN_ALL Complete] All {num_slaves} robots executing simultaneously!")
    print("  (All robots start at EXACTLY the same time - zero bias!)")

def cmd_stop_all():
    """Press '6': STOP ALL robots simultaneously"""
    print(f"\n[CMD_STOP_ALL] Sending STOP command to ALL {num_slaves} robots...")
    
    # Set CMD_STOP for all slaves
    for i in range(num_slaves):
        slaves[i].current_cmd = CMD_STOP
        slaves[i].data = [0] * 14
    
    # Send all in single packet
    build_and_send(f"CMD_STOP_ALL (All {num_slaves} robots)")
    
    print(f"✓ [STOP_ALL Complete] All {num_slaves} robots stopped!")

def cmd_home_all():
    """Press 'h': Send HOME (GO_TO origin) command to ALL robots"""
    print(f"\n[CMD_HOME_ALL] Sending all {num_slaves} robots to origin (0, 0)...")
    
    target_x = 0.0
    target_y = 0.0
    x_mm = int(target_x * 1000)
    y_mm = int(target_y * 1000)
    
    # Set CMD_GO_TO for all slaves with target (0, 0)
    for i in range(num_slaves):
        slaves[i].current_cmd = CMD_GO_TO
        slaves[i].data = [0] * 14
        slaves[i].data[0] = (x_mm >> 8) & 0xFF
        slaves[i].data[1] = x_mm & 0xFF
        slaves[i].data[2] = (y_mm >> 8) & 0xFF
        slaves[i].data[3] = y_mm & 0xFF
    
    # Send all in single packet
    build_and_send(f"CMD_HOME_ALL (All {num_slaves} robots to origin)")
    
    print(f"✓ [HOME_ALL Complete] All {num_slaves} robots going to origin (0, 0)!")

# <-- ADDED FUNCTION
def cmd_go_to_corners():
    """Press 'g': Send ALL robots to the 4 workspace corners"""
    print(f"\n[CMD_GO_TO_CORNERS] Sending all {num_slaves} robots to workspace corners...")

    # Targets are in METERS (converted from mm constants)
    targets_m = [
        (WORKSPACE_MIN_X / 1000.0, WORKSPACE_MIN_Y / 1000.0), # Robot 1 (index 0)
        (WORKSPACE_MAX_X / 1000.0, WORKSPACE_MIN_Y / 1000.0), # Robot 2 (index 1)
        (WORKSPACE_MAX_X / 1000.0, WORKSPACE_MAX_Y / 1000.0), # Robot 3 (index 2)
        (WORKSPACE_MIN_X / 1000.0, WORKSPACE_MAX_Y / 1000.0)  # Robot 4 (index 3)
    ]
    
    if num_slaves > len(targets_m):
        print(f"  [WARNING] More slaves ({num_slaves}) than defined corners ({len(targets_m)}).")
        print(f"  Only the first {len(targets_m)} robots will be sent to corners.")

    # Set CMD_GO_TO for all slaves with their respective corner
    for i in range(num_slaves):
        if i < len(targets_m):
            target_x, target_y = targets_m[i]
            x_mm = int(target_x * 1000)
            y_mm = int(target_y * 1000)
            
            slaves[i].current_cmd = CMD_GO_TO
            slaves[i].data = [0] * 14
            slaves[i].data[0] = (x_mm >> 8) & 0xFF
            slaves[i].data[1] = x_mm & 0xFF
            slaves[i].data[2] = (y_mm >> 8) & 0xFF
            slaves[i].data[3] = y_mm & 0xFF
            print(f"  Robot {i+1} -> ({target_x:.3f}m, {target_y:.3f}m)")
        else:
            # Stop any extra robots (e.g., if num_slaves > 4)
            slaves[i].current_cmd = CMD_STOP
            slaves[i].data = [0] * 14
            print(f"  Robot {i+1} -> STOP (no corner defined)")

    # Send all in single packet
    build_and_send(f"CMD_GO_TO_CORNERS (All {num_slaves} robots)")
    
    print(f"✓ [GO_TO_CORNERS Complete] All robots sent to destinations!")


def cmd_manual_update(x, y, theta=None):
    """Manual override: persistently override current robot position"""
    global current_r_id

    s = slaves[current_r_id]
    s.manual_override = True
    s.manual_x = x
    s.manual_y = y
    if theta is not None:
        s.manual_theta = int(theta) % 360

    print(f"\n[MANUAL OVERRIDE] Robot {current_r_id + 1} → ({x:.2f}, {y:.2f}) "
          f"{'(θ='+str(s.manual_theta)+'°)' if theta is not None else ''}")
    print("This override will persist and affect all future AUX/command packets.")
    print("Use 'm 0 0' and 's' to cycle all robots to clear.")
    
    # Immediately send updated packet
    build_and_send(f"MANUAL_OVERRIDE (Robot {current_r_id + 1})")

def cmd_aux_manual_pwm(pwm_left, pwm_right):
    """Send AUX 0x1F: Manual PWM for 2 seconds"""
    global current_r_id
    
    # Clamp values to valid range
    pwm_left = max(-255, min(255, pwm_left))
    pwm_right = max(-255, min(255, pwm_right))
    
    # Convert to signed int16 bytes
    pwm_left_bytes = pwm_left.to_bytes(2, byteorder='big', signed=True)
    pwm_right_bytes = pwm_right.to_bytes(2, byteorder='big', signed=True)
    
    slaves[current_r_id].current_cmd = CMD_AUX
    slaves[current_r_id].data = [0] * 14
    slaves[current_r_id].data[0] = 0x1F  # Sub-command
    slaves[current_r_id].data[1] = pwm_left_bytes[0]   # PWM_left high
    slaves[current_r_id].data[2] = pwm_left_bytes[1]   # PWM_left low
    slaves[current_r_id].data[3] = pwm_right_bytes[0]  # PWM_right high
    slaves[current_r_id].data[4] = pwm_right_bytes[1]  # PWM_right low
    
    print(f"\n[AUX 0x1F] Robot {current_r_id + 1} Manual PWM: L={pwm_left}, R={pwm_right} (2 sec)")
    print("→ Watch for YELLOW LED on robot (ON=running, OFF=done)")
    build_and_send(f"AUX_MANUAL_PWM (Robot {current_r_id + 1})")

    # ✓ CRITICAL: Clear data immediately to prevent background thread repetition
    slaves[current_r_id].data = [0] * 14
    print("→ Command sent once, cleared from buffer")


# <-- REMOVED FUNCTION cmd_aux_set_offset
# <-- REMOVED FUNCTION cmd_aux_backdoor


# ==================== BACKGROUND AUX THREAD ====================
def background_aux_thread():
    """Background thread: Send AUX commands every ~200ms"""
    global AUX_THREAD_RUNNING
    
    print(f"\n[AUX THREAD] Started - Sending position updates (0x9F) every {AUX_SEND_INTERVAL}s")
    
    while AUX_THREAD_RUNNING:
        try:
            # Update positions for all slaves first
            update_all_slave_positions()
            
            complete_packet = bytearray()
            
            for s in slaves:
                # === KEY FIX: Only keep GO_TO/RUN/PREP for ONE cycle, then revert to AUX ===
                
                # <-- MODIFIED: Added CMD_CALIBRATE to this list
                if s.current_cmd in [CMD_GO_TO, CMD_RUN, CMD_CALIBRATE]:
                    # This command was just sent by main thread.
                    # Revert it to a standard AUX update
                    s.current_cmd = CMD_AUX
                    s.data = [0] * 14
                    s.data[0] = 0x9F  # Standard AUX sub-command
                elif s.current_cmd == CMD_PREP:
                    # PREP mode is sticky, it stays until explicitly changed
                    # The main thread handles sending PREP packets
                    # The AUX thread just respects the PREP state
                    pass
                else:
                    # Normal AUX updates (handles CMD_STOP, CMD_AUX)
                    s.current_cmd = CMD_AUX
                    s.data = [0] * 14
                    s.data[0] = 0x9F  # Standard AUX sub-command
                
                complete_packet.extend(s.get_packet())
            
            send_packet_to_master(complete_packet, "AUX (Background 0x9F)")
            
            time.sleep(AUX_SEND_INTERVAL)
        
        except Exception as e:
            print(f"[AUX THREAD ERROR] {e}")
            time.sleep(AUX_SEND_INTERVAL)

# ==================== MAIN LOOP ====================

def print_menu():
    """Print command menu"""
    print("\n" + "="*60)
    print("MASTER WIXEL + OPTITRACK + WAYPOINT BRIDGE")
    print("="*60)
    print(f"Current Mode: {num_slaves} slaves | Target Robot: {current_r_id + 1}")
    print(f"OptiTrack: {OPTITRACK_SERVER_IP}:{OPTITRACK_PORT}")
    print(f"Logs: {SENT_LOG_FILE}, {RECEIVED_LOG_FILE}, {OPTITRACK_LOG_FILE}")
    print(f"Waypoint Bridge: {'✓ Available' if WAYPOINT_BRIDGE_AVAILABLE else '✗ Not found'}")
    print("\nKeyboard Commands:")
    print("  --- Waypoint Workflow ---")
    print("  'l' : LOAD waypoints from path planner (waypoints.json)")
    print("  '9' : GO_TO First Waypoint (all robots)") # <-- ADDED
    print("  '8' : PREP ALL robots with loaded waypoints (batch)")
    print("  '7' : RUN ALL robots simultaneously (zero bias!)")
    print("  '6' : STOP ALL robots immediately")
    print("  'h' : HOME ALL robots (send all to origin 0,0)")
    print("  'g' : GO_TO Corners (all robots to 4 corners)")
    print("\n  --- Single Robot Commands ---")
    print("  'a' : STOP current robot")
    print("  's' : Select next robot")
    print("  'f' : GO_TO origin (0, 0)")
    print("  'j' : PREP current robot (uses loaded waypoints or fallback rectangle)")
    print("  'k' : RUN current robot")
    print("  'c' : CALIBRATE current robot (auto-finds offset)")
    print("\n  --- Advanced ---")
    # <-- REMOVED '5'
    print("  'p <L> <R>' : Manual PWM command (e.g., 'p 100 100')")
    # <-- REMOVED 'o'
    print("  'm <X> <Y> [T]': Manual position override (e.g. 'm 1.0 -0.5 90')")
    print("  'q' : Quit")
    print(f"\n[Background] AUX thread sends updates every {AUX_SEND_INTERVAL*1000:.0f}ms")
    print("[OptiTrack] Real positions integrated")
    print("\n💡 Quick Workflow: l → 9 → 8 → 7 (Load, Go to Start, PREP all, RUN all)") # <-- MODIFIED
    print("="*60 + "\n")

def main():
    """Main function"""
    global num_slaves, current_r_id, AUX_THREAD_RUNNING, optitrack
    
    # Initialize log files
    initialize_log_files()
    
    # Connect to OptiTrack
    optitrack = OptiTrackClient(OPTITRACK_SERVER_IP, OPTITRACK_PORT)
    if not optitrack.connect():
        print("[WARNING] OptiTrack connection failed - will use (0,0,0) fallback")
    
    # Start OptiTrack receiver thread
    optitrack_thread = threading.Thread(target=optitrack.receive_positions, daemon=True)
    optitrack_thread.start()
    time.sleep(1) # Give OptiTrack time to connect and get first data
    
    # Open serial connection
    if not open_serial_connection():
        if optitrack:
            optitrack.disconnect()
        sys.exit(1)
    
    print_menu()
    
    # Start background AUX thread
    aux_thread = threading.Thread(target=background_aux_thread, daemon=True)
    aux_thread.start()
    
    try:
        while True:
            read_serial_response()
            
            try:
                cmd = input("Enter command: ").strip().lower()

                if cmd == 'a':
                    cmd_stop()
                elif cmd == 's':
                    cmd_select_next_robot()
                elif cmd == 'f':
                    cmd_go_to_origin()
                elif cmd == 'j':
                    cmd_prep()
                elif cmd == 'k':
                    cmd_run()
                elif cmd == 'c':
                    cmd_calibrate()
                elif cmd == 'l':
                    cmd_load_waypoints()
                elif cmd == '9': # <-- ADDED
                    cmd_go_to_first_waypoints()
                elif cmd == '8':
                    cmd_prep_all()
                elif cmd == '7':
                    cmd_run_all()
                elif cmd == '6':
                    cmd_stop_all()
                elif cmd == 'h':
                    cmd_home_all()
                elif cmd == 'g':
                    cmd_go_to_corners()
                # <-- REMOVED '5'
                elif cmd.startswith('p '):
                    parts = cmd.split()
                    try:
                        if len(parts) == 3:
                            pwm_l, pwm_r = int(parts[1]), int(parts[2])
                            cmd_aux_manual_pwm(pwm_l, pwm_r)
                        else:
                            print("✗ Usage: p <pwm_left> <pwm_right>")
                            print("  Example: p 100 100")
                    except ValueError:
                        print("✗ Invalid numbers. Usage: p <pwm_left> <pwm_right>")

                # <-- REMOVED 'o'

                elif cmd.startswith('m '):
                    parts = cmd.split()
                    try:
                        if len(parts) == 3:
                            x, y = float(parts[1]), float(parts[2])
                            cmd_manual_update(x, y)
                        elif len(parts) == 4:
                            x, y, theta = float(parts[1]), float(parts[2]), float(parts[3])
                            cmd_manual_update(x, y, theta)
                        else:
                            print("✗ Usage: m <x> <y> [theta]")
                    except ValueError:
                        print("✗ Invalid numbers. Usage: m <x> <y> [theta]")
                elif cmd == 'q':
                    print("\n✓ Exiting...")
                    break
                else:
                    if cmd: # Don't print error for empty input
                        print("✗ Invalid command. Try again.")

            
            except KeyboardInterrupt:
                print("\n✓ Interrupted by user")
                break
    
    finally:
        print("\nShutting down...")
        AUX_THREAD_RUNNING = False
        
        if optitrack:
            optitrack.disconnect()
            print("✓ OptiTrack connection closed")
        
        if ser and ser.is_open:
            ser.close()
            print("✓ Serial connection closed")
        
        # Wait for threads to stop
        time.sleep(0.5) 
        
        print(f"\n✓ Check logs: {SENT_LOG_FILE}, {RECEIVED_LOG_FILE}, {OPTITRACK_LOG_FILE}")
        print("✓ Shutdown complete.")

if __name__ == "__main__":
    main()