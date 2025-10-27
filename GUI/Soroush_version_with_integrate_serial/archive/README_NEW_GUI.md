# Multi-Robot Path Planning GUI - Production Edition

## Overview

This is a production-level, educational GUI for teaching robotics path planning to 16-17 year old students. Students draw paths for 1-4 robots, which are then intelligently optimized into exactly 20 waypoints per robot for execution on real hardware.

## Key Features

### 🎯 Mission-Based Learning
- **4 Progressive Missions**: From single robot (easy) to 4 robots (expert)
- Each mission increases in complexity and coordination requirements
- Clear objectives and difficulty ratings

### ✏️ Intuitive Drawing Interface
- Click and drag to draw paths from start (S) to end (E) markers
- Color-coded robots (Red, Green, Blue, Yellow)
- Real-time visual feedback with grid overlay
- Professional, clean UI design

### 🧠 Intelligent Waypoint Optimization
- **Spline Interpolation**: Smooth curves fitted to drawn paths
- **Curvature Analysis**: More waypoints on curves, fewer on straight sections
- **Smart Distribution**: Maintains 10cm minimum distance between waypoints
- **Fixed Output**: Always exactly 20 waypoints (padded with endpoint duplicates)
- **Visual Comparison**: Translucent drawn paths vs solid optimized paths

### ✅ Robust Validation
- Verifies paths start and end at correct positions
- Checks minimum path length
- Detects extreme zigzag patterns
- Clear, actionable error messages for students

### 📊 Real-World Coordinates
- Canvas: 800x800 pixels
- Real-world: 2000x2000mm square
- Automatic coordinate transformation
- Ready for robot control system integration

## Architecture

### Modular Design

```
robot_path_planner.py      # Main GUI application
├── mission_config.py       # Mission definitions and robot configurations
├── path_optimizer.py       # Interpolation and waypoint optimization
├── path_validator.py       # Path validation logic
└── coordinate_transformer.py  # (legacy - replaced by CoordinateConverter)
```

### Core Components

1. **MissionManager**: Manages 4 missions with increasing complexity
2. **PathInterpolator**: Uses scipy B-splines for smooth path curves
3. **WaypointOptimizer**: Curvature-based intelligent waypoint placement
4. **CoordinateConverter**: Canvas ↔ Real-world coordinate transformation
5. **PathValidator**: Comprehensive path validation with clear feedback
6. **RobotPathCanvas**: Interactive drawing canvas with dual-layer rendering

## Installation

```bash
# Install dependencies
pip install -r requirements.txt

# Requirements:
# - numpy
# - scipy
# - opencv-python-headless
# - PyQt5
```

## Usage

### Starting the Application

```bash
python robot_path_planner.py
```

### Workflow for Students

1. **Select Mission**: Choose from 4 progressive difficulty levels
2. **Select Robot**: Click on a robot button to start drawing its path
3. **Draw Path**: Click and drag from START (S) to END (E) markers
4. **Repeat**: Draw paths for all robots in the mission
5. **Validate**: Click "✓ Validate Paths" to check for errors
6. **Set Waypoints**: Click "📍 Set Waypoints" to optimize paths
7. **Review**: Examine the optimized waypoints shown on canvas
8. **Send**: Click "📤 Send to Robots" to generate commands

### Visual Feedback

- **Translucent Dashed Lines**: Original drawn paths
- **Solid Bright Lines**: Optimized waypoint paths
- **Numbered Circles**: Individual waypoints (1-20)
- **S Markers**: Robot start positions (circles)
- **E Markers**: Robot end positions (squares)

## Algorithm Details

### Path Interpolation

```python
# 1. Clean duplicate points from user drawing
# 2. Parameterize by arc length
# 3. Fit B-spline (degree 1-3 based on point count)
# 4. Sample 500 points along smooth curve
```

### Waypoint Optimization

```python
# 1. Calculate curvature at each point along path
# 2. Place more waypoints where curvature is high (curves)
# 3. Place fewer waypoints where curvature is low (straight)
# 4. Enforce 10cm minimum distance between waypoints
# 5. Pad remaining slots with endpoint duplicates
# 6. Always output exactly 20 waypoints
```

### Curvature Formula

```
κ = |x'y'' - y'x''| / (x'² + y'²)^(3/2)

Where:
- κ = curvature
- x', y' = first derivatives
- x'', y'' = second derivatives
```

## Output Format

When "Send to Robots" is clicked, formatted commands are printed to console:

```python
RED_ROBOT_WAYPOINTS = [
    (250.00, 250.00),  # WP1
    (389.70, 277.50),  # WP2
    ...
    (1157.50, 1000.00),  # WP20
]

GREEN_ROBOT_WAYPOINTS = [
    ...
]
```

