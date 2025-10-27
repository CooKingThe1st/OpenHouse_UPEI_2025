# Robot Integration Guide

## Overview

This guide explains how to integrate the GUI path planner (`robot_path_planner.py`) with the physical robot control system via serial communication.

**Key Components:**
1. **`robot_controller.py`** - Low-level serial communication with robot hardware
2. **`gui_robot_bridge.py`** - High-level bridge connecting GUI to controller
3. **`robot_path_planner.py`** - GUI application (NO CHANGES NEEDED)

## Architecture

```
┌─────────────────────────┐
│  robot_path_planner.py  │  (GUI - generates waypoints)
│  (No modifications)     │
└───────────┬─────────────┘
            │
            │ robot_commands dict
            │ {'red': [(x,y), ...], 'green': [...]}
            ▼
┌─────────────────────────┐
│  gui_robot_bridge.py    │  (Integration layer)
│  - Format conversion    │
│  - Multi-robot coord.   │
│  - Mission execution    │
└───────────┬─────────────┘
            │
            │ PREP/RUN commands
            ▼
┌─────────────────────────┐
│  robot_controller.py    │  (Serial communication)
│  - Packet building      │
│  - Serial transmission  │
│  - Background updates   │
└───────────┬─────────────┘
            │
            │ Serial packets (COM5)
            ▼
┌─────────────────────────┐
│  Master Wixel + Robots  │  (Hardware)
└─────────────────────────┘
```

## Quick Start

### 1. Install Dependencies

```powershell
pip install pyserial PyQt5
```

### 2. Basic Usage (Standalone)

```python
from gui_robot_bridge import create_bridge

# Connect to robots
bridge = create_bridge(port="COM5", auto_connect=True)

# Define waypoints (from GUI or manual)
robot_commands = {
    'red': [(x1, y1), (x2, y2), ...],    # 20 waypoints in mm
    'green': [(x1, y1), (x2, y2), ...]   # 20 waypoints in mm
}

# Send waypoints
result = bridge.send_mission_waypoints(robot_commands)

if result.success:
    # Execute mission
    run_result = bridge.run_all_loaded_robots()
    
    # Later: stop robots
    bridge.stop_all_robots()

# Disconnect
bridge.disconnect()
```

### 3. Integration with GUI

The GUI already generates waypoints in the correct format. To send them to robots:

**Option A: Automatic Integration (Recommended)**

Use the provided integration example:

```python
python gui_with_robots.py
```

This adds a "Connect Robots" button to the GUI that automatically sends waypoints.

**Option B: Manual Integration**

After GUI generates waypoints (in `send_to_robots()` method), add:

```python
# In robot_path_planner.py, after waypoints are generated:

from gui_robot_bridge import create_bridge

# Connect to robots
bridge = create_bridge(port="COM5")

if bridge:
    # Send waypoints (robot_commands already exists in GUI)
    result = bridge.send_mission_waypoints(robot_commands)
    
    if result.success:
        # Optionally auto-run
        bridge.run_all_loaded_robots()
```

## Detailed API Reference

### RobotBridge Class

#### Connection Methods

**`connect() -> MissionResult`**
- Establishes serial connection to robot control system
- Starts background position update thread
- Returns success/failure status

**`disconnect()`**
- Closes serial connection
- Stops background threads
- Clears loaded waypoints

**`is_connected() -> bool`**
- Check if bridge is ready for commands

#### Waypoint Methods

**`send_mission_waypoints(robot_commands, run_after_send=None) -> MissionResult`**
- **Primary integration point with GUI**
- Sends waypoints to multiple robots
- Args:
  - `robot_commands`: Dict mapping color to waypoints
    - Format: `{'red': [(x_mm, y_mm), ...], 'green': [...]}`
    - Each robot needs exactly 20 waypoints
  - `run_after_send`: Auto-execute after sending (optional)
- Returns: `MissionResult` with status

**`send_single_robot_waypoints(robot_color, waypoints) -> MissionResult`**
- Send waypoints to one robot only
- Args:
  - `robot_color`: 'red', 'green', 'blue', or 'yellow'
  - `waypoints`: List of 20 (x_mm, y_mm) tuples

#### Execution Methods

**`run_all_loaded_robots() -> MissionResult`**
- Send RUN command to all robots with waypoints
- Robots execute waypoint mission simultaneously

**`run_single_robot(robot_color) -> MissionResult`**
- Start mission for one specific robot

**`stop_all_robots() -> MissionResult`**
- Emergency stop for all robots

**`stop_single_robot(robot_color) -> MissionResult`**
- Stop one specific robot

