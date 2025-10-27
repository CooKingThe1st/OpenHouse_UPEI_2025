import socket
import time
import math
import serial

# ============== Configuration ==============
OPTITRACK_SERVER_IP = "192.168.0.100"
CLIENT_IP = "192.168.0.232"
BROADCAST_PORT = 5400
BUFFER_SIZE = 8192

# ============== Circular Path Configuration ==============
CIRCLE_CENTER_X = 0.67  # meters - CHANGE THIS
CIRCLE_CENTER_Y = -0.09  # meters - CHANGE THIS
CIRCLE_RADIUS = 0.2    # meters - CHANGE THIS
ROBOT_ID = 2           # Which robot to control (matches your C++ code)

# ============== Motor Control Configuration ==============
SERIAL_PORT = "/dev/serial0"  # ← FIXED: Hardware UART (was /dev/ttyACM0)
SERIAL_BAUD = 115200

# Control parameters (from your C++ code)
MAX_SPEED = 60.0       # Maximum wheel velocity
ROTATION_GAIN = 3.0    # Rotation control gain
SAMPLE_TIME = 0.05     # 50ms = 20Hz control rate
ZUMO_SAT = 95.0        # Velocity saturation limit

# PID parameters (tune these for your robot)
KP = 2.0  # Proportional gain
KI = 0.0  # Integral gain (set to 0 for simple P control)
KD = 0.5  # Derivative gain

class OptiTrackClient:
    def __init__(self, server_ip, port):
        self.server_ip = server_ip
        self.port = port
        self.sock = None
        self.connected = False
        
    def connect(self):
        """Connect to the OptiTrack broadcasting server"""
        try:
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.sock.settimeout(5.0)
            
            print(f"Connecting to {self.server_ip}:{self.port}...")
            self.sock.connect((self.server_ip, self.port))
            
            print(f"✓ Connected to OptiTrack server")
            self.connected = True
            self.sock.settimeout(0.5)  # ← FIXED: Changed to 0.5 like other clients
            return True
            
        except Exception as e:
            print(f"✗ Connection error: {e}")
            return False
    
    def receive_data(self):
        """Receive robot data from server"""
        if not self.connected:
            return None
        
        try:
            data = self.sock.recv(BUFFER_SIZE)
            
            if not data:
                print("✗ Server disconnected")
                self.connected = False
                return None
            
            # ← FIXED: Same decoding as client_rasp_opti and test_com
            decoded = data.decode('utf-8', errors='ignore')
            cleaned = decoded.replace('\x00', '').strip()
            return cleaned
            
        except socket.timeout:
            # ← ADDED: Handle timeout gracefully
            return None
        except Exception as e:
            print(f"✗ Receive error: {e}")
            self.connected = False
            return None
    
    def parse_robot_data(self, raw_data):
        """
        Parse robot data - NEW FORMAT with ID included
        Format: "id,x,y,z,rotation;id,x,y,z,rotation;..."
        Example: "1,0.6730,-0.0890,0.0040,-80.6900;2,0.6410,0.5440,0.2130,148.7700;"
        """
        if not raw_data or len(raw_data) < 5:
            return []
        
        try:
            # Split by semicolon - each part is one robot
            parts = raw_data.split(';')
            
            robots = []
            seen_robot_ids = set()  # ← ADDED: Track unique robot IDs
            
            # Process each semicolon-separated part
            for part in parts:
                part = part.strip()
                if not part:
                    continue
                
                # Split by comma to get values
                values = [v.strip() for v in part.split(',')]
                
                try:
                    # NEW FORMAT: id, x, y, z, rotation (5 values)
                    if len(values) == 5:
                        robot_id = int(values[0])
                        x = float(values[1])
                        y = float(values[2])
                        z = float(values[3])
                        rotation = float(values[4])
                        
                        # ← ADDED: Skip if duplicate
                        if robot_id in seen_robot_ids:
                            continue
                        
                        # ← ADDED: Skip if any value is NaN
                        if any(v != v for v in [x, y, z, rotation]):
                            continue
                        
                        seen_robot_ids.add(robot_id)
                        
                        robot = {
                            'id': robot_id,  # ← FIXED: Use actual ID from data
                            'type': 'robot',
                            'x': x,
                            'y': y,
                            'z': z,
                            'rotation': rotation
                        }
                        robots.append(robot)
                    
                except (ValueError, IndexError):
                    continue
            
            # ← ADDED: Sort by ID for consistency
            robots.sort(key=lambda r: r['id'])
            
            return robots
            
        except Exception as e:
            return []
    
    def close(self):
        """Close the socket connection"""
        if self.sock:
            self.sock.close()
            self.connected = False


