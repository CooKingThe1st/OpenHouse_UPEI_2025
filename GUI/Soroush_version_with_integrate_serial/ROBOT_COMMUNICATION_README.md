# Robot Communication System

Production-level communication layer for GUI-to-Robot integration.

## 🎯 Overview

This system provides seamless integration between the `robot_path_planner.py` GUI and the physical robot control system via serial communication. **No modifications to the GUI code are required.**

## 📦 Components

### Core Modules

1. **`robot_controller.py`** - Low-level serial communication
   - Packet construction and transmission
   - Serial protocol implementation
   - Background position updates
   - Comprehensive logging

2. **`gui_robot_bridge.py`** - High-level integration layer
   - Waypoint format conversion
   - Multi-robot coordination
   - Mission execution orchestration
   - Status feedback and error handling

3. **`gui_with_robots.py`** - Complete GUI integration
   - Robot-enabled version of the path planner
   - Connection management UI
   - Mission execution controls
   - Emergency stop capability

### Examples & Utilities

4. **`simple_robot_example.py`** - Minimal usage example
5. **`ROBOT_INTEGRATION_GUIDE.md`** - Comprehensive documentation

## 🚀 Quick Start

### Installation

```powershell
# Install dependencies
pip install pyserial PyQt5
```

### Option 1: GUI with Robot Control (Recommended)

```powershell
python gui_with_robots.py
```

This launches the full GUI with integrated robot controls:
1. Click **"Connect to Robots"** button
2. Enter your serial port (e.g., `COM5`)
3. Draw paths and set waypoints as usual
4. Waypoints automatically send to robots
5. Click **"Execute Mission"** to start

### Option 2: Standalone Python Script

```python
from gui_robot_bridge import create_bridge

# Connect
bridge = create_bridge(port="COM5", auto_connect=True)

# Define waypoints (mm)
robot_commands = {
    'red': [(x1, y1), (x2, y2), ...],    # 20 waypoints
    'green': [(x1, y1), (x2, y2), ...]   # 20 waypoints
}

# Send and execute
result = bridge.send_mission_waypoints(robot_commands)
if result.success:
    bridge.run_all_loaded_robots()

# Cleanup
bridge.disconnect()
```

See `simple_robot_example.py` for a complete working example.

## 🏗️ Architecture

```
┌──────────────────────────┐
│  robot_path_planner.py   │  ← Original GUI (unchanged)
│  Generates waypoints     │
└────────────┬─────────────┘
             │
             │ Waypoint data: {'red': [(x,y), ...], ...}
             ▼
┌──────────────────────────┐
│  gui_robot_bridge.py     │  ← Integration layer
│  - Format conversion     │
│  - Multi-robot control   │
│  - Mission execution     │
└────────────┬─────────────┘
             │
             │ PREP/RUN commands
             ▼
┌──────────────────────────┐
│  robot_controller.py     │  ← Serial communication
│  - Packet building       │
│  - Serial transmission   │
│  - Background updates    │
└────────────┬─────────────┘
             │
             │ Serial packets (COM5, 9600 baud)
             ▼
┌──────────────────────────┐
│  Master Wixel + Robots   │  ← Hardware
└──────────────────────────┘
```

## 🔌 Connection Setup

### Windows
```python
bridge = create_bridge(port="COM5")
```

### Linux
```python
bridge = create_bridge(port="/dev/ttyUSB0")
```

### macOS
```python
bridge = create_bridge(port="/dev/tty.usbserial-XXX")
```

## 📡 Protocol Overview

### Robot ID Mapping

| Color  | Slave ID | Hardware Address |
|--------|----------|------------------|
| Red    | 1        | 0x01             |
| Green  | 2        | 0x02             |
| Blue   | 3        | 0x03             |
| Yellow | 4        | 0x04             |

### Commands

| Command    | Code | Description                    |
|------------|------|--------------------------------|
| STOP       | 0x10 | Stop robot immediately         |
| GO_TO      | 0x11 | Move to single position        |
| PREP       | 0x12 | Load waypoint (1 per packet)   |
| RUN        | 0x13 | Execute loaded waypoints       |
| AUX        | 0x14 | Auxiliary (position updates)   |
| CALIBRATE  | 0x15 | Auto-calibration               |

### Packet Structure (16 bytes)

| Bytes | Field     | Description              |
|-------|-----------|--------------------------|
| 0     | ADD       | Slave address (1-4)      |
| 1-2   | X         | X position (int16, mm)   |
| 3-4   | Y         | Y position (int16, mm)   |
| 5     | Theta     | Rotation (0-255 → 0-360°)|
| 6     | CMD       | Command code             |
| 7-14  | Data      | Command-specific data    |
| 15    | Delimiter | 0xFF                     |

### Waypoint Transmission

Each robot receives **20 waypoints** via **20 PREP packets** (one waypoint per packet):