#### Status Methods

**`get_status() -> MissionStatus`**
- Get current bridge status
- Enum: IDLE, CONNECTING, CONNECTED, SENDING_WAYPOINTS, WAYPOINTS_LOADED, RUNNING, COMPLETED, ERROR, DISCONNECTED

**`get_loaded_robots() -> List[str]`**
- Get list of robot colors with waypoints loaded

**`get_connection_info() -> Dict`**
- Detailed connection and status information

### MissionResult Class

Returned by most bridge methods:

```python
@dataclass
class MissionResult:
    success: bool           # Operation succeeded
    status: MissionStatus   # Current status
    message: str            # Human-readable message
    robots_processed: int   # Number of robots affected
    errors: List[str]       # List of error messages (if any)
```

## Robot Color to ID Mapping

The system automatically maps robot colors to hardware slave IDs:

| Color  | Slave ID | Notes                    |
|--------|----------|--------------------------|
| Red    | 1        | First robot              |
| Green  | 2        | Second robot             |
| Blue   | 3        | Third robot              |
| Yellow | 4        | Fourth robot             |

This mapping is handled automatically by `RobotIDMapper`.

## Communication Protocol

### Packet Structure

Each robot receives a 16-byte packet:

| Byte   | Field       | Description                    |
|--------|-------------|--------------------------------|
| 0      | ADD         | Slave address (1-4)            |
| 1-2    | X           | X position (int16, mm)         |
| 3-4    | Y           | Y position (int16, mm)         |
| 5      | Theta       | Rotation (0-255 → 0-360°)      |
| 6      | CMD         | Command byte                   |
| 7-14   | Data        | Command-specific data (8 bytes)|
| 15     | Delimiter   | 0xFF (message delimiter)       |

### Commands

| Command      | Code | Description                          |
|--------------|------|--------------------------------------|
| STOP         | 0x10 | Stop robot immediately               |
| GO_TO        | 0x11 | Move to single position              |
| PREP         | 0x12 | Load waypoint (1 per packet)         |
| RUN          | 0x13 | Execute loaded waypoints             |
| AUX          | 0x14 | Auxiliary (position updates)         |
| CALIBRATE    | 0x15 | Auto-calibration sequence            |

### Waypoint Transmission (PREP)

Waypoints are sent one per packet (20 packets per robot):

**Data bytes for PREP:**
- `Data[0]`: Waypoint order (0-19)
- `Data[1-2]`: X coordinate (int16, mm)
- `Data[3-4]`: Y coordinate (int16, mm)
- `Data[5-7]`: Padding (zeros)

### Background Updates

The controller automatically sends position updates every 200ms using AUX commands (0x14 with sub-command 0x9F). This keeps the robot synchronized without manual intervention.

## Configuration

### Serial Port Configuration

Edit `robot_controller.py` or override at runtime:

```python
from gui_robot_bridge import create_bridge

# Windows
bridge = create_bridge(port="COM5", baud_rate=9600)

# Linux
bridge = create_bridge(port="/dev/ttyUSB0", baud_rate=9600)

# macOS
bridge = create_bridge(port="/dev/tty.usbserial-XXX", baud_rate=9600)
```

### Auto-Run Configuration

Control whether missions auto-execute after waypoint loading:

```python
from gui_robot_bridge import RobotBridge

# Auto-run enabled
bridge = RobotBridge(port="COM5", auto_run=True)

# Auto-run disabled (manual control)
bridge = RobotBridge(port="COM5", auto_run=False)
```

## Error Handling

The bridge provides comprehensive error handling:

```python
result = bridge.send_mission_waypoints(robot_commands)

if result.success:
    print(f"✓ {result.message}")
    print(f"Robots processed: {result.robots_processed}")
else:
    print(f"✗ {result.message}")
    for error in result.errors:
        print(f"  - {error}")
```

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| "Not connected" | Serial port not open | Call `connect()` first |
| "Serial connection failed" | Port doesn't exist or in use | Check port name, close other apps |
| "Invalid robot color" | Typo in color name | Use 'red', 'green', 'blue', 'yellow' |
| "No waypoints" | Empty waypoints list | Ensure 20 waypoints per robot |

## Logging

The system provides comprehensive logging:

### Log Files

1. **`robot_controller_sent.log`**
   - All packets sent to robots
   - Hex dumps with human-readable decoding
   - Timestamps and command labels

2. **`robot_controller_received.log`**
   - Responses from robot system
   - Serial feedback messages

### Console Logging

Enable verbose console output:

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
```

## Status Callbacks

Get real-time status updates in your GUI:

```python
def status_callback(message: str):
    print(f"[STATUS] {message}")
    # Update GUI status label, log display, etc.

