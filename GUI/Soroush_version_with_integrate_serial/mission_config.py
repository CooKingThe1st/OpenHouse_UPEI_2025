"""
Mission Configuration Module
Defines mission parameters, robot configurations, and validation rules.
"""

from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass
from enum import Enum


class RobotColor(Enum):
    """Robot color identifiers."""
    RED = "red"
    GREEN = "green"
    BLUE = "blue"
    YELLOW = "yellow"


@dataclass
class RobotConfig:
    """Configuration for a single robot."""
    color: RobotColor
    start_pos: Tuple[float, float]  # (x, y) in canvas coordinates
    end_pos: Tuple[float, float]
    display_name: str
    hex_color: str  # For rendering


@dataclass
class MissionConfig:
    """Configuration for a mission."""
    mission_id: int
    name: str
    description: str
    robots: List[RobotConfig]
    difficulty: str
    
    def get_robot_by_color(self, color: RobotColor) -> Optional[RobotConfig]:
        """Get robot configuration by color."""
        for robot in self.robots:
            if robot.color == color:
                return robot
        return None


class MissionManager:
    """
    Manages mission configurations and provides mission data.
    """
    
    def __init__(self, canvas_width: int = 800, canvas_height: int = 800):
        """
        Initialize mission manager.
        
        Args:
            canvas_width: Canvas width in pixels
            canvas_height: Canvas height in pixels
        """
        self.canvas_width = canvas_width
        self.canvas_height = canvas_height
        self.missions = self._create_missions()
    
    def _create_missions(self) -> Dict[int, MissionConfig]:
        """Create all mission configurations."""
        
        # Helper function for positioning
        def pos(x_frac: float, y_frac: float) -> Tuple[float, float]:
            return (x_frac * self.canvas_width, y_frac * self.canvas_height)
        
        missions = {}
        
        # Mission 1: Single Robot (Red)
        missions[1] = MissionConfig(
            mission_id=1,
            name="Mission 1: Solo Navigator",
            description="Guide the RED robot from start to finish. Learn the basics!",
            difficulty="Easy",
            robots=[
                RobotConfig(
                    color=RobotColor.RED,
                    start_pos=pos(0.15, 0.15),
                    end_pos=pos(0.85, 0.85),
                    display_name="Red Robot",
                    hex_color="#FF3333"
                )
            ]
        )
        
        # Mission 2: Two Robots (Red, Green)
        missions[2] = MissionConfig(
            mission_id=2,
            name="Mission 2: Dual Dance",
            description="Coordinate RED and GREEN robots. Don't let them collide!",
            difficulty="Medium",
            robots=[
                RobotConfig(
                    color=RobotColor.RED,
                    start_pos=pos(0.15, 0.15),
                    end_pos=pos(0.85, 0.85),
                    display_name="Red Robot",
                    hex_color="#FF3333"
                ),
                RobotConfig(
                    color=RobotColor.GREEN,
                    start_pos=pos(0.85, 0.15),
                    end_pos=pos(0.15, 0.85),
                    display_name="Green Robot",
                    hex_color="#33FF33"
                )
            ]
        )
        
        # Mission 3: Three Robots (Red, Green, Blue)
        missions[3] = MissionConfig(
            mission_id=3,
            name="Mission 3: Triple Threat",
            description="Navigate three robots simultaneously. Precision required!",
            difficulty="Hard",
            robots=[
                RobotConfig(
                    color=RobotColor.RED,
                    start_pos=pos(0.15, 0.15),  # Top-left
                    end_pos=pos(0.85, 0.85),    # Bottom-right
                    display_name="Red Robot",
                    hex_color="#FF3333"
                ),
                RobotConfig(
                    color=RobotColor.GREEN,
                    start_pos=pos(0.85, 0.15),  # Top-right
                    end_pos=pos(0.15, 0.85),    # Bottom-left
                    display_name="Green Robot",
                    hex_color="#33FF33"
                ),
                RobotConfig(
                    color=RobotColor.BLUE,
                    start_pos=pos(0.50, 0.85),  # Bottom-center
                    end_pos=pos(0.50, 0.15),    # Top-center
                    display_name="Blue Robot",
                    hex_color="#3333FF"
                )
            ]
        )
        
        # Mission 4: Four Robots (All colors)
        missions[4] = MissionConfig(
            mission_id=4,
            name="Mission 4: Quadrant Chaos",
            description="Master level! Control all four robots without any collisions.",
            difficulty="Expert",
            robots=[
                RobotConfig(
                    color=RobotColor.RED,
                    start_pos=pos(0.15, 0.30),  # Left side, upper
                    end_pos=pos(0.85, 0.70),    # Right side, lower
                    display_name="Red Robot",
                    hex_color="#FF3333"
                ),
                RobotConfig(
                    color=RobotColor.GREEN,
                    start_pos=pos(0.85, 0.30),  # Right side, upper
                    end_pos=pos(0.15, 0.70),    # Left side, lower
                    display_name="Green Robot",
                    hex_color="#33FF33"
                ),
                RobotConfig(
                    color=RobotColor.BLUE,
                    start_pos=pos(0.30, 0.15),  # Top side, left
                    end_pos=pos(0.70, 0.85),    # Bottom side, right
                    display_name="Blue Robot",
                    hex_color="#3333FF"
                ),
                RobotConfig(
                    color=RobotColor.YELLOW,
                    start_pos=pos(0.70, 0.15),  # Top side, right
                    end_pos=pos(0.30, 0.85),    # Bottom side, left
                    display_name="Yellow Robot",
                    hex_color="#FFDD33"
                )
            ]
        )
        
        return missions
    
    def get_mission(self, mission_id: int) -> Optional[MissionConfig]:
        """Get mission configuration by ID."""
        return self.missions.get(mission_id)
    
    def get_all_missions(self) -> List[MissionConfig]:
        """Get all mission configurations."""
        return list(self.missions.values())
    
    def get_mission_count(self) -> int:
        """Get total number of missions."""
        return len(self.missions)


# Example usage
if __name__ == "__main__":
    manager = MissionManager(canvas_width=800, canvas_height=800)
    
    print("=== Mission Configurations ===\n")
    for mission in manager.get_all_missions():
        print(f"{mission.name}")
        print(f"  Difficulty: {mission.difficulty}")
        print(f"  Robots: {len(mission.robots)}")
        for robot in mission.robots:
            print(f"    - {robot.display_name}: {robot.start_pos} → {robot.end_pos}")
        print()