**PREP Data Format (8 bytes):**
- `Data[0]`: Waypoint order (0-19)
- `Data[1-2]`: X coordinate (int16, mm)
- `Data[3-4]`: Y coordinate (int16, mm)
- `Data[5-7]`: Padding (zeros)

## 📝 API Reference

### RobotBridge Class

#### Connection
```python
bridge = RobotBridge(port="COM5", baud_rate=9600, status_callback=callback_fn)
result = bridge.connect()          # Connect to robots
bridge.disconnect()                 # Close connection
is_ready = bridge.is_connected()   # Check status
```

#### Waypoint Management
```python
# Send waypoints to multiple robots
# Waypoints in GUI coordinates (mm): x=[0,2000], y=[0,2000]
# Automatically transformed to robot space: x=[-1000,1000], y=[-2000,0]
robot_commands = {
    'red': [(x1, y1), ..., (x20, y20)],
    'green': [(x1, y1), ..., (x20, y20)]
}
result = bridge.send_mission_waypoints(robot_commands)

# Send to single robot
result = bridge.send_single_robot_waypoints('red', waypoints)
```

#### Mission Execution
```python
result = bridge.run_all_loaded_robots()  # Start all robots
result = bridge.run_single_robot('red')  # Start one robot
result = bridge.stop_all_robots()        # Emergency stop all
result = bridge.stop_single_robot('red') # Stop one robot
```

#### Status
```python
status = bridge.get_status()             # Current status enum
robots = bridge.get_loaded_robots()      # List of loaded colors
info = bridge.get_connection_info()      # Detailed info dict
```

### MissionResult Class

All operations return a `MissionResult`:

```python
@dataclass
class MissionResult:
    success: bool              # Operation succeeded
    status: MissionStatus      # Current status
    message: str               # Human-readable message
    robots_processed: int      # Number of robots affected
    errors: List[str]          # Error messages (if any)
```

## 🧪 Testing

### Test Individual Components

**Controller only:**
```powershell
python robot_controller.py
```

**Bridge only:**
```powershell
python gui_robot_bridge.py
```

**Simple example:**
```powershell
python simple_robot_example.py
```

**Full GUI integration:**
```powershell
python gui_with_robots.py
```

## �️ Coordinate Transformation

### Automatic Space Conversion

The system automatically transforms waypoints from GUI coordinate space to robot operating space:

**GUI Coordinate Space:**
- X range: [0, 2000] mm
- Y range: [0, 2000] mm
- Origin at top-left

**Robot Operating Space:**
- X range: [-1000, 1000] mm
- Y range: [-2000, 0] mm
- Origin at center

### Transformation Examples

| GUI Coordinates | Robot Coordinates | Location |
|----------------|-------------------|----------|
| (0, 0)         | (-1000, -2000)    | Top-left corner |
| (1000, 1000)   | (0, -1000)        | Center |
| (2000, 2000)   | (1000, 0)         | Bottom-right corner |
| (0, 2000)      | (-1000, 0)        | Bottom-left corner |
| (2000, 0)      | (1000, -2000)     | Top-right corner |

### Configuring Operating Space

You can change the robot operating space bounds if needed:

```python
from robot_controller import ControllerConfig

# Customize robot operating space
ControllerConfig.ROBOT_X_MIN = -1500.0  # mm
ControllerConfig.ROBOT_X_MAX = 1500.0   # mm
ControllerConfig.ROBOT_Y_MIN = -2500.0  # mm
ControllerConfig.ROBOT_Y_MAX = 500.0    # mm

# Customize GUI space (if GUI coordinate system changes)
ControllerConfig.GUI_X_MIN = 0.0        # mm
ControllerConfig.GUI_X_MAX = 2000.0     # mm
ControllerConfig.GUI_Y_MIN = 0.0        # mm
ControllerConfig.GUI_Y_MAX = 2000.0     # mm

# Create controller (will use new settings)
bridge = create_bridge(port="COM5")
```

### How Transformation Works

The transformation uses linear mapping:

1. **Normalize GUI coordinates to [0, 1]:**
   ```
   norm_x = (gui_x - GUI_X_MIN) / (GUI_X_MAX - GUI_X_MIN)
   norm_y = (gui_y - GUI_Y_MIN) / (GUI_Y_MAX - GUI_Y_MIN)
   ```

2. **Map to robot space:**
   ```
   robot_x = ROBOT_X_MIN + (norm_x * (ROBOT_X_MAX - ROBOT_X_MIN))
   robot_y = ROBOT_Y_MIN + (norm_y * (ROBOT_Y_MAX - ROBOT_Y_MIN))
   ```

This ensures waypoints are correctly positioned in the robot's actual operating area.

## �📊 Logging

The system generates detailed logs:

### Log Files

1. **`robot_controller_sent.log`**
   - All packets sent to robots
   - Hex dumps with decoded content
   - Timestamps and labels

2. **`robot_controller_received.log`**
   - Responses from robot system
   - Serial feedback messages

