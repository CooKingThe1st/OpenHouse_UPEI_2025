"""
Modular Robot Control System
- Mode 1: Motor Test (test all motor directions)
- Mode 2: Goal Reaching (PID control to reach a single waypoint)
- Mode 3: Path Tracking (follow multiple waypoints in sequence)
"""

""" if going 10 10, for 3 seconds, would be 14-14,5-14,5 cm in real life (3tests)
    if going 30 30, for 3 seconds, would be 22-24-24cm in real life (3tests)
    if going 60 60, for 3 seconds, would be 41-39,5-40cm in real life (3tests)
    this robot cannot self rotate tho"""


import socket
import time
import math
import serial
import json
import os
import sys
import threading

# ============== Configuration ==============
OPTITRACK_SERVER_IP = "192.168.0.100"
BROADCAST_PORT = 5400
BUFFER_SIZE = 8192
STATUS_FILE = "/tmp/demo_status.json"

# Robot Configuration
ROBOT_ID = 2
SERIAL_PORT = "/dev/serial0"
SERIAL_BAUD = 115200

# Control Parameters
MAX_SPEED = 60.0
ROTATION_GAIN = 3.0
SAMPLE_TIME = 0.05
ZUMO_SAT = 95.0

# PID Parameters (tuned for velocity control in m/s)
KP_POSITION = 0.15    # Lower gain - distance in meters to velocity in m/s
KI_POSITION = 0.0
KD_POSITION = 0.05
KP_HEADING = 1.5      # Heading control gain (was 8.0, reduced since no /5.0 divisor)

# Motor Test Configuration
MOTOR_TEST_SPEED = 60.0
MOTOR_TEST_DURATION = 3.0

# Goal Reaching Configuration
GOAL_THRESHOLD = 0.05  # 5cm - consider goal reached
GOAL_TIMEOUT = 30.0    # 30 seconds max per goal

# Add to Configuration section (around line 60)
CALIBRATION_SPEED = 30.0
CALIBRATION_DURATION = 3.0
HEADING_OFFSET_FILE = "/tmp/robot_heading_offset.json"

# ============== TCP Command Server Configuration ==============
TCP_COMMAND_PORT = 5500
TCP_COMMAND_ENABLED = True



def motor_to_velocity(motor_cmd):
    """
    Convert motor command (0-60) to real velocity in m/s
    Uses piecewise linear interpolation based on calibration
    """
    motor_cmd = abs(motor_cmd)
    
    if motor_cmd <= 10:
        # Linear from 0 to 10: 0 -> 0, 10 -> 0.0483
        velocity = motor_cmd * 0.00483
    elif motor_cmd <= 30:
        # Linear from 10 to 30: 10 -> 0.0483, 30 -> 0.0777
        velocity = 0.0483 + (motor_cmd - 10) * (0.0777 - 0.0483) / 20
    else:
        # Linear from 30 to 60: 30 -> 0.0777, 60 -> 0.1340
        velocity = 0.0777 + (motor_cmd - 30) * (0.1340 - 0.0777) / 30
    
    return velocity


def velocity_to_motor(desired_velocity_ms):
    """
    Convert desired velocity in m/s to motor command (0-60)
    Inverse of motor_to_velocity using piecewise linear approximation
    """
    desired_velocity_ms = abs(desired_velocity_ms)
    
    if desired_velocity_ms <= 0.0483:
        # Linear zone: 0 to 10
        motor_cmd = desired_velocity_ms / 0.00483
    elif desired_velocity_ms <= 0.0777:
        # Linear zone: 10 to 30
        motor_cmd = 10 + (desired_velocity_ms - 0.0483) * 20 / (0.0777 - 0.0483)
    elif desired_velocity_ms <= 0.1340:
        # Linear zone: 30 to 60
        motor_cmd = 30 + (desired_velocity_ms - 0.0777) * 30 / (0.1340 - 0.0777)
    else:
        # Cap at max
        motor_cmd = 60
    
    return motor_cmd



