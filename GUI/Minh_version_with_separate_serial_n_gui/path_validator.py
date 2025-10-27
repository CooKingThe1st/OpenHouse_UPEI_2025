"""
Path Validation Module
Validates drawn paths for correctness and feasibility.
"""

from typing import List, Tuple, Optional
import math
from mission_config import RobotConfig


class ValidationResult:
    """Result of path validation."""
    
    def __init__(self, valid: bool, message: str = ""):
        self.valid = valid
        self.message = message
    
    def __bool__(self):
        return self.valid
    
    def __repr__(self):
        status = "✓ VALID" if self.valid else "✗ INVALID"
        return f"{status}: {self.message}" if self.message else status


class PathValidator:
    """
    Validates drawn paths for robots.
    """
    
    def __init__(self, tolerance_pixels: float = 30.0, min_path_length: float = 50.0):
        """
        Initialize path validator.
        
        Args:
            tolerance_pixels: Maximum distance allowed between path endpoints and target points
            min_path_length: Minimum acceptable path length in pixels
        """
        self.tolerance = tolerance_pixels
        self.min_path_length = min_path_length
    
    def validate_path(self, path: List[Tuple[float, float]], 
                     robot: RobotConfig) -> ValidationResult:
        """
        Validate a single robot's path.
        
        Args:
            path: List of (x, y) coordinates
            robot: Robot configuration with start/end positions
            
        Returns:
            ValidationResult indicating if path is valid
        """
        # Check if path exists
        if not path or len(path) < 2:
            return ValidationResult(False, f"{robot.display_name}: No path drawn!")
        
        # Check if path connects start and end (in either direction)
        # Calculate distances from path endpoints to robot start/end positions
        dist_first_to_start = self._euclidean_distance(path[0], robot.start_pos)
        dist_first_to_end = self._euclidean_distance(path[0], robot.end_pos)
        dist_last_to_start = self._euclidean_distance(path[-1], robot.start_pos)
        dist_last_to_end = self._euclidean_distance(path[-1], robot.end_pos)
        
        # Determine if path is drawn correctly or needs to be reversed
        forward_valid = (dist_first_to_start <= self.tolerance and 
                        dist_last_to_end <= self.tolerance)
        reverse_valid = (dist_first_to_end <= self.tolerance and 
                        dist_last_to_start <= self.tolerance)
        
        if not forward_valid and not reverse_valid:
            # Path doesn't connect start and end properly in either direction
            return ValidationResult(
                False,
                f"{robot.display_name}: Path must connect START to END positions!\n"
                f"  Start position: {robot.start_pos}\n"
                f"  End position: {robot.end_pos}\n"
                f"  Your path goes from ({path[0][0]:.0f}, {path[0][1]:.0f}) "
                f"to ({path[-1][0]:.0f}, {path[-1][1]:.0f})"
            )
        
        # Note: Path direction is handled automatically - if drawn backwards, 
        # it will be reversed during processing
        
        # Check minimum path length
        path_length = self._calculate_path_length(path)
        if path_length < self.min_path_length:
            return ValidationResult(
                False, 
                f"{robot.display_name}: Path too short ({path_length:.1f}px). Draw a longer path!"
            )
        
        # Note: Zigzag detection disabled for hand-drawn paths
        # Hand-drawn paths naturally have variations that shouldn't be considered errors
        # The interpolation and waypoint optimization will smooth out the path anyway
        
        direction_note = " (auto-reversed)" if reverse_valid and not forward_valid else ""
        return ValidationResult(True, f"{robot.display_name}: Path is valid! ✓{direction_note}")
    
    def validate_all_paths(self, paths: dict, robots: List[RobotConfig]) -> ValidationResult:
        """
        Validate all robot paths.
        
        Args:
            paths: Dictionary mapping robot colors to paths
            robots: List of robot configurations
            
        Returns:
            ValidationResult for all paths combined
        """
        messages = []
        all_valid = True
        
        for robot in robots:
            color_key = robot.color.value
            path = paths.get(color_key, [])
            
            result = self.validate_path(path, robot)
            if not result.valid:
                all_valid = False
            messages.append(result.message)
        
        combined_message = "\n".join(messages)
        return ValidationResult(all_valid, combined_message)
    
    def normalize_path_direction(self, path: List[Tuple[float, float]], 
                                 robot: RobotConfig) -> List[Tuple[float, float]]:
        """
        Ensure path goes from start to end, reversing if necessary.
        
        Args:
            path: Original path (may be in either direction)
            robot: Robot configuration with start/end positions
            
        Returns:
            Path oriented from start to end
        """
        if not path or len(path) < 2:
            return path
        
        # Check which direction the path is drawn
        dist_first_to_start = self._euclidean_distance(path[0], robot.start_pos)
        dist_first_to_end = self._euclidean_distance(path[0], robot.end_pos)
        
        # If path starts closer to end than start, reverse it
        if dist_first_to_end < dist_first_to_start:
            return list(reversed(path))
        
        return path
    
    def _check_endpoint(self, point: Tuple[float, float], 
                       target: Tuple[float, float], 
                       endpoint_type: str) -> ValidationResult:
        """Check if point is close enough to target."""
        distance = self._euclidean_distance(point, target)
        
        if distance > self.tolerance:
            return ValidationResult(
                False,
                f"Path {endpoint_type} point is too far from target "
                f"({distance:.1f}px away, max {self.tolerance:.1f}px)"
            )
        
        return ValidationResult(True)
    
    def _calculate_path_length(self, path: List[Tuple[float, float]]) -> float:
        """Calculate total path length."""
        total_length = 0.0
        for i in range(len(path) - 1):
            total_length += self._euclidean_distance(path[i], path[i + 1])
        return total_length
    
    def _has_extreme_zigzag(self, path: List[Tuple[float, float]], 
                           threshold_angle: float = 160.0,
                           min_segment_length: float = 30.0) -> bool:
        """
        Check for extreme zigzag patterns (sharp back-and-forth movements).
        
        This checks for repeated sharp reversals in direction that would indicate
        chaotic or invalid drawing rather than intentional curves.
        
        Args:
            path: Path to check
            threshold_angle: Angle in degrees above which is considered extreme (180 = straight back)
            min_segment_length: Minimum distance between points to consider for angle calculation
        """
        if len(path) < 3:
            return False
        
        # Sample path at meaningful intervals to avoid noise from dense mouse tracking
        sampled_path = self._sample_path_for_validation(path, min_segment_length)
        
        if len(sampled_path) < 3:
            return False
        
        sharp_reversals = 0
        total_angles_checked = 0
        
        for i in range(len(sampled_path) - 2):
            angle = self._calculate_angle(sampled_path[i], sampled_path[i + 1], sampled_path[i + 2])
            total_angles_checked += 1
            
            # If angle is very large (close to 180°), it's a sharp reversal
            if angle > threshold_angle:
                sharp_reversals += 1
        
        # Only fail if a significant percentage of the path consists of sharp reversals
        # This allows smooth curves while catching actual chaotic zigzags
        if total_angles_checked == 0:
            return False
        
        reversal_ratio = sharp_reversals / total_angles_checked
        
        # If more than 30% of the path has sharp reversals, it's problematic
        # This is much more lenient than the previous consecutive counting approach
        return reversal_ratio > 0.3
    
    def _sample_path_for_validation(self, path: List[Tuple[float, float]], 
                                    min_distance: float) -> List[Tuple[float, float]]:
        """
        Sample path at meaningful intervals to reduce noise from dense mouse tracking.
        
        Args:
            path: Original dense path from mouse tracking
            min_distance: Minimum distance between sampled points
            
        Returns:
            Sampled path with points spaced at least min_distance apart
        """
        if len(path) < 2:
            return path
        
        sampled = [path[0]]  # Always include start point
        
        for i in range(1, len(path)):
            dist = self._euclidean_distance(sampled[-1], path[i])
            if dist >= min_distance:
                sampled.append(path[i])
        
        # Always include end point if not already included
        if sampled[-1] != path[-1]:
            sampled.append(path[-1])
        
        return sampled
    
    def _calculate_angle(self, p1: Tuple[float, float], 
                        p2: Tuple[float, float], 
                        p3: Tuple[float, float]) -> float:
        """
        Calculate angle at p2 formed by p1-p2-p3 in degrees.
        Returns angle in range [0, 180].
        """
        # Vectors
        v1 = (p1[0] - p2[0], p1[1] - p2[1])
        v2 = (p3[0] - p2[0], p3[1] - p2[1])
        
        # Dot product and magnitudes
        dot = v1[0] * v2[0] + v1[1] * v2[1]
        mag1 = math.sqrt(v1[0]**2 + v1[1]**2)
        mag2 = math.sqrt(v2[0]**2 + v2[1]**2)
        
        if mag1 < 1e-6 or mag2 < 1e-6:
            return 0.0
        
        # Angle in radians, then degrees
        cos_angle = dot / (mag1 * mag2)
        cos_angle = max(-1.0, min(1.0, cos_angle))  # Clamp to [-1, 1]
        angle_rad = math.acos(cos_angle)
        angle_deg = math.degrees(angle_rad)
        
        return angle_deg
    
    @staticmethod
    def _euclidean_distance(p1: Tuple[float, float], p2: Tuple[float, float]) -> float:
        """Calculate Euclidean distance between two points."""
        return math.sqrt((p2[0] - p1[0])**2 + (p2[1] - p1[1])**2)


