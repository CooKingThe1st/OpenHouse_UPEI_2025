# Waypoint Bridge Commands - Quick Reference

## ✅ NOW IMPLEMENTED: Commands 'l', '8', '7'

### Complete Workflow (3 commands)
```
l   →   8   →   7
↓       ↓       ↓
LOAD    PREP    RUN
        ALL     ALL
```

---

## Command Details

### `l` - LOAD WAYPOINTS
**Purpose:** Load waypoints from `waypoints.json` (created by path planner)

**What it does:**
- Reads waypoints.json file
- Stores waypoints for each robot in memory
- Shows summary of loaded data

**Example output:**
```
✓ [LOAD SUCCESS] Loaded waypoints for 4 robot(s)
  Robot 1: 20 waypoints
  Robot 2: 20 waypoints
  Robot 3: 20 waypoints
  Robot 4: 20 waypoints

→ Use '8' to PREP all robots, or 'j' to PREP current robot
```

**Error handling:**
- File not found → tells you to export from path planner
- No waypoint_bridge.py → tells you to add the file
- Empty/corrupt file → shows error message

---

### `8` - PREP ALL ROBOTS (Batch)
**Purpose:** Send CMD_PREP with loaded waypoints to ALL robots at once

**What it does:**
- Loops through all 4 robots
- Sends 20 waypoints to each robot (1 per packet)
- 50ms delay between packets
- Skips robots without waypoints

**Example output:**
```
[CMD_PREP_ALL] Sending PREP to ALL 4 robots with loaded waypoints...

  Robot 1: Sending 20 waypoints...
  ✓ Robot 1: PREP complete
  
  Robot 2: Sending 20 waypoints...
  ✓ Robot 2: PREP complete
  
  ... (continues for all robots)

✓ [PREP_ALL Complete] All robots prepared!
→ Use '7' to RUN all robots simultaneously
```

**Timing:**
- 20 waypoints × 100ms delay = ~2 seconds per robot
- 4 robots × 2 seconds = ~8 seconds total

**Requirements:**
- Must run `l` first to load waypoints
- Will show error if no waypoints loaded

---

### `7` - RUN ALL ROBOTS (Simultaneous)
**Purpose:** Send CMD_RUN to ALL robots in single packet (zero bias!)

**What it does:**
- Sets CMD_RUN for all 4 slaves
- Sends ALL commands in ONE packet
- All robots start at EXACTLY the same time

**Example output:**
```
[CMD_RUN_ALL] Sending RUN command to ALL 4 robots simultaneously...
✓ [RUN_ALL Complete] All 4 robots executing simultaneously!
  (All robots start at EXACTLY the same time - zero bias!)
```

**Fairness:**
- Sequential ('9' 4 times): Robot 1 gets 600ms head start
- Simultaneous ('7' once): All robots start together

---

## Comparison: Old vs New

### OLD WAY (Sequential - 13 keypresses)
```
s j s j s j s j    →  PREP all robots (8 commands + robot selection)
s 9 s 9 s 9 s 9    →  RUN all robots (8 commands + robot selection)
                      = 16 total commands, ~600ms timing bias
```

### NEW WAY (Batch - 3 keypresses)
```
l                  →  LOAD waypoints once
8                  →  PREP all robots
7                  →  RUN all robots
                      = 3 total commands, ZERO timing bias
```

**Efficiency gain:** 16 → 3 commands (81% reduction!)

---

## Modified Commands

### `j` - PREP CURRENT ROBOT (Enhanced)
**NEW behavior:**
- Checks if waypoints loaded for current robot
- If YES: Uses loaded waypoints from path planner
- If NO: Falls back to rectangle pattern

**Example with loaded waypoints:**
```
[CMD_PREP] Robot 1 - Using LOADED waypoints from path planner
Sending 20 waypoints (1 per packet)...
```

