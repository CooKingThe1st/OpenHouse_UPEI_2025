"""
================= PYTHON TEST CODE WITH LOGGING =================

Added features:
- Log all SENT packets to "sent_packets.log"
- Log all RECEIVED responses to "received_packets.log"
- Hex dump format for easier debugging
- Timestamp for each entry

=====================================================================
"""

import serial
import time
import random
import struct
import sys
import threading
from datetime import datetime


# Workaround: ensure SerialException is defined
try:
    SerialException = serial.SerialException
except Exception:
    try:
        from serial.serialutil import SerialException  # type: ignore
    except Exception:
        SerialException = Exception

# ==================== CONFIGURATION ====================

SERIAL_PORT = "COM9"          # Change to your COM port
BAUD_RATE = 9600
SERIAL_TIMEOUT = 1.0

# Log files
SENT_LOG_FILE = "sent_packets.log"
RECEIVED_LOG_FILE = "received_packets.log"

# Command definitions
CMD_STOP = 0x10
CMD_GO_TO = 0x11
CMD_PREP = 0x12
CMD_RUN = 0x13
CMD_AUX = 0x14

# Protocol definitions
MESSAGE_DELIMITER = 0xFF
BYTES_PER_SLAVE = 16

# Position bounds and resolution
POS_MIN = -3.0
POS_MAX = 3.0
POS_RESOLUTION = 0.01

# Waypoint generation
MAX_WAYPOINTS = 20

# PREP loop timing
PREP_LOOP_DURATION = 5.0
PREP_PACKETS_PER_LOOP = 7

# Background AUX thread
AUX_SEND_INTERVAL = 1.0
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
                
                cmd_name = {0x10: "STOP", 0x11: "GO_TO", 0x12: "PREP", 0x13: "RUN", 0x14: "AUX"}.get(cmd, f"UNKNOWN(0x{cmd:02X})")
                
                f.write(f"  Slave {slave_idx+1} (ADD=0x{addr:02X}): Pos=({x/100:.2f}, {y/100:.2f}, {theta}°) CMD={cmd_name}\n")
            
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

def initialize_log_files():
    """Clear log files at startup"""
    try:
        with open(SENT_LOG_FILE, 'w') as f:
            f.write(f"SENT PACKETS LOG - Started at {datetime.now()}\n")
            f.write("="*70 + "\n")
        
        with open(RECEIVED_LOG_FILE, 'w') as f:
            f.write(f"RECEIVED DATA LOG - Started at {datetime.now()}\n")
            f.write("="*70 + "\n")
        
        print(f"✓ Log files initialized: {SENT_LOG_FILE}, {RECEIVED_LOG_FILE}")
    except Exception as e:
        print(f"✗ Failed to initialize log files: {e}")

# ==================== GLOBAL STATE ====================
class SlaveState:
    def __init__(self, slave_id):
        self.slave_id = slave_id
        self.current_cmd = CMD_STOP  # DEFAULT: STOP for all slaves
        self.data = [0] * 14  # Data0-Data13
        self.position_x = 0.0
        self.position_y = 0.0
        self.position_theta = 0
    
    def get_packet(self):
        """
        Get 16-byte packet for this slave
        Format: [ADD] [X_high] [X_low] [Y_high] [Y_low] [Theta] [Cmd] [Data3..Data13] [Delimiter]
                [0]   [1]      [2]     [3]      [4]     [5]     [6]   [7..13]        [15]
        """
        packet = bytearray(BYTES_PER_SLAVE)
        
        x_mm = int(self.position_x * 100)
        y_mm = int(self.position_y * 100)
        
        packet[0] = self.slave_id                          # ADD
        packet[1] = (x_mm >> 8) & 0xFF                     # X high byte
        packet[2] = x_mm & 0xFF                            # X low byte
        packet[3] = (y_mm >> 8) & 0xFF                     # Y high byte
        packet[4] = y_mm & 0xFF                            # Y low byte
        packet[5] = self.position_theta & 0xFF             # Theta
        packet[6] = self.current_cmd                       # Cmd
        
        # Data3-Data13 (indices 7-14 in packet, indices 0-7 in self.data array)
        for i in range(8):
            packet[7 + i] = self.data[i] if i < len(self.data) else 0
        
        packet[15] = MESSAGE_DELIMITER                     # Delimiter
        
        return packet


