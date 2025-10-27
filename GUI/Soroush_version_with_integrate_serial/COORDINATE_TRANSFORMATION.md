# Coordinate Transformation - Technical Details

## Overview

The robot communication system automatically transforms waypoints from the GUI's coordinate space to the robot's actual operating space. This is done transparently - the GUI doesn't need to know about the robot's coordinate system.

## Coordinate Spaces

### GUI Coordinate Space
```
X range: [0, 2000] mm
Y range: [0, 2000] mm
Origin: Top-left corner
Total area: 2000mm × 2000mm
```

### Robot Operating Space (Physical Arena)
```
X range: [-1000, 1000] mm
Y range: [-2000, 0] mm
Origin: Center of arena (horizontally), top edge (vertically)
Total area: 2000mm × 2000mm
```

## Visual Representation

```
GUI SPACE:                          ROBOT SPACE:
(0,0) ────────────── (2000,0)      (-1000,-2000) ──── (1000,-2000)
  │                      │              │                   │
  │                      │              │                   │
  │       CENTER         │              │      CENTER       │
  │      (1000,1000)     │              │      (0,-1000)    │
  │                      │              │                   │
  │                      │              │                   │
(0,2000) ────────── (2000,2000)    (-1000,0) ──────── (1000,0)
```

## Transformation Algorithm

### Mathematical Formula

For a point (gui_x, gui_y) in GUI space:

1. **Normalize to [0, 1]:**
   ```
   norm_x = (gui_x - 0) / 2000
   norm_y = (gui_y - 0) / 2000
   ```

2. **Map to robot space:**
   ```
   robot_x = -1000 + (norm_x * 2000)
   robot_y = -2000 + (norm_y * 2000)
   ```

### Simplified Formula

```
robot_x = gui_x - 1000
robot_y = gui_y - 2000
```

## Example Transformations

| GUI Coordinates | Normalized | Robot Coordinates | Location Description |
|----------------|------------|-------------------|---------------------|
| (0, 0)         | (0, 0)     | (-1000, -2000)    | Top-left corner |
| (1000, 0)      | (0.5, 0)   | (0, -2000)        | Top edge center |
| (2000, 0)      | (1, 0)     | (1000, -2000)     | Top-right corner |
| (0, 1000)      | (0, 0.5)   | (-1000, -1000)    | Left edge center |
| (1000, 1000)   | (0.5, 0.5) | (0, -1000)        | Arena center |
| (2000, 1000)   | (1, 0.5)   | (1000, -1000)     | Right edge center |
| (0, 2000)      | (0, 1)     | (-1000, 0)        | Bottom-left corner |
| (1000, 2000)   | (0.5, 1)   | (0, 0)            | Bottom edge center |
| (2000, 2000)   | (1, 1)     | (1000, 0)         | Bottom-right corner |

## Implementation

### CoordinateTransformer Class

Located in `robot_controller.py`:

```python
class CoordinateTransformer:
    def __init__(self,
                 gui_x_min=0.0, gui_x_max=2000.0,
                 gui_y_min=0.0, gui_y_max=2000.0,
                 robot_x_min=-1000.0, robot_x_max=1000.0,
                 robot_y_min=-2000.0, robot_y_max=0.0):
        # Store ranges and calculate scale factors
        ...
    
    def transform_point(self, gui_x, gui_y):
        # Transform single point
        norm_x = (gui_x - self.gui_x_min) / self.gui_x_range
        norm_y = (gui_y - self.gui_y_min) / self.gui_y_range
        
        robot_x = self.robot_x_min + (norm_x * self.robot_x_range)
        robot_y = self.robot_y_min + (norm_y * self.robot_y_range)
        
        return robot_x, robot_y
    
    def transform_waypoints(self, waypoints):
        # Transform list of waypoints
        return [self.transform_point(x, y) for x, y in waypoints]
```

### Usage in RobotController

Transformation happens automatically in `send_waypoints()`:

```python
def send_waypoints(self, robot_color, waypoints):
    # waypoints are in GUI coordinates (mm)
    
    # Transform to robot space
    waypoints_robot = self.coord_transformer.transform_waypoints(waypoints)
    
    # Convert to meters
    waypoints_m = [(x/1000.0, y/1000.0) for x, y in waypoints_robot]
    
    # Send to robot
    ...
```

## Configuration

### Default Configuration

In `robot_controller.py`:

```python
class ControllerConfig:
    # GUI coordinate space
    GUI_X_MIN = 0.0
    GUI_X_MAX = 2000.0
    GUI_Y_MIN = 0.0
    GUI_Y_MAX = 2000.0
    
    # Robot operating space
    ROBOT_X_MIN = -1000.0
    ROBOT_X_MAX = 1000.0
    ROBOT_Y_MIN = -2000.0
    ROBOT_Y_MAX = 0.0
```

