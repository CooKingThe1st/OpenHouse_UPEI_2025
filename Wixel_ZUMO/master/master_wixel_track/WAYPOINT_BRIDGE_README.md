# Robot Waypoint Bridge

**Simple, production-level bridge for transferring waypoints from GUI path planner to robot controller.**

## Overview

This bridge uses a shared JSON file (`waypoints.json`) to transfer waypoint data between two independent applications:

1. **Path Planner GUI** (`robot_path_planner.py`) - Draw paths and generate optimized waypoints
2. **Robot Controller** (`test_serial.py`) - Send waypoints to physical robots

## Workflow

### 1. Run Path Planner
```bash
python robot_path_planner.py
```

- Select a mission
- Draw paths for each robot
- Click "Validate Paths"
- Click "Set Waypoints" (optimizes paths to 20 waypoints)
- Click "Send to Robots" → **Saves waypoints.json**

### 2. Run Robot Controller
```bash
python test_serial.py
```

**Single Robot:**
- Press **'l'** to load waypoints from `waypoints.json`
- Press **'s'** to select robot
- Press **'j'** to send waypoints via CMD_PREP (current robot)
- Press **'9'** to execute (CMD_RUN)

**Multiple Robots (Fast & Fair!):**
- Press **'l'** to load waypoints from `waypoints.json`
- Press **'8'** to send waypoints to ALL robots at once
- Press **'7'** to execute ALL robots simultaneously (no bias!)

> **Pro Tip:** Use '8' + '7' for perfect simultaneous execution!

## Files

- `waypoint_bridge.py` - Shared bridge module (copy to both directories)
- `waypoints.json` - Auto-generated waypoint data file

## Data Format

**waypoints.json structure:**
```json
{
  "timestamp": "2025-10-25T10:30:00",
  "waypoints": {
    "1": [
      {"order": 0, "x": 500.0, "y": 500.0},
      {"order": 1, "x": 750.0, "y": 800.0},
      ...
    ],
    "2": [ ... ]
  }
}
```

- **Robot IDs**: 1=Blue, 2=Red, 3=Green, 4=Yellow
- **Coordinates**: Real-world millimeters (mm)
- **Order**: Waypoint sequence (0-19)

## Error Handling

- **Bridge file not found**: Controller falls back to rectangle pattern
- **Missing robot waypoints**: Controller skips that robot
- **Invalid JSON**: Load fails gracefully with error message

## Production Features

✅ Simple, minimal design  
✅ No inter-process communication needed  
✅ File-based transfer (robust, debuggable)  
✅ Fallback to default patterns  
✅ Clear error messages  
✅ Timestamp tracking  
✅ Works on Windows/Linux/Mac  

## Notes

- Both applications can run independently
- No need for simultaneous execution
- Manual control - you trigger each step
- Waypoints persist in JSON until overwritten
- Safe to run multiple times
