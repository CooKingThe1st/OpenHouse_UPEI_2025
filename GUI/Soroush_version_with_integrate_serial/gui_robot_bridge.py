"""
GUI Robot Bridge - Integration Layer
====================================

Seamlessly connects the robot_path_planner GUI with the robot_controller
serial communication system.

This module provides:
- Non-invasive integration (no GUI code changes required)
- Automatic waypoint format conversion (GUI → Controller)
- Mission execution orchestration
- Real-time status feedback
- Error handling and recovery

Usage:
    from gui_robot_bridge import RobotBridge
    
    bridge = RobotBridge()
    bridge.connect()
    
    # Send waypoints from GUI format
    bridge.send_mission_waypoints(robot_commands_dict)

Author: Production System
Date: 2025-10-25
"""

import logging
from typing import Dict, List, Tuple, Optional, Callable
from dataclasses import dataclass
from enum import Enum

from robot_controller import RobotController, ControllerConfig, RobotIDMapper


# ==================== BRIDGE CONFIGURATION ====================

class BridgeConfig:
    """Configuration for GUI-Robot bridge."""
    
    # Serial port (can be overridden)
    DEFAULT_PORT = "COM5"
    DEFAULT_BAUD = 9600
    
    # Mission execution
    AUTO_RUN_AFTER_WAYPOINTS = False  # Set True to auto-execute after sending waypoints
    DELAY_BETWEEN_ROBOTS = 0.5  # Seconds between sending waypoints to different robots
    
    # Status feedback
    VERBOSE_LOGGING = True


# ==================== MISSION STATUS ====================

class MissionStatus(Enum):
    """Status of mission execution."""
    IDLE = "idle"
    CONNECTING = "connecting"
    CONNECTED = "connected"
    SENDING_WAYPOINTS = "sending_waypoints"
    WAYPOINTS_LOADED = "waypoints_loaded"
    RUNNING = "running"
    COMPLETED = "completed"
    ERROR = "error"
    DISCONNECTED = "disconnected"


@dataclass
class MissionResult:
    """Result of mission operation."""
    success: bool
    status: MissionStatus
    message: str
    robots_processed: int = 0
    errors: List[str] = None
    
    def __post_init__(self):
        if self.errors is None:
            self.errors = []


# ==================== ROBOT BRIDGE ====================