### Console Output

Enable verbose logging:

```python
import logging
logging.basicConfig(level=logging.INFO)
```

## ⚠️ Error Handling

```python
result = bridge.send_mission_waypoints(robot_commands)

if result.success:
    print(f"✓ {result.message}")
    print(f"  Robots: {result.robots_processed}")
else:
    print(f"✗ {result.message}")
    for error in result.errors:
        print(f"  - {error}")
```

### Common Errors

| Error                      | Cause                    | Solution                        |
|----------------------------|--------------------------|---------------------------------|
| "Not connected"            | Serial port not open     | Call `connect()` first          |
| "Serial connection failed" | Port unavailable         | Check port name, close other apps |
| "Invalid robot color"      | Typo in color name       | Use 'red', 'green', 'blue', 'yellow' |
| "No waypoints"             | Empty waypoints list     | Ensure 20 waypoints per robot   |

## 🔧 Configuration

### Serial Port

```python
# Default port
from robot_controller import ControllerConfig
ControllerConfig.SERIAL_PORT = "COM3"

# Or override per instance
bridge = create_bridge(port="COM3", baud_rate=115200)
```

### Auto-Run

```python
# Auto-execute after waypoint loading
bridge = RobotBridge(port="COM5", auto_run=True)
```

### Background Updates

```python
# Adjust position update frequency (default: 200ms)
from robot_controller import ControllerConfig
ControllerConfig.AUX_SEND_INTERVAL = 0.1  # 100ms
```

## 📚 Examples

### Example 1: Single Robot

```python
from gui_robot_bridge import create_bridge

bridge = create_bridge(port="COM5", auto_connect=True)

waypoints = [(-500, -500), (-500, 500), (500, 500), (500, -500)]
waypoints.extend([waypoints[-1]] * 16)  # Pad to 20

bridge.send_single_robot_waypoints('red', waypoints)
bridge.run_single_robot('red')
```

### Example 2: Multiple Robots

```python
from gui_robot_bridge import create_bridge

bridge = create_bridge(port="COM5", auto_connect=True)

robot_commands = {
    'red': [...],     # 20 waypoints
    'green': [...],   # 20 waypoints
    'blue': [...]     # 20 waypoints
}

result = bridge.send_mission_waypoints(robot_commands)
if result.success:
    bridge.run_all_loaded_robots()
```

### Example 3: Status Callbacks

```python
def my_callback(message):
    print(f"[ROBOT] {message}")
    # Update GUI, log to file, etc.

bridge = create_bridge(
    port="COM5",
    status_callback=my_callback,
    auto_connect=True
)
```

## 🎓 Best Practices

1. **Always check connection:**
   ```python
   if not bridge.is_connected():
       bridge.connect()
   ```

2. **Handle errors gracefully:**
   ```python
   result = bridge.send_mission_waypoints(...)
   if not result.success:
       show_error_to_user(result.message)
   ```

3. **Clean disconnect:**
   ```python
   try:
       # Robot operations
   finally:
       bridge.disconnect()
   ```

4. **Use status callbacks for user feedback:**
   ```python
   def update_status(msg):
       status_label.setText(msg)
   
   bridge = create_bridge(status_callback=update_status)
   ```

5. **Provide emergency stop:**
   ```python
   stop_button.clicked.connect(bridge.stop_all_robots)
   ```

## 🔍 Troubleshooting

### Port Not Found
- **Windows:** Check Device Manager → Ports (COM & LPT)
- **Linux:** Run `ls /dev/ttyUSB*` or `ls /dev/ttyACM*`
- **macOS:** Run `ls /dev/tty.usbserial-*`

### Port In Use
- Close other applications (Arduino IDE, PuTTY, test_serial.py)
- Only one program can use a serial port at a time

### Waypoint Count
- System expects exactly 20 waypoints per robot
- Auto-pads if fewer (repeats last waypoint)
- Auto-truncates if more (uses first 20)

### Connection Timeout
- Verify hardware is powered on
- Check USB cable connection
- Try a different USB port
- Restart hardware

## 📖 Full Documentation

For comprehensive details, see:
- **`ROBOT_INTEGRATION_GUIDE.md`** - Complete integration guide
- **`robot_controller.py`** - Detailed API documentation
- **`gui_robot_bridge.py`** - Bridge implementation details

## 🤝 Integration with Existing Code

The system is designed for **zero-modification integration**:

1. GUI code (`robot_path_planner.py`) remains **unchanged**
2. Bridge intercepts waypoint data automatically
3. All robot communication is transparent
4. Status updates feed back to GUI seamlessly

## 📄 License

Production-level code for OpenDay MRS robot control system.

## 🆘 Support

For issues:
1. Check log files (`robot_controller_sent.log`, `robot_controller_received.log`)
2. Run test scripts to isolate problem
3. Verify hardware connections
4. Review troubleshooting section above

---

**Ready to control your robots!** 🤖