class CircularPathController:
    def __init__(self, center_x, center_y, radius, kp=2.0, ki=0.0, kd=0.5):
        self.center_x = center_x
        self.center_y = center_y
        self.radius = radius
        
        # PID parameters
        self.kp = kp
        self.ki = ki
        self.kd = kd
        
        # PID state
        self.prev_error = 0.0
        self.integral = 0.0
        
        # Velocity limits
        self.prev_wL = 0.0
        self.prev_wR = 0.0
        
    def wrap_angle(self, angle):
        """Normalize angle to [-π, π]"""
        while angle > math.pi:
            angle -= 2 * math.pi
        while angle < -math.pi:
            angle += 2 * math.pi
        return angle
    
    def saturation(self, value, min_val, max_val):
        """Limit value between min and max"""
        return max(min_val, min(max_val, value))
    
    def zumo_saturation(self, old_w, new_w):
        """Rate limiter for smooth acceleration (from your C++ code)"""
        if abs(old_w - new_w) > ZUMO_SAT:
            if new_w > old_w:
                return old_w + ZUMO_SAT
            else:
                return old_w - ZUMO_SAT
        return new_w
    
    def calculate_wheel_velocities(self, theta, norm_v, rotation_gain):
        """
        Calculate left and right wheel velocities
        Converted from your C++ calculateWheelVelocities function
        
        theta: heading error (radians)
        norm_v: desired velocity magnitude
        rotation_gain: gain for rotation control
        """
        # Calculate wheel velocities based on heading error
        wL = norm_v - rotation_gain * theta
        wR = norm_v + rotation_gain * theta
        
        # Apply saturation
        wL = self.saturation(wL, -MAX_SPEED, MAX_SPEED)
        wR = self.saturation(wR, -MAX_SPEED, MAX_SPEED)
        
        # Apply rate limiting for smooth motion
        wL = self.zumo_saturation(self.prev_wL, wL)
        wR = self.zumo_saturation(self.prev_wR, wR)
        
        # Store for next iteration
        self.prev_wL = wL
        self.prev_wR = wR
        
        return wL, wR
    
    def compute_control(self, robot_x, robot_y, robot_rotation_deg, dt):
        """
        Compute motor commands to follow circular path
        
        Returns: (wL, wR, debug_info)
        """
        # Convert rotation from degrees to radians
        robot_theta = math.radians(robot_rotation_deg)
        
        # Step 1: Calculate distance to circle center
        dx = robot_x - self.center_x
        dy = robot_y - self.center_y
        distance_to_center = math.sqrt(dx**2 + dy**2)
        
        # Step 2: Calculate radial error (distance from desired circle)
        radial_error = distance_to_center - self.radius
        
        # Step 3: Calculate desired direction (tangent to circle)
        # Angle from center to robot
        angle_to_robot = math.atan2(dy, dx)
        
        # Tangent angle (perpendicular to radial direction)
        # Add π/2 for counter-clockwise motion
        desired_tangent = angle_to_robot + math.pi / 2
        
        # If radial error is large, blend in corrective angle
        if abs(radial_error) > 0.05:  # 5cm threshold
            # Calculate angle towards/away from center
            radial_correction = math.atan2(dy, dx)
            if radial_error > 0:  # Too far from center
                radial_correction += math.pi  # Point towards center
            
            # Blend tangent and radial correction
            blend_factor = min(abs(radial_error) / self.radius, 0.5)
            desired_heading = (1 - blend_factor) * desired_tangent + blend_factor * radial_correction
        else:
            desired_heading = desired_tangent
        
        # Step 4: Calculate heading error
        heading_error = self.wrap_angle(desired_heading - robot_theta)
        
        # Step 5: PID control for velocity based on radial error
        self.integral += radial_error * dt
        derivative = (radial_error - self.prev_error) / dt if dt > 0 else 0.0
        
        velocity_correction = -(self.kp * radial_error + 
                               self.ki * self.integral + 
                               self.kd * derivative)
        
        self.prev_error = radial_error
        
        # Base velocity for circular motion
        base_velocity = MAX_SPEED * 0.5  # 50% of max speed
        desired_velocity = base_velocity + velocity_correction
        desired_velocity = self.saturation(desired_velocity, 0, MAX_SPEED)
        
        # Step 6: Calculate wheel velocities
        wL, wR = self.calculate_wheel_velocities(
            heading_error, 
            desired_velocity, 
            ROTATION_GAIN
        )
        
        # Debug info
        debug_info = {
            'distance_to_center': distance_to_center,
            'radial_error': radial_error,
            'heading_error_deg': math.degrees(heading_error),
            'desired_velocity': desired_velocity,
            'wL': wL,
            'wR': wR
        }
        
        return wL, wR, debug_info