bridge = create_bridge(
    port="COM5",
    status_callback=status_callback
)
```

The callback receives messages like:
- "✓ Connected to COM5"
- "Sending waypoints to RED robot..."
- "✓ Mission running (2 robots)"
- "✗ Failed to connect to COM5: Port in use"

## Testing

### Test Individual Components

**Test Controller:**
```powershell
python robot_controller.py
```
Runs demo with one robot, rectangle path.

**Test Bridge:**
```powershell
python gui_robot_bridge.py
```
Runs demo with two robots, mirrored paths.

**Test GUI:**
```powershell
python robot_path_planner.py
```
Runs GUI without robot connection.

### Integration Test

```powershell
python gui_with_robots.py
```
Full integration: GUI + robot control.

## Troubleshooting

### Robot Not Responding

1. Check serial connection:
   ```python
   bridge.get_connection_info()
   ```

2. Verify port name:
   - Windows: Device Manager → Ports (COM & LPT)
   - Linux: `ls /dev/ttyUSB*` or `ls /dev/ttyACM*`
   - macOS: `ls /dev/tty.usbserial-*`

3. Check logs:
   - Review `robot_controller_sent.log`
   - Verify packets are being sent
   - Check for error messages

### Waypoint Count Mismatch

The system expects exactly 20 waypoints per robot. It will auto-pad or truncate:

```python
# If you have fewer than 20, it pads with last waypoint
waypoints = [(x1, y1), ..., (x8, y8)]  # Only 8
# System pads: [(x1,y1), ..., (x8,y8), (x8,y8), ..., (x8,y8)]

# If you have more than 20, it truncates
waypoints = [(x1, y1), ..., (x25, y25)]  # 25 waypoints
# System uses: [(x1,y1), ..., (x20,y20)]
```

### Serial Port In Use

Only one application can use a serial port at a time:

1. Close other applications (test_serial.py, Arduino IDE, etc.)
2. Disconnect and reconnect:
   ```python
   bridge.disconnect()
   time.sleep(1)
   bridge.connect()
   ```

## Best Practices

### 1. Always Check Connection

```python
if not bridge.is_connected():
    result = bridge.connect()
    if not result.success:
        print("Cannot connect to robots")
        return
```

### 2. Handle Errors Gracefully

```python
result = bridge.send_mission_waypoints(robot_commands)

if result.success:
    # Proceed with mission
    run_result = bridge.run_all_loaded_robots()
else:
    # Show error to user
    show_error_dialog(result.message, result.errors)
```

### 3. Clean Disconnect

```python
try:
    # Your robot operations
    bridge.send_mission_waypoints(...)
    bridge.run_all_loaded_robots()
finally:
    # Always disconnect
    bridge.disconnect()
```

### 4. Use Status Callbacks

Provide user feedback through callbacks:

```python
def update_gui_status(message: str):
    status_label.setText(message)
    log_display.append(message)

bridge = create_bridge(status_callback=update_gui_status)
```

### 5. Emergency Stop

Always provide a stop button:

```python
stop_button.clicked.connect(lambda: bridge.stop_all_robots())
```

## Advanced Usage

### Custom Port Configuration

```python
from robot_controller import ControllerConfig

# Override default port
ControllerConfig.SERIAL_PORT = "COM3"
ControllerConfig.BAUD_RATE = 115200

# Create bridge (uses new defaults)
bridge = create_bridge()
```

### Manual Position Updates

```python
# Access controller directly
controller = bridge.controller

# Update robot position (for testing without OptiTrack)
controller._update_slave_position(
    slave_id=1,  # Red robot
    x=0.5,       # meters
    y=0.3,       # meters
    theta=45     # degrees
)
```

### Single Robot Control

```python
# Send waypoints to just one robot
bridge.send_single_robot_waypoints('red', waypoints_red)

# Run just that robot
bridge.run_single_robot('red')

# Stop just that robot
bridge.stop_single_robot('red')
```

## Performance Notes

- **Waypoint transmission**: ~1 second per robot (20 waypoints @ 50ms each)
- **Background updates**: Every 200ms (5 Hz)
- **Serial baud rate**: 9600 (can be increased if hardware supports)
- **Max robots**: 4 simultaneous

## Support

For issues or questions:

1. Check log files (`robot_controller_sent.log`, `robot_controller_received.log`)
2. Run test scripts to isolate problem
3. Verify hardware connections
4. Review this guide's troubleshooting section

## License

Production-level code for OpenDay MRS robot control system.