**Example without loaded waypoints:**
```
[CMD_PREP] Robot 1 - Using FALLBACK rectangle waypoints
  (Use 'l' to load waypoints from path planner)
Sending 20 waypoints (1 per packet)...
```

---

## Integration with Path Planner

### Path Planner Side
1. Draw paths for robots on canvas
2. Click "Send to Robots" button
3. Creates `waypoints.json` with:
   - Robot ID (1=blue, 2=red, 3=green, 4=yellow)
   - 20 waypoints per robot
   - Format: (order, x_mm, y_mm)

### Controller Side
1. Press `l` to load waypoints.json
2. Press `8` to PREP all robots with waypoints
3. Press `7` to RUN all robots simultaneously

---

## File Format: waypoints.json

```json
{
  "timestamp": "2025-10-25 14:30:00",
  "source": "robot_path_planner.py",
  "robot_count": 4,
  "waypoints_per_robot": 20,
  "waypoints": {
    "1": [
      [0, 1500.0, 1200.0],
      [1, 1600.0, 1250.0],
      ...
    ],
    "2": [...],
    "3": [...],
    "4": [...]
  }
}
```

---

## Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| `waypoint_bridge.py not found` | Missing bridge file | Copy waypoint_bridge.py to directory |
| `waypoints.json not found` | Haven't exported from planner | Run path planner, click "Send to Robots" |
| `No waypoints loaded` | Pressed 8/7 before 'l' | Press 'l' first |
| `Robot X: No waypoints found` | That robot not in JSON | Add path for that robot in planner |

---

## Complete Workflow Example

### Step 1: Path Planner (GUI)
```
1. Launch robot_path_planner.py
2. Draw paths for blue, red, green, yellow robots
3. Click "Optimize All Missions" (optional)
4. Click "Send to Robots"
   → Creates waypoints.json
5. Keep GUI open or close it (doesn't matter)
```

### Step 2: Robot Controller (Terminal)
```
python test_serial.py

Enter command: l
✓ [LOAD SUCCESS] Loaded waypoints for 4 robot(s)

Enter command: 8
[CMD_PREP_ALL] Sending PREP to ALL 4 robots...
✓ [PREP_ALL Complete] All robots prepared!

Enter command: 7
[CMD_RUN_ALL] Sending RUN to ALL 4 robots simultaneously!
✓ All robots executing simultaneously!
```

**Total time:** ~10 seconds (8s for PREP, 1s for RUN)
**Total keypresses:** 3

---

## Technical Notes

### Coordinate Conversion
- Path planner: Canvas pixels (0-800)
- waypoints.json: Millimeters (0-2000mm)
- Controller: Converts mm → meters for transmission

### Packet Format
- 1 waypoint = 5 bytes: [order, x_high, x_low, y_high, y_low]
- Sent in Data0-Data4 of 16-byte packet
- 1 waypoint per packet (20 packets per robot)

### Threading Safety
- Background AUX thread continues during PREP
- Manual commands use serial_lock for thread safety
- Loaded waypoints stored in global dict

---

## FAQ

**Q: Can I use '8' without running 'l' first?**
A: No, it will show error. Must load waypoints first.

**Q: What if I only have 2 robots?**
A: '8' will skip robots without waypoints. Still works!

**Q: Can I mix loaded + fallback waypoints?**
A: Yes! 'j' checks per-robot. Robot 1 might use loaded, Robot 2 uses fallback.

**Q: Does '7' require PREP first?**
A: No, but robots won't move without waypoints. Always PREP before RUN.

**Q: What if waypoints.json is corrupted?**
A: 'l' will show error. Re-export from path planner.

---

## Summary

✅ **'l' command:** Load waypoints from path planner
✅ **'8' command:** PREP all robots with loaded waypoints (batch)
✅ **'7' command:** RUN all robots simultaneously (zero bias)
✅ **'j' command:** Enhanced to use loaded waypoints (fallback to rectangle)

**Quick workflow:** `l → 8 → 7` (3 commands, fair execution)