# Global slave states
num_slaves = 3
slaves = [SlaveState(i+1) for i in range(4)]
current_r_id = 0

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
                if label:
                    print(f"✓ [{label}] Sent {len(packet_data)} bytes to master")
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
    """Generate random position and orientation (mimicking OptiTrack)"""
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
    x_mm = int(x * 100)
    y_mm = int(y * 100)
    return [order, (x_mm >> 8) & 0xFF, x_mm & 0xFF, (y_mm >> 8) & 0xFF, y_mm & 0xFF]

# ==================== COMMAND HANDLERS ====================

def cmd_stop():
    """Press 'a': STOP current robot, increment r_id"""
    global current_r_id
    
    slaves[current_r_id].current_cmd = CMD_STOP
    slaves[current_r_id].data = [0] * 14
    
    # Build and send complete packet
    complete_packet = bytearray()
    for i in range(num_slaves):
        slaves[i].position_x, slaves[i].position_y, slaves[i].position_theta = generate_random_position()
        complete_packet.extend(slaves[i].get_packet())
    
    print(f"\n[CMD_STOP] Robot {current_r_id + 1} STOP")
    send_packet_to_master(complete_packet, f"CMD_STOP (Robot {current_r_id + 1})")
    
    current_r_id = (current_r_id + 1) % num_slaves
    print(f"[Next Target] Robot {current_r_id + 1}")

def cmd_go_to():
    """Press 'f': GO_TO random location"""
    global current_r_id
    
    target_x, target_y = generate_waypoint()
    
    x_mm = int(target_x * 100)
    y_mm = int(target_y * 100)
    
    slaves[current_r_id].current_cmd = CMD_GO_TO
    slaves[current_r_id].data[0] = (x_mm >> 8) & 0xFF
    slaves[current_r_id].data[1] = x_mm & 0xFF
    slaves[current_r_id].data[2] = (y_mm >> 8) & 0xFF
    slaves[current_r_id].data[3] = y_mm & 0xFF
    
    complete_packet = bytearray()
    for i in range(num_slaves):
        slaves[i].position_x, slaves[i].position_y, slaves[i].position_theta = generate_random_position()
        complete_packet.extend(slaves[i].get_packet())
    
    print(f"\n[CMD_GO_TO] Robot {current_r_id + 1} -> ({target_x:.2f}, {target_y:.2f})")
    send_packet_to_master(complete_packet, f"CMD_GO_TO (Robot {current_r_id + 1})")

def cmd_prep():
    """Press 'j': PREP mode - send 20 waypoints over 5 seconds"""
    global current_r_id
    
    waypoints = []
    for i in range(MAX_WAYPOINTS):
        x, y = generate_waypoint()
        waypoints.append((i, x, y))
    
    print(f"\n[CMD_PREP] Robot {current_r_id + 1} - Preparing 20 waypoints for 5 seconds...")
    
    start_time = time.time()
    packet_count = 0
    
    while (time.time() - start_time) < PREP_LOOP_DURATION:
        for packet_idx in range(PREP_PACKETS_PER_LOOP):
            waypoints_in_packet = 3 if packet_idx < 6 else 2
            
            waypoint_data = []
            for wp_idx in range(waypoints_in_packet):
                global_wp_idx = (packet_idx * 3 + wp_idx) % MAX_WAYPOINTS
                order, x, y = waypoints[global_wp_idx]
                waypoint_data.extend(waypoint_to_bytes(order, x, y))
            
            while len(waypoint_data) < 10:
                waypoint_data.append(0)
            
            slaves[current_r_id].current_cmd = CMD_PREP
            slaves[current_r_id].data = waypoint_data[:10]
            slaves[current_r_id].data.append(0)
            slaves[current_r_id].data.extend([0] * 3)
            
            complete_packet = bytearray()
            for i in range(num_slaves):
                slaves[i].position_x, slaves[i].position_y, slaves[i].position_theta = generate_random_position()
                complete_packet.extend(slaves[i].get_packet())
            
            send_packet_to_master(complete_packet, f"CMD_PREP packet {packet_count+1}")
            packet_count += 1
            
            time.sleep(0.1)
            
            if (time.time() - start_time) >= PREP_LOOP_DURATION:
                break
    
    print(f"[PREP Complete] Sent {packet_count} packets with waypoints")