# Add new class after ManualVelocityMode
class HeadingCalibrationMode:
    """Calibrate robot heading offset relative to OptiTrack rigid body"""
    
    def __init__(self, motor_controller, optitrack_client, robot_id):
        self.motor = motor_controller
        self.optitrack = optitrack_client
        self.robot_id = robot_id
        self.offset = 0.0
        
    def run(self):
        print("\n" + "="*70)
        print("🧭 HEADING CALIBRATION MODE")
        print("="*70)
        print("This will drive the robot forward to determine heading offset")
        print("-"*70)
        
        # Step 1: Get initial position
        print("📍 Step 1: Recording initial position...")
        initial_data = self._get_stable_position()
        if not initial_data:
            return {'success': False, 'error': 'Could not read initial position'}
        
        x0, y0, theta0_deg = initial_data['x'], initial_data['y'], initial_data['rotation']
        print(f"   Initial: x={x0:.4f}, y={y0:.4f}, θ_optitrack={theta0_deg:.2f}°")
        
        # Step 2: Drive forward
        print(f"\n🚗 Step 2: Driving forward at {CALIBRATION_SPEED:.1f} for {CALIBRATION_DURATION}s...")
        self.motor.send_command(CALIBRATION_SPEED, CALIBRATION_SPEED)
        time.sleep(CALIBRATION_DURATION)
        self.motor.stop()
        
        # Step 3: Get final position
        time.sleep(0.5)  # Let robot settle
        print("\n📍 Step 3: Recording final position...")
        final_data = self._get_stable_position()
        if not final_data:
            return {'success': False, 'error': 'Could not read final position'}
        
        x1, y1, theta1_deg = final_data['x'], final_data['y'], final_data['rotation']
        print(f"   Final: x={x1:.4f}, y={y1:.4f}, θ_optitrack={theta1_deg:.2f}°")
        
        # Step 4: Calculate actual heading from movement
        dx = x1 - x0
        dy = y1 - y0
        distance = math.sqrt(dx**2 + dy**2)
        
        if distance < 0.05:  # Robot didn't move enough
            print(f"\n✗ Robot moved only {distance*100:.1f}cm - too small for calibration")
            return {'success': False, 'error': 'Insufficient movement'}
        
        actual_heading_rad = math.atan2(dy, dx)
        actual_heading_deg = math.degrees(actual_heading_rad)
        
        # Step 5: Calculate offset
        theta0_rad = math.radians(theta0_deg)
        self.offset = actual_heading_rad - theta0_rad
        
        # Wrap to [-π, π]
        while self.offset > math.pi:
            self.offset -= 2 * math.pi
        while self.offset < -math.pi:
            self.offset += 2 * math.pi
        
        offset_deg = math.degrees(self.offset)
        
        print("\n" + "="*70)
        print("📊 CALIBRATION RESULTS")
        print("="*70)
        print(f"Distance traveled:     {distance*100:.2f} cm")
        print(f"Actual heading:        {actual_heading_deg:.2f}°")
        print(f"OptiTrack heading:     {theta0_deg:.2f}°")
        print(f"Heading offset:        {offset_deg:.2f}°")
        print("="*70)
        
        # Save offset to file
        self._save_offset()
        
        return {
            'success': True,
            'offset_deg': offset_deg,
            'offset_rad': self.offset,
            'message': f'Calibration complete: offset = {offset_deg:.2f}°'
        }
    
    def _get_stable_position(self, samples=5):
        """Get average position over several samples"""
        positions = []
        print(f"   Attempting to read {samples} samples...")
        
        for i in range(samples):
            raw_data = self.optitrack.receive_data()
            print(f"   Sample {i+1}: raw_data={'None' if not raw_data else f'{len(raw_data)} chars'}")
            
            if raw_data:
                robots = self.optitrack.parse_robot_data(raw_data)
                print(f"   Parsed {len(robots)} robots: {[r['id'] for r in robots]}")
                
                robot = next((r for r in robots if r['id'] == self.robot_id), None)
                if robot:
                    positions.append(robot)
                    print(f"   ✓ Found robot {self.robot_id}: x={robot['x']:.3f}, y={robot['y']:.3f}")
                else:
                    print(f"   ✗ Robot {self.robot_id} not found")
            else:
                print(f"   ✗ No data received")
            
            time.sleep(0.1)
        
        if not positions:
            print(f"   ✗ No valid positions collected!")
            return None
        
        # Average position
        avg_x = sum(p['x'] for p in positions) / len(positions)
        avg_y = sum(p['y'] for p in positions) / len(positions)
        avg_rot = sum(p['rotation'] for p in positions) / len(positions)
        
        print(f"   ✓ Collected {len(positions)}/{samples} samples")
        return {'x': avg_x, 'y': avg_y, 'rotation': avg_rot}
    
    def _save_offset(self):
        """Save offset to file for persistence"""
        try:
            data = {
                'robot_id': self.robot_id,
                'offset_rad': self.offset,
                'offset_deg': math.degrees(self.offset),
                'timestamp': time.time()
            }
            with open(HEADING_OFFSET_FILE, 'w') as f:
                json.dump(data, f, indent=2)
            print(f"\n✓ Offset saved to {HEADING_OFFSET_FILE}")
        except Exception as e:
            print(f"\n⚠️  Could not save offset: {e}")
    
    @staticmethod
    def load_offset():
        """Load saved offset from file"""
        try:
            if os.path.exists(HEADING_OFFSET_FILE):
                with open(HEADING_OFFSET_FILE, 'r') as f:
                    data = json.load(f)
                    return data['offset_rad']
        except:
            pass
        return 0.0



