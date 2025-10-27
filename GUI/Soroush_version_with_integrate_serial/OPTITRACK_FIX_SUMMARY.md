# OptiTrack Position Handling Fix

**Date:** October 25, 2025  
**Issue:** World frame offset being incorrectly applied to OptiTrack positions  
**Status:** ✅ FIXED

---

## Problem Description

The `robot_controller.py` was incorrectly applying the `WORLD_FRAME_OFFSET` to OptiTrack positions in the `SlaveState.get_packet()` method. This caused robot positions to be sent with incorrect coordinates.

### What Was Wrong:

```python
# BEFORE (INCORRECT):
x_robot = self.position_x + ControllerConfig.WORLD_FRAME_OFFSET_X  # meters + millimeters ❌
y_robot = self.position_y + ControllerConfig.WORLD_FRAME_OFFSET_Y
x_mm = int(x_robot * 1000)
y_mm = int(y_robot * 1000)
```

**Two issues:**
1. **Unit mismatch**: Adding millimeters (`WORLD_FRAME_OFFSET`) to meters (`position_x/y`)
2. **Wrong semantic**: OptiTrack positions are already in robot world frame and should NOT have offset applied

---

## Solution

Based on analysis of `test_serial.py` (the working reference implementation):

### Key Insight from `test_serial.py`:

1. **OptiTrack positions**: 
   - Read in meters from OptiTrack server
   - Converted to millimeters
   - Sent AS-IS in position fields [bytes 1-4]
   - **NO offset applied**

2. **Waypoints** (from GUI):
   - Generated in GUI frame
   - Offset applied to transform to robot world frame
   - Sent in DATA field [bytes 7-14]

### The Fix:

```python
# AFTER (CORRECT):
# OptiTrack positions are already in robot world frame (meters)
# Convert meters to millimeters (signed int16)
# DO NOT apply world frame offset to OptiTrack positions!
x_mm = int(self.position_x * 1000)
y_mm = int(self.position_y * 1000)
```

---

## Understanding the Two Coordinate Spaces

### 1. **OptiTrack Positions** (Bytes [1-5] in packet)
```
Source: OptiTrack motion capture system
Frame:  Robot world frame (already)
Units:  Received in meters, converted to millimeters
Offset: NONE - already in correct frame
```

**Flow:**
```
OptiTrack Server → (x, y, θ) meters
                 ↓
    robot_controller.py OptiTrackClient.get_position()
                 ↓
         SlaveState.position_x/y/theta (meters)
                 ↓
         SlaveState.get_packet(): × 1000 → millimeters
                 ↓
              Bytes [1-5] of packet
```

### 2. **Waypoints** (Bytes [7-14] in packet DATA field)
```
Source: GUI path planner
Frame:  GUI frame (centered at origin)
Units:  Millimeters
Offset: WORLD_FRAME_OFFSET applied to transform to robot world frame
```

**Flow:**
```
GUI Drawing → CoordinateConverter → GUI Frame (mm, centered)
                                          ↓
              RobotController.send_waypoints()
                                          ↓
            Apply WORLD_FRAME_OFFSET: gui_pos + offset
                                          ↓
                    Robot World Frame (mm)
                                          ↓
                    Encode in DATA field
                                          ↓
                   Bytes [7-14] of packet
```

---

## Packet Structure (16 bytes)

```
[0]     ADD       Slave address (1-4)
[1-2]   X_POS     X position in mm (OptiTrack, NO offset) ← FIXED
[3-4]   Y_POS     Y position in mm (OptiTrack, NO offset) ← FIXED
[5]     THETA     Rotation 0-255 (0-360°)
[6]     CMD       Command byte
[7-14]  DATA      Command data (waypoints WITH offset applied)
[15]    DELIM     Message delimiter (0xFF)
```

### Example - PREP Command (Waypoint Transmission):

**Waypoint from GUI:** (0, 0) mm in GUI frame (center)
**After offset:** (0 + (-1000), 0 + (-1000)) = (-1000, -1000) mm in robot world
**Encoded in DATA field:** [order, x_high, x_low, y_high, y_low, padding...]

**OptiTrack position:** (1.5, -0.8) meters in robot world  
**In packet bytes [1-4]:** 1500 mm, -800 mm (NO offset)

---

## Files Modified

### `robot_controller.py`

**1. SlaveState.get_packet() method:**
```python
# Removed incorrect offset application to OptiTrack positions
# Now correctly converts meters → millimeters without offset
x_mm = int(self.position_x * 1000)
y_mm = int(self.position_y * 1000)
```

**2. Updated docstring:**
```python
"""
...
[1-2]  X position (int16, mm) - OptiTrack position (NO offset applied)
[3-4]  Y position (int16, mm) - OptiTrack position (NO offset applied)
...
[7-14] Data bytes (8 bytes) - Waypoints have offset applied in send_waypoints()

Note: World frame offset is applied ONLY to waypoints in the DATA field,
      NOT to OptiTrack positions. OptiTrack already provides positions
      in the robot world frame.
"""
```

**3. send_waypoints() method:**
- No changes needed - already correctly applies offset to waypoints
- Waypoints transformed: `gui_pos + WORLD_FRAME_OFFSET → robot_world_pos`

---

## Verification

### Test Case 1: OptiTrack Position
```
OptiTrack reports: (1.5, -0.8, 90) meters
Expected in packet: X=1500mm, Y=-800mm, θ=64 (no offset)

✓ PASS: Position sent as-is, no offset applied
```

### Test Case 2: GUI Waypoint
```
GUI waypoint: (0, 0) mm (center of GUI frame)
WORLD_FRAME_OFFSET: (-1000, -1000) mm
Expected in DATA field: (-1000, -1000) mm

✓ PASS: Offset applied correctly to waypoint
```

### Test Case 3: Packet Structure
```
Comparing with test_serial.py:
- Position fields: Same (meters × 1000 → mm)
- DATA field: Same (waypoint encoding)
- Offset application: Now matches test_serial.py ✓
```

---

## Impact

### ✅ Fixed:
- OptiTrack positions now sent correctly (no offset)
- Waypoints still transformed correctly (with offset)
- Matches `test_serial.py` reference implementation

### 📋 No Changes Required:
- GUI code unchanged
- OptiTrack integration unchanged
- Waypoint transmission logic unchanged

---

## Summary

| Item | Before | After |
|------|--------|-------|
| **OptiTrack positions** | Offset applied ❌ | No offset ✓ |
| **Waypoints** | Offset applied ✓ | Offset applied ✓ |
| **Unit handling** | meters + mm ❌ | Consistent units ✓ |
| **Matches test_serial.py** | No ❌ | Yes ✓ |

**The key fix:** OptiTrack positions are already in robot world frame and should be sent AS-IS without transformation!

---

## Configuration Reference

### Frame Definitions:

**GUI Frame:**
- Center: (0, 0)
- Range: [-1000, +1000] mm

**Robot World Frame:**
- Center: (-1000, -1000) mm (in real-world coordinates)
- Range: [-2000, 0] mm

**OptiTrack Frame:**
- Same as Robot World Frame
- Units: meters
- No transformation needed

### Offset:
```python
WORLD_FRAME_OFFSET_X = -1000.0  # mm
WORLD_FRAME_OFFSET_Y = -1000.0  # mm
```

**Applied to:** Waypoints from GUI  
**NOT applied to:** OptiTrack positions

---

✅ **OptiTrack position handling is now correct!**
