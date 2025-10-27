# Quick Start Guide - Multi-Robot Path Planner

## 5-Minute Setup

### 1. Install Dependencies
```bash
pip install -r requirements.txt
```

Required packages:
- `numpy` - Numerical computations
- `scipy` - Spline interpolation
- `PyQt5` - GUI framework
- `opencv-python-headless` - (legacy, may not be needed)

### 2. Run the Application
```bash
python robot_path_planner.py
```

## First Mission - Step by Step

### Mission 1: Solo Navigator (Single Robot)

#### Step 1: Application Opens
- You'll see a clean interface with:
  - Large 800x800 grid canvas on the left
  - Control panel on the right
  - Mission 1 pre-selected

#### Step 2: Select Robot
- Click the **"Red Robot"** button (it will highlight)
- Status message appears: "Drawing mode: Red Robot..."

#### Step 3: Draw Path
- Click and drag on the canvas from the **S marker** (start) to the **E marker** (end)
- Your path appears as a translucent red dashed line
- Keep dragging smoothly - don't lift the mouse until you reach the end

**Tips:**
- Start close to the S marker (within the circle)
- End close to the E marker (within the square)
- Draw smooth curves, not sharp zigzags
- Longer, flowing paths work better than short jerky ones

#### Step 4: Validate Path
- Click **"✓ Validate Paths"** button
- System checks:
  - ✅ Starts near S marker?
  - ✅ Ends near E marker?
  - ✅ Long enough?
  - ✅ No extreme zigzags?
- If validation fails, you'll see clear error messages

#### Step 5: Set Waypoints
- Click **"📍 Set Waypoints"** button
- Watch the magic happen:
  - Your drawn path stays (translucent dashed)
  - Optimized path appears (solid bright line)
  - 20 numbered waypoint circles appear
  - More waypoints on curves, fewer on straight sections

#### Step 6: Review Waypoints
- Examine the canvas:
  - Numbered circles show waypoint positions
  - Straight sections have waypoints further apart
  - Curved sections have waypoints closer together
- Check the log for details about each waypoint

#### Step 7: Send to Robots
- Click **"📤 Send to Robots"** button
- Check the console output for formatted commands:
```python
RED_ROBOT_WAYPOINTS = [
    (300.00, 300.00),  # WP1
    (450.00, 400.00),  # WP2
    ...
    (1700.00, 1700.00),  # WP20
]
```

**🎉 Congratulations!** You've completed your first mission!

## Try Mission 2: Two Robots

### What's Different?
- Now you have TWO robots (Red and Green)
- They cross paths - plan carefully!

### Steps:
1. Select **Mission 2** from dropdown
2. Click **"Red Robot"** button
3. Draw RED path from its S to its E
4. Click **"Green Robot"** button  
5. Draw GREEN path from its S to its E
6. Click **"✓ Validate Paths"**
7. If valid, click **"📍 Set Waypoints"**
8. Review both paths - do they collide?
9. If happy, click **"📤 Send to Robots"**

**Challenge:** Make the paths cross without robots colliding!

## Understanding Waypoint Optimization

### Why 20 Waypoints?
- Your robot control system requires exactly 20 waypoints
- More isn't better - it's unnecessary precision
- Fewer isn't enough - might miss curves

### How Optimization Works

1. **Your Drawing**: Potentially 1000+ pixel coordinates
2. **Interpolation**: Fitted to smooth 500-point B-spline curve
3. **Curvature Analysis**: System calculates bend at each point
4. **Smart Placement**: 
   - High curvature = place waypoint (curves)
   - Low curvature = skip ahead (straight lines)
5. **Distance Check**: Minimum 10cm between waypoints
6. **Padding**: If fewer than 20, final point is duplicated

### Visual Guide

```
Drawn Path:     ~~~~~~~~~~~~~~~~~~~~~~
                (translucent dashed)

Optimized Path: ━━━●━━●━●●━━━━━●━━━━●
                (solid with numbered dots)
                
Straight:       fewer waypoints ━━━━●━━━━●
Curve:          more waypoints  ━●●●●━
```

## Common Issues & Solutions

### ❌ "Path start point is too far from target"
**Problem:** You started drawing away from the S marker  
**Solution:** Start your drawing right on or near the S circle

