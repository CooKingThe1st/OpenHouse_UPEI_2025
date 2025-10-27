"""
OptiTrack Real-Time Position Monitor
Simple standalone program to get and display robot positions from OptiTrack
"""

import socket
import time
import sys
from datetime import datetime

# OptiTrack Configuration
OPTITRACK_SERVER_IP = "192.168.0.100"
OPTITRACK_PORT = 5400
BUFFER_SIZE = 8192

class OptiTrackMonitor:
    """Monitor and display OptiTrack data in real-time"""
   
    def __init__(self, server_ip, port, debug=False):
        self.server_ip = server_ip
        self.port = port
        self.sock = None
        self.connected = False
        self.debug = debug  # Debug mode to show raw data
       
        # Statistics
        self.frame_count = 0
        self.start_time = None
        self.last_print_time = 0
       
    def connect(self):
        """Connect to OptiTrack server"""
        try:
            print(f"[INFO] Connecting to OptiTrack server at {self.server_ip}:{self.port}...")
           
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.sock.settimeout(5.0)  # 5 second timeout for connection
           
            self.sock.connect((self.server_ip, self.port))
           
            self.sock.settimeout(0.5)  # Short timeout for receiving data
            self.connected = True
            self.start_time = time.time()
           
            print(f"[SUCCESS] Connected to OptiTrack server!")
            print(f"[INFO] Receiving data... (Press Ctrl+C to stop)\n")
            print("=" * 80)
           
            return True
           
        except socket.timeout:
            print(f"[ERROR] Connection timeout - server not responding")
            return False
        except ConnectionRefusedError:
            print(f"[ERROR] Connection refused - check if OptiTrack server is running")
            return False
        except Exception as e:
            print(f"[ERROR] Connection failed: {e}")
            return False
   
    def disconnect(self):
        """Disconnect from OptiTrack server"""
        if self.sock:
            try:
                self.sock.close()
            except:
                pass
        self.connected = False
        print("\n[INFO] Disconnected from OptiTrack server")
   
    def parse_robot_data(self, raw_data):
        """Parse robot position data from OptiTrack stream
       
        New format from OptiTrack server:
        id,x,y,z,rotation;id,x,y,z,rotation;...
       
        Example: "1,0.6730,-0.0890,0.0040,-80.6900;2,0.6410,0.5440,0.2130,148.7700;"
        """
        if not raw_data or len(raw_data) < 5:
            return []
       
        try:
            # Split by semicolon - each part is one robot
            parts = raw_data.split(';')
           
            robots = []
            seen_robot_ids = set()  # Track unique robot IDs to avoid duplicates
           
            # Process each semicolon-separated part (each is one robot)
            for part in parts:
                part = part.strip()
                if not part:
                    continue
               
                # Split by comma to get values
                values = [v.strip() for v in part.split(',')]
               
                try:
                    # New format: id, x, y, z, rotation (5 values)
                    if len(values) == 5:
                        robot_id = int(values[0])
                        x = float(values[1])
                        y = float(values[2])
                        z = float(values[3])
                        rotation = float(values[4])
                       
                        # Skip if we've already seen this robot ID
                        if robot_id in seen_robot_ids:
                            continue
                       
                        # Skip if any value is NaN or invalid
                        if any(v != v for v in [x, y, z, rotation]):  # NaN check
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
                   
                except (ValueError, IndexError) as e:
                    # Skip invalid data
                    continue
           
            # Sort robots by ID for consistent display
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
       
        # Clear previous lines (for cleaner output)
        # Note: This works on most terminals but might not work on all
        if self.frame_count > 1 and not self.debug:
            # Move cursor up by number of robots + 3 header lines (+ 2 if debug)
            lines_to_clear = len(robots) + 3
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
            print("No robots detected                                                              ")
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
   
    def monitor_loop(self):
        """Main monitoring loop - receives and displays data"""
        try:
            while self.connected:
                try:
                    # Receive data from OptiTrack
                    data = self.sock.recv(BUFFER_SIZE)
                   
                    if not data:
                        print("\n[WARNING] Server disconnected")
                        break
                   
                    # Decode and clean data
                    decoded = data.decode('utf-8', errors='ignore')
                    cleaned = decoded.replace('\x00', '').strip()
                   
                    # Update frame count
                    self.frame_count += 1
                   
                    # Parse robot positions
                    robots = self.parse_robot_data(cleaned)
                   
                    # Print to terminal (with raw data if debug mode)
                    self.print_robots(robots, cleaned if self.debug else "")
                   
                except socket.timeout:
                    # Normal timeout, continue
                    continue
                   
                except KeyboardInterrupt:
                    raise  # Re-raise to be caught by outer handler
                   
                except Exception as e:
                    print(f"\n[ERROR] Error receiving data: {e}")
                    break
                   
        except KeyboardInterrupt:
            print("\n\n[INFO] Stopped by user (Ctrl+C)")
        finally:
            self.disconnect()
   
    def run(self):
        """Connect and start monitoring"""
        if self.connect():
            self.monitor_loop()


def main():
    """Main entry point"""
    print("=" * 80)
    print("OptiTrack Real-Time Position Monitor")
    print("=" * 80)
    print()
   
    # Check if custom IP/port provided via command line
    server_ip = OPTITRACK_SERVER_IP
    port = OPTITRACK_PORT
    debug = False
   
    # Parse command line arguments
    args = sys.argv[1:]
    for arg in args:
        if arg == '--debug' or arg == '-d':
            debug = True
            args.remove(arg)
            break
   
    if len(args) > 0:
        server_ip = args[0]
    if len(args) > 1:
        port = int(args[1])
   
    print(f"[CONFIG] OptiTrack Server: {server_ip}:{port}")
    if debug:
        print(f"[CONFIG] Debug Mode: ENABLED (showing raw data)")
    print()
   
    # Create and run monitor
    monitor = OptiTrackMonitor(server_ip, port, debug=debug)
    monitor.run()
   
    print("\n[INFO] Program terminated")


if __name__ == "__main__":
    main()
