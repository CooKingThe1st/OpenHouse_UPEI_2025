"""
Robot Controller - Serial Communication Bridge
==============================================

Production-level communication layer that bridges the GUI path planner
with the robot control system via serial communication.

Features:
- Thread-safe serial communication
- Automatic robot ID mapping (color → slave ID)
- Waypoint transmission with PREP command
- Mission execution with RUN command
- Background position updates (AUX)
- Comprehensive error handling and logging
- Connection health monitoring

Author: Production System
Date: 2025-10-25
"""

import sys
import time
import threading
import math
import socket
from typing import Dict, List, Tuple, Optional, Callable
from dataclasses import dataclass
from enum import Enum
import logging
from datetime import datetime

try:
    import serial
    from serial.serialutil import SerialException
except ImportError:
    print("ERROR: pyserial not installed. Run: pip install pyserial")
    sys.exit(1)


# ==================== CONFIGURATION ====================

class ControllerConfig:
    """Configuration parameters for robot controller."""
    
    # Serial communication
    SERIAL_PORT = "COM5"
    BAUD_RATE = 9600
    SERIAL_TIMEOUT = 1.0
    
    # Protocol definitions
    MESSAGE_DELIMITER = 0xFF
    BYTES_PER_SLAVE = 16
    MAX_SLAVES = 4
    MAX_WAYPOINTS = 20
    
    # Command codes (must match embedded firmware)
    CMD_STOP = 0x10
    CMD_GO_TO = 0x11
    CMD_PREP = 0x12
    CMD_RUN = 0x13
    CMD_AUX = 0x14
    CMD_CALIBRATE = 0x15
    
    # AUX sub-commands
    AUX_POSITION_UPDATE = 0x9F
    AUX_MANUAL_PWM = 0x1F
    AUX_SET_OFFSET = 0x0F
    
    # Background thread timing
    AUX_SEND_INTERVAL = 0.2  # 200ms between position updates
    
    # OptiTrack configuration
    OPTITRACK_SERVER_IP = "192.168.0.100"
    OPTITRACK_PORT = 5400
    OPTITRACK_BUFFER_SIZE = 8192
    OPTITRACK_TIMEOUT = 1.0
    ENABLE_OPTITRACK = True  # Set to False to disable OptiTrack integration
    
    # World frame transformation
    # GUI frame (centered at origin): waypoints come in this frame
    # Robot world frame: offset from GUI frame  
    # The GUI center (0,0) should map to robot world center at (-1000, -1000)
    # Transform: robot_pos = gui_pos + WORLD_FRAME_OFFSET
    WORLD_FRAME_OFFSET_X = -1000.0  # mm - centers the workspace at (-1000, -1000)
    WORLD_FRAME_OFFSET_Y = -1000.0  # mm
    
    # Legacy coordinate bounds (kept for reference, not used for transformation)
    GUI_X_MIN = 0.0
    GUI_X_MAX = 2000.0
    GUI_Y_MIN = 0.0
    GUI_Y_MAX = 2000.0
    
    ROBOT_X_MIN = -1000.0
    ROBOT_X_MAX = 1000.0
    ROBOT_Y_MIN = -2000.0
    ROBOT_Y_MAX = 0.0
    
    # Logging
    LOG_SENT_PACKETS = True
    LOG_RECEIVED_DATA = True
    SENT_LOG_FILE = "robot_controller_sent.log"
    RECEIVED_LOG_FILE = "robot_controller_received.log"


# ==================== COORDINATE TRANSFORMATION ====================