# PID Parameters (tuned for velocity control in m/s)
KP_POSITION = 0.15    # Lower gain - distance in meters to velocity in m/s
KI_POSITION = 0.0
KD_POSITION = 0.05
KP_HEADING = 8.0      # Higher gain - robot is hard to steer

class OptiTrackClient:
    """Handles connection and data parsing from OptiTrack server"""
    
    def __init__(self, server_ip, port):
        self.server_ip = server_ip
        self.port = port
        self.sock = None
        self.connected = False
        
    def connect(self):
        try:
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.sock.settimeout(5.0)
            self.sock.connect((self.server_ip, self.port))
            self.connected = True
            self.sock.settimeout(0.5)
            print(f"✓ Connected to OptiTrack server")
            return True
        except Exception as e:
            print(f"✗ OptiTrack connection error: {e}")
            return False
    
    def receive_data(self):
        if not self.connected:
            return None
        try:
            data = self.sock.recv(BUFFER_SIZE)
            if not data:
                self.connected = False
                return None
            decoded = data.decode('utf-8', errors='ignore')
            return decoded.replace('\x00', '').strip()
        except socket.timeout:
            return None
        except Exception as e:
            print(f"✗ Receive error: {e}")
            self.connected = False
            return None
    
    def parse_robot_data(self, raw_data):
        if not raw_data or len(raw_data) < 5:
            return []
        
        try:
            parts = raw_data.split(';')
            robots = []
            seen_ids = set()
            
            for part in parts:
                part = part.strip()
                if not part:
                    continue
                
                values = [v.strip() for v in part.split(',')]
                
                try:
                    if len(values) == 5:
                        robot_id = int(values[0])
                        x, y, z = float(values[1]), float(values[2]), float(values[3])
                        rotation = float(values[4])
                        
                        if robot_id in seen_ids or any(v != v for v in [x, y, z, rotation]):
                            continue
                        
                        seen_ids.add(robot_id)
                        robots.append({
                            'id': robot_id, 'type': 'robot',
                            'x': x, 'y': y, 'z': z, 'rotation': rotation
                        })
                except (ValueError, IndexError):
                    continue
            
            robots.sort(key=lambda r: r['id'])
            return robots
        except:
            return []
    
    def close(self):
        if self.sock:
            self.sock.close()
            self.connected = False


class MotorController:
    """Handles serial communication with Zumo robot"""
    
    def __init__(self, port=SERIAL_PORT, baudrate=SERIAL_BAUD):
        self.port = port
        self.baudrate = baudrate
        self.ser = None
        self.connected = False
        
    def connect(self):
        try:
            print(f"Connecting to motor controller on {self.port}...")
            self.ser = serial.Serial(
                port=self.port, baudrate=self.baudrate,
                bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE,
                stopbits=serial.STOPBITS_ONE, timeout=1,
                xonxoff=False, rtscts=False, dsrdtr=False
            )
            time.sleep(0.5)
            self.ser.reset_input_buffer()
            self.ser.reset_output_buffer()
            self.connected = True
            print(f"✓ Connected to motor controller")
            return True
        except Exception as e:
            print(f"✗ Motor controller connection error: {e}")
            return False
    
    def send_command(self, wL, wR):
        if not self.connected:
            return False
        try:
            command = f"g,{wL:.2f},{wR:.2f}\n"
            self.ser.write(command.encode('utf-8'))
            self.ser.flush()
            return True
        except Exception as e:
            print(f"✗ Motor command error: {e}")
            self.connected = False
            return False
    
    def stop(self):
        if self.connected:
            try:
                self.ser.write("s,0,0,0,0,0\n".encode('utf-8'))
                self.ser.flush()
            except:
                pass
    
    def close(self):
        if self.ser:
            self.stop()
            time.sleep(0.5)
            self.ser.close()
            self.connected = False