# Example usage and testing
if __name__ == "__main__":
    from mission_config import RobotColor, RobotConfig
    
    print("=== Testing Path Validator ===\n")
    
    # Create test robot
    test_robot = RobotConfig(
        color=RobotColor.RED,
        start_pos=(100, 100),
        end_pos=(700, 700),
        display_name="Test Robot",
        hex_color="#FF0000"
    )
    
    validator = PathValidator(tolerance_pixels=30.0)
    
    # Test Case 1: Valid path
    valid_path = [(100, 100), (200, 200), (400, 400), (600, 600), (700, 700)]
    result = validator.validate_path(valid_path, test_robot)
    print(f"Test 1 - Valid path: {result}")
    
    # Test Case 2: Wrong start point
    wrong_start = [(150, 150), (200, 200), (700, 700)]
    result = validator.validate_path(wrong_start, test_robot)
    print(f"Test 2 - Wrong start: {result}")
    
    # Test Case 3: Wrong end point
    wrong_end = [(100, 100), (200, 200), (650, 650)]
    result = validator.validate_path(wrong_end, test_robot)
    print(f"Test 3 - Wrong end: {result}")
    
    # Test Case 4: Too short
    too_short = [(100, 100), (110, 110)]
    result = validator.validate_path(too_short, test_robot)
    print(f"Test 4 - Too short: {result}")
    
    # Test Case 5: Empty path
    empty_path = []
    result = validator.validate_path(empty_path, test_robot)
    print(f"Test 5 - Empty path: {result}")
    
    print("\n=== Test Complete ===")
