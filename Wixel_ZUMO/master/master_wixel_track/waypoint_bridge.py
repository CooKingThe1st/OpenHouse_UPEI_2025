"""
Waypoint Bridge - Simple JSON-based data transfer between path planner and robot controller.
Production-level, minimal design.

Usage:
    Path Planner: WaypointBridge.save(waypoints_dict)
    Robot Controller: waypoints = WaypointBridge.load()
"""

import json
from typing import Dict, List, Tuple
from datetime import datetime
import os


class WaypointBridge:
    """Simple bridge for transferring waypoint data between applications."""
    
    BRIDGE_FILE = "waypoints.json"
    
    @staticmethod
    def save(waypoints: Dict[int, List[Tuple[int, float, float]]]) -> bool:
        """
        Save waypoints to bridge file.
        
        Args:
            waypoints: Dict mapping robot_id -> [(order, x_mm, y_mm), ...]
        
        Returns:
            True if saved successfully, False otherwise
        """
        try:
            data = {
                "timestamp": datetime.now().isoformat(),
                "waypoints": {
                    str(robot_id): [
                        {"order": order, "x": x, "y": y}
                        for order, x, y in wp_list
                    ]
                    for robot_id, wp_list in waypoints.items()
                }
            }
            
            with open(WaypointBridge.BRIDGE_FILE, 'w') as f:
                json.dump(data, f, indent=2)
            
            print(f"✓ Waypoints saved to {WaypointBridge.BRIDGE_FILE}")
            return True
            
        except Exception as e:
            print(f"✗ Failed to save waypoints: {e}")
            return False
    
    @staticmethod
    def load() -> Dict[int, List[Tuple[int, float, float]]]:
        """
        Load waypoints from bridge file.
        
        Returns:
            Dict mapping robot_id -> [(order, x_mm, y_mm), ...]
            Empty dict if file doesn't exist or is invalid
        """
        if not os.path.exists(WaypointBridge.BRIDGE_FILE):
            print(f"✗ Bridge file not found: {WaypointBridge.BRIDGE_FILE}")
            return {}
        
        try:
            with open(WaypointBridge.BRIDGE_FILE, 'r') as f:
                data = json.load(f)
            
            waypoints = {
                int(robot_id): [
                    (wp["order"], wp["x"], wp["y"])
                    for wp in wp_list
                ]
                for robot_id, wp_list in data["waypoints"].items()
            }
            
            timestamp = data.get("timestamp", "unknown")
            print(f"✓ Loaded waypoints from {WaypointBridge.BRIDGE_FILE}")
            print(f"  Generated: {timestamp}")
            print(f"  Robots: {list(waypoints.keys())}")
            
            return waypoints
            
        except Exception as e:
            print(f"✗ Failed to load waypoints: {e}")
            return {}