class ControllerBase:
    """Base class for all control modes"""
    
    def __init__(self):
        self.prev_wL = 0.0
        self.prev_wR = 0.0
        
    def wrap_angle(self, angle):
        while angle > math.pi:
            angle -= 2 * math.pi
        while angle < -math.pi:
            angle += 2 * math.pi
        return angle
    
    def saturation(self, value, min_val, max_val):
        return max(min_val, min(max_val, value))
    
    def zumo_saturation(self, old_w, new_w):
        if abs(old_w - new_w) > ZUMO_SAT:
            return old_w + ZUMO_SAT if new_w > old_w else old_w - ZUMO_SAT
        return new_w
    
    def calculate_wheel_velocities(self, v_base, turn_ratio):
        """
        Calculate wheel velocities for non-holonomic robot
        v_base: base forward velocity (always positive)
        turn_ratio: turning ratio [-1, 1]
                   -1 = turn left (slow down left wheel)
                   +1 = turn right (slow down right wheel)
                    0 = straight
        
        Both wheels always have SAME SIGN (forward only)
        """
        # Ensure base velocity is positive
        v_base = abs(v_base)
        
        # Clamp turn ratio
        turn_ratio = self.saturation(turn_ratio, -1.0, 1.0)
        
        if turn_ratio < 0:
            # Turn left: slow down left wheel
            wL = v_base * (1.0 + turn_ratio)  # Reduce left
            wR = v_base
        else:
            # Turn right: slow down right wheel
            wL = v_base
            wR = v_base * (1.0 - turn_ratio)  # Reduce right
        
        # Apply saturation
        wL = self.saturation(wL, 0, MAX_SPEED)
        wR = self.saturation(wR, 0, MAX_SPEED)
        
        # Apply rate limiting
        wL = self.zumo_saturation(self.prev_wL, wL)
        wR = self.zumo_saturation(self.prev_wR, wR)
        
        self.prev_wL = wL
        self.prev_wR = wR
        
        return wL, wR


class GoalReachingMode(ControllerBase):
    """Mode 2: Reach a single goal position"""
    
    def __init__(self, goal_x, goal_y):
        super().__init__()
        self.goal_x = goal_x
        self.goal_y = goal_y
    
    def compute_control(self, robot_x, robot_y, robot_rotation_deg, dt):
        """
        Compute motor commands to reach goal
        Returns: (wL, wR, debug_info, goal_reached)
        """
        robot_theta = math.radians(robot_rotation_deg)
        
        # Position error in world frame
        error_x = self.goal_x - robot_x
        error_y = self.goal_y - robot_y
        distance_to_goal = math.sqrt(error_x**2 + error_y**2)
        
        # Check if goal reached
        if distance_to_goal < GOAL_THRESHOLD:
            return 0, 0, {'distance': distance_to_goal, 'reached': True}, True
        
        # Desired heading (angle to goal)
        desired_heading = math.atan2(error_y, error_x)
        heading_error = self.wrap_angle(desired_heading - robot_theta)
        
        # === FORWARD-ONLY CONTROL STRATEGY ===
        
        # 1. Calculate base velocity (always forward)
        desired_velocity_ms = KP_POSITION * distance_to_goal
        desired_velocity_ms = self.saturation(desired_velocity_ms, 0, 0.10)  # Cap at 10 cm/s
        
        # 2. Reduce speed if heading error is large
        heading_error_abs = abs(heading_error)
        if heading_error_abs > math.radians(60):  # More than 60° off
            # Slow down significantly - need to turn more
            desired_velocity_ms *= 0.3
        elif heading_error_abs > math.radians(30):  # More than 30° off
            desired_velocity_ms *= 0.6
        
        # 3. Convert to motor command
        v_base_motor = velocity_to_motor(desired_velocity_ms)
        
        # Ensure minimum speed when far from goal (prevent stalling)
        if distance_to_goal > 0.1 and v_base_motor < 15:
            v_base_motor = 15  # Minimum motor command
        
        # 4. Calculate turn ratio based on heading error
        # Turn ratio: -1 (left) to +1 (right)
        # FIXED: Remove /5.0 divisor for more aggressive turning
        turn_ratio = self.saturation(KP_HEADING * heading_error, -0.9, 0.9)
        
        # 5. Calculate wheel velocities (both positive)
        wL, wR = self.calculate_wheel_velocities(v_base_motor, turn_ratio)
        
        # Calculate actual expected velocity for debugging
        actual_velocity_ms = motor_to_velocity(v_base_motor)
        
        debug_info = {
            'distance': distance_to_goal,
            'heading_error_deg': math.degrees(heading_error),
            'desired_velocity_ms': desired_velocity_ms,
            'actual_velocity_ms': actual_velocity_ms,
            'v_base_motor': v_base_motor,
            'turn_ratio': turn_ratio,
            'wL': wL,
            'wR': wR,
            'reached': False
        }
        
        return wL, wR, debug_info, False   
    