class CoordinateTransformer:
    """
    Transform coordinates from GUI space to robot operating space.
    
    GUI space:   x=[0, 2000], y=[0, 2000] (mm)
    Robot space: x=[-1000, 1000], y=[-2000, 0] (mm)
    """
    
    def __init__(self,
                 gui_x_min: float = ControllerConfig.GUI_X_MIN,
                 gui_x_max: float = ControllerConfig.GUI_X_MAX,
                 gui_y_min: float = ControllerConfig.GUI_Y_MIN,
                 gui_y_max: float = ControllerConfig.GUI_Y_MAX,
                 robot_x_min: float = ControllerConfig.ROBOT_X_MIN,
                 robot_x_max: float = ControllerConfig.ROBOT_X_MAX,
                 robot_y_min: float = ControllerConfig.ROBOT_Y_MIN,
                 robot_y_max: float = ControllerConfig.ROBOT_Y_MAX):
        """
        Initialize coordinate transformer.
        
        Args:
            gui_x_min, gui_x_max: GUI X-axis range (mm)
            gui_y_min, gui_y_max: GUI Y-axis range (mm)
            robot_x_min, robot_x_max: Robot X-axis range (mm)
            robot_y_min, robot_y_max: Robot Y-axis range (mm)
        """
        self.gui_x_min = gui_x_min
        self.gui_x_max = gui_x_max
        self.gui_y_min = gui_y_min
        self.gui_y_max = gui_y_max
        
        self.robot_x_min = robot_x_min
        self.robot_x_max = robot_x_max
        self.robot_y_min = robot_y_min
        self.robot_y_max = robot_y_max
        
        # Calculate scale factors
        self.gui_x_range = gui_x_max - gui_x_min
        self.gui_y_range = gui_y_max - gui_y_min
        self.robot_x_range = robot_x_max - robot_x_min
        self.robot_y_range = robot_y_max - robot_y_min
    
    def transform_point(self, gui_x: float, gui_y: float) -> Tuple[float, float]:
        """
        Transform a point from GUI coordinates to robot coordinates.
        
        Args:
            gui_x: X coordinate in GUI space (mm)
            gui_y: Y coordinate in GUI space (mm)
            
        Returns:
            Tuple of (robot_x, robot_y) in robot space (mm)
        """
        # Normalize to [0, 1] range
        norm_x = (gui_x - self.gui_x_min) / self.gui_x_range
        norm_y = (gui_y - self.gui_y_min) / self.gui_y_range
        
        # Map to robot space
        robot_x = self.robot_x_min + (norm_x * self.robot_x_range)
        robot_y = self.robot_y_min + (norm_y * self.robot_y_range)
        
        return robot_x, robot_y
    
    def transform_waypoints(self, waypoints: List[Tuple[float, float]]) -> List[Tuple[float, float]]:
        """
        Transform a list of waypoints from GUI to robot coordinates.
        
        Args:
            waypoints: List of (x, y) tuples in GUI space (mm)
            
        Returns:
            List of (x, y) tuples in robot space (mm)
        """
        return [self.transform_point(x, y) for x, y in waypoints]


# ==================== OPTITRACK INTEGRATION ====================

class OptiTrackClient:
    """
    OptiTrack position tracking client.
    Receives real-time robot positions via TCP socket.
    """
    
    def __init__(self, 
                 server_ip: str = ControllerConfig.OPTITRACK_SERVER_IP,
                 port: int = ControllerConfig.OPTITRACK_PORT,
                 buffer_size: int = ControllerConfig.OPTITRACK_BUFFER_SIZE,
                 timeout: float = ControllerConfig.OPTITRACK_TIMEOUT):
        """
        Initialize OptiTrack client.
        
        Args:
            server_ip: OptiTrack server IP address
            port: OptiTrack server port
            buffer_size: Socket receive buffer size
            timeout: Socket timeout in seconds
        """
        self.server_ip = server_ip
        self.port = port
        self.buffer_size = buffer_size
        self.timeout = timeout
        
        self.sock = None
        self.connected = False
        self.position_lock = threading.Lock()
        self.robot_positions = {}  # {robot_id: {'x': float, 'y': float, 'z': float, 'rotation': float}}
        
        self.receive_thread = None
        self.running = False
        
        self.logger = logging.getLogger(self.__class__.__name__)
    
    def connect(self) -> bool:
        """
        Connect to OptiTrack server and start receiving positions.
        
        Returns:
            True if connection successful, False otherwise
        """
        try:
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.sock.settimeout(self.timeout)
            self.sock.connect((self.server_ip, self.port))
            self.connected = True
            self.running = True
            
            # Start background thread to receive positions
            self.receive_thread = threading.Thread(target=self._receive_positions, daemon=True)
            self.receive_thread.start()
            
            self.logger.info(f"✓ Connected to OptiTrack server at {self.server_ip}:{self.port}")
            return True
            
        except Exception as e:
            self.logger.error(f"✗ Failed to connect to OptiTrack: {e}")
            self.connected = False
            return False
    
    def disconnect(self):
        """Disconnect from OptiTrack server."""
        self.running = False
        self.connected = False
        
        if self.sock:
            try:
                self.sock.close()
            except:
                pass
            self.sock = None
        
        if self.receive_thread and self.receive_thread.is_alive():
            self.receive_thread.join(timeout=2.0)
        
        self.logger.info("OptiTrack client disconnected")
    
    def parse_robot_data(self, raw_data: str) -> List[Dict]:
        """
        Parse robot position data from OptiTrack server.
        
        Format: "id,x,y,z,rotation;id,x,y,z,rotation;..."
        
        Args:
            raw_data: Raw string data from OptiTrack
            
        Returns:
            List of robot dictionaries with keys: id, x, y, z, rotation
        """
        robots = []
        
        if not raw_data or raw_data.strip() == "":
            return robots
        
        entries = raw_data.split(';')
        
        for entry in entries:
            entry = entry.strip()
            if not entry:
                continue
            
            parts = entry.split(',')
            if len(parts) >= 5:
                try:
                    robot_id = int(parts[0])
                    x = float(parts[1])
                    y = float(parts[2])
                    z = float(parts[3])
                    rotation = float(parts[4])
                    
                    robots.append({
                        'id': robot_id,
                        'x': x,
                        'y': y,
                        'z': z,
                        'rotation': rotation
                    })
                except (ValueError, IndexError):
                    continue
        
        return robots
    
    def _receive_positions(self):
        """Background thread: continuously receive position updates."""
        self.logger.info("[OptiTrack Thread] Started - receiving position data...")
        
        while self.connected and self.running:
            try:
                data = self.sock.recv(self.buffer_size)
                
                if not data:
                    self.logger.warning("[OptiTrack] Server disconnected")
                    self.connected = False
                    break
                
                decoded = data.decode('utf-8', errors='ignore')
                cleaned = decoded.replace('\x00', '').strip()
                
                robots = self.parse_robot_data(cleaned)
                
                # Update position cache (thread-safe)
                with self.position_lock:
                    self.robot_positions = {r['id']: r for r in robots}
            
            except socket.timeout:
                continue
            except Exception as e:
                self.logger.error(f"[OptiTrack ERROR] {e}")
                self.connected = False
                break
        
        self.logger.info("[OptiTrack Thread] Stopped")
    
    def get_position(self, robot_id: int) -> Tuple[float, float, int]:
        """
        Get current position for a robot.
        
        Args:
            robot_id: Robot ID (1-4)
            
        Returns:
            Tuple of (x_meters, y_meters, theta_degrees)
            Returns (0.0, 0.0, 0) if robot not found
        """
        with self.position_lock:
            if robot_id in self.robot_positions:
                pos = self.robot_positions[robot_id]
                return pos['x'], pos['y'], int(pos['rotation'])
        
        # Fallback if robot_id not found
        return 0.0, 0.0, 0
    
    def is_connected(self) -> bool:
        """Check if OptiTrack client is connected."""
        return self.connected