### Customizing Operating Space

If your robot arena has different dimensions:

```python
from robot_controller import ControllerConfig

# Example: Larger arena
ControllerConfig.ROBOT_X_MIN = -1500.0
ControllerConfig.ROBOT_X_MAX = 1500.0
ControllerConfig.ROBOT_Y_MIN = -3000.0
ControllerConfig.ROBOT_Y_MAX = 0.0

# Create controller (will use new settings)
controller = RobotController(port="COM5")
```

### Customizing GUI Space

If the GUI coordinate system changes:

```python
# Example: Different GUI dimensions
ControllerConfig.GUI_X_MIN = -1000.0
ControllerConfig.GUI_X_MAX = 1000.0
ControllerConfig.GUI_Y_MIN = -1000.0
ControllerConfig.GUI_Y_MAX = 1000.0
```

## Protocol Compliance

The transformation is applied **before** converting to the wire protocol format:

1. GUI generates waypoints in GUI coordinates
2. **Transformation occurs here** → Robot coordinates
3. Convert mm to meters
4. Pack into 16-byte packets (as per test_serial.py protocol)
5. Send via serial

The packet structure remains exactly as specified in `test_serial.py`:

```
Byte 0:    Slave ID (1-4)
Bytes 1-2: X position (int16, mm) - AFTER transformation
Bytes 3-4: Y position (int16, mm) - AFTER transformation
Byte 5:    Theta (0-255 from 0-360°)
Byte 6:    Command (0x12 for PREP)
Bytes 7-14: Waypoint data (order, x_high, x_low, y_high, y_low, padding)
Byte 15:   Delimiter (0xFF)
```

## Testing Transformation

### Test Script

```python
from robot_controller import CoordinateTransformer, ControllerConfig

# Create transformer
transformer = CoordinateTransformer()

# Test corners
print("GUI (0, 0) ->", transformer.transform_point(0, 0))
print("GUI (2000, 2000) ->", transformer.transform_point(2000, 2000))
print("GUI (1000, 1000) ->", transformer.transform_point(1000, 1000))

# Expected output:
# GUI (0, 0) -> (-1000.0, -2000.0)
# GUI (2000, 2000) -> (1000.0, 0.0)
# GUI (1000, 1000) -> (0.0, -1000.0)
```

### Verify in Logs

Check `robot_controller_sent.log` after sending waypoints. The logged positions will show **robot coordinates** (post-transformation).

## Why This Matters

### Problem

- GUI uses a simple coordinate system: origin at top-left, positive X right, positive Y down
- Robot operates in a physical arena with origin at center-top, negative Y coordinates
- Without transformation, waypoints would be in the wrong location

### Solution

- Automatic, transparent transformation
- GUI developers don't need to know robot coordinate system
- Robot system receives correctly positioned waypoints
- Easy to reconfigure if arena dimensions change

## Edge Cases

### Waypoints Outside GUI Bounds

If waypoints are outside [0, 2000] range, they will still be transformed linearly:

```python
# GUI waypoint outside bounds
gui_point = (-500, 3000)

# Still transforms (extrapolates)
robot_point = transformer.transform_point(-500, 3000)
# Result: (-1250, 1000)
```

However, the robot's firmware may reject waypoints outside its operating bounds.

### Precision

- Transformation uses floating-point arithmetic
- Final coordinates rounded to int16 (mm) for transmission
- Precision loss: < 1mm (negligible for robot navigation)

## Verification Checklist

✅ GUI waypoints in [0, 2000] × [0, 2000] range  
✅ Transformation produces robot coords in [-1000, 1000] × [-2000, 0]  
✅ Center of GUI (1000, 1000) maps to center of robot (0, -1000)  
✅ Packet structure matches test_serial.py exactly  
✅ Logged coordinates show robot space values  
✅ Robot executes paths in correct location  

## Troubleshooting

### Robot goes to wrong location

1. Check log file: are coordinates in robot space? (negative Y values)
2. Verify transformation:
   ```python
   transformer.transform_point(1000, 1000)  # Should be (0, -1000)
   ```
3. Check ControllerConfig values match your arena

### Waypoints too close together

- Transformation preserves relative distances
- Check if GUI waypoints are already close
- Consider adjusting WaypointOptimizer epsilon

### Coordinates outside robot bounds

- Robot firmware may clamp or reject
- Ensure GUI waypoints stay within [0, 2000] range
- Or adjust ROBOT_X/Y_MIN/MAX to match actual arena

---

**Transformation is automatic and transparent - just send GUI coordinates!** 🗺️
