"""
Demo Script - Test the complete path planning pipeline
"""

from mission_config import MissionManager, RobotColor
from path_optimizer import PathInterpolator, WaypointOptimizer, CoordinateConverter
from path_validator import PathValidator

def demo_complete_pipeline():
    """Demonstrate the complete path planning workflow."""
    
    print("="*70)
    print("MULTI-ROBOT PATH PLANNING - COMPLETE PIPELINE DEMO")
    print("="*70)
    
    # Initialize components
    print("\n1️⃣  Initializing components...")
    mission_manager = MissionManager(canvas_width=800, canvas_height=800)
    path_validator = PathValidator(tolerance_pixels=30.0, min_path_length=50.0)
    path_interpolator = PathInterpolator(smoothness=0.0)
    waypoint_optimizer = WaypointOptimizer(min_distance_mm=100.0, max_waypoints=20)
    coord_converter = CoordinateConverter(
        canvas_width=800, canvas_height=800,
        real_width_mm=2000.0, real_height_mm=2000.0
    )
    
    # Load Mission 1
    print("\n2️⃣  Loading Mission 1: Solo Navigator...")
    mission = mission_manager.get_mission(1)
    print(f"   Mission: {mission.name}")
    print(f"   Difficulty: {mission.difficulty}")
    print(f"   Robots: {len(mission.robots)}")
    
    robot = mission.robots[0]  # Red robot
    print(f"\n   Robot: {robot.display_name}")
    print(f"   Start: {robot.start_pos}")
    print(f"   End: {robot.end_pos}")
    
    # Simulate user drawing a path
    print("\n3️⃣  Simulating user drawing a path...")
    # Create a curved path from start to end
    start_x, start_y = robot.start_pos
    end_x, end_y = robot.end_pos
    
    # Create path with some curves
    drawn_path = [
        robot.start_pos,
        (200, 150),
        (300, 180),
        (400, 250),
        (500, 400),
        (600, 550),
        (650, 650),
        robot.end_pos
    ]
    
    print(f"   Drew path with {len(drawn_path)} control points")
    
    # Validate path
    print("\n4️⃣  Validating path...")
    paths = {robot.color.value: drawn_path}
    validation_result = path_validator.validate_all_paths(paths, [robot])
    
    if validation_result.valid:
        print("   ✅ Path is VALID!")
    else:
        print(f"   ❌ Path validation FAILED:")
        print(f"      {validation_result.message}")
        return
    
    # Interpolate path
    print("\n5️⃣  Interpolating path with splines...")
    interpolated = path_interpolator.interpolate_path(drawn_path, num_samples=500)
    print(f"   Generated {len(interpolated)} interpolated points")
    
    # Convert to real-world coordinates
    print("\n6️⃣  Converting to real-world coordinates...")
    real_path = coord_converter.path_canvas_to_real(interpolated)
    print(f"   Canvas: (0, 0) → ({coord_converter.canvas_width}, {coord_converter.canvas_height}) pixels")
    print(f"   Real-world: (0, 0) → ({coord_converter.real_width_mm}, {coord_converter.real_height_mm}) mm")
    
    # Optimize waypoints
    print("\n7️⃣  Optimizing waypoints with curvature analysis...")
    waypoints = waypoint_optimizer.optimize_waypoints(real_path)
    
    # Count unique waypoints
    unique_waypoints = []
    for wp in waypoints:
        if not unique_waypoints or wp != unique_waypoints[-1]:
            unique_waypoints.append(wp)
    
    print(f"   Generated {len(unique_waypoints)} unique waypoints")
    print(f"   Padded to {len(waypoints)} total waypoints")
    
    # Display waypoints
    print("\n8️⃣  Final Waypoints (Real-World Coordinates in mm):")
    print("   " + "="*60)
    
    for i, (x, y) in enumerate(waypoints):
        # Mark duplicates
        if i > 0 and (x, y) == waypoints[i-1]:
            marker = " [duplicate]"
        else:
            marker = ""
        print(f"   WP{i+1:2d}: ({x:7.1f}, {y:7.1f}){marker}")
    
    # Calculate distances
    print("\n9️⃣  Distances between unique waypoints:")
    print("   " + "="*60)
    
    for i in range(len(unique_waypoints) - 1):
        dist = waypoint_optimizer._euclidean_distance(unique_waypoints[i], unique_waypoints[i+1])
        print(f"   WP{i+1} → WP{i+2}: {dist:6.1f} mm ({dist/10:.1f} cm)")
    
    # Summary
    print("\n" + "="*70)
    print("✅ PIPELINE COMPLETE!")
    print("="*70)
    print(f"\n📊 Summary:")
    print(f"   • Input: {len(drawn_path)} drawn points")
    print(f"   • Interpolated: {len(interpolated)} smooth points")
    print(f"   • Optimized: {len(unique_waypoints)} unique waypoints")
    print(f"   • Output: {len(waypoints)} waypoints (padded to 20)")
    print(f"   • Min distance: {coord_converter.scale_x * 100:.1f} mm (10cm)")
    print(f"   • Path uses curvature analysis for intelligent placement")
    print(f"\n🤖 Ready to send to robot control system!")
    
    # Format for robot system
    print("\n" + "="*70)
    print("FORMATTED OUTPUT FOR ROBOT CONTROL SYSTEM")
    print("="*70)
    print(f"\n{robot.color.value.upper()}_ROBOT_WAYPOINTS = [")
    for i, (x, y) in enumerate(waypoints):
        print(f"    ({x:.2f}, {y:.2f}),  # WP{i+1}")
    print("]\n")


if __name__ == "__main__":
    demo_complete_pipeline()
