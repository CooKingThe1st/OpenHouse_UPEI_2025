"""
Coordinate Transformation Module
Converts between pixmap coordinates and real-world OptiTrack coordinates
"""

import numpy as np
import json
import os

class CoordinateTransformer:
    """
    Transforms coordinates between pixmap space and real-world OptiTrack space
    using perspective transformation (homography)
    """
    
    def __init__(self, calibration_file='dotconnect_data/calibration.json'):
        self.calibration_file = calibration_file
        self.calibration_data = None
        self.transform_matrix = None
        self.is_calibrated = False
        
        # Load calibration if exists
        self.load_calibration()
    
    def set_calibration(self, pixmap_corners, realworld_corners):
        """
        Set calibration using 4 corner points
        
        Args:
            pixmap_corners: List of 4 points [(x0,y0), (x1,y1), (x2,y2), (x3,y3)] in pixmap coordinates
                           Typically: [(0,0), (600,0), (600,400), (0,400)]
            realworld_corners: List of 4 corresponding points in real-world OptiTrack coordinates
                              Example: [(0.5, -0.3), (1.5, -0.3), (1.5, 0.7), (0.5, 0.7)]
        
        Returns:
            bool: True if calibration successful
        """
        if len(pixmap_corners) != 4 or len(realworld_corners) != 4:
            print("[ERROR] Calibration requires exactly 4 corner points")
            return False
        
        # Convert to numpy arrays
        src_points = np.array(pixmap_corners, dtype=np.float32)
        dst_points = np.array(realworld_corners, dtype=np.float32)
        
        # Compute perspective transformation matrix
        try:
            # Using OpenCV-style homography calculation
            self.transform_matrix = self._compute_homography(src_points, dst_points)
            
            self.calibration_data = {
                'pixmap_corners': pixmap_corners,
                'realworld_corners': realworld_corners,
                'transform_matrix': self.transform_matrix.tolist()
            }
            
            self.is_calibrated = True
            print("[INFO] Calibration successful!")
            return True
            
        except Exception as e:
            print(f"[ERROR] Calibration failed: {e}")
            return False
    
    def _compute_homography(self, src_points, dst_points):
        """
        Compute perspective transformation matrix (3x3 homography)
        Maps src_points to dst_points
        """
        # Build the equation system for homography
        # For 4 point pairs, we have 8 equations (2 per point)
        A = []
        for i in range(4):
            x, y = src_points[i]
            u, v = dst_points[i]
            A.append([x, y, 1, 0, 0, 0, -u*x, -u*y, -u])
            A.append([0, 0, 0, x, y, 1, -v*x, -v*y, -v])
        
        A = np.array(A)
        
        # Solve using SVD
        U, S, Vt = np.linalg.svd(A)
        H = Vt[-1].reshape(3, 3)
        
        # Normalize
        H = H / H[2, 2]
        
        return H
    
    def pixmap_to_realworld(self, x, y):
        """
        Convert a single point from pixmap coordinates to real-world coordinates
        
        Args:
            x, y: Coordinates in pixmap space
        
        Returns:
            (real_x, real_y): Coordinates in real-world OptiTrack space
        """
        if not self.is_calibrated:
            print("[WARNING] Coordinate transformer not calibrated! Returning original coordinates.")
            return (x, y)
        
        # Apply perspective transformation
        point = np.array([x, y, 1], dtype=np.float32)
        transformed = self.transform_matrix @ point
        
        # Normalize by homogeneous coordinate
        real_x = transformed[0] / transformed[2]
        real_y = transformed[1] / transformed[2]
        
        return (real_x, real_y)
    
    def pixmap_path_to_realworld(self, pixmap_path):
        """
        Convert a path (list of points) from pixmap to real-world coordinates
        
        Args:
            pixmap_path: List of (x, y) tuples in pixmap coordinates
        
        Returns:
            List of (real_x, real_y) tuples in real-world coordinates
        """
        if not pixmap_path:
            return []
        
        realworld_path = []
        for x, y in pixmap_path:
            real_x, real_y = self.pixmap_to_realworld(x, y)
            realworld_path.append((real_x, real_y))
        
        return realworld_path
    
    def convert_solution_to_realworld(self, solution):
        """
        Convert entire solution dictionary from pixmap to real-world coordinates
        
        Args:
            solution: Dict with color keys and path lists
                     Example: {'red': [(x1,y1), (x2,y2), ...], 'green': [...], ...}
        
        Returns:
            Dict with same structure but real-world coordinates
        """
        realworld_solution = {}
        
        for color, path in solution.items():
            realworld_solution[color] = self.pixmap_path_to_realworld(path)
        
        return realworld_solution
    
    def save_calibration(self):
        """Save calibration data to file"""
        if not self.is_calibrated or not self.calibration_data:
            print("[WARNING] No calibration data to save")
            return False
        
        try:
            os.makedirs(os.path.dirname(self.calibration_file), exist_ok=True)
            with open(self.calibration_file, 'w') as f:
                json.dump(self.calibration_data, f, indent=2)
            print(f"[INFO] Calibration saved to {self.calibration_file}")
            return True
        except Exception as e:
            print(f"[ERROR] Failed to save calibration: {e}")
            return False
    
    def load_calibration(self):
        """Load calibration data from file"""
        if not os.path.exists(self.calibration_file):
            print("[INFO] No calibration file found. Please calibrate first.")
            return False
        
        try:
            with open(self.calibration_file, 'r') as f:
                self.calibration_data = json.load(f)
            
            self.transform_matrix = np.array(self.calibration_data['transform_matrix'], dtype=np.float32)
            self.is_calibrated = True
            print("[INFO] Calibration loaded successfully!")
            return True
        except Exception as e:
            print(f"[ERROR] Failed to load calibration: {e}")
            return False
    
    def get_calibration_info(self):
        """Get human-readable calibration information"""
        if not self.is_calibrated:
            return "Not calibrated"
        
        info = "Calibration Mapping:\n"
        pixmap = self.calibration_data['pixmap_corners']
        realworld = self.calibration_data['realworld_corners']
        
        corner_names = ['Top-Left', 'Top-Right', 'Bottom-Right', 'Bottom-Left']
        for i, name in enumerate(corner_names):
            info += f"  {name}: Pixmap{pixmap[i]} → Real{realworld[i]}\n"
        
        return info


# Example usage and test
if __name__ == "__main__":
    # Create transformer
    transformer = CoordinateTransformer()
    
    # Example calibration (replace with actual measured values)
    pixmap_corners = [
        (0, 0),      # Top-left
        (600, 0),    # Top-right
        (600, 400),  # Bottom-right
        (0, 400)     # Bottom-left
    ]
    
    realworld_corners = [
        (0.5, -0.3),   # Top-left in meters
        (1.5, -0.3),   # Top-right in meters
        (1.5, 0.7),    # Bottom-right in meters
        (0.5, 0.7)     # Bottom-left in meters
    ]
    
    # Set calibration
    transformer.set_calibration(pixmap_corners, realworld_corners)
    
    # Test conversion
    print("\nTest Conversions:")
    test_points = [
        (0, 0),       # Top-left corner
        (600, 400),   # Bottom-right corner
        (300, 200),   # Center
        (150, 100),   # Random point
    ]
    
    for px, py in test_points:
        rx, ry = transformer.pixmap_to_realworld(px, py)
        print(f"  Pixmap ({px:3d}, {py:3d}) → Real ({rx:6.3f}, {ry:6.3f})")
    
    # Save calibration
    transformer.save_calibration()
    
    print("\n" + transformer.get_calibration_info())