class RobotBridge:
    """
    Bridge between GUI path planner and robot controller.
    
    Handles:
    - Waypoint format conversion
    - Multi-robot coordination
    - Sequential waypoint transmission
    - Mission execution control
    - Status reporting
    """
    
    def __init__(self,
                 port: str = BridgeConfig.DEFAULT_PORT,
                 baud_rate: int = BridgeConfig.DEFAULT_BAUD,
                 status_callback: Optional[Callable[[str], None]] = None,
                 auto_run: bool = BridgeConfig.AUTO_RUN_AFTER_WAYPOINTS):
        """
        Initialize robot bridge.
        
        Args:
            port: Serial port for robot communication
            baud_rate: Serial baud rate
            status_callback: Callback for status updates (optional)
            auto_run: Automatically send RUN command after waypoints
        """
        self.port = port
        self.baud_rate = baud_rate
        self.auto_run = auto_run
        
        # Robot controller
        self.controller: Optional[RobotController] = None
        
        # Status tracking
        self.current_status = MissionStatus.IDLE
        self.status_callback = status_callback
        
        # Mission state
        self.loaded_robots: List[str] = []  # Colors of robots with waypoints loaded
        
        # Logger
        self.logger = logging.getLogger(__name__)
        if BridgeConfig.VERBOSE_LOGGING:
            logging.basicConfig(
                level=logging.INFO,
                format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
            )
    
    def _update_status(self, status: MissionStatus, message: str = ""):
        """Update internal status and notify callback."""
        self.current_status = status
        
        if message and self.status_callback:
            try:
                self.status_callback(message)
            except Exception as e:
                self.logger.error(f"Status callback error: {e}")
        
        self.logger.info(f"Status: {status.value} - {message}")
    
    # ==================== CONNECTION MANAGEMENT ====================
    
    def connect(self) -> MissionResult:
        """
        Connect to robot control system.
        
        Returns:
            MissionResult with connection status
        """
        self._update_status(MissionStatus.CONNECTING, "Connecting to robot control system...")
        
        try:
            # Create controller with status forwarding
            def controller_status_callback(msg: str):
                if self.status_callback:
                    self.status_callback(msg)
            
            self.controller = RobotController(
                port=self.port,
                baud_rate=self.baud_rate,
                enable_logging=True,
                status_callback=controller_status_callback
            )
            
            # Attempt connection
            if self.controller.connect():
                self._update_status(
                    MissionStatus.CONNECTED,
                    f"✓ Connected to {self.port}"
                )
                
                return MissionResult(
                    success=True,
                    status=MissionStatus.CONNECTED,
                    message=f"Successfully connected to {self.port}"
                )
            else:
                self._update_status(
                    MissionStatus.ERROR,
                    f"✗ Failed to connect to {self.port}"
                )
                
                return MissionResult(
                    success=False,
                    status=MissionStatus.ERROR,
                    message=f"Failed to connect to {self.port}",
                    errors=["Serial connection failed"]
                )
        
        except Exception as e:
            error_msg = f"Connection error: {e}"
            self._update_status(MissionStatus.ERROR, error_msg)
            
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message=error_msg,
                errors=[str(e)]
            )
    
    def disconnect(self):
        """Disconnect from robot control system."""
        if self.controller:
            self.controller.disconnect()
            self._update_status(
                MissionStatus.DISCONNECTED,
                "Disconnected from robot control system"
            )
            self.controller = None
            self.loaded_robots.clear()
    
    def is_connected(self) -> bool:
        """Check if bridge is connected and ready."""
        return (self.controller is not None and 
                self.controller.is_ready() and
                self.current_status not in [MissionStatus.DISCONNECTED, MissionStatus.ERROR])
    
    # ==================== WAYPOINT MANAGEMENT ====================
    
    def send_mission_waypoints(self, 
                               robot_commands: Dict[str, List[Tuple[float, float]]],
                               run_after_send: Optional[bool] = None) -> MissionResult:
        """
        Send waypoints for multiple robots.
        
        This is the main integration point with the GUI. The GUI calls
        this method with waypoint data in the format it already generates.
        
        Args:
            robot_commands: Dict mapping robot color (str) to waypoints
                           Format: {'red': [(x_mm, y_mm), ...], 'green': [...]}
                           Each robot should have exactly 20 waypoints
            run_after_send: Override auto_run setting if specified
            
        Returns:
            MissionResult with operation status
        """
        # Check connection
        if not self.is_connected():
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message="Not connected to robot control system",
                errors=["Call connect() first"]
            )
        
        # Validate input
        if not robot_commands:
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message="No robot waypoints provided",
                errors=["robot_commands is empty"]
            )
        
        self._update_status(
            MissionStatus.SENDING_WAYPOINTS,
            f"Sending waypoints for {len(robot_commands)} robot(s)..."
        )
        
        errors = []
        processed_count = 0
        self.loaded_robots.clear()
        
        # Send waypoints to each robot
        for robot_color, waypoints in robot_commands.items():
            try:
                # Validate color
                color_lower = robot_color.lower()
                
                # Validate waypoint count
                if len(waypoints) != ControllerConfig.MAX_WAYPOINTS:
                    self.logger.warning(
                        f"{robot_color}: Expected {ControllerConfig.MAX_WAYPOINTS} waypoints, "
                        f"got {len(waypoints)} - will pad/truncate"
                    )
                
                # Send waypoints
                self._update_status(
                    MissionStatus.SENDING_WAYPOINTS,
                    f"Sending waypoints to {robot_color.upper()} robot..."
                )
                
                success = self.controller.send_waypoints(color_lower, waypoints)
                
                if success:
                    processed_count += 1
                    self.loaded_robots.append(color_lower)
                    self._update_status(
                        MissionStatus.SENDING_WAYPOINTS,
                        f"✓ {robot_color.upper()} robot waypoints loaded ({len(waypoints)} WPs)"
                    )
                else:
                    error_msg = f"Failed to send waypoints to {robot_color} robot"
                    errors.append(error_msg)
                    self.logger.error(error_msg)
                
                # Small delay between robots
                import time
                time.sleep(BridgeConfig.DELAY_BETWEEN_ROBOTS)
            
            except ValueError as e:
                error_msg = f"Invalid robot color '{robot_color}': {e}"
                errors.append(error_msg)
                self.logger.error(error_msg)
            
            except Exception as e:
                error_msg = f"Error sending waypoints to {robot_color}: {e}"
                errors.append(error_msg)
                self.logger.error(error_msg)
        
        # Determine final status
        if processed_count == 0:
            self._update_status(
                MissionStatus.ERROR,
                "✗ Failed to send waypoints to any robot"
            )
            
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message="Failed to send waypoints to any robot",
                robots_processed=0,
                errors=errors
            )
        
        elif processed_count < len(robot_commands):
            self._update_status(
                MissionStatus.WAYPOINTS_LOADED,
                f"⚠ Partial success: {processed_count}/{len(robot_commands)} robots loaded"
            )
            
            result = MissionResult(
                success=True,  # Partial success still counts as success
                status=MissionStatus.WAYPOINTS_LOADED,
                message=f"Waypoints sent to {processed_count}/{len(robot_commands)} robots",
                robots_processed=processed_count,
                errors=errors
            )
        
        else:
            self._update_status(
                MissionStatus.WAYPOINTS_LOADED,
                f"✓ All waypoints loaded ({processed_count} robots)"
            )
            
            result = MissionResult(
                success=True,
                status=MissionStatus.WAYPOINTS_LOADED,
                message=f"Waypoints successfully sent to all {processed_count} robots",
                robots_processed=processed_count
            )
        
        # Auto-run if configured
        should_run = run_after_send if run_after_send is not None else self.auto_run
        if should_run and processed_count > 0:
            import time
            time.sleep(0.5)
            run_result = self.run_all_loaded_robots()
            
            if not run_result.success:
                result.errors.extend(run_result.errors)
        
        return result
    
    def send_single_robot_waypoints(self,
                                    robot_color: str,
                                    waypoints: List[Tuple[float, float]]) -> MissionResult:
        """
        Send waypoints to a single robot.
        
        Args:
            robot_color: Robot color ('red', 'green', 'blue', 'yellow')
            waypoints: List of (x_mm, y_mm) tuples (should be 20 waypoints)
            
        Returns:
            MissionResult with operation status
        """
        return self.send_mission_waypoints({robot_color: waypoints}, run_after_send=False)
    
    # ==================== MISSION EXECUTION ====================
    
    def run_all_loaded_robots(self) -> MissionResult:
        """
        Send RUN command to all robots with loaded waypoints.
        
        Returns:
            MissionResult with execution status
        """
        if not self.is_connected():
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message="Not connected to robot control system",
                errors=["Call connect() first"]
            )
        
        if not self.loaded_robots:
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message="No robots have waypoints loaded",
                errors=["Send waypoints first using send_mission_waypoints()"]
            )
        
        self._update_status(
            MissionStatus.RUNNING,
            f"Starting mission for {len(self.loaded_robots)} robot(s)..."
        )
        
        errors = []
        run_count = 0
        
        for robot_color in self.loaded_robots:
            try:
                if self.controller.run_mission(robot_color):
                    run_count += 1
                    self._update_status(
                        MissionStatus.RUNNING,
                        f"✓ {robot_color.upper()} robot mission started"
                    )
                else:
                    error_msg = f"Failed to start mission for {robot_color} robot"
                    errors.append(error_msg)
                    self.logger.error(error_msg)
                
                # Small delay between commands
                import time
                time.sleep(0.2)
            
            except Exception as e:
                error_msg = f"Error starting mission for {robot_color}: {e}"
                errors.append(error_msg)
                self.logger.error(error_msg)
        
        if run_count == 0:
            self._update_status(
                MissionStatus.ERROR,
                "✗ Failed to start mission for any robot"
            )
            
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message="Failed to start mission for any robot",
                robots_processed=0,
                errors=errors
            )
        
        else:
            self._update_status(
                MissionStatus.RUNNING,
                f"✓ Mission running ({run_count} robots)"
            )
            
            return MissionResult(
                success=True,
                status=MissionStatus.RUNNING,
                message=f"Mission started for {run_count} robot(s)",
                robots_processed=run_count,
                errors=errors
            )
    
    def run_single_robot(self, robot_color: str) -> MissionResult:
        """
        Send RUN command to a single robot.
        
        Args:
            robot_color: Robot color ('red', 'green', 'blue', 'yellow')
            
        Returns:
            MissionResult with execution status
        """
        if not self.is_connected():
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message="Not connected to robot control system"
            )
        
        try:
            color_lower = robot_color.lower()
            
            if self.controller.run_mission(color_lower):
                self._update_status(
                    MissionStatus.RUNNING,
                    f"✓ {robot_color.upper()} robot mission started"
                )
                
                return MissionResult(
                    success=True,
                    status=MissionStatus.RUNNING,
                    message=f"{robot_color.upper()} robot mission started",
                    robots_processed=1
                )
            else:
                return MissionResult(
                    success=False,
                    status=MissionStatus.ERROR,
                    message=f"Failed to start mission for {robot_color} robot",
                    errors=["RUN command failed"]
                )
        
        except Exception as e:
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message=f"Error starting mission: {e}",
                errors=[str(e)]
            )
    
    def stop_all_robots(self) -> MissionResult:
        """
        Send STOP command to all robots.
        
        Returns:
            MissionResult with operation status
        """
        if not self.is_connected():
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message="Not connected to robot control system"
            )
        
        try:
            if self.controller.stop_all_robots():
                self._update_status(
                    MissionStatus.IDLE,
                    "✓ All robots stopped"
                )
                
                return MissionResult(
                    success=True,
                    status=MissionStatus.IDLE,
                    message="All robots stopped"
                )
            else:
                return MissionResult(
                    success=False,
                    status=MissionStatus.ERROR,
                    message="Failed to stop robots",
                    errors=["STOP command failed"]
                )
        
        except Exception as e:
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message=f"Error stopping robots: {e}",
                errors=[str(e)]
            )
    
    def stop_single_robot(self, robot_color: str) -> MissionResult:
        """
        Send STOP command to a single robot.
        
        Args:
            robot_color: Robot color ('red', 'green', 'blue', 'yellow')
            
        Returns:
            MissionResult with operation status
        """
        if not self.is_connected():
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message="Not connected to robot control system"
            )
        
        try:
            color_lower = robot_color.lower()
            
            if self.controller.stop_robot(color_lower):
                self._update_status(
                    MissionStatus.IDLE,
                    f"✓ {robot_color.upper()} robot stopped"
                )
                
                return MissionResult(
                    success=True,
                    status=MissionStatus.IDLE,
                    message=f"{robot_color.upper()} robot stopped"
                )
            else:
                return MissionResult(
                    success=False,
                    status=MissionStatus.ERROR,
                    message=f"Failed to stop {robot_color} robot",
                    errors=["STOP command failed"]
                )
        
        except Exception as e:
            return MissionResult(
                success=False,
                status=MissionStatus.ERROR,
                message=f"Error stopping robot: {e}",
                errors=[str(e)]
            )
    
    # ==================== STATUS QUERIES ====================
    
    def get_status(self) -> MissionStatus:
        """Get current bridge status."""
        return self.current_status
    
    def get_loaded_robots(self) -> List[str]:
        """Get list of robot colors with waypoints loaded."""
        return self.loaded_robots.copy()
    
    def get_connection_info(self) -> Dict[str, any]:
        """Get connection information."""
        return {
            'connected': self.is_connected(),
            'port': self.port,
            'baud_rate': self.baud_rate,
            'status': self.current_status.value,
            'loaded_robots': self.loaded_robots,
            'controller_ready': self.controller.is_ready() if self.controller else False
        }