class MotorTestMode:
    """Mode 1: Test motor movements"""
    
    def __init__(self, motor_controller):
        self.motor = motor_controller
        
    def run(self):
        print("\n" + "="*60)
        print("🔧 MOTOR TEST MODE")
        print("="*60)
        
        tests = [
            ("ROTATION (CCW)", MOTOR_TEST_SPEED, -MOTOR_TEST_SPEED),
            # ("FORWARD", MOTOR_TEST_SPEED, MOTOR_TEST_SPEED),
            # ("MAX TURN", MOTOR_TEST_SPEED, 10),
            # ("BACKWARD", -MOTOR_TEST_SPEED, -MOTOR_TEST_SPEED),
            # ("OUTBOUND", 80, 80)
        ]
        
        for i, (name, wL, wR) in enumerate(tests, 1):
            print(f"\n{i}️⃣  Testing {name}")
            print(f"   Command: L={wL:.1f}, R={wR:.1f}")
            self.motor.send_command(wL, wR)
            time.sleep(MOTOR_TEST_DURATION)
            self.motor.stop()
            time.sleep(1)
        
        print("\n✓ Motor test complete!")
        print("="*60 + "\n")
        return {'success': True, 'message': 'Motor test completed'}


class ManualVelocityMode:
    """Mode 0: Manual velocity test - send specific velocities for 3 seconds"""
    
    def __init__(self, motor_controller, vL, vR):
        self.motor = motor_controller
        self.vL = vL
        self.vR = vR
        self.duration = 3.0
        
    def run(self):
        print("\n" + "="*60)
        print("⚡ MANUAL VELOCITY TEST MODE")
        print("="*60)
        print(f"Left Velocity:  {self.vL:.1f}")
        print(f"Right Velocity: {self.vR:.1f}")
        print(f"Duration: {self.duration}s")
        print("-"*60)
        
        # Send velocities
        self.motor.send_command(self.vL, self.vR)
        print(f"▶ Executing... ", end='', flush=True)
        
        # Wait for duration
        time.sleep(self.duration)
        
        # Stop motors
        self.motor.stop()
        print("✓ Complete")
        
        print("="*60 + "\n")
        return {
            'success': True, 
            'message': f'Velocity test complete: L={self.vL}, R={self.vR}'
        }

class PathTrackingMode(ControllerBase):
    """Mode 3: Follow a sequence of waypoints"""
    
    def __init__(self, waypoints):
        super().__init__()
        self.waypoints = waypoints  # List of (x, y) tuples
        self.current_waypoint_index = 0
        self.goal_controller = None
        self.path_complete = False
        
        if waypoints:
            self.set_current_goal()
    
    def set_current_goal(self):
        if self.current_waypoint_index < len(self.waypoints):
            x, y = self.waypoints[self.current_waypoint_index]
            self.goal_controller = GoalReachingMode(x, y)
            print(f"📍 Waypoint {self.current_waypoint_index + 1}/{len(self.waypoints)}: ({x:.2f}, {y:.2f})")
        else:
            self.path_complete = True
    
    def compute_control(self, robot_x, robot_y, robot_rotation_deg, dt):
        """
        Compute motor commands to follow path
        Returns: (wL, wR, debug_info, path_complete)
        """
        if self.path_complete:
            return 0, 0, {'status': 'Path complete'}, True
        
        # Use goal reaching for current waypoint
        wL, wR, debug, goal_reached = self.goal_controller.compute_control(
            robot_x, robot_y, robot_rotation_deg, dt
        )
        
        # If current waypoint reached, move to next
        if goal_reached:
            self.current_waypoint_index += 1
            if self.current_waypoint_index < len(self.waypoints):
                self.set_current_goal()
                return wL, wR, debug, False
            else:
                self.path_complete = True
                return 0, 0, {'status': 'Path complete'}, True
        
        debug['waypoint'] = f"{self.current_waypoint_index + 1}/{len(self.waypoints)}"
        return wL, wR, debug, False


