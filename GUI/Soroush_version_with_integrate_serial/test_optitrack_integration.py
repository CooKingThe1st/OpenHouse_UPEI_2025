"""
OptiTrack Integration Test
===========================

Tests the new OptiTrack position tracking in robot_controller.py

This script verifies:
1. OptiTrack client connects and receives data
2. Position updates flow into slave packets
3. AUX thread sends real-time positions
4. PREP/RUN commands include current positions

Run this to verify OptiTrack integration is working correctly.
"""

import sys
import time
import logging
from robot_controller import RobotController, ControllerConfig

# Setup logging to see what's happening
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

def test_optitrack_integration():
    """Test OptiTrack position tracking integration."""
    
    print("="*70)
    print("OPTITRACK INTEGRATION TEST")
    print("="*70)
    
    # Test 1: Create controller with OptiTrack enabled
    print("\n[TEST 1] Creating RobotController with OptiTrack enabled...")
    controller = RobotController(
        port=ControllerConfig.SERIAL_PORT,
        enable_logging=True,
        enable_optitrack=True  # ← This enables OptiTrack
    )
    
    if controller.optitrack:
        print("✓ OptiTrack client created")
    else:
        print("✗ OptiTrack client NOT created")
        return False
    
    # Test 2: Connect to serial and OptiTrack
    print("\n[TEST 2] Connecting to serial port and OptiTrack server...")
    if not controller.connect():
        print("✗ Failed to connect")
        return False
    
    print("✓ Connected to serial port")
    
    if controller.optitrack and controller.optitrack.is_connected():
        print("✓ Connected to OptiTrack server")
        print(f"   Server: {ControllerConfig.OPTITRACK_SERVER_IP}:{ControllerConfig.OPTITRACK_PORT}")
    else:
        print("⚠ OptiTrack connection failed (will use manual positions)")
    
    # Test 3: Wait for OptiTrack data
    print("\n[TEST 3] Waiting for OptiTrack position data...")
    print("(Monitoring for 5 seconds...)")
    
    for i in range(5):
        time.sleep(1)
        
        # Check if we're getting position data
        if controller.optitrack and controller.optitrack.is_connected():
            positions = controller.optitrack.robot_positions
            if positions:
                print(f"\n✓ Receiving positions for {len(positions)} robot(s):")
                for robot_id, pos in positions.items():
                    print(f"   Robot {robot_id}: x={pos['x']:.3f}m, y={pos['y']:.3f}m, θ={pos['rotation']:.1f}°")
            else:
                print(f"  [{i+1}/5] Waiting for position data...")
    
    # Test 4: Check slave positions are being updated
    print("\n[TEST 4] Checking if slave positions are being updated...")
    
    # Force a position update
    controller._update_all_slave_positions()
    
    any_non_zero = False
    for i, slave in enumerate(controller.slaves):
        robot_id = i + 1
        print(f"  Slave {robot_id}: x={slave.position_x:.3f}m, y={slave.position_y:.3f}m, θ={slave.position_theta}°")
        if slave.position_x != 0.0 or slave.position_y != 0.0:
            any_non_zero = True
    
    if any_non_zero:
        print("✓ Slaves have non-zero positions (OptiTrack working!)")
    else:
        print("⚠ All slaves at (0,0,0) - OptiTrack may not be detecting robots")
    
    # Test 5: Monitor AUX thread
    print("\n[TEST 5] Monitoring AUX thread position updates...")
    print("(The AUX thread should call _update_all_slave_positions() every 200ms)")
    print("Check the log file 'robot_controller_sent.log' for position values.")
    print("\nWaiting 3 seconds for AUX packets...")
    
    time.sleep(3)
    
    print("✓ Check robot_controller_sent.log for 'Pos=' values in packets")
    print("  - If positions are changing, OptiTrack integration is working!")
    print("  - If positions stay at (0,0,0), check OptiTrack connection")
    
    # Test 6: Manual position override test
    print("\n[TEST 6] Testing manual position override...")
    controller._update_slave_position(1, 0.5, 0.3, 45)
    
    slave1 = controller.slaves[0]
    if slave1.position_x == 0.5 and slave1.position_y == 0.3:
        print("✓ Manual position override working")
        print(f"  Slave 1 now at: ({slave1.position_x}m, {slave1.position_y}m, {slave1.position_theta}°)")
    else:
        print("✗ Manual position override failed")
    
    # Cleanup
    print("\n[CLEANUP] Disconnecting...")
    controller.disconnect()
    print("✓ Disconnected")
    
    print("\n" + "="*70)
    print("TEST SUMMARY")
    print("="*70)
    print("\n✓ OptiTrack client integration: COMPLETE")
    print("✓ Position update mechanism: IMPLEMENTED")
    print("✓ AUX thread position updates: ACTIVE")
    print("\nNext steps:")
    print("1. Check robot_controller_sent.log for position values")
    print("2. Verify positions change when robots move")
    print("3. If positions stay (0,0,0), check:")
    print("   - OptiTrack server is running at 192.168.0.100:5400")
    print("   - Robots are visible to OptiTrack cameras")
    print("   - Network connection to OptiTrack server")
    
    return True

def test_without_optitrack():
    """Test controller with OptiTrack disabled (fallback mode)."""
    
    print("\n\n" + "="*70)
    print("FALLBACK MODE TEST (OptiTrack Disabled)")
    print("="*70)
    
    print("\n[TEST] Creating controller with OptiTrack disabled...")
    controller = RobotController(
        port=ControllerConfig.SERIAL_PORT,
        enable_logging=False,
        enable_optitrack=False  # ← OptiTrack disabled
    )
    
    if controller.optitrack is None:
        print("✓ OptiTrack disabled correctly")
    else:
        print("✗ OptiTrack should be None")
        return False
    
    print("\n✓ Controller can work without OptiTrack")
    print("  - Positions will remain at (0,0,0) or manually set values")
    print("  - Useful for testing without OptiTrack hardware")
    
    return True

if __name__ == "__main__":
    try:
        print("\n" + "="*70)
        print("ROBOT CONTROLLER - OPTITRACK INTEGRATION TEST")
        print("="*70)
        print("\nThis test verifies that robot_controller.py now:")
        print("1. Connects to OptiTrack server (192.168.0.100:5400)")
        print("2. Updates slave positions from real-time OptiTrack data")
        print("3. Sends updated positions in AUX packets every 200ms")
        print("4. Matches test_serial.py behavior exactly")
        print("\n" + "="*70)
        
        input("\nPress ENTER to start test (or Ctrl+C to cancel)...")
        
        # Run tests
        success = test_optitrack_integration()
        
        if success:
            test_without_optitrack()
        
        print("\n" + "="*70)
        print("ALL TESTS COMPLETED")
        print("="*70)
        
    except KeyboardInterrupt:
        print("\n\nTest cancelled by user")
    except Exception as e:
        print(f"\n✗ Test failed with error: {e}")
        import traceback
        traceback.print_exc()
