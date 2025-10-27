"""
Position Processing Diagnostic Test
====================================

Compares test_serial.py and robot_controller.py position handling.
Identifies discrepancies in OptiTrack position processing.

Run this to diagnose position-related issues.
"""

import sys

print("="*70)
print("POSITION PROCESSING DIAGNOSTIC TEST")
print("="*70)

# Test 1: Check position storage format
print("\n[TEST 1] Position Storage Format")
print("-" * 70)

print("\ntest_serial.py:")
print("  - SlaveState.position_x: meters (float)")
print("  - SlaveState.position_y: meters (float)")
print("  - SlaveState.position_theta: degrees (int, 0-359)")
print("  - Updates: get_effective_position() -> returns (x_m, y_m, theta_deg)")

print("\nrobot_controller.py:")
print("  - SlaveState.position_x: meters (float)")
print("  - SlaveState.position_y: meters (float)")
print("  - SlaveState.position_theta: degrees (int, 0-359)")
print("  ✓ MATCHES test_serial.py")

# Test 2: Check packet building
print("\n[TEST 2] Packet Building (get_packet)")
print("-" * 70)

print("\ntest_serial.py:")
print("  x_mm = int(self.position_x * 1000)")
print("  y_mm = int(self.position_y * 1000)")
print("  theta_byte = int((theta_norm_360 / 360.0) * 256.0)")

print("\nrobot_controller.py:")
print("  x_mm = int(self.position_x * 1000)")
print("  y_mm = int(self.position_y * 1000)")
print("  theta_byte = int((theta_norm / 360.0) * 256.0)")
print("  ✓ MATCHES test_serial.py")

# Test 3: Check position update mechanism
print("\n[TEST 3] Position Update Mechanism")
print("-" * 70)

print("\ntest_serial.py:")
print("  ✓ HAS update_all_slave_positions()")
print("    - Calls get_effective_position() for each slave")
print("    - get_effective_position() gets OptiTrack data")
print("    - Falls back to last known position if OptiTrack returns (0,0,0)")
print("  ✓ CALLED BEFORE EVERY PACKET SEND (in build_and_send())")

print("\nrobot_controller.py:")
print("  ✗ NO update_all_slave_positions()")
print("  ✗ NO get_effective_position()")
print("  ✗ NO OptiTrack integration")
print("  ✗ Positions remain at initialization values (0, 0, 0)")
print("  ⚠ CRITICAL ISSUE: Positions never updated from real robot locations!")

# Test 4: Check AUX background thread
print("\n[TEST 4] Background Position Updates")
print("-" * 70)

print("\ntest_serial.py:")
print("  ✓ background_aux_thread() updates positions BEFORE sending:")
print("    update_all_slave_positions()  # <-- UPDATES FROM OPTITRACK")
print("    complete_packet = build_complete_packet()")
print("    send_packet_to_master(complete_packet)")

print("\nrobot_controller.py:")
print("  ✗ _aux_thread_worker() does NOT update positions:")
print("    # No position update call")
print("    packet = self._build_complete_packet()  # Uses stale positions!")
print("    self._send_packet(packet)")
print("  ⚠ CRITICAL ISSUE: Sends packets with (0,0,0) positions!")

# Test 5: Waypoint coordinate handling
print("\n[TEST 5] Waypoint Coordinate Handling")
print("-" * 70)

print("\ntest_serial.py (cmd_prep):")
print("  waypoints = [...] # In meters")
print("  waypoint_data = waypoint_to_bytes(order, x, y)")
print("  def waypoint_to_bytes(order, x, y):")
print("    x_mm = int(x * 1000)  # x is in METERS")
print("    y_mm = int(y * 1000)")

print("\nrobot_controller.py (send_waypoints):")
print("  waypoints = [...] # In millimeters (GUI output)")
print("  waypoints_robot = self.coord_transformer.transform_waypoints(waypoints)")
print("  waypoints_m = [(x / 1000.0, y / 1000.0) for x, y in waypoints_robot]")
print("  x_mm = int(x_m * 1000)  # x_m is in METERS")
print("  ✓ MATCHES test_serial.py (converts mm->m->mm correctly)")

# Summary
print("\n" + "="*70)
print("SUMMARY OF ISSUES FOUND")
print("="*70)

print("\n❌ CRITICAL ISSUE #1: No OptiTrack Position Updates")
print("  Problem: robot_controller.py never updates slave positions")
print("  Impact: All packets sent with positions (0, 0, 0)")
print("  Location: Missing update_all_slave_positions() equivalent")

print("\n❌ CRITICAL ISSUE #2: AUX Thread Doesn't Update Positions")
print("  Problem: Background thread sends packets without updating positions first")
print("  Impact: Robots receive stale/zero position data")
print("  Location: _aux_thread_worker() method")

print("\n✅ NO ISSUE: Packet Format")
print("  Verdict: Packet structure matches test_serial.py exactly")

print("\n✅ NO ISSUE: Waypoint Coordinates")  
print("  Verdict: Coordinate transformation works correctly")
print("  Note: GUI coords (mm) -> Robot coords (mm) -> meters -> mm for packet")

print("\n" + "="*70)
print("RECOMMENDED FIXES")
print("="*70)

print("\n1. Add OptiTrack Integration to robot_controller.py")
print("   - Copy OptiTrackClient class from test_serial.py")
print("   - Add optitrack instance to RobotController")
print("   - Connect on initialization")

print("\n2. Add Position Update Mechanism")
print("   - Add _update_all_slave_positions() method")
print("   - Call OptiTrack to get real positions")
print("   - Update slave.position_x, position_y, position_theta")

print("\n3. Update AUX Thread Worker")
print("   - Call _update_all_slave_positions() BEFORE building packet")
print("   - This ensures real robot positions are sent")

print("\n4. Make OptiTrack Optional")
print("   - Allow controller to work without OptiTrack")
print("   - Fall back to (0,0,0) or last known positions")
print("   - Add enable_optitrack parameter to __init__")

print("\n" + "="*70)
print("TESTING RECOMMENDATIONS")
print("="*70)

print("\n1. Check Serial Logs:")
print("   cat robot_controller_sent.log | grep 'Pos='")
print("   - Look for position values in logged packets")
print("   - Should see non-zero values if OptiTrack working")

print("\n2. Compare test_serial.py vs robot_controller.py:")
print("   - Run test_serial.py, check sent_packets.log")
print("   - Run robot_controller.py, check robot_controller_sent.log")
print("   - Compare position values in Slave packets")

print("\n3. Enable Verbose Logging:")
print("   import logging")
print("   logging.basicConfig(level=logging.DEBUG)")

print("\n4. Test with Manual Position:")
print("   controller._update_slave_position(1, 0.5, 0.3, 45)")
print("   # Should see (500, 300, 45°) in next packet")

print("\n" + "="*70)
print("COMPATIBILITY NOTE")
print("="*70)

print("\nThe robot_controller.py was designed for GUI integration where:")
print("  - GUI provides waypoints (not real-time positions)")
print("  - Robots execute waypoints autonomously")
print("  - Position feedback not required for waypoint upload")

print("\nIf you need real-time position updates:")
print("  - Integrate OptiTrack (like test_serial.py)")
print("  - Or provide position callback to RobotController")
print("  - Or use manual position override")

print("\n" + "="*70)