class StatusWriter:
    """Write demo status to file for web server"""
    
    def __init__(self, filepath=STATUS_FILE):
        self.filepath = filepath
        self.last_write_time = 0
        self.write_interval = 0.1
    
    def update(self, mode, robot_data, control_data, frame_count, fps):
        current_time = time.time()
        if current_time - self.last_write_time < self.write_interval:
            return
        
        try:
            status = {
                'timestamp': current_time,
                'mode': mode,
                'frame_count': frame_count,
                'fps': fps,
                'robot': robot_data,
                'control': control_data,
            }
            
            temp_file = self.filepath + '.tmp'
            with open(temp_file, 'w') as f:
                json.dump(status, f, indent=2)
            os.replace(temp_file, self.filepath)
            
            self.last_write_time = current_time
        except:
            pass
    
    def clear(self):
        try:
            if os.path.exists(self.filepath):
                os.remove(self.filepath)
        except:
            pass


class TCPCommandServer:
    """
    TCP server for external control (backdoor)
    Commands (JSON format):
    - {"command": "test_motor"}
    - {"command": "goal_reaching", "goal_x": 0.5, "goal_y": 0.5}
    - {"command": "path_tracking", "waypoints": [[0.5, 0.5], [1.0, 1.0]]}
    - {"command": "stop"}
    - {"command": "status"}
    """
    
    def __init__(self, port, mode_callback):
        self.port = port
        self.mode_callback = mode_callback
        self.running = False
        self.thread = None
        self.server_sock = None
        self.is_listening = False  # Add this flag

        
    def start(self):
        self.running = True
        self.thread = threading.Thread(target=self._server_loop, daemon=True)
        self.thread.start()
        print(f"✓ TCP command server started on port {self.port}")
        # Wait a bit for server to start
        time.sleep(0.2)
        if self.is_listening:
            print(f"✓ TCP command server listening on port {self.port}")
        else:
            print(f"⚠️  TCP command server starting on port {self.port}...")
    
    def stop(self):
        self.running = False
        self.is_listening = False
        if self.server_sock:
            try:
                self.server_sock.close()
            except:
                pass
    
    def _server_loop(self):
        try:
            self.server_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.server_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self.server_sock.bind(('0.0.0.0', self.port))
            self.server_sock.listen(5)
            self.server_sock.settimeout(1.0)
            self.is_listening = True  # Mark as listening
            print(f"✓ TCP server bound to 0.0.0.0:{self.port}")
            
            while self.running:
                try:
                    client_sock, addr = self.server_sock.accept()
                    print(f"📡 TCP client connected: {addr}")
                    threading.Thread(target=self._handle_client, args=(client_sock, addr), daemon=True).start()
                except socket.timeout:
                    continue
                except Exception as e:
                    if self.running:  # Only print if we're still supposed to be running
                        print(f"⚠️  Accept error: {e}")
                    break
        except Exception as e:
            self.is_listening = False
            print(f"✗ TCP server error: {e}")
            print(f"   Port {self.port} may be in use or blocked by firewall")
    
    def _handle_client(self, client_sock, addr):
        try:
            client_sock.settimeout(5.0)  # Add timeout for client operations
            data = client_sock.recv(4096).decode('utf-8')
            
            if not data:
                return
            
            print(f"📨 Received command from {addr}: {data[:100]}...")  # Log first 100 chars
            command = json.loads(data)
            
            response = self.mode_callback(command)
            
            response_str = json.dumps(response)
            client_sock.sendall(response_str.encode('utf-8'))
            print(f"📤 Sent response to {addr}: {response_str[:100]}...")
            
        except socket.timeout:
            print(f"⚠️  Client {addr} timed out")
            error_response = {'success': False, 'error': 'Client timeout'}
            try:
                client_sock.sendall(json.dumps(error_response).encode('utf-8'))
            except:
                pass
        except json.JSONDecodeError as e:
            print(f"✗ Invalid JSON from {addr}: {e}")
            error_response = {'success': False, 'error': f'Invalid JSON: {str(e)}'}
            try:
                client_sock.sendall(json.dumps(error_response).encode('utf-8'))
            except:
                pass
        except Exception as e:
            print(f"✗ Error handling client {addr}: {e}")
            error_response = {'success': False, 'error': str(e)}
            try:
                client_sock.sendall(json.dumps(error_response).encode('utf-8'))
            except:
                pass
        finally:
            try:
                client_sock.close()
            except:
                pass