class MotorController:
    def __init__(self, port=SERIAL_PORT, baudrate=SERIAL_BAUD):
        self.port = port
        self.baudrate = baudrate
        self.ser = None
        self.connected = False
        
    def connect(self):
        """Connect to motor controller via serial - FIXED VERSION"""
        try:
            print(f"Connecting to motor controller on {self.port}...")
            
            # ✅ FIXED: Add proper serial configuration for hardware UART
            self.ser = serial.Serial(
                port=self.port,
                baudrate=self.baudrate,
                bytesize=serial.EIGHTBITS,
                parity=serial.PARITY_NONE,
                stopbits=serial.STOPBITS_ONE,
                timeout=1,
                xonxoff=False,
                rtscts=False,
                dsrdtr=False
            )
            
            # ✅ FIXED: Reduced wait time for hardware UART (no Arduino reset)
            time.sleep(0.5)  # Was 2 seconds
            
            # ✅ FIXED: Flush buffers
            self.ser.reset_input_buffer()
            self.ser.reset_output_buffer()
            
            print(f"✓ Connected to motor controller")
            self.connected = True
            return True
            
        except Exception as e:
            print(f"✗ Motor controller connection error: {e}")
            return False
    
    def send_command(self, wL, wR):
        """
        Send motor command to Zumo robot
        Format: "g,wL,wR\n" (from your C++ code)
        """
        if not self.connected:
            return False
        
        try:
            command = f"g,{wL:.2f},{wR:.2f}\n"
            self.ser.write(command.encode('utf-8'))
            self.ser.flush()  # ✅ FIXED: Force write to hardware
            return True
            
        except Exception as e:
            print(f"✗ Motor command error: {e}")
            self.connected = False
            return False
    
    def stop(self):
        """Stop the robot"""
        if self.connected:
            try:
                command = "s,0,0,0,0,0\n"
                self.ser.write(command.encode('utf-8'))
                self.ser.flush()  # ✅ FIXED: Force write to hardware
            except Exception as e:
                print(f"✗ Stop error: {e}")
    
    def close(self):
        """Close serial connection"""
        if self.ser:
            self.stop()
            time.sleep(0.5)
            self.ser.close()
            self.connected = False


def main():
    print("\n" + "="*70)
    print("🎯 Circular Path Tracking with OptiTrack")
    print("="*70)
    print(f"Circle Center: ({CIRCLE_CENTER_X:.2f}, {CIRCLE_CENTER_Y:.2f})")
    print(f"Circle Radius: {CIRCLE_RADIUS:.2f} m")
    print(f"Target Robot ID: {ROBOT_ID}")
    print(f"Serial Port: {SERIAL_PORT}")
    print(f"Data Format: id,x,y,z,rotation")  # ← ADDED
    print("="*70 + "\n")
    
    # Initialize clients
    optitrack = OptiTrackClient(OPTITRACK_SERVER_IP, BROADCAST_PORT)
    motor = MotorController()
    controller = CircularPathController(CIRCLE_CENTER_X, CIRCLE_CENTER_Y, CIRCLE_RADIUS, KP, KI, KD)
    
    # Connect to OptiTrack
    if not optitrack.connect():
        print("Failed to connect to OptiTrack. Exiting.")
        return
    
    # Connect to motor controller
    if not motor.connect():
        print("Failed to connect to motor controller. Running in simulation mode.")
        motor.connected = False
    
    print("\nPress Ctrl+C to stop\n")
    
    try:
        last_control_time = time.time()
        frame_count = 0
        
        while True:
            current_time = time.time()
            
            # Receive OptiTrack data
            raw_data = optitrack.receive_data()
            
            if raw_data is None:
                if not optitrack.connected:
                    print("\n✗ OptiTrack connection lost. Reconnecting...")
                    motor.stop()
                    time.sleep(1)
                    if not optitrack.connect():
                        break
                continue  # ← FIXED: Continue if just timeout, not error
            
            # Parse robot data
            robots = optitrack.parse_robot_data(raw_data)
            
            # Find our robot by ID (not by position!)
            our_robot = None
            for robot in robots:
                if robot['id'] == ROBOT_ID:  # ← FIXED: Compare actual ID
                    our_robot = robot
                    break
            
            if our_robot is None:
                # Robot not found, stop motors
                if frame_count % 20 == 0:  # Print every 20 frames
                    print(f"⚠️  Robot ID {ROBOT_ID} not found in tracking data")
                motor.stop()
                frame_count += 1
                continue
            
            # Control loop at SAMPLE_TIME rate
            dt = current_time - last_control_time
            
            if dt >= SAMPLE_TIME:
                # Compute control
                wL, wR, debug = controller.compute_control(
                    our_robot['x'],
                    our_robot['y'],
                    our_robot['rotation'],
                    dt
                )
                
                # Send motor commands
                motor.send_command(wL, wR)
                
                # Print status every second
                if frame_count % 20 == 0:
                    print(f"Frame {frame_count:5d} | "
                          f"ID: {our_robot['id']} | "  # ← ADDED: Show robot ID
                          f"Pos: ({our_robot['x']:>7.3f}, {our_robot['y']:>7.3f}) | "
                          f"Rot: {our_robot['rotation']:>6.1f}° | "
                          f"R_err: {debug['radial_error']:>6.3f} | "
                          f"H_err: {debug['heading_error_deg']:>6.1f}° | "
                          f"Motors: L={wL:>6.1f} R={wR:>6.1f}")
                
                last_control_time = current_time
            
            frame_count += 1
    
    except KeyboardInterrupt:
        print("\n\n✓ Stopping robot...")
    
    finally:
        motor.stop()
        motor.close()
        optitrack.close()
        print("✓ System shutdown complete")


if __name__ == "__main__":
    main()