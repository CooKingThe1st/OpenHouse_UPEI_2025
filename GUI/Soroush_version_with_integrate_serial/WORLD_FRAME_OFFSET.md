# World Frame Offset Transformation

**Date:** October 25, 2025  
**Status:** ✅ Implemented

## Overview

Added world frame offset transformation to align GUI frame with robot world frame.

**Transformation:**
```
robot_position = gui_position + offset(-1000, -2000) mm
```

## Implementation Details

### Configuration (ControllerConfig)

```python
# World frame transformation
WORLD_FRAME_OFFSET_X = -1000.0  # mm
WORLD_FRAME_OFFSET_Y = -2000.0  # mm
```

### Where Applied

1. **Position Packets** (`SlaveState.get_packet()`)
   - Applied to all position commands (X, Y coordinates)
   - OptiTrack positions, manual positions, etc.

2. **Waypoint Commands** (`RobotController.send_waypoints()`)
   - Applied to each waypoint before encoding
   - Ensures waypoints are in robot world frame

### Code Changes

#### 1. SlaveState.get_packet()
```python
# Apply world frame offset: robot_pos = gui_pos + offset
x_robot = self.position_x + ControllerConfig.WORLD_FRAME_OFFSET_X
y_robot = self.position_y + ControllerConfig.WORLD_FRAME_OFFSET_Y

# Convert meters to millimeters (signed int16)
x_mm = int(x_robot * 1000)
y_mm = int(y_robot * 1000)
```

#### 2. RobotController.send_waypoints()
```python
# Apply world frame offset to waypoint: robot_pos = gui_pos + offset
x_robot = x_m + (ControllerConfig.WORLD_FRAME_OFFSET_X / 1000.0)
y_robot = y_m + (ControllerConfig.WORLD_FRAME_OFFSET_Y / 1000.0)

# Convert to millimeters (int16)
x_mm = int(x_robot * 1000)
y_mm = int(y_robot * 1000)
```

## Frame Definitions

### GUI Frame
- Origin: Center of GUI coordinate system
- Units: millimeters (mm)
- Waypoints generated in this frame

### Robot World Frame  
- Origin: Offset from GUI frame by (-1000, -2000) mm
- Units: millimeters (mm)
- Physical robot operating space

### Example Transformations

| GUI Frame (mm) | Robot World Frame (mm) |
|----------------|------------------------|
| (0, 0)         | (-1000, -2000)        |
| (1000, 2000)   | (0, 0)                |
| (500, -500)    | (-500, -2500)         |
| (-500, 500)    | (-1500, -1500)        |

## Usage

No changes required in calling code! The transformation is applied automatically:

```python
# GUI generates waypoints in GUI frame
waypoints_gui = [(0, 0), (500, 500), ...]

# Controller applies offset automatically
controller.send_waypoints('red', waypoints_gui)
# Robot receives: [(-1000, -2000), (-500, -1500), ...]
```

## Testing

The transformation is applied to:
- ✅ Waypoint transmission (PREP command)
- ✅ Position updates (AUX command) 
- ✅ GO_TO commands
- ✅ RUN commands
- ✅ STOP commands
- ✅ All OptiTrack position data

## Notes

- Offset is applied in **millimeters** throughout
- Position data stored internally in **meters** (self.position_x/y)
- Offset converted to meters when needed: `offset / 1000.0`
- Transformation is **additive**: `new = old + offset`

## Compatibility

- ✅ Works with OptiTrack integration
- ✅ Works with manual position overrides
- ✅ Works with GUI integration (gui_with_robots.py)
- ✅ Maintains protocol compatibility with test_serial.py

**Author:** AI Assistant  
**Requested by:** Binh  
**Date:** October 25, 2025
