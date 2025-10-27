"""
Integration test simulating complete user workflow with both bug fixes.
"""

from path_validator import PathValidator
from mission_config import RobotConfig, RobotColor
from path_optimizer import PathInterpolator, WaypointOptimizer, CoordinateConverter

print("="*70)
print("INTEGRATION TEST - Complete User Workflow")
print("="*70)

# Initialize components
validator = PathValidator(tolerance_pixels=30.0)
interpolator = PathInterpolator(smoothness=0.0)
optimizer = WaypointOptimizer(min_distance_mm=100.0, max_waypoints=20)
converter = CoordinateConverter(
    canvas_width=800, canvas_height=800,
    real_width_mm=2000.0, real_height_mm=2000.0
)

# Create test robots
robots = [
    RobotConfig(
        color=RobotColor.RED,
        start_pos=(100, 100),
        end_pos=(700, 700),
        display_name="Red Robot",
        hex_color="#FF0000"
    ),
    RobotConfig(
        color=RobotColor.BLUE,
        start_pos=(700, 100),
        end_pos=(100, 700),
        display_name="Blue Robot",
        hex_color="#0000FF"
    )
]

# Simulate user drawing paths
print("\n" + "="*70)
print("STEP 1: User Draws Paths")
print("="*70)

# Red Robot: Drawn correctly (forward)
red_path = [(100, 100)]  # Start at exact position
for i in range(1, 49):
    t = i / 49
    x = 100 + 600 * t
    y = 100 + 600 * t + 10 * (i % 3 - 1)  # Smaller natural mouse jitter
    red_path.append((x, y))
red_path.append((700, 700))  # End at exact position

print(f"✓ Red Robot path drawn: {len(red_path)} points (START → END)")

# Blue Robot: Drawn backwards (common user behavior)
blue_path = [(100, 700)]  # Start at END position
for i in range(1, 49):
    t = i / 49
    x = 100 + 600 * t
    y = 700 - 600 * t + 10 * (i % 3 - 1)  # Smaller natural mouse jitter
    blue_path.append((x, y))
blue_path.append((700, 100))  # End at START position

print(f"✓ Blue Robot path drawn: {len(blue_path)} points (END → START - backwards!)")

# Simulate validation
print("\n" + "="*70)
print("STEP 2: Validate Paths (Bug Fix #1 & #2 in action)")
print("="*70)

paths = {
    'red': red_path,
    'blue': blue_path
}

all_valid = True
for robot in robots:
    color_key = robot.color.value
    path = paths[color_key]
    
    result = validator.validate_path(path, robot)
    print(f"\n{robot.display_name}:")
    print(f"  Status: {result}")
    print(f"  Points: {len(path)}")
    print(f"  Start: ({path[0][0]:.0f}, {path[0][1]:.0f})")
    print(f"  End: ({path[-1][0]:.0f}, {path[-1][1]:.0f})")
    
    if not result.valid:
        all_valid = False

if not all_valid:
    print("\n❌ VALIDATION FAILED - Test incomplete")
    exit(1)

print("\n✅ All paths validated successfully!")

# Normalize paths
print("\n" + "="*70)
print("STEP 3: Normalize Path Directions (Auto-correct backwards paths)")
print("="*70)

normalized_paths = {}
for robot in robots:
    color_key = robot.color.value
    path = paths[color_key]
    normalized = validator.normalize_path_direction(path, robot)
    normalized_paths[color_key] = normalized
    
    if normalized != path:
        print(f"\n{robot.display_name}:")
        print(f"  ⚠ Path was drawn backwards - AUTO-REVERSED")
        print(f"  Before: ({path[0][0]:.0f}, {path[0][1]:.0f}) → ({path[-1][0]:.0f}, {path[-1][1]:.0f})")
        print(f"  After:  ({normalized[0][0]:.0f}, {normalized[0][1]:.0f}) → ({normalized[-1][0]:.0f}, {normalized[-1][1]:.0f})")
    else:
        print(f"\n{robot.display_name}:")
        print(f"  ✓ Path direction correct - no changes needed")

# Process paths
print("\n" + "="*70)
print("STEP 4: Process Paths (Interpolate & Optimize)")
print("="*70)

final_waypoints = {}
for robot in robots:
    color_key = robot.color.value
    path = normalized_paths[color_key]
    
    # Interpolate
    interpolated = interpolator.interpolate_path(path, num_samples=500)
    
    # Convert to real-world coordinates
    real_path = converter.path_canvas_to_real(interpolated)
    
    # Optimize waypoints
    waypoints_real = optimizer.optimize_waypoints(real_path)
    
    final_waypoints[color_key] = waypoints_real
    
    print(f"\n{robot.display_name}:")
    print(f"  Original points: {len(path)}")
    print(f"  Interpolated: {len(interpolated)}")
    print(f"  Final waypoints: {len(waypoints_real)}")
    print(f"  First waypoint: ({waypoints_real[0][0]:.1f}, {waypoints_real[0][1]:.1f}) mm")
    print(f"  Last waypoint: ({waypoints_real[-1][0]:.1f}, {waypoints_real[-1][1]:.1f}) mm")

# Verify waypoints are correctly oriented
print("\n" + "="*70)
print("STEP 5: Verify Waypoint Orientation")
print("="*70)

all_correct = True
for robot in robots:
    color_key = robot.color.value
    waypoints = final_waypoints[color_key]
    
    # Convert robot start/end to real coordinates
    real_start = converter.canvas_to_real(robot.start_pos[0], robot.start_pos[1])
    real_end = converter.canvas_to_real(robot.end_pos[0], robot.end_pos[1])
    
    # Check first and last waypoints
    first_dist = ((waypoints[0][0] - real_start[0])**2 + 
                  (waypoints[0][1] - real_start[1])**2)**0.5
    last_dist = ((waypoints[-1][0] - real_end[0])**2 + 
                 (waypoints[-1][1] - real_end[1])**2)**0.5
    
    print(f"\n{robot.display_name}:")
    print(f"  Start distance: {first_dist:.1f} mm (should be ~0)")
    print(f"  End distance: {last_dist:.1f} mm (should be ~0)")
    
    if first_dist < 100 and last_dist < 100:  # Within 100mm tolerance
        print(f"  ✅ Waypoints correctly oriented START → END")
    else:
        print(f"  ❌ Waypoint orientation incorrect!")
        all_correct = False

# Final summary
print("\n" + "="*70)
print("INTEGRATION TEST RESULTS")
print("="*70)

if all_correct:
    print("\n🎉 SUCCESS! All tests passed!")
    print("\nKey achievements:")
    print("  ✅ Bug #1 Fixed: Paths with mouse jitter accepted (no false zigzag errors)")
    print("  ✅ Bug #2 Fixed: Backwards path auto-corrected")
    print("  ✅ Both robots processed successfully")
    print("  ✅ Final waypoints correctly oriented")
    print("  ✅ Ready for robot control system")
    print("\n" + "="*70)
    print("SYSTEM IS PRODUCTION READY FOR STUDENT SHOWCASE! 🚀")
    print("="*70)
else:
    print("\n❌ FAILURE - Some tests failed")
    print("Review output above for details")

print()