class RobotControlSystem:
    """Main control system - manages modes and execution"""
    

    def __init__(self):
        self.optitrack = OptiTrackClient(OPTITRACK_SERVER_IP, BROADCAST_PORT)
        self.motor = MotorController()
        self.status_writer = StatusWriter()
        self.tcp_server = None
        
        self.current_mode = None
        self.current_controller = None
        self.mode_name = "idle"
        self.running = False
        
        # Load heading offset
        self.heading_offset = HeadingCalibrationMode.load_offset()
        if self.heading_offset != 0.0:
            print(f"✓ Loaded heading offset: {math.degrees(self.heading_offset):.2f}°")



    def start_heading_calibration(self):
        """Run heading calibration"""
        print("\n🧭 Starting Heading Calibration")
        self.mode_name = "calibration"
        calibration = HeadingCalibrationMode(self.motor, self.optitrack, ROBOT_ID)
        result = calibration.run()
        
        if result['success']:
            self.heading_offset = calibration.offset
            print(f"✓ Heading offset updated: {math.degrees(self.heading_offset):.2f}°")
        
        self.mode_name = "idle"
        return result
        
    def correct_heading(self, optitrack_heading_deg):
        """Apply heading offset correction"""
        corrected_rad = math.radians(optitrack_heading_deg) + self.heading_offset
        # Wrap to [0, 360)
        corrected_deg = math.degrees(corrected_rad) % 360
        return corrected_deg

    def start_manual_velocity(self, vL, vR):
        print(f"\n⚡ Starting Manual Velocity Test: L={vL:.1f}, R={vR:.1f}")
        self.mode_name = "manual_velocity"
        velocity_mode = ManualVelocityMode(self.motor, vL, vR)
        result = velocity_mode.run()
        self.mode_name = "idle"
        return result

    def handle_tcp_command(self, command):
        """Handle commands from TCP server"""
        cmd_type = command.get('command', '')
        
        if cmd_type == 'manual_velocity':
            vL = command.get('vL', 0.0)
            vR = command.get('vR', 0.0)
            return self.start_manual_velocity(vL, vR)
        elif cmd_type == 'test_motor':
            return self.start_motor_test()
        elif cmd_type == 'calibrate_heading':  # ← FIX THIS
            return self.start_heading_calibration()
        elif cmd_type == 'goal_reaching':
            goal_x = command.get('goal_x', 0.5)
            goal_y = command.get('goal_y', 0.5)
            return self.start_goal_reaching(goal_x, goal_y)
        
        elif cmd_type == 'path_tracking':
            waypoints = command.get('waypoints', [[0.5, 0.5]])
            return self.start_path_tracking(waypoints)
        
        elif cmd_type == 'stop':
            self.stop()
            return {'success': True, 'message': 'Stopped'}
        
        elif cmd_type == 'status':
            return {'success': True, 'mode': self.mode_name, 'running': self.running}


        elif cmd_type == 'check_robot':
            # Check if robot is visible
            raw_data = self.optitrack.receive_data()
            if raw_data:
                robots = self.optitrack.parse_robot_data(raw_data)
                our_robot = next((r for r in robots if r['id'] == ROBOT_ID), None)
                if our_robot:
                    return {
                        'success': True,
                        'robot_found': True,
                        'robot_data': our_robot
                    }
                else:
                    return {
                        'success': True,
                        'robot_found': False,
                        'available_robots': [r['id'] for r in robots]
                    }
            return {'success': False, 'error': 'No OptiTrack data'}

        else:
            return {'success': False, 'error': f'Unknown command: {cmd_type}'}

    def start_motor_test(self):
        print("\n🔧 Starting Motor Test Mode")
        self.mode_name = "test_motor"
        test_mode = MotorTestMode(self.motor)
        result = test_mode.run()
        self.mode_name = "idle"
        return result
    
    def start_goal_reaching(self, goal_x, goal_y):
        print(f"\n🎯 Starting Goal Reaching Mode: ({goal_x:.2f}, {goal_y:.2f})")
        self.mode_name = "goal_reaching"
        self.current_controller = GoalReachingMode(goal_x, goal_y)
        self.running = True
        return {'success': True, 'message': f'Goal reaching started: ({goal_x}, {goal_y})'}
    
    def start_path_tracking(self, waypoints):
        print(f"\n🛤️  Starting Path Tracking Mode: {len(waypoints)} waypoints")
        self.mode_name = "path_tracking"
        self.current_controller = PathTrackingMode(waypoints)
        self.running = True
        return {'success': True, 'message': f'Path tracking started with {len(waypoints)} waypoints'}
    
    def stop(self):
        self.running = False
        self.motor.stop()
        self.mode_name = "idle"
        print("⏹ Stopped")
    
    def run(self):
        """Main execution loop"""
        print("\n" + "="*70)
        print("🤖 Robot Control System")
        print("="*70)
        print(f"Robot ID: {ROBOT_ID}")
        print(f"OptiTrack: {OPTITRACK_SERVER_IP}:{BROADCAST_PORT}")
        print(f"Serial: {SERIAL_PORT}")
        if TCP_COMMAND_ENABLED:
            print(f"TCP Command Port: {TCP_COMMAND_PORT}")
        print("="*70 + "\n")
        
        # Connect to OptiTrack
        if not self.optitrack.connect():
            print("Failed to connect to OptiTrack. Exiting.")
            return
        
        # Connect to motors
        if not self.motor.connect():
            print("Failed to connect to motor controller.")
            return
        
        # Start TCP command server
        if TCP_COMMAND_ENABLED:
            self.tcp_server = TCPCommandServer(TCP_COMMAND_PORT, self.handle_tcp_command)
            self.tcp_server.start()
        
        print("\n✓ System ready")
        print("Waiting for commands via web UI or TCP...\n")
        
        try:
            last_control_time = time.time()
            start_time = time.time()
            frame_count = 0
            
            while True:
                current_time = time.time()
                
                # Receive OptiTrack data
                raw_data = self.optitrack.receive_data()
                
                if raw_data is None:
                    if not self.optitrack.connected:
                        print("\n✗ OptiTrack connection lost. Reconnecting...")
                        self.motor.stop()
                        time.sleep(1)
                        if not self.optitrack.connect():
                            break
                    continue
                
                # Parse robots
                robots = self.optitrack.parse_robot_data(raw_data)
                our_robot = next((r for r in robots if r['id'] == ROBOT_ID), None)
                
                if not our_robot:
                    if frame_count % 20 == 0:
                        print(f"⚠️  Robot ID {ROBOT_ID} not found")
                    self.motor.stop()
                    frame_count += 1
                    continue
                else:
                    # Apply heading correction
                    our_robot['rotation'] = self.correct_heading(our_robot['rotation'])
                
                # Control loop
                dt = current_time - last_control_time
                
                if dt >= SAMPLE_TIME and self.running and self.current_controller:
                    # Compute control based on current mode
                    result = self.current_controller.compute_control(
                        our_robot['x'], our_robot['y'], our_robot['rotation'], dt
                    )
                    
                    if len(result) == 4:  # goal_reaching or path_tracking
                        wL, wR, debug, done = result
                        if done:
                            print(f"✓ {self.mode_name} completed!")
                            self.stop()
                    else:
                        wL, wR, debug = result
                    
                    self.motor.send_command(wL, wR)
                    
                    # Update status file
                    fps = frame_count / (current_time - start_time) if frame_count > 0 else 0
                    control_data = {'wL': wL, 'wR': wR, **debug}
                    self.status_writer.update(self.mode_name, our_robot, control_data, frame_count, fps)
                    
                    # Print status
                    if frame_count % 20 == 0:
                        print(f"[{self.mode_name}] Frame {frame_count:5d} | "
                              f"Pos: ({our_robot['x']:>7.3f}, {our_robot['y']:>7.3f}) | "
                              f"Motors: L={wL:>6.1f} R={wR:>6.1f}")
                    
                    last_control_time = current_time
                
                frame_count += 1
        
        except KeyboardInterrupt:
            print("\n\n✓ Stopping system...")
        
        finally:
            self.motor.stop()
            self.motor.close()
            self.optitrack.close()
            self.status_writer.clear()
            if self.tcp_server:
                self.tcp_server.stop()
            print("✓ System shutdown complete")


def main():
    # Check for command line arguments
    if len(sys.argv) > 1:
        # Command line mode for testing
        mode = sys.argv[1]
        system = RobotControlSystem()
        
        if mode == "test":
            system.start_motor_test()
        elif mode == "goal" and len(sys.argv) == 4:
            x, y = float(sys.argv[2]), float(sys.argv[3])
            system.start_goal_reaching(x, y)
            system.run()
        elif mode == "path":
            # Example: python lil_demo_path_tracking.py path 0.5,0.5 1.0,1.0
            waypoints = []
            for wp in sys.argv[2:]:
                x, y = map(float, wp.split(','))
                waypoints.append((x, y))
            system.start_path_tracking(waypoints)
            system.run()
    else:
        # Normal mode - wait for web UI or TCP commands
        system = RobotControlSystem()
        system.run()


if __name__ == "__main__":
    main()