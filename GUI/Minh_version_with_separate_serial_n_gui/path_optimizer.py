"""
Path Optimization Module
Handles path interpolation and intelligent waypoint generation for robot navigation.
"""

import numpy as np
from scipy import interpolate
from typing import List, Tuple, Optional
import math


class PathInterpolator:
    """
    Interpolates drawn paths into smooth curves using spline fitting.
    """
    
    def __init__(self, smoothness: float = 0.0):
        """
        Initialize path interpolator.
        
        Args:
            smoothness: Smoothing factor for spline (0 = no smoothing)
        """
        self.smoothness = smoothness
    
    def interpolate_path(self, points: List[Tuple[float, float]], 
                        num_samples: int = 500) -> Optional[List[Tuple[float, float]]]:
        """
        Interpolate a path through given points using B-spline.
        
        Args:
            points: List of (x, y) coordinates
            num_samples: Number of points to sample along the curve
            
        Returns:
            List of interpolated (x, y) points, or None if interpolation fails
        """
        if not points or len(points) < 2:
            return None
        
        # Remove duplicate consecutive points
        cleaned_points = [points[0]]
        for p in points[1:]:
            if abs(p[0] - cleaned_points[-1][0]) > 0.1 or abs(p[1] - cleaned_points[-1][1]) > 0.1:
                cleaned_points.append(p)
        
        if len(cleaned_points) < 2:
            return [points[0], points[-1]]
        
        # Convert to numpy arrays
        points_array = np.array(cleaned_points)
        x = points_array[:, 0]
        y = points_array[:, 1]
        
        # Handle straight line case
        if len(cleaned_points) == 2:
            t = np.linspace(0, 1, num_samples)
            interp_x = x[0] + t * (x[1] - x[0])
            interp_y = y[0] + t * (y[1] - y[0])
            return list(zip(interp_x, interp_y))
        
        try:
            # Parameterize by cumulative distance
            distances = np.sqrt(np.diff(x)**2 + np.diff(y)**2)
            distances = np.insert(distances, 0, 0)
            t = np.cumsum(distances)
            t = t / t[-1]  # Normalize to [0, 1]
            
            # Determine spline degree (k)
            k = min(3, len(cleaned_points) - 1)
            
            # Create B-spline interpolation for both x and y together
            tck, u = interpolate.splprep([x, y], u=t, s=self.smoothness, k=k)
            
            # Sample the spline
            u_new = np.linspace(0, 1, num_samples)
            x_new, y_new = interpolate.splev(u_new, tck)
            
            return list(zip(x_new, y_new))
            
        except Exception as e:
            print(f"[WARNING] Spline interpolation failed: {e}. Using linear interpolation.")
            return self._linear_interpolation(cleaned_points, num_samples)
    
    def _linear_interpolation(self, points: List[Tuple[float, float]], 
                             num_samples: int) -> List[Tuple[float, float]]:
        """
        Fallback linear interpolation between points.
        """
        if len(points) < 2:
            return points
        
        result = []
        total_segments = len(points) - 1
        samples_per_segment = max(2, num_samples // total_segments)
        
        for i in range(len(points) - 1):
            x0, y0 = points[i]
            x1, y1 = points[i + 1]
            
            t = np.linspace(0, 1, samples_per_segment, endpoint=(i == len(points) - 2))
            segment_x = x0 + t * (x1 - x0)
            segment_y = y0 + t * (y1 - y0)
            
            result.extend(zip(segment_x, segment_y))
        
        return result


class WaypointOptimizer:
    """
    Optimizes waypoint placement along paths using Ramer-Douglas-Peucker algorithm.
    Intelligently simplifies paths while preserving geometric features.
    """
    
    def __init__(self, epsilon_mm: float = 50.0, max_waypoints: int = 20):
        """
        Initialize waypoint optimizer.
        
        Args:
            epsilon_mm: RDP simplification tolerance in millimeters (higher = more aggressive)
            max_waypoints: Maximum number of waypoints to generate
        """
        self.epsilon_mm = epsilon_mm
        self.max_waypoints = max_waypoints
    
    def optimize_waypoints(self, path: List[Tuple[float, float]]) -> List[Tuple[float, float]]:
        """
        Generate optimized waypoints using Ramer-Douglas-Peucker algorithm.
        This algorithm preserves important geometric features (curves, corners)
        while eliminating redundant points on straight sections.
        
        Args:
            path: List of (x, y) coordinates in millimeters
            
        Returns:
            List of optimized waypoints (always 20 points, padded if necessary)
        """
        if not path or len(path) < 2:
            return []
        
        # Apply Ramer-Douglas-Peucker algorithm
        simplified = self._rdp_simplify(path, self.epsilon_mm)
        
        # If we got too many waypoints, increase epsilon and try again
        attempts = 0
        current_epsilon = self.epsilon_mm
        while len(simplified) > self.max_waypoints and attempts < 5:
            current_epsilon *= 1.5
            simplified = self._rdp_simplify(path, current_epsilon)
            attempts += 1
        
        # If still too many, take evenly-spaced subset
        if len(simplified) > self.max_waypoints:
            indices = np.linspace(0, len(simplified) - 1, self.max_waypoints, dtype=int)
            simplified = [simplified[i] for i in indices]
        
        # Pad with final point to reach exactly max_waypoints
        while len(simplified) < self.max_waypoints:
            simplified.append(path[-1])
        
        return simplified[:self.max_waypoints]
    
    def _rdp_simplify(self, points: List[Tuple[float, float]], 
                     epsilon: float) -> List[Tuple[float, float]]:
        """
        Ramer-Douglas-Peucker algorithm for path simplification.
        
        Recursively finds points that are furthest from the line segment
        between endpoints. If the distance exceeds epsilon, the point is kept
        and the algorithm recurses on both sides.
        
        Args:
            points: Path points to simplify
            epsilon: Distance threshold (points closer than this to line are removed)
            
        Returns:
            Simplified path that preserves important geometric features
        """
        if len(points) < 3:
            return points
        
        # Find the point with maximum distance from line segment
        start = points[0]
        end = points[-1]
        max_dist = 0.0
        max_index = 0
        
        for i in range(1, len(points) - 1):
            dist = self._perpendicular_distance(points[i], start, end)
            if dist > max_dist:
                max_dist = dist
                max_index = i
        
        # If max distance exceeds epsilon, recursively simplify both sides
        if max_dist > epsilon:
            # Recursively simplify left and right segments
            left_segment = self._rdp_simplify(points[:max_index + 1], epsilon)
            right_segment = self._rdp_simplify(points[max_index:], epsilon)
            
            # Combine results (remove duplicate middle point)
            return left_segment[:-1] + right_segment
        else:
            # All intermediate points are close to the line, keep only endpoints
            return [start, end]
    
    def _perpendicular_distance(self, point: Tuple[float, float],
                               line_start: Tuple[float, float],
                               line_end: Tuple[float, float]) -> float:
        """
        Calculate perpendicular distance from point to line segment.
        
        Uses the formula: |cross product| / |line length|
        """
        x0, y0 = point
        x1, y1 = line_start
        x2, y2 = line_end
        
        # Vector from line_start to line_end
        dx = x2 - x1
        dy = y2 - y1
        
        # Line length
        line_length = math.sqrt(dx * dx + dy * dy)
        
        if line_length < 1e-6:
            # Line segment is essentially a point
            return math.sqrt((x0 - x1)**2 + (y0 - y1)**2)
        
        # Calculate perpendicular distance using cross product
        # |cross product| = |(x2-x1)(y1-y0) - (x1-x0)(y2-y1)|
        cross_product = abs(dx * (y1 - y0) - (x1 - x0) * dy)
        distance = cross_product / line_length
        
        return distance
    
    @staticmethod
    def _euclidean_distance(p1: Tuple[float, float], p2: Tuple[float, float]) -> float:
        """Calculate Euclidean distance between two points."""
        return math.sqrt((p2[0] - p1[0])**2 + (p2[1] - p1[1])**2)


class CoordinateConverter:
    """
    Converts coordinates between canvas pixels and real-world millimeters.
    """
    
    def __init__(self, canvas_width: int = 800, canvas_height: int = 800,
                 real_width_mm: float = 2000.0, real_height_mm: float = 2000.0):
        """
        Initialize coordinate converter.
        
        Args:
            canvas_width: Canvas width in pixels
            canvas_height: Canvas height in pixels
            real_width_mm: Real-world width in millimeters
            real_height_mm: Real-world height in millimeters
        """
        self.canvas_width = canvas_width
        self.canvas_height = canvas_height
        self.real_width_mm = real_width_mm
        self.real_height_mm = real_height_mm
        
        # Calculate scaling factors
        self.scale_x = real_width_mm / canvas_width
        self.scale_y = real_height_mm / canvas_height
    
    def canvas_to_real(self, x: float, y: float) -> Tuple[float, float]:
        """
        Convert canvas coordinates to real-world coordinates.
        
        Args:
            x, y: Canvas coordinates in pixels
            
        Returns:
            (real_x, real_y) in millimeters
        """
        real_x = x * self.scale_x
        real_y = y * self.scale_y
        return (real_x, real_y)
    
    def real_to_canvas(self, real_x: float, real_y: float) -> Tuple[float, float]:
        """
        Convert real-world coordinates to canvas coordinates.
        
        Args:
            real_x, real_y: Real-world coordinates in millimeters
            
        Returns:
            (x, y) in canvas pixels
        """
        x = real_x / self.scale_x
        y = real_y / self.scale_y
        return (x, y)
    
    def path_canvas_to_real(self, path: List[Tuple[float, float]]) -> List[Tuple[float, float]]:
        """Convert entire path from canvas to real-world coordinates."""
        return [self.canvas_to_real(x, y) for x, y in path]
    
    def path_real_to_canvas(self, path: List[Tuple[float, float]]) -> List[Tuple[float, float]]:
        """Convert entire path from real-world to canvas coordinates."""
        return [self.real_to_canvas(x, y) for x, y in path]


def test_optimizer():
    """Test the path optimization pipeline."""
    print("=== Testing Path Optimizer ===\n")
    
    # Create test path (rough L-shape with curve)
    test_points = [
        (100, 100),
        (120, 105),
        (150, 110),
        (200, 120),
        (300, 140),
        (400, 160),
        (420, 170),
        (440, 190),
        (450, 220),
        (455, 260),
        (460, 300),
        (462, 350),
        (463, 400),
    ]
    
    print(f"Input: {len(test_points)} drawn points")
    
    # Interpolate
    interpolator = PathInterpolator(smoothness=0.0)
    interpolated = interpolator.interpolate_path(test_points, num_samples=500)
    print(f"Interpolated: {len(interpolated)} points")
    
    # Convert to real-world coordinates
    converter = CoordinateConverter(canvas_width=800, canvas_height=800,
                                    real_width_mm=2000, real_height_mm=2000)
    real_path = converter.path_canvas_to_real(interpolated)
    
    # Optimize waypoints
    optimizer = WaypointOptimizer(min_distance_mm=100, max_waypoints=20)
    waypoints = optimizer.optimize_waypoints(real_path)
    
    print(f"Optimized: {len(waypoints)} waypoints\n")
    print("Waypoints (mm):")
    for i, (x, y) in enumerate(waypoints):
        print(f"  WP{i+1:2d}: ({x:7.1f}, {y:7.1f})")
    
    # Check distances
    print("\nDistances between consecutive waypoints:")
    for i in range(len(waypoints) - 1):
        dist = optimizer._euclidean_distance(waypoints[i], waypoints[i+1])
        print(f"  WP{i+1} -> WP{i+2}: {dist:.1f} mm")
    
    print("\n=== Test Complete ===")


if __name__ == "__main__":
    test_optimizer()