# ==================== SLAVE STATE MANAGEMENT ====================
# ==================== COLOR TO ROBOT ID MAPPING ====================

class RobotIDMapper:
    """Maps robot colors to slave IDs (1-4)."""
    
    # Standard mapping: matches test_serial.py slave order
    COLOR_TO_ID = {
        'red': 1,
        'green': 2,
        'blue': 3,
        'yellow': 4
    }
    
    @classmethod
    def get_slave_id(cls, color: str) -> int:
        """
        Get slave ID (1-4) from robot color string.
        
        Args:
            color: Robot color ('red', 'green', 'blue', 'yellow')
            
        Returns:
            Slave ID (1-4)
            
        Raises:
            ValueError: If color is invalid
        """
        color_lower = color.lower()
        if color_lower not in cls.COLOR_TO_ID:
            raise ValueError(f"Invalid robot color: {color}. Must be one of {list(cls.COLOR_TO_ID.keys())}")
        return cls.COLOR_TO_ID[color_lower]


# ==================== SLAVE STATE MANAGEMENT ====================

@dataclass
class SlaveState:
    """State information for a single robot slave."""
    
    slave_id: int  # 1-4
    current_cmd: int = ControllerConfig.CMD_STOP
    data: List[int] = None  # 14 bytes of command-specific data
    position_x: float = 0.0  # meters
    position_y: float = 0.0  # meters
    position_theta: int = 0  # degrees (0-359)
    
    def __post_init__(self):
        if self.data is None:
            self.data = [0] * 14
    
    def get_packet(self) -> bytearray:
        """
        Build 16-byte packet for this slave.
        
        Packet format:
        [0]    ADD (slave address 1-4)
        [1-2]  X position (int16, mm) - OptiTrack position (NO offset applied)
        [3-4]  Y position (int16, mm) - OptiTrack position (NO offset applied)
        [5]    Theta rotation (0-255 mapped from 0-360°)
        [6]    Command byte
        [7-14] Data bytes (8 bytes) - Waypoints have offset applied in send_waypoints()
        [15]   Delimiter (0xFF)
        
        Note: World frame offset is applied ONLY to waypoints in the DATA field,
              NOT to OptiTrack positions. OptiTrack already provides positions
              in the robot world frame.
        
        Returns:
            16-byte packet as bytearray
        """
        packet = bytearray(ControllerConfig.BYTES_PER_SLAVE)
        
        # OptiTrack positions are already in robot world frame (meters)
        # Convert meters to millimeters (signed int16)
        # DO NOT apply world frame offset to OptiTrack positions!
        x_mm = int(self.position_x * 1000)
        y_mm = int(self.position_y * 1000)
        
        # Clamp to int16 range
        x_mm = max(-32768, min(32767, x_mm))
        y_mm = max(-32768, min(32767, y_mm))
        
        packet[0] = self.slave_id
        packet[1] = (x_mm >> 8) & 0xFF  # X high byte
        packet[2] = x_mm & 0xFF          # X low byte
        packet[3] = (y_mm >> 8) & 0xFF  # Y high byte
        packet[4] = y_mm & 0xFF          # Y low byte
        
        # Map theta (0-360°) to byte (0-255)
        theta_norm = self.position_theta % 360
        theta_byte = int((theta_norm / 360.0) * 256.0)
        packet[5] = theta_byte & 0xFF
        
        packet[6] = self.current_cmd
        
        # Data bytes (use first 8 bytes of self.data)
        for i in range(8):
            packet[7 + i] = self.data[i] if i < len(self.data) else 0
        
        packet[15] = ControllerConfig.MESSAGE_DELIMITER
        
        return packet