def cmd_run():
    """Press '9': RUN operation"""
    global current_r_id
    
    slaves[current_r_id].current_cmd = CMD_RUN
    slaves[current_r_id].data = [0] * 14
    
    complete_packet = bytearray()
    for i in range(num_slaves):
        slaves[i].position_x, slaves[i].position_y, slaves[i].position_theta = generate_random_position()
        complete_packet.extend(slaves[i].get_packet())
    
    print(f"\n[CMD_RUN] Robot {current_r_id + 1} START execution")
    send_packet_to_master(complete_packet, f"CMD_RUN (Robot {current_r_id + 1})")

def cmd_aux_backdoor():
    """Press '5': Send AUX command with Data3=5 (backdoor forward test)"""
    global current_r_id
    
    slaves[current_r_id].current_cmd = CMD_AUX
    slaves[current_r_id].data = [0] * 14
    slaves[current_r_id].data[0] = 5
    
    complete_packet = bytearray()
    for i in range(num_slaves):
        slaves[i].position_x, slaves[i].position_y, slaves[i].position_theta = generate_random_position()
        complete_packet.extend(slaves[i].get_packet())
    
    print(f"\n[CMD_AUX] Robot {current_r_id + 1} BACKDOOR (Data3=5)")
    send_packet_to_master(complete_packet, f"CMD_AUX_BACKDOOR (Robot {current_r_id + 1})")


# ==================== BACKGROUND AUX THREAD ====================

def background_aux_thread():
    """Background thread: Send AUX commands every ~1 second"""
    global AUX_THREAD_RUNNING
    
    print("\n[AUX THREAD] Started - Sending position updates every 1 second")
    
    while AUX_THREAD_RUNNING:
        try:
            complete_packet = bytearray()
            
            for i in range(num_slaves):
                slaves[i].position_x, slaves[i].position_y, slaves[i].position_theta = generate_random_position()
                
                if slaves[i].current_cmd not in [CMD_PREP, CMD_RUN, CMD_GO_TO]:
                    slaves[i].current_cmd = CMD_AUX
                    slaves[i].data = [0] * 14
                
                complete_packet.extend(slaves[i].get_packet())
            
            send_packet_to_master(complete_packet, "AUX (Background)")
            
            time.sleep(AUX_SEND_INTERVAL)
        
        except Exception as e:
            print(f"[AUX THREAD ERROR] {e}")
            time.sleep(AUX_SEND_INTERVAL)

# ==================== MAIN LOOP ====================

def print_menu():
    """Print command menu"""
    print("\n" + "="*60)
    print("MASTER WIXEL PYTHON TEST CODE (WITH LOGGING)")
    print("="*60)
    print(f"Current Mode: {num_slaves} slaves | Target Robot: {current_r_id + 1}")
    print(f"Logs: {SENT_LOG_FILE}, {RECEIVED_LOG_FILE}")
    print("\nKeyboard Commands:")
    print("  'a' : STOP current robot, move to next")
    print("  'f' : GO_TO random location")
    print("  'j' : PREP mode (5 seconds, 20 waypoints)")
    print("  '9' : RUN operation")
    print("  '5' : AUX command with Data3=5 (backdoor forward)")
    print("  'q' : Quit")
    print("\n[Background] AUX thread sends position updates every 1 second")
    print("="*60 + "\n")

def main():
    """Main function"""
    global num_slaves, current_r_id, AUX_THREAD_RUNNING
    
    # Initialize log files
    initialize_log_files()
    
    # Open serial connection
    if not open_serial_connection():
        sys.exit(1)
    
    print_menu()
    
    # Start background AUX thread
    aux_thread = threading.Thread(target=background_aux_thread, daemon=True)
    aux_thread.start()
    
    try:
        while True:
            read_serial_response()
            
            try:
                cmd = input("Enter command (a/f/j/9/5/0/q): ").strip().lower()
                
                if cmd == 'a':
                    cmd_stop()
                elif cmd == 'f':
                    cmd_go_to()
                elif cmd == 'j':
                    cmd_prep()
                elif cmd == '9':
                    cmd_run()
                elif cmd == '5':
                    cmd_aux_backdoor()
                elif cmd == 'q':
                    print("\n✓ Exiting...")
                    break
                else:
                    print("✗ Invalid command. Try again.")
            
            except KeyboardInterrupt:
                print("\n✓ Interrupted by user")
                break
    
    finally:
        AUX_THREAD_RUNNING = False
        time.sleep(0.5)
        
        if ser:
            ser.close()
            print("✓ Serial connection closed")
        
        print(f"\n✓ Check logs: {SENT_LOG_FILE}, {RECEIVED_LOG_FILE}")

if __name__ == "__main__":
    main()