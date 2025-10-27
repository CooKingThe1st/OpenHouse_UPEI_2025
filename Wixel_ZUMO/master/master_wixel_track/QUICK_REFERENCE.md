# Quick Reference: Multi-Robot Workflow

## 🚀 Fast Multi-Robot Workflow (Recommended)

```
1. Path Planner → Draw paths for all robots → "Send to Robots"
   ✓ Creates waypoints.json

2. Robot Controller:
   l  → Load waypoints (all robots)
   8  → PREP ALL robots at once (sends all waypoints)
   7  → RUN ALL robots simultaneously (no bias!)
   
   Done! All robots execute together! 🎉
```

## 🐌 Single Robot Workflow (If needed)

```
1. Path Planner → Draw path → "Send to Robots"
   ✓ Creates waypoints.json

2. Robot Controller:
   l  → Load waypoints
   s  → Select robot 1
   j  → PREP robot 1
   9  → RUN robot 1
   s  → Select robot 2
   j  → PREP robot 2
   9  → RUN robot 2
   ... (repeat for each robot)
```

## Command Comparison

| Task | Old Way | New Way | Time Saved |
|------|---------|---------|------------|
| **PREP 4 robots** | `s j s j s j s j` | `8` | 7 keypresses! |
| **RUN 4 robots** | `9 s 9 s 9 s 9` | `7` | 6 keypresses! |
| **PREP + RUN all** | `s j s j s j s j 9 s 9 s 9 s 9` | `8 7` | 13 keypresses! |

## Key Commands

- **`l`** - Load waypoints from path planner
- **`8`** - ⭐ **PREP ALL robots** (batch waypoint upload)
- **`7`** - ⭐ **RUN ALL robots** (simultaneous execution - no bias!)
- **`9`** - RUN current robot only
- **`j`** - PREP current robot only
- **`s`** - Select next robot

## Typical Session

```bash
# Terminal 1: Path Planner
python robot_path_planner.py
# Draw paths → Validate → Set Waypoints → Send to Robots

# Terminal 2: Robot Controller  
python test_serial.py

> l          # Load waypoints for all robots
✓ Loaded waypoints for 4 robot(s)

> 8          # Send to ALL robots at once!
✓ PREP_ALL complete! All robots ready!

> 7          # Execute ALL robots simultaneously!
✓ All 4 robots executing - no bias! 🎯

# Done! All robots running together!
```

## Fairness: Why '7' is Better Than Sequential '9'

**Sequential (Old):**
```
9 → Robot 1 starts (t=0ms)
s → Switch to Robot 2
9 → Robot 2 starts (t=200ms) ❌ 200ms delay!
s → Switch to Robot 3
9 → Robot 3 starts (t=400ms) ❌ 400ms delay!
```

**Simultaneous (New):**
```
7 → All robots start at EXACTLY the same time (t=0ms) ✅
```

No more bias from sequential execution!

## Notes

- **'8' automatically sends to all robots with loaded waypoints**
- **'7' sends RUN to ALL robots simultaneously (perfect fairness!)**
- No need to select each robot individually
- Waypoints are sent in robot ID order (1, 2, 3, 4)
- Fallback: robots without loaded waypoints are skipped
- Use '7' for true simultaneous start - no timing bias between robots!
