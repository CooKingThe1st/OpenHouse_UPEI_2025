import serial
import time

# ============== Configuration ==============
SERIAL_PORT = "/dev/serial0"  # Hardware UART (same as C++)
SERIAL_BAUD = 115200

# Test parameters
TEST_SPEED = 50.0
ROTATION_SPEED = 40.0

class MotorTester:
    def __init__(self, port=SERIAL_PORT, baudrate=SERIAL_BAUD):
        self.port = port
        self.baudrate = baudrate    
        self.ser = None
        self.connected = False
        
    def connect(self):
        """Connect to motor controller via serial"""
        try:
            print(f"Connecting to {self.port}...")
            # Add extra settings to match hardware UART
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
            
            # Don't wait for Arduino reset on hardware UART
            time.sleep(0.5)  # Reduced from 2 seconds
            
            # Flush buffers
            self.ser.reset_input_buffer()
            self.ser.reset_output_buffer()
            
            print(f"✓ Connected to motor controller")
            self.connected = True
            return True
        except Exception as e:
            print(f"✗ Connection error: {e}")
            return False
    
    def send_command(self, wL, wR, verbose=True):
        """
        Send motor command
        Format: "g,wL,wR\n"
        """
        if not self.connected:
            print("✗ Not connected!")
            return False
        
        try:
            command = f"g,{wL:.2f},{wR:.2f}\n"
            
            # Encode and send
            self.ser.write(command.encode('utf-8'))
            self.ser.flush()  # Force write to hardware
            
            if verbose:
                print(f"   → Sent: {command.strip()}")
                print(f"   → Bytes: {command.encode('utf-8')}")
            
            return True
        except Exception as e:
            print(f"✗ Send error: {e}")
            self.connected = False
            return False
    
    def stop(self, verbose=True):
        """Stop the motors - exact format from C++"""
        if self.connected:
            try:
                # Exact format from C++ code: "s,0,0,0,0,0\n"
                command = "s,0,0,0,0,0\n"
                self.ser.write(command.encode('utf-8'))
                self.ser.flush()
                if verbose:
                    print(f"   → STOP sent: {command.strip()}")
            except Exception as e:
                print(f"✗ Stop error: {e}")
    
    def test_raw_command(self, command_str):
        """Send raw command for debugging"""
        if self.connected:
            try:
                self.ser.write(command_str.encode('utf-8'))
                self.ser.flush()
                print(f"   → Raw sent: {repr(command_str)}")
                time.sleep(0.1)
                
                # Try to read response if any
                if self.ser.in_waiting > 0:
                    response = self.ser.read(self.ser.in_waiting)
                    print(f"   ← Response: {response}")
            except Exception as e:
                print(f"✗ Raw command error: {e}")
    
    def close(self):
        """Close serial connection"""
        if self.ser:
            self.stop(verbose=False)
            time.sleep(0.5)
            self.ser.close()
            self.connected = False
            print("✓ Connection closed")


def run_simple_test(tester):
    """Simple forward test"""
    print("\n" + "="*60)
    print("🔧 Simple Motor Test")
    print("="*60)
    
    try:
        # Test 1: Very slow forward
        print("\n[TEST 1] Slow forward for 2 seconds (speed=30)...")
        tester.send_command(30, 30)
        time.sleep(2)
        
        # Stop
        print("\n[TEST 2] STOP for 1 second...")
        tester.stop()
        time.sleep(1)
        
        # Test 2: Medium forward
        print("\n[TEST 3] Medium forward for 2 seconds (speed=50)...")
        tester.send_command(50, 50)
        time.sleep(2)
        
        # Stop
        print("\n[TEST 4] STOP")
        tester.stop()
        
        print("\n✓ Test completed!")
        
    except KeyboardInterrupt:
        print("\n\n⚠️  Test interrupted!")
        tester.stop()


def run_debug_test(tester):
    """Debug test - send various commands"""
    print("\n" + "="*60)
    print("🐛 Debug Test - Raw Commands")
    print("="*60)
    
    # Test various command formats
    test_commands = [
        "s,0,0,0,0,0\n",
        "g,50.0,50.0\n",
        "g,100,100\n",
        "s,0,0,0,0,0\n"
    ]
    
    for cmd in test_commands:
        print(f"\nSending: {repr(cmd)}")
        tester.test_raw_command(cmd)
        time.sleep(2)


def main():
    print("\n" + "="*60)
    print("🤖 Zumo Robot Motor Test - DEBUG MODE")
    print("="*60)
    print(f"Serial Port: {SERIAL_PORT}")
    print(f"Baud Rate: {SERIAL_BAUD}")
    print("="*60)
    
    # Create tester
    tester = MotorTester()
    
    # Connect
    if not tester.connect():
        print("\n❌ Failed to connect.")
        print("\n🔧 Troubleshooting:")
        print("  1. Enable UART: sudo raspi-config → Interface → Serial")
        print("     - Disable login shell: YES")
        print("     - Enable serial port: YES")
        print("  2. Check /boot/config.txt has: enable_uart=1")
        print("  3. Reboot after changes")
        print("  4. Check permissions: ls -l /dev/serial0")
        print("  5. Add to dialout: sudo usermod -a -G dialout $USER")
        return
    
    print("\n⚠️  Choose test mode:")
    print("  1 - Simple test (recommended)")
    print("  2 - Debug mode (raw commands)")
    
    choice = input("\nEnter 1 or 2: ").strip()
    
    print("\n⚠️  Robot will start moving!")
    print("Press Ctrl+C to stop anytime.")
    time.sleep(2)
    
    try:
        if choice == "2":
            run_debug_test(tester)
        else:
            run_simple_test(tester)
    finally:
        tester.close()
        print("\n✓ Motors stopped.\n")


if __name__ == "__main__":
    main()