"""
Quick Reference: OptiTrack Integration in robot_controller.py
==============================================================

WHAT CHANGED
------------
✓ OptiTrack client now integrated (connects to 192.168.0.100:5400)
✓ Real-time position updates from OptiTrack
✓ AUX thread updates positions before every packet send
✓ All commands (PREP, RUN, STOP) use current robot positions
✓ Matches test_serial.py behavior exactly

HOW TO USE
----------

Basic Usage (OptiTrack Enabled - Default):
------------------------------------------
from robot_controller import RobotController

# Create controller - OptiTrack enabled by default
controller = RobotController()

# Connect - automatically connects to OptiTrack
controller.connect()
# Output:
#   ✓ Connected to COM5 at 9600 baud
#   ✓ OptiTrack connected - real-time position tracking enabled

# Send waypoints - positions automatically updated
controller.send_waypoints('red', waypoints)

# Disconnect - cleans up OptiTrack connection
controller.disconnect()


Disable OptiTrack (Testing/Fallback):
-------------------------------------
# Create controller WITHOUT OptiTrack
controller = RobotController(enable_optitrack=False)

# Positions will stay at (0,0,0) or manually set values
controller.connect()


Manual Position Override:
------------------------
# Set position manually (meters and degrees)
controller._update_slave_position(
    slave_id=1,     # Robot 1
    x=0.5,          # 0.5 meters
    y=0.3,          # 0.3 meters  
    theta=45        # 45 degrees
)

# Note: Will be overwritten by next OptiTrack update if enabled!


Check OptiTrack Status:
-----------------------
# Check if OptiTrack is connected
if controller.optitrack and controller.optitrack.is_connected():
    print("OptiTrack running")
else:
    print("OptiTrack not available")

# Get position for a specific robot
if controller.optitrack:
    x, y, theta = controller.optitrack.get_position(robot_id=1)
    print(f"Robot 1: ({x:.3f}m, {y:.3f}m, {theta}°)")


WHAT HAPPENS AUTOMATICALLY
---------------------------

When you call controller.connect():
  1. Opens serial connection to COM5
  2. Connects to OptiTrack at 192.168.0.100:5400
  3. Starts background thread to receive positions
  4. Starts AUX thread (sends packets every 200ms)

During AUX thread (every 200ms):
  1. Updates ALL slave positions from OptiTrack
  2. Builds packet with current positions
  3. Sends packet to master Wixel
  
When you call send_waypoints/run_mission/stop_robot:
  1. Updates ALL slave positions from OptiTrack
  2. Builds packet with current positions
  3. Sends command packet

When you call controller.disconnect():
  1. Stops AUX thread
  2. Disconnects from OptiTrack
  3. Closes serial connection


LOGGING & DEBUGGING
-------------------

Check Sent Packets Log:
  Type: cat robot_controller_sent.log | Select-String "Pos="
  
  Look for position values like:
    Pos=(234mm, -567mm, 128°)  ← Real positions from OptiTrack
  
  NOT like:
    Pos=(0mm, 0mm, 0°)         ← Stale/zero positions (BAD!)

Enable Debug Logging:
  import logging
  logging.basicConfig(level=logging.DEBUG)
  
  # Now you'll see detailed OptiTrack messages:
  # [OptiTrack Thread] Started - receiving position data...
  # ✓ Connected to OptiTrack server at 192.168.0.100:5400
  # Robot 1: x=0.234, y=-0.567, θ=128°


CONFIGURATION
-------------

Default Settings (in ControllerConfig):
  OPTITRACK_SERVER_IP = "192.168.0.100"
  OPTITRACK_PORT = 5400
  ENABLE_OPTITRACK = True
  AUX_SEND_INTERVAL = 0.2  # 200ms

To Change:
  from robot_controller import ControllerConfig
  
  # Change OptiTrack server
  ControllerConfig.OPTITRACK_SERVER_IP = "192.168.1.100"
  
  # Change AUX interval
  ControllerConfig.AUX_SEND_INTERVAL = 0.5  # 500ms


TROUBLESHOOTING
---------------

Problem: "OptiTrack connection failed"
Solution:
  - Check OptiTrack server is running
  - Ping 192.168.0.100
  - Check firewall allows port 5400
  - Verify IP in ControllerConfig

Problem: Positions stay at (0, 0, 0)
Solution:
  - Check robots visible to OptiTrack cameras
  - Verify OptiTrack server is sending data
  - Run test_serial.py to verify OptiTrack working
  - Check robot IDs match (1-4)

Problem: Positions not updating
Solution:
  - Check AUX thread is running (see logs)
  - Verify OptiTrack still connected
  - Check network connection stable


TESTING
-------

Run Integration Test:
  python test_optitrack_integration.py
  
  This will:
  - Connect to OptiTrack
  - Monitor position updates
  - Verify AUX thread
  - Check log files

Run Diagnostic Test:
  python test_position_processing.py
  
  This will:
  - Compare test_serial.py vs robot_controller.py
  - Identify any discrepancies
  - Show recommended fixes


GUI INTEGRATION
---------------

The GUI code requires NO CHANGES!

gui_with_robots.py:
  # OptiTrack is automatically used
  robot_bridge = RobotBridge()
  robot_bridge.initialize_robot('red')  # OptiTrack enabled
  
gui_robot_bridge.py:
  # No changes needed - automatically uses OptiTrack


MIGRATION FROM test_serial.py
------------------------------

If you're used to test_serial.py:

test_serial.py                    robot_controller.py
--------------                    -------------------
optitrack.get_position(id)   →    controller.optitrack.get_position(id)
update_all_slave_positions() →    controller._update_all_slave_positions()
slaves[i].position_x         →    controller.slaves[i].position_x
build_and_send(label)        →    controller._send_packet(packet, label)


BACKWARD COMPATIBILITY
----------------------

✓ All existing code works unchanged
✓ No API breaking changes
✓ OptiTrack is optional (can disable)
✓ Manual position override still works
✓ Coordinate transformation unchanged


SUMMARY
-------

Before:  Positions always (0,0,0) - BROKEN
After:   Real-time positions from OptiTrack - WORKING!

The robot controller now operates as it should with proper OptiTrack processing.
"""

if __name__ == "__main__":
    print(__doc__)