### ❌ "Path end point is too far from target"
**Problem:** You ended drawing away from the E marker  
**Solution:** End your drawing right on or near the E square

### ❌ "Path too short"
**Problem:** Path is less than 50 pixels total  
**Solution:** Draw a longer, more complete path

### ❌ "Path has extreme zigzags"
**Problem:** You drew back and forth rapidly  
**Solution:** Draw smooth, flowing paths without sharp reversals

### ❌ "No path drawn"
**Problem:** Forgot to select a robot first  
**Solution:** Click a robot button before drawing

## Pro Tips

### Drawing Technique
1. **Start steady**: Click and hold near S marker
2. **Smooth motion**: Move mouse in flowing curves
3. **Constant speed**: Don't speed up or slow down suddenly
4. **Plan ahead**: Think about where you're going before drawing
5. **End cleanly**: Release mouse button near E marker

### Multi-Robot Strategy
1. **Draw longest path first**: Gives you most flexibility
2. **Plan crossings**: Make robots pass at different times
3. **Use space wisely**: Spread out to avoid collisions
4. **Review before sending**: Check all paths together

### Optimization Insights
- Longer smooth curves = more evenly spaced waypoints
- Sharp corners = tighter waypoint clusters
- Straight diagonal = minimal waypoints needed
- S-curves = balanced waypoint distribution

## Keyboard Shortcuts

Currently no keyboard shortcuts, but you can:
- Click buttons with mouse
- Draw with continuous mouse drag
- Use mouse to navigate interface

## What to Expect

### Mission Difficulty Progression

**Mission 1 (Easy)**: 1 robot
- Learn the interface
- Practice drawing
- See waypoint optimization
- ~2 minutes

**Mission 2 (Medium)**: 2 robots
- Coordinate multiple paths
- Avoid collisions
- Plan crossing strategies
- ~5 minutes

**Mission 3 (Hard)**: 3 robots
- Complex coordination
- Multiple collision risks
- Strategic planning required
- ~10 minutes

**Mission 4 (Expert)**: 4 robots
- Maximum complexity
- All robots in motion
- Master-level challenge
- ~15 minutes

## Advanced Usage

### Clearing Paths
- **Clear Current Robot Path**: Removes path for selected robot only
- **Clear All Paths**: Removes all paths (asks for confirmation)

### Iterating on Solutions
1. Draw all paths
2. Validate
3. Don't like one? Select that robot and **Clear Current Robot Path**
4. Redraw just that one
5. Validate again
6. Set waypoints when happy

### Exporting Data
- Console output can be copy-pasted into your code
- Waypoints are in millimeters
- Format is ready for direct use in control systems

## Next Steps

After mastering all 4 missions:
1. Try different path strategies
2. Experiment with curve placement
3. Minimize path crossings
4. Optimize for shortest total distance
5. Challenge friends to beat your solutions

## Getting Help

### Check These First
1. **Status bar** (blue box): Quick feedback on current state
2. **Detailed log** (green terminal): Full information about operations
3. **Error dialogs**: Clear explanations when something goes wrong

### Understanding Output

**Console output format:**
```python
RED_ROBOT_WAYPOINTS = [
    (x1, y1),  # WP1  <- First waypoint
    (x2, y2),  # WP2
    ...
    (x20, y20),  # WP20  <- Last waypoint (may be duplicate)
]
```

**Coordinates:**
- Values are in millimeters
- (0, 0) is top-left of canvas
- (2000, 2000) is bottom-right
- Matches your real robot arena

## Troubleshooting

### GUI won't start
```bash
# Check Python version
python --version  # Need 3.7+

# Reinstall PyQt5
pip install --upgrade PyQt5
```

### Waypoints look weird
- Check if you drew smooth paths
- Avoid rapid direction changes
- Make sure paths are long enough

### Can't see waypoints
- Did you click "Set Waypoints" button?
- Check if validation passed first
- Look for numbered circles on canvas

## Have Fun!

This tool teaches:
- **Path planning** concepts
- **Coordinate transformation** skills  
- **Multi-agent coordination** strategies
- **Algorithm optimization** appreciation

Enjoy planning robot missions! 🤖🎯