# ==================== ROBOT CONTROLLER ====================

class RobotController:
    """
    Main controller for robot communication.
    
    Manages serial connection, waypoint transmission, and mission execution.
    """
    
    def __init__(self, 
                 port: str = ControllerConfig.SERIAL_PORT,
                 baud_rate: int = ControllerConfig.BAUD_RATE,
                 enable_logging: bool = True,
                 enable_optitrack: bool = ControllerConfig.ENABLE_OPTITRACK,
                 status_callback: Optional[Callable[[str], None]] = None):
        """
        Initialize robot controller.
        
        Args:
            port: Serial port name (e.g., 'COM5', '/dev/ttyUSB0')
            baud_rate: Baud rate for serial communication
            enable_logging: Enable file logging of packets
            enable_optitrack: Enable OptiTrack position tracking
            status_callback: Optional callback for status updates
        """
        self.port = port
        self.baud_rate = baud_rate
        self.enable_logging = enable_logging
        self.enable_optitrack = enable_optitrack
        self.status_callback = status_callback
        
        # Serial connection
        self.serial_conn: Optional[serial.Serial] = None
        self.serial_lock = threading.Lock()
        self.is_connected = False
        
        # Slave states (4 robots)
        self.slaves = [SlaveState(slave_id=i+1) for i in range(ControllerConfig.MAX_SLAVES)]
        
        # Coordinate transformer (GUI space -> Robot space)
        self.coord_transformer = CoordinateTransformer()
        
        # OptiTrack client
        self.optitrack: Optional[OptiTrackClient] = None
        if enable_optitrack:
            self.optitrack = OptiTrackClient()
        
        # Background thread control
        self.aux_thread_running = False
        self.aux_thread: Optional[threading.Thread] = None
        
        # Setup logging
        if enable_logging:
            self._setup_logging()
        
        # Logger for this class
        self.logger = logging.getLogger(__name__)
    
    def _setup_logging(self):
        """Initialize log files for packet tracking."""
        try:
            # Clear/initialize sent packets log
            with open(ControllerConfig.SENT_LOG_FILE, 'w') as f:
                f.write(f"Robot Controller - Sent Packets Log\n")
                f.write(f"Started: {datetime.now()}\n")
                f.write("=" * 70 + "\n\n")
            
            # Clear/initialize received data log
            with open(ControllerConfig.RECEIVED_LOG_FILE, 'w') as f:
                f.write(f"Robot Controller - Received Data Log\n")
                f.write(f"Started: {datetime.now()}\n")
                f.write("=" * 70 + "\n\n")
        except Exception as e:
            self.logger.warning(f"Failed to initialize log files: {e}")
    
    def _log_status(self, message: str):
        """Send status update to callback if available."""
        if self.status_callback:
            try:
                self.status_callback(message)
            except Exception as e:
                self.logger.error(f"Status callback error: {e}")
    
    def _log_sent_packet(self, packet: bytearray, label: str = ""):
        """Log sent packet to file with detailed hex dump and decoding."""
        if not self.enable_logging:
            return
        
        try:
            with open(ControllerConfig.SENT_LOG_FILE, 'a') as f:
                timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
                f.write(f"\n{'='*70}\n")
                f.write(f"[{timestamp}] {label}\n")
                f.write(f"Length: {len(packet)} bytes\n\n")
                
                # Hex dump (16 bytes per line)
                for i in range(0, len(packet), 16):
                    hex_part = ' '.join(f'{b:02X}' for b in packet[i:i+16])
                    ascii_part = ''.join(chr(b) if 32 <= b < 127 else '.' for b in packet[i:i+16])
                    f.write(f"{i:04X}: {hex_part:<48} {ascii_part}\n")
                
                # Decode per-slave packets
                num_slaves = len(packet) // ControllerConfig.BYTES_PER_SLAVE
                f.write(f"\nDecoded Slave Packets ({num_slaves} robots):\n")
                
                for slave_idx in range(num_slaves):
                    offset = slave_idx * ControllerConfig.BYTES_PER_SLAVE
                    slave_data = packet[offset:offset+ControllerConfig.BYTES_PER_SLAVE]
                    
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
                    
                    # Command name lookup
                    cmd_names = {
                        0x10: "STOP",
                        0x11: "GO_TO",
                        0x12: "PREP",
                        0x13: "RUN",
                        0x14: "AUX",
                        0x15: "CALIBRATE"
                    }
                    cmd_name = cmd_names.get(cmd, f"UNKNOWN(0x{cmd:02X})")
                    
                    theta_deg = int((theta / 256.0) * 360.0)
                    
                    f.write(f"  Robot {slave_idx+1} (ID=0x{addr:02X}): "
                           f"Pos=({x/1000:.3f}m, {y/1000:.3f}m, {theta_deg}°) "
                           f"CMD={cmd_name}\n")
                    
                    # Show data bytes if non-zero
                    data_bytes = slave_data[7:15]
                    if any(b != 0 for b in data_bytes):
                        f.write(f"    Data: {' '.join(f'{b:02X}' for b in data_bytes)}\n")
                
                f.flush()
        except Exception as e:
            self.logger.error(f"Failed to log sent packet: {e}")
    
    def _log_received_data(self, data: str, label: str = ""):
        """Log received data to file."""
        if not self.enable_logging:
            return
        
        try:
            with open(ControllerConfig.RECEIVED_LOG_FILE, 'a') as f:
                timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
                f.write(f"[{timestamp}] {label}\n")
                f.write(f"{data}\n\n")
                f.flush()
        except Exception as e:
            self.logger.error(f"Failed to log received data: {e}")
    
    # ==================== CONNECTION MANAGEMENT ====================
    
    def connect(self) -> bool:
        """
        Open serial connection to robot control system.
        Also connects to OptiTrack if enabled.
        
        Returns:
            True if connection successful, False otherwise
        """
        try:
            self.serial_conn = serial.Serial(
                port=self.port,
                baudrate=self.baud_rate,
                timeout=ControllerConfig.SERIAL_TIMEOUT
            )
            time.sleep(2)  # Allow connection to stabilize
            self.is_connected = True
            
            msg = f"✓ Connected to {self.port} at {self.baud_rate} baud"
            self.logger.info(msg)
            self._log_status(msg)
            
            # Connect to OptiTrack if enabled
            if self.enable_optitrack and self.optitrack:
                if self.optitrack.connect():
                    msg = "✓ OptiTrack connected - real-time position tracking enabled"
                    self.logger.info(msg)
                    self._log_status(msg)
                else:
                    msg = "⚠ OptiTrack connection failed - using manual positions"
                    self.logger.warning(msg)
                    self._log_status(msg)
            
            # Start background AUX thread
            self._start_aux_thread()
            
            return True
        
        except SerialException as e:
            msg = f"✗ Failed to connect to {self.port}: {e}"
            self.logger.error(msg)
            self._log_status(msg)
            return False
        except Exception as e:
            msg = f"✗ Unexpected error connecting: {e}"
            self.logger.error(msg)
            self._log_status(msg)
            return False
    
    def disconnect(self):
        """Close serial connection and stop background threads."""
        # Stop background thread
        self._stop_aux_thread()
        
        # Disconnect OptiTrack
        if self.optitrack:
            self.optitrack.disconnect()
        
        # Close serial connection
        if self.serial_conn and self.serial_conn.is_open:
            try:
                self.serial_conn.close()
                self.is_connected = False
                msg = "✓ Serial connection closed"
                self.logger.info(msg)
                self._log_status(msg)
            except Exception as e:
                self.logger.error(f"Error closing serial connection: {e}")
    
    def is_ready(self) -> bool:
        """Check if controller is ready for commands."""
        return self.is_connected and self.serial_conn and self.serial_conn.is_open
    
    # ==================== PACKET TRANSMISSION ====================
    
    def _send_packet(self, packet: bytearray, label: str = "") -> bool:
        """
        Send packet to master Wixel (thread-safe).
        
        Args:
            packet: Complete packet data to send
            label: Description for logging
            
        Returns:
            True if sent successfully, False otherwise
        """
        try:
            with self.serial_lock:
                if not self.is_ready():
                    raise RuntimeError("Serial connection not ready")
                
                self.serial_conn.write(packet)
                self._log_sent_packet(packet, label)
                return True
        
        except Exception as e:
            self.logger.error(f"Failed to send packet: {e}")
            return False
    
    def _build_complete_packet(self) -> bytearray:
        """
        Build complete packet containing all 4 slave packets.
        
        Returns:
            64-byte packet (16 bytes × 4 slaves)
        """
        complete_packet = bytearray()
        for slave in self.slaves:
            complete_packet.extend(slave.get_packet())
        return complete_packet
    
    def _update_slave_position(self, slave_id: int, x: float, y: float, theta: int = 0):
        """
        Update position for a specific slave (manual override).
        
        Args:
            slave_id: Slave ID (1-4)
            x: X position in meters
            y: Y position in meters
            theta: Rotation in degrees (0-359)
        """
        if 1 <= slave_id <= ControllerConfig.MAX_SLAVES:
            slave = self.slaves[slave_id - 1]
            slave.position_x = x
            slave.position_y = y
            slave.position_theta = theta % 360
    
    def _get_effective_position(self, slave_index: int) -> Tuple[float, float, int]:
        """
        Get effective position for a slave (OptiTrack > last known > fallback).
        
        Args:
            slave_index: Slave index (0-3)
            
        Returns:
            Tuple of (x_meters, y_meters, theta_degrees)
        """
        slave = self.slaves[slave_index]
        
        # Try to get OptiTrack data if available
        if self.optitrack and self.optitrack.is_connected():
            robot_id = slave_index + 1
            x, y, theta = self.optitrack.get_position(robot_id)
            
            # Fallback if OptiTrack returns (0,0,0) - robot not visible
            if x == 0.0 and y == 0.0 and theta == 0:
                # Use last known good position if available
                if slave.position_x != 0.0 or slave.position_y != 0.0:
                    return slave.position_x, slave.position_y, slave.position_theta
                # Final fallback
                return 0.0, 0.0, 0
            
            return x, y, theta
        
        # No OptiTrack: use current slave position
        return slave.position_x, slave.position_y, slave.position_theta
    
    def _update_all_slave_positions(self):
        """Update positions for ALL slaves from OptiTrack (if available)."""
        for i in range(ControllerConfig.MAX_SLAVES):
            x, y, theta = self._get_effective_position(i)
            self.slaves[i].position_x = x
            self.slaves[i].position_y = y
            self.slaves[i].position_theta = theta
    
    # ==================== BACKGROUND AUX THREAD ====================
    
    def _aux_thread_worker(self):
        """Background thread: Send AUX position updates every 200ms."""
        self.logger.info(f"AUX thread started (interval: {ControllerConfig.AUX_SEND_INTERVAL}s)")
        
        while self.aux_thread_running:
            try:
                # Update all slave positions from OptiTrack (if available)
                self._update_all_slave_positions()
                
                # Build packet with current positions
                for slave in self.slaves:
                    # Only send AUX updates if robot is not executing other commands
                    if slave.current_cmd in [ControllerConfig.CMD_GO_TO, 
                                            ControllerConfig.CMD_RUN,
                                            ControllerConfig.CMD_CALIBRATE]:
                        # Command was sent, revert to AUX for continuous position updates
                        slave.current_cmd = ControllerConfig.CMD_AUX
                        slave.data = [ControllerConfig.AUX_POSITION_UPDATE] + [0] * 13
                    elif slave.current_cmd == ControllerConfig.CMD_PREP:
                        # PREP stays active until explicitly changed
                        pass
                    else:
                        # Default: AUX position update
                        slave.current_cmd = ControllerConfig.CMD_AUX
                        slave.data = [ControllerConfig.AUX_POSITION_UPDATE] + [0] * 13
                
                # Send complete packet
                packet = self._build_complete_packet()
                self._send_packet(packet, "AUX Background Update")
                
                time.sleep(ControllerConfig.AUX_SEND_INTERVAL)
            
            except Exception as e:
                self.logger.error(f"AUX thread error: {e}")
                time.sleep(ControllerConfig.AUX_SEND_INTERVAL)
        
        self.logger.info("AUX thread stopped")
    
    def _start_aux_thread(self):
        """Start background AUX position update thread."""
        if not self.aux_thread_running:
            self.aux_thread_running = True
            self.aux_thread = threading.Thread(
                target=self._aux_thread_worker,
                daemon=True,
                name="RobotController-AUX"
            )
            self.aux_thread.start()
    
    def _stop_aux_thread(self):
        """Stop background AUX thread."""
        if self.aux_thread_running:
            self.aux_thread_running = False
            if self.aux_thread:
                self.aux_thread.join(timeout=1.0)
                self.aux_thread = None
    
    # ==================== WAYPOINT COMMANDS ====================
    
    def send_waypoints(self, robot_color: str, waypoints: List[Tuple[float, float]]) -> bool:
        """
        Send waypoints to a specific robot using PREP command.
        
        Sends one waypoint per packet (20 packets total). This matches the
        test_serial.py protocol where each packet contains one waypoint.
        
        World frame transformation is applied: robot_pos = gui_pos + offset
        
        Args:
            robot_color: Robot color ('red', 'green', 'blue', 'yellow')
            waypoints: List of (x, y) tuples in GUI frame coordinates (millimeters, max 20 waypoints)
                      GUI frame: Centered at (0,0), range approx [-1000, +1000] mm
                      Robot world frame: GUI coordinates + offset
            
        Returns:
            True if waypoints sent successfully, False otherwise
        """
        try:
            # Get slave ID from color
            slave_id = RobotIDMapper.get_slave_id(robot_color)
            slave = self.slaves[slave_id - 1]
            
            # Validate waypoint count
            if len(waypoints) != ControllerConfig.MAX_WAYPOINTS:
                self.logger.warning(f"Expected {ControllerConfig.MAX_WAYPOINTS} waypoints, got {len(waypoints)}")
                # Pad or truncate to exactly 20
                if len(waypoints) < ControllerConfig.MAX_WAYPOINTS:
                    # Pad with last waypoint
                    last_wp = waypoints[-1] if waypoints else (0.0, 0.0)
                    waypoints = waypoints + [last_wp] * (ControllerConfig.MAX_WAYPOINTS - len(waypoints))
                else:
                    waypoints = waypoints[:ControllerConfig.MAX_WAYPOINTS]
            
            # Waypoints are in GUI frame (mm), convert to meters
            waypoints_m = [(x / 1000.0, y / 1000.0) for x, y in waypoints]
            
            # Set PREP mode
            slave.current_cmd = ControllerConfig.CMD_PREP
            
            msg = f"Sending {len(waypoints)} waypoints to {robot_color.upper()} robot (ID {slave_id})..."
            self.logger.info(msg)
            self._log_status(msg)
            
            # Send one waypoint per packet
            for wp_idx, (x_m, y_m) in enumerate(waypoints_m):
                # Update all slave positions before building packet (matches test_serial.py behavior)
                self._update_all_slave_positions()
                
                # Apply world frame offset to waypoint: robot_pos = gui_pos + offset
                x_robot = x_m + (ControllerConfig.WORLD_FRAME_OFFSET_X / 1000.0)
                y_robot = y_m + (ControllerConfig.WORLD_FRAME_OFFSET_Y / 1000.0)
                
                # Convert to millimeters (int16)
                x_mm = int(x_robot * 1000)
                y_mm = int(y_robot * 1000)
                
                # Build waypoint data (5 bytes): order, x_high, x_low, y_high, y_low
                # This matches test_serial.py waypoint_to_bytes() function
                waypoint_data = [
                    wp_idx,                    # Order (0-19)
                    (x_mm >> 8) & 0xFF,       # X high byte
                    x_mm & 0xFF,               # X low byte
                    (y_mm >> 8) & 0xFF,       # Y high byte
                    y_mm & 0xFF                # Y low byte
                ]
                
                # Pad to 14 bytes (only first 8 will be sent in packet)
                waypoint_data.extend([0] * (14 - len(waypoint_data)))
                
                # Set data for this slave
                slave.data = waypoint_data
                
                # Build and send packet
                packet = self._build_complete_packet()
                label = f"PREP Waypoint {wp_idx + 1}/{len(waypoints)} ({robot_color.upper()})"
                if not self._send_packet(packet, label):
                    return False
                
                # Match test_serial.py delay
                time.sleep(0.1)
            
            msg = f"✓ All {len(waypoints)} waypoints sent to {robot_color.upper()} robot"
            self.logger.info(msg)
            self._log_status(msg)
            
            return True
        
        except ValueError as e:
            self.logger.error(f"Invalid robot color: {e}")
            return False
        except Exception as e:
            self.logger.error(f"Failed to send waypoints: {e}")
            return False
    
    def run_mission(self, robot_color: str) -> bool:
        """
        Send RUN command to execute waypoint mission.
        
        Args:
            robot_color: Robot color ('red', 'green', 'blue', 'yellow')
            
        Returns:
            True if command sent successfully, False otherwise
        """
        try:
            slave_id = RobotIDMapper.get_slave_id(robot_color)
            slave = self.slaves[slave_id - 1]
            
            # Update positions before building packet (matches test_serial.py behavior)
            self._update_all_slave_positions()
            
            # Set RUN command
            slave.current_cmd = ControllerConfig.CMD_RUN
            slave.data = [0] * 14
            
            # Build and send packet
            packet = self._build_complete_packet()
            label = f"RUN Command ({robot_color.upper()} Robot)"
            
            if self._send_packet(packet, label):
                msg = f"✓ RUN command sent to {robot_color.upper()} robot"
                self.logger.info(msg)
                self._log_status(msg)
                return True
            else:
                return False
        
        except ValueError as e:
            self.logger.error(f"Invalid robot color: {e}")
            return False
        except Exception as e:
            self.logger.error(f"Failed to send RUN command: {e}")
            return False
    
    def stop_robot(self, robot_color: str) -> bool:
        """
        Send STOP command to a specific robot.
        
        Args:
            robot_color: Robot color ('red', 'green', 'blue', 'yellow')
            
        Returns:
            True if command sent successfully, False otherwise
        """
        try:
            slave_id = RobotIDMapper.get_slave_id(robot_color)
            slave = self.slaves[slave_id - 1]
            
            # Update positions before building packet (matches test_serial.py behavior)
            self._update_all_slave_positions()
            
            # Set STOP command
            slave.current_cmd = ControllerConfig.CMD_STOP
            slave.data = [0] * 14
            
            # Build and send packet
            packet = self._build_complete_packet()
            label = f"STOP Command ({robot_color.upper()} Robot)"
            
            if self._send_packet(packet, label):
                msg = f"✓ STOP command sent to {robot_color.upper()} robot"
                self.logger.info(msg)
                self._log_status(msg)
                return True
            else:
                return False
        
        except ValueError as e:
            self.logger.error(f"Invalid robot color: {e}")
            return False
        except Exception as e:
            self.logger.error(f"Failed to send STOP command: {e}")
            return False
    
    def stop_all_robots(self) -> bool:
        """
        Send STOP command to all robots.
        
        Returns:
            True if command sent successfully, False otherwise
        """
        try:
            # Set STOP for all slaves
            for slave in self.slaves:
                slave.current_cmd = ControllerConfig.CMD_STOP
                slave.data = [0] * 14
            
            # Build and send packet
            packet = self._build_complete_packet()
            label = "STOP All Robots"
            
            if self._send_packet(packet, label):
                msg = "✓ STOP command sent to all robots"
                self.logger.info(msg)
                self._log_status(msg)
                return True
            else:
                return False
        
        except Exception as e:
            self.logger.error(f"Failed to send STOP ALL command: {e}")
            return False


