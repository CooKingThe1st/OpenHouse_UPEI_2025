"""
Test script to verify coordinate transformation from GUI to Robot World Frame.

This script validates that the coordinate transformation correctly maps:
- GUI center (canvas 400,400) → GUI frame (0,0) → Robot world (-1000,-1000)
- GUI boundaries map correctly to robot workspace boundaries

Author: AI Assistant
Date: 2025-10-25
"""

from path_optimizer import CoordinateConverter
from robot_controller import ControllerConfig

def test_coordinate_transformation():
    """Test the complete coordinate transformation pipeline."""
    
    print("="*70)
    print("Coordinate Transformation Test")
    print("="*70)
    print()
    
    # Create coordinate converter (canvas to GUI frame)
    converter = CoordinateConverter(
        canvas_width=800,
        canvas_height=800,
        real_width_mm=2000.0,
        real_height_mm=2000.0
    )
    
    # Display configuration
    print("Configuration:")
    print(f"  Canvas size: 800x800 pixels")
    print(f"  GUI frame: 2000x2000 mm (centered at origin)")
    print(f"  World frame offset: ({ControllerConfig.WORLD_FRAME_OFFSET_X}, "
          f"{ControllerConfig.WORLD_FRAME_OFFSET_Y}) mm")
    print()
    
    # Test points
    test_points = [
        # (canvas_x, canvas_y, description)
        (0, 0, "Top-left corner"),
        (400, 0, "Top center"),
        (800, 0, "Top-right corner"),
        (0, 400, "Left center"),
        (400, 400, "CENTER (most important!)"),
        (800, 400, "Right center"),
        (0, 800, "Bottom-left corner"),
        (400, 800, "Bottom center"),
        (800, 800, "Bottom-right corner"),
    ]
    
    print("Transformation Results:")
    print("-" * 70)
    print(f"{'Canvas (px)':<15} {'→ GUI (mm)':<20} {'→ Robot World (mm)':<25} {'Location'}")
    print("-" * 70)
    
    for canvas_x, canvas_y, description in test_points:
        # Step 1: Canvas to GUI frame
        gui_x, gui_y = converter.canvas_to_real(canvas_x, canvas_y)
        
        # Step 2: GUI frame to Robot world frame
        robot_x = gui_x + ControllerConfig.WORLD_FRAME_OFFSET_X
        robot_y = gui_y + ControllerConfig.WORLD_FRAME_OFFSET_Y
        
        # Format output
        canvas_str = f"({canvas_x:>3}, {canvas_y:>3})"
        gui_str = f"({gui_x:>7.1f}, {gui_y:>7.1f})"
        robot_str = f"({robot_x:>7.1f}, {robot_y:>7.1f})"
        
        # Highlight the center point
        marker = " ← *** " if "CENTER" in description else ""
        
        print(f"{canvas_str:<15} → {gui_str:<20} → {robot_str:<25} {description}{marker}")
    
    print("-" * 70)
    print()
    
    # Verify the critical requirement
    print("Critical Requirement Verification:")
    print("-" * 70)
    
    # Canvas center should map to robot world (-1000, -1000)
    gui_center = converter.canvas_to_real(400, 400)
    robot_center = (
        gui_center[0] + ControllerConfig.WORLD_FRAME_OFFSET_X,
        gui_center[1] + ControllerConfig.WORLD_FRAME_OFFSET_Y
    )
    
    expected_robot_center = (-1000.0, -1000.0)
    
    print(f"Canvas center (400, 400):")
    print(f"  → GUI frame: {gui_center}")
    print(f"  → Robot world: {robot_center}")
    print(f"  Expected: {expected_robot_center}")
    
    if robot_center == expected_robot_center:
        print("  ✓ PASS: Center maps correctly!")
    else:
        print("  ✗ FAIL: Center does not map correctly!")
        print(f"  Error: {robot_center} != {expected_robot_center}")
    
    print()
    
    # Test workspace boundaries
    print("Workspace Boundary Verification:")
    print("-" * 70)
    
    # GUI boundaries (after centering)
    gui_corners = [
        converter.canvas_to_real(0, 0),      # Top-left
        converter.canvas_to_real(800, 0),    # Top-right
        converter.canvas_to_real(0, 800),    # Bottom-left
        converter.canvas_to_real(800, 800),  # Bottom-right
    ]
    
    print(f"GUI frame boundaries (mm):")
    print(f"  X range: [{gui_corners[0][0]:.1f}, {gui_corners[1][0]:.1f}]")
    print(f"  Y range: [{gui_corners[0][1]:.1f}, {gui_corners[2][1]:.1f}]")
    
    # Robot world boundaries
    robot_corners = [
        (x + ControllerConfig.WORLD_FRAME_OFFSET_X, 
         y + ControllerConfig.WORLD_FRAME_OFFSET_Y)
        for x, y in gui_corners
    ]
    
    print(f"Robot world boundaries (mm):")
    print(f"  X range: [{robot_corners[0][0]:.1f}, {robot_corners[1][0]:.1f}]")
    print(f"  Y range: [{robot_corners[0][1]:.1f}, {robot_corners[2][1]:.1f}]")
    
    # Expected robot workspace: center at (-1000, -1000), size 2000x2000
    # So boundaries should be [-2000, 0] for both X and Y
    expected_x_range = (-2000.0, 0.0)
    expected_y_range = (-2000.0, 0.0)
    
    actual_x_range = (robot_corners[0][0], robot_corners[1][0])
    actual_y_range = (robot_corners[0][1], robot_corners[2][1])
    
    x_match = actual_x_range == expected_x_range
    y_match = actual_y_range == expected_y_range
    
    print()
    print(f"Expected robot workspace:")
    print(f"  X range: [{expected_x_range[0]:.1f}, {expected_x_range[1]:.1f}]")
    print(f"  Y range: [{expected_y_range[0]:.1f}, {expected_y_range[1]:.1f}]")
    
    if x_match and y_match:
        print("  ✓ PASS: Workspace boundaries match!")
    else:
        print("  ✗ FAIL: Workspace boundaries do not match!")
        if not x_match:
            print(f"    X range error: {actual_x_range} != {expected_x_range}")
        if not y_match:
            print(f"    Y range error: {actual_y_range} != {expected_y_range}")
    
    print()
    print("="*70)
    
    # Test a drawing boundary square
    print()
    print("Example: Square boundary centered at GUI origin")
    print("-" * 70)
    
    # A square with 500mm radius around GUI origin
    square_points = [
        (-500, -500),  # Bottom-left
        (500, -500),   # Bottom-right
        (500, 500),    # Top-right
        (-500, 500),   # Top-left
    ]
    
    print("GUI square (mm) → Robot world (mm):")
    for gui_point in square_points:
        robot_point = (
            gui_point[0] + ControllerConfig.WORLD_FRAME_OFFSET_X,
            gui_point[1] + ControllerConfig.WORLD_FRAME_OFFSET_Y
        )
        print(f"  {gui_point} → {robot_point}")
    
    print()
    print("This square should have its center at robot world (-1000, -1000)")
    square_center = (0 + ControllerConfig.WORLD_FRAME_OFFSET_X, 
                     0 + ControllerConfig.WORLD_FRAME_OFFSET_Y)
    print(f"Square center: {square_center}")
    
    if square_center == expected_robot_center:
        print("✓ PASS: Square center matches expected robot world center!")
    else:
        print("✗ FAIL: Square center does not match!")
    
    print("="*70)


if __name__ == "__main__":
    test_coordinate_transformation()
