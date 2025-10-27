# Robot Communication - Quick Reference Card

## 🚀 Quick Start (Copy & Paste)

### Run GUI with Robot Control
```powershell
python gui_with_robots.py
```

### Simple Python Script
```python
from gui_robot_bridge import create_bridge

# Connect
bridge = create_bridge(port="COM5", auto_connect=True)

# Send waypoints
robot_commands = {
    'red': [(x1,y1), ..., (x20,y20)],    # 20 waypoints in mm
    'green': [(x1,y1), ..., (x20,y20)]
}
bridge.send_mission_waypoints(robot_commands)

# Execute
bridge.run_all_loaded_robots()

# Stop
bridge.stop_all_robots()

# Disconnect
bridge.disconnect()
```

## 📋 Essential Commands

### Connection
```python
bridge = create_bridge(port="COM5")      # Connect
bridge.disconnect()                       # Disconnect
bridge.is_connected()                     # Check status
```

### Waypoints
```python
# Multiple robots
bridge.send_mission_waypoints({
    'red': waypoints_red,
    'green': waypoints_green
})

# Single robot
bridge.send_single_robot_waypoints('red', waypoints)
```

### Execution
```python
bridge.run_all_loaded_robots()           # Start all
bridge.run_single_robot('red')           # Start one
bridge.stop_all_robots()                 # Stop all
bridge.stop_single_robot('red')          # Stop one
```

### Status
```python
result = bridge.send_mission_waypoints(...)

if result.success:
    print(f"✓ {result.message}")
    print(f"Robots: {result.robots_processed}")
else:
    print(f"✗ {result.message}")
    for error in result.errors:
        print(f"  - {error}")
```

## 🎨 Robot Colors

**Valid colors:** `'red'`, `'green'`, `'blue'`, `'yellow'`

**Mapping to hardware:**
- Red → Slave ID 1
- Green → Slave ID 2
- Blue → Slave ID 3
- Yellow → Slave ID 4

## 📦 Waypoint Format

```python
waypoints = [
    (x1, y1),  # WP 1
    (x2, y2),  # WP 2
    ...
    (x20, y20) # WP 20
]

# Coordinates in GUI space (millimeters):
# X range: [0, 2000] mm
# Y range: [0, 2000] mm
# Exactly 20 waypoints required
# System auto-pads/truncates if needed

# Automatically transformed to robot operating space:
# X range: [-1000, 1000] mm
# Y range: [-2000, 0] mm
```

## 🗺️ Coordinate Transformation

**GUI sends waypoints in GUI space, automatically transformed to robot space:**

| GUI Space (mm) | Robot Space (mm) |
|----------------|------------------|
| (0, 0)         | (-1000, -2000)   |
| (1000, 1000)   | (0, -1000)       |
| (2000, 2000)   | (1000, 0)        |
| (0, 2000)      | (-1000, 0)       |
| (2000, 0)      | (1000, -2000)    |

**Configuration (optional):**
```python
from robot_controller import ControllerConfig

# Change robot operating space bounds
ControllerConfig.ROBOT_X_MIN = -1500.0
ControllerConfig.ROBOT_X_MAX = 1500.0
ControllerConfig.ROBOT_Y_MIN = -2500.0
ControllerConfig.ROBOT_Y_MAX = 500.0

# Change GUI space bounds (if GUI changes)
ControllerConfig.GUI_X_MIN = 0.0
ControllerConfig.GUI_X_MAX = 2000.0
ControllerConfig.GUI_Y_MIN = 0.0
ControllerConfig.GUI_Y_MAX = 2000.0
```

## 🔌 Serial Ports

**Windows:** `COM1`, `COM5`, etc.
**Linux:** `/dev/ttyUSB0`, `/dev/ttyACM0`
**macOS:** `/dev/tty.usbserial-XXX`

**Find your port:**
- Windows: Device Manager → Ports
- Linux: `ls /dev/ttyUSB*`
- macOS: `ls /dev/tty.*`

## ⚠️ Error Handling Pattern

```python
try:
    result = bridge.send_mission_waypoints(robot_commands)
    
    if result.success:
        # Success path
        bridge.run_all_loaded_robots()
    else:
        # Handle error
        print(f"Error: {result.message}")
        
except Exception as e:
    # Unexpected error
    print(f"Exception: {e}")
    
finally:
    # Always cleanup
    bridge.disconnect()
```

## 📊 Status Callback

```python
def status_update(message):
    print(f"[STATUS] {message}")
    # Update GUI, log, etc.

bridge = create_bridge(
    port="COM5",
    status_callback=status_update
)
```

## 🔧 Common Fixes

**Port not found:**
```python
# Check available ports
import serial.tools.list_ports
ports = serial.tools.list_ports.comports()
for port in ports:
    print(port.device)
```

**Port in use:**
- Close other programs using the port
- Restart your application
- Unplug/replug USB cable

**Connection failed:**
```python
# Try with explicit parameters
bridge = RobotBridge(
    port="COM5",
    baud_rate=9600,
    enable_logging=True
)
result = bridge.connect()
print(result.message)
```

## 📝 Logging

**Log files created:**
- `robot_controller_sent.log` - Outgoing packets
- `robot_controller_received.log` - Incoming data

**Enable console logging:**
```python
import logging
logging.basicConfig(level=logging.INFO)
```

## 🧪 Test Commands

```powershell
# Test controller only
python robot_controller.py

# Test bridge only
python gui_robot_bridge.py

# Test simple example
python simple_robot_example.py

# Test full GUI
python gui_with_robots.py
```

## 🎯 Integration Pattern

**Add to existing code:**
```python
from gui_robot_bridge import create_bridge

# At startup
bridge = create_bridge(port="COM5", auto_connect=True)

# When waypoints ready
if bridge and bridge.is_connected():
    result = bridge.send_mission_waypoints(waypoints_dict)
    if result.success:
        bridge.run_all_loaded_robots()

# At shutdown
if bridge:
    bridge.disconnect()
```

## 📚 More Info

- **Full Documentation:** `ROBOT_INTEGRATION_GUIDE.md`
- **README:** `ROBOT_COMMUNICATION_README.md`
- **Examples:** `simple_robot_example.py`, `gui_with_robots.py`

---

**Ready to send waypoints!** 🤖✨