# ==================== CONVENIENCE FUNCTIONS ====================

def create_controller(port: str = ControllerConfig.SERIAL_PORT,
                     baud_rate: int = ControllerConfig.BAUD_RATE,
                     status_callback: Optional[Callable[[str], None]] = None) -> RobotController:
    """
    Factory function to create and connect a RobotController.
    
    Args:
        port: Serial port name
        baud_rate: Serial baud rate
        status_callback: Optional callback for status messages
        
    Returns:
        Connected RobotController instance, or None if connection failed
    """
    controller = RobotController(
        port=port,
        baud_rate=baud_rate,
        enable_logging=True,
        status_callback=status_callback
    )
    
    if controller.connect():
        return controller
    else:
        return None


# ==================== DEMO/TEST CODE ====================

if __name__ == "__main__":
    """
    Demo: Send waypoints and run mission for a single robot.
    """
    
    # Setup basic logging to console
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    
    print("="*60)
    print("Robot Controller - Demo Test")
    print("="*60)
    
    # Create controller with status callback
    def status_callback(msg: str):
        print(f"[STATUS] {msg}")
    
    controller = create_controller(
        port=ControllerConfig.SERIAL_PORT,
        status_callback=status_callback
    )
    
    if not controller:
        print("Failed to create controller. Exiting.")
        sys.exit(1)
    
    try:
        # Example waypoints in GUI frame coordinates (mm)
        # GUI frame: Centered at (0,0), range approx [-1000, +1000] mm
        # Robot world frame: GUI + offset
        # 
        # Transformation applied automatically by controller:
        #   robot_pos = gui_pos + offset
        
        print("\n" + "="*60)
        print("Waypoint Demo - Centered GUI Frame with World Transform")
        print("="*60)
        print(f"World frame offset: ({ControllerConfig.WORLD_FRAME_OFFSET_X}, "
              f"{ControllerConfig.WORLD_FRAME_OFFSET_Y}) mm")
        print("Robot receives: gui_pos + offset")
        print(f"GUI (0,0) → Robot ({ControllerConfig.WORLD_FRAME_OFFSET_X}, "
              f"{ControllerConfig.WORLD_FRAME_OFFSET_Y})")
        print("="*60 + "\n")
        
        waypoints = []
        
        # Define rectangle in GUI coordinates (centered at origin of GUI frame)
        x_min, y_min = -500.0, -500.0
        x_max, y_max = 500.0, 500.0
        x_mid, y_mid = 0.0, 0.0
        
        # 8 distinct waypoints (corners and midpoints) in GUI frame
        distinct_waypoints = [
            (x_min, y_min),  # Bottom-left corner
            (x_min, y_mid),  # Left midpoint
            (x_min, y_max),  # Top-left corner
            (x_mid, y_max),  # Top midpoint
            (x_max, y_max),  # Top-right corner
            (x_max, y_mid),  # Right midpoint
            (x_max, y_min),  # Bottom-right corner
            (x_mid, y_min)   # Bottom midpoint
        ]
        
        waypoints.extend(distinct_waypoints)
        
        # Pad to 20 waypoints with last waypoint
        last_wp = distinct_waypoints[-1]
        while len(waypoints) < 20:
            waypoints.append(last_wp)
        
        print(f"Sending {len(waypoints)} waypoints to RED robot...")
        print("(GUI frame coordinates - world offset applied automatically)")
        print(f"Example transformations:")
        print(f"  GUI (0, 0) → Robot ({ControllerConfig.WORLD_FRAME_OFFSET_X}, "
              f"{ControllerConfig.WORLD_FRAME_OFFSET_Y})")
        print(f"  GUI ({x_min}, {y_min}) → Robot ({x_min + ControllerConfig.WORLD_FRAME_OFFSET_X}, "
              f"{y_min + ControllerConfig.WORLD_FRAME_OFFSET_Y})\n")
        
        # Send waypoints
        if controller.send_waypoints('red', waypoints):
            print("✓ Waypoints sent successfully!")
            
            # Wait a moment
            time.sleep(1)
            
            # Run mission
            print("\nSending RUN command...")
            if controller.run_mission('red'):
                print("✓ Mission started!")
                
                # Let it run for a while
                print("\nMission running... (Press Ctrl+C to stop)")
                time.sleep(30)
                
                # Stop robot
                print("\nStopping robot...")
                controller.stop_robot('red')
            else:
                print("✗ Failed to start mission")
        else:
            print("✗ Failed to send waypoints")
    
    except KeyboardInterrupt:
        print("\n\nInterrupted by user")
    
    finally:
        print("\nDisconnecting...")
        controller.disconnect()
        print("✓ Demo complete")
