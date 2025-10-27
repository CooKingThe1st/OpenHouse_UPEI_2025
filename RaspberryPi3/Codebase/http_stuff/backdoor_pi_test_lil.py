"""
TCP Client to test robot control backdoor
Quick script to send commands directly to the Pi without using web UI
"""

import socket
import json
import sys

# Configuration
ROBOT_PI_IP = "192.168.0.232"  # ← CHANGE THIS to your Pi's IP
TCP_PORT = 5500

def send_command(command_dict):
    """Send command to robot and print response"""
    try:
        # Connect to robot
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(10.0)  # Longer timeout for calibration
        
        print(f"📡 Connecting to {ROBOT_PI_IP}:{TCP_PORT}...")
        sock.connect((ROBOT_PI_IP, TCP_PORT))
        print(f"✓ Connected!")
        
        # Send command
        command_json = json.dumps(command_dict)
        print(f"📤 Sending: {command_json}")
        sock.sendall(command_json.encode('utf-8'))
        
        # Receive response
        response_data = sock.recv(4096)
        response = json.loads(response_data.decode('utf-8'))
        
        print(f"📥 Response: {json.dumps(response, indent=2)}")
        
        sock.close()
        return response
        
    except Exception as e:
        print(f"✗ Error: {e}")
        return None


def main():
    print("\n" + "="*60)
    print("🤖 Robot TCP Command Client")
    print("="*60)
    print(f"Target: {ROBOT_PI_IP}:{TCP_PORT}")
    print("="*60 + "\n")
    
    if len(sys.argv) < 2:
        print("Usage examples:")
        print("  python backdoor_pi_test_lil.py cal         # Calibrate heading offset")
        print("  python backdoor_pi_test_lil.py manual <vL> <vR>  # Manual velocity test")
        print("  python backdoor_pi_test_lil.py test              # Test all motors")
        print("  python backdoor_pi_test_lil.py goal <x> <y>      # Go to goal")
        print("  python backdoor_pi_test_lil.py path <x1,y1> <x2,y2> ...  # Follow path")
        print("  python backdoor_pi_test_lil.py stop              # Stop robot")
        print("  python backdoor_pi_test_lil.py status            # Get status")
        return
    
    mode = sys.argv[1].lower()

    if mode == "cal" or mode == "calibrate_heading":
        # Heading calibration
        print("\n🧭 Starting heading calibration...")
        print("   Robot will drive forward for 3 seconds")
        print("   Make sure there's clear space ahead!\n")
        
        response = input("Continue? (y/n): ")
        if response.lower() != 'y':
            print("Calibration cancelled")
            return

        command = {"command": "calibrate_heading"}
        result = send_command(command)
        
        if result and result.get('success'):
            print("\n✓ Calibration successful!")
            if 'offset_deg' in result:
                print(f"   Heading offset: {result['offset_deg']:.2f}°")
        else:
            print("\n✗ Calibration failed")
            if result:
                print(f"   Error: {result.get('error', 'Unknown error')}")
    
    elif mode == "manual":
        # Manual velocity test
        if len(sys.argv) != 4:
            print("Usage: python backdoor_pi_test_lil.py manual <vL> <vR>")
            print("Example: python backdoor_pi_test_lil.py manual 40 40")
            return
        vL = float(sys.argv[2])
        vR = float(sys.argv[3])
        command = {"command": "manual_velocity", "vL": vL, "vR": vR}
        send_command(command)
    
    elif mode == "test":
        # Test motors
        command = {"command": "test_motor"}
        send_command(command)
    
    elif mode == "goal":
        # Goal reaching
        if len(sys.argv) != 4:
            print("Usage: python backdoor_pi_test_lil.py goal <x> <y>")
            print("Example: python backdoor_pi_test_lil.py goal 0.5 0.5")
            return
        x = float(sys.argv[2])
        y = float(sys.argv[3])
        command = {"command": "goal_reaching", "goal_x": x, "goal_y": y}
        send_command(command)
    
    elif mode == "path":
        # Path tracking
        if len(sys.argv) < 3:
            print("Usage: python backdoor_pi_test_lil.py path <x1,y1> <x2,y2> ...")
            print("Example: python backdoor_pi_test_lil.py path 0.5,0.5 1.0,1.0 0.5,-0.5")
            return
        waypoints = []
        for wp in sys.argv[2:]:
            x, y = map(float, wp.split(','))
            waypoints.append([x, y])
        command = {"command": "path_tracking", "waypoints": waypoints}
        send_command(command)
    
    elif mode == "stop":
        # Stop robot
        command = {"command": "stop"}
        send_command(command)
    
    elif mode == "status":
        # Get status
        command = {"command": "status"}
        send_command(command)
    
    else:
        print(f"Unknown command: {mode}")
        print("Available: calibrate, manual, test, goal, path, stop, status")


if __name__ == "__main__":
    main()