# ==================== CONVENIENCE FUNCTION ====================

def create_bridge(port: str = BridgeConfig.DEFAULT_PORT,
                 baud_rate: int = BridgeConfig.DEFAULT_BAUD,
                 status_callback: Optional[Callable[[str], None]] = None,
                 auto_connect: bool = True) -> Optional[RobotBridge]:
    """
    Factory function to create and optionally connect a RobotBridge.
    
    Args:
        port: Serial port name
        baud_rate: Serial baud rate
        status_callback: Optional callback for status messages
        auto_connect: Automatically connect on creation
        
    Returns:
        RobotBridge instance (connected if auto_connect=True), or None on failure
    """
    bridge = RobotBridge(
        port=port,
        baud_rate=baud_rate,
        status_callback=status_callback
    )
    
    if auto_connect:
        result = bridge.connect()
        if not result.success:
            return None
    
    return bridge


# ==================== DEMO/TEST CODE ====================

if __name__ == "__main__":
    """
    Demo: Send waypoints from GUI format and execute mission.
    """
    
    print("="*60)
    print("GUI Robot Bridge - Demo Test")
    print("="*60)
    
    # Create bridge with status callback
    def status_callback(msg: str):
        print(f"[BRIDGE] {msg}")
    
    bridge = create_bridge(status_callback=status_callback, auto_connect=True)
    
    if not bridge:
        print("Failed to create/connect bridge. Exiting.")
        import sys
        sys.exit(1)
    
    try:
        # Example waypoints in GUI format (millimeters)
        # This matches the format produced by robot_path_planner.py
        
        waypoints_red = []
        waypoints_green = []
        
        # Red robot: Rectangle path
        x_min, y_min = -500.0, -500.0
        x_max, y_max = 500.0, 500.0
        x_mid, y_mid = 0.0, 0.0
        
        red_distinct = [
            (x_min, y_min), (x_min, y_mid), (x_min, y_max), (x_mid, y_max),
            (x_max, y_max), (x_max, y_mid), (x_max, y_min), (x_mid, y_min)
        ]
        waypoints_red.extend(red_distinct)
        waypoints_red.extend([red_distinct[-1]] * (20 - len(red_distinct)))
        
        # Green robot: Mirrored path
        green_distinct = [
            (x_max, y_min), (x_max, y_mid), (x_max, y_max), (x_mid, y_max),
            (x_min, y_max), (x_min, y_mid), (x_min, y_min), (x_mid, y_min)
        ]
        waypoints_green.extend(green_distinct)
        waypoints_green.extend([green_distinct[-1]] * (20 - len(green_distinct)))
        
        # Build robot_commands dict (GUI format)
        robot_commands = {
            'red': waypoints_red,
            'green': waypoints_green
        }
        
        print(f"\n{'='*60}")
        print("Sending waypoints for 2 robots...")
        print(f"{'='*60}\n")
        
        # Send waypoints (main integration point)
        result = bridge.send_mission_waypoints(robot_commands, run_after_send=False)
        
        if result.success:
            print(f"\n✓ {result.message}")
            print(f"  Robots processed: {result.robots_processed}")
            
            if result.errors:
                print(f"  Warnings: {len(result.errors)}")
                for error in result.errors:
                    print(f"    - {error}")
            
            # Wait a moment
            import time
            time.sleep(1)
            
            # Run mission
            print(f"\n{'='*60}")
            print("Starting mission execution...")
            print(f"{'='*60}\n")
            
            run_result = bridge.run_all_loaded_robots()
            
            if run_result.success:
                print(f"\n✓ {run_result.message}")
                print(f"  Robots running: {run_result.robots_processed}")
                
                # Let mission run
                print("\nMission running... (waiting 10 seconds)")
                time.sleep(10)
                
                # Stop all robots
                print("\nStopping all robots...")
                stop_result = bridge.stop_all_robots()
                print(f"✓ {stop_result.message}")
            else:
                print(f"\n✗ {run_result.message}")
                for error in run_result.errors:
                    print(f"  - {error}")
        else:
            print(f"\n✗ {result.message}")
            for error in result.errors:
                print(f"  - {error}")
    
    except KeyboardInterrupt:
        print("\n\nInterrupted by user")
        bridge.stop_all_robots()
    
    finally:
        print("\nDisconnecting...")
        bridge.disconnect()
        print("✓ Demo complete")