Coordinates are in millimeters, ready for control system integration.

## Mission Configurations

### Mission 1: Solo Navigator (Easy)
- 1 Red robot
- Learn basic path drawing
- No collision concerns

### Mission 2: Dual Dance (Medium)
- 2 Robots (Red, Green)
- Crossing paths
- Basic collision avoidance

### Mission 3: Triple Threat (Hard)
- 3 Robots (Red, Green, Blue)
- Complex coordination
- Multiple potential collisions

### Mission 4: Quadrant Chaos (Expert)
- 4 Robots (All colors)
- Maximum complexity
- Requires careful planning

## Customization

### Adjust Waypoint Parameters

```python
# In robot_path_planner.py, __init__ method:

self.waypoint_optimizer = WaypointOptimizer(
    min_distance_mm=100.0,  # Minimum 10cm between waypoints
    max_waypoints=20        # Always 20 waypoints output
)
```

### Adjust Validation Tolerance

```python
self.path_validator = PathValidator(
    tolerance_pixels=30.0,    # How close to start/end required
    min_path_length=50.0      # Minimum path length in pixels
)
```

### Change Real-World Dimensions

```python
self.coord_converter = CoordinateConverter(
    canvas_width=800,
    canvas_height=800,
    real_width_mm=2000.0,   # Change this for different arena size
    real_height_mm=2000.0
)
```

### Modify Mission Configurations

Edit `mission_config.py` to change:
- Robot start/end positions
- Number of robots per mission
- Robot colors
- Difficulty levels

## Error Handling

The system handles various edge cases:

- **Empty paths**: Clear error message
- **Wrong start/end points**: Shows distance tolerance violation
- **Too short paths**: Enforces minimum length
- **Extreme zigzags**: Detects unrealistic back-and-forth patterns
- **Interpolation failures**: Falls back to linear interpolation
- **Invalid splines**: Robust error recovery

## Educational Benefits

1. **Progressive Learning**: Start simple, build complexity
2. **Visual Feedback**: See optimization in real-time
3. **Immediate Validation**: Learn from mistakes quickly
4. **Real-World Connection**: Coordinates map to actual robot arena
5. **Algorithmic Understanding**: See how curvature affects waypoint placement

## Technical Highlights

### Production-Level Code Quality
- ✅ Modular architecture with clear separation of concerns
- ✅ Comprehensive error handling and validation
- ✅ Type hints for better code clarity
- ✅ Detailed docstrings and comments
- ✅ Defensive programming against edge cases
- ✅ Professional UI/UX design
- ✅ Efficient algorithms (O(n) complexity)

### Robustness
- Handles invalid user inputs gracefully
- Recovers from spline interpolation failures
- Validates all paths before optimization
- Clamps coordinates to valid ranges
- Prevents division by zero in calculations

### UI/UX Excellence
- Intuitive mission-based workflow
- Clear visual hierarchy
- Color-coded feedback (green = success, red = error)
- Real-time status updates
- Detailed logging for debugging
- Emoji icons for better recognition
- Professional color scheme

## Future Enhancements

Potential additions for production deployment:

1. **Collision Detection**: Check if robot paths intersect
2. **Undo/Redo**: Allow students to revert changes
3. **Save/Load**: Persist mission progress
4. **Animation**: Simulate robot movement along paths
5. **Leaderboard**: Track completion times
6. **Tutorial Mode**: Step-by-step guidance for first-time users
7. **Advanced Algorithms**: A* pathfinding, RRT, etc.
8. **3D Visualization**: Show robot movements in 3D space
9. **Network Integration**: Direct communication with robot control system
10. **Performance Metrics**: Analyze path efficiency

## Testing

Test individual modules:

```bash
# Test path optimizer
python path_optimizer.py

# Test mission configurations
python mission_config.py

# Test path validator
python path_validator.py
```

## Troubleshooting

### GUI doesn't start
- Ensure PyQt5 is installed: `pip install PyQt5`
- Check Python version (requires 3.7+)

### Spline interpolation fails
- System falls back to linear interpolation automatically
- Check if scipy is installed: `pip install scipy`

### Waypoints look wrong
- Verify real-world dimensions in CoordinateConverter
- Check min_distance_mm parameter in WaypointOptimizer
- Ensure drawn paths are smooth (not too many sharp turns)

### Paths not validating
- Check tolerance_pixels setting (default 30px)
- Ensure paths actually reach start/end markers
- Draw longer paths (minimum 50px by default)

## Credits

Developed for student robotics education at MoreLab.
Production-level refactoring completed October 2025.

## License

For educational use in robotics courses.
