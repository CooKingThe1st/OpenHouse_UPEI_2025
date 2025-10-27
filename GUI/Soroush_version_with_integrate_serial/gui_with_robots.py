"""
GUI with Robot Control - Complete Integration Example
=====================================================

This script demonstrates how to integrate the robot_path_planner GUI
with the robot control system with ZERO modifications to the GUI code.

It works by:
1. Intercepting the waypoint data after GUI generates it
2. Sending it to robots via the bridge
3. Providing user controls for robot connection/execution

Usage:
    python gui_with_robots.py

Features:
- "Connect Robots" button added to GUI
- Automatic waypoint transmission
- Mission execution control
- Real-time robot status
- Emergency stop capability

Author: Production System
Date: 2025-10-25
"""

import sys
from typing import Dict, List, Tuple

from PyQt5.QtWidgets import (
    QApplication, QPushButton, QMessageBox, QInputDialog
)
from PyQt5.QtCore import QTimer
from PyQt5.QtGui import QFont

# Import original GUI
from robot_path_planner import MultiRobotGUI

# Import robot bridge
from gui_robot_bridge import RobotBridge, MissionStatus, create_bridge


class RobotEnabledGUI(MultiRobotGUI):
    """
    Extended GUI with robot control capabilities.
    
    Extends the original GUI by adding robot communication features
    without modifying the core GUI code.
    """
    
    def __init__(self):
        """Initialize GUI with robot control."""
        super().__init__()
        
        # Robot bridge
        self.robot_bridge: RobotBridge = None
        self.robot_connected = False
        
        # Add robot control UI
        self._add_robot_controls()
        
        # Update window title
        self.setWindowTitle("Multi-Robot Path Planner - Robot Control Enabled")
    
    def _add_robot_controls(self):
        """Add robot control buttons to existing GUI."""
        # Find the path operations group (where Send to Robots button is)
        path_ops_group = None
        for widget in self.findChildren(type(self.send_btn.parent())):
            if widget.title() == "Path Operations":
                path_ops_group = widget
                break
        
        if not path_ops_group:
            return
        
        # Get the layout
        layout = path_ops_group.layout()
        
        # Insert robot controls before the "Send to Robots" button
        # We'll add them at the beginning of the layout
        
        # Connection button
        self.connect_robots_btn = QPushButton("🔌 Connect to Robots")
        self.connect_robots_btn.setMinimumHeight(72)
        self.connect_robots_btn.setFont(QFont("Inter", 32, QFont.DemiBold))
        self.connect_robots_btn.setStyleSheet("""
            QPushButton {
                background-color: #2563EB; /* blue */
                color: white;
                border: none;
                border-radius: 8px;
                padding: 12px 18px;
                font-weight: 600;
            }
            QPushButton:hover {
                background-color: #1D4ED8;
            }
            QPushButton:pressed {
                background-color: #1E40AF;
            }
            QPushButton:disabled {
                background-color: #E0E0E0;
                color: #9E9E9E;
            }
        """)
        self.connect_robots_btn.clicked.connect(self._connect_robots)
        layout.insertWidget(0, self.connect_robots_btn)
        
        # Execute mission button (initially hidden)
        self.execute_mission_btn = QPushButton("▶ Execute Mission")
        self.execute_mission_btn.setMinimumHeight(72)
        self.execute_mission_btn.setFont(QFont("Inter", 32, QFont.DemiBold))
        self.execute_mission_btn.setEnabled(False)
        self.execute_mission_btn.setVisible(False)
        self.execute_mission_btn.setStyleSheet("""
            QPushButton {
                background-color: #059669; /* green */
                color: white;
                border: none;
                border-radius: 8px;
                padding: 12px 18px;
                font-weight: 700;
            }
            QPushButton:hover:enabled {
                background-color: #047857;
            }
            QPushButton:pressed:enabled {
                background-color: #065F46;
            }
            QPushButton:disabled {
                background-color: #E0E0E0;
                color: #9E9E9E;
            }
        """)
        self.execute_mission_btn.clicked.connect(self._execute_mission)
        layout.insertWidget(1, self.execute_mission_btn)
        
        # Emergency stop button (initially hidden)
        self.emergency_stop_btn = QPushButton("⚠ EMERGENCY STOP")
        self.emergency_stop_btn.setMinimumHeight(72)
        self.emergency_stop_btn.setFont(QFont("Inter", 32, QFont.Bold))
        self.emergency_stop_btn.setEnabled(False)
        self.emergency_stop_btn.setVisible(False)
        self.emergency_stop_btn.setStyleSheet("""
            QPushButton {
                background-color: #DC2626; /* red */
                color: white;
                border: none;
                border-radius: 8px;
                padding: 12px 18px;
                font-weight: 700;
            }
            QPushButton:hover:enabled {
                background-color: #B91C1C;
            }
            QPushButton:pressed:enabled {
                background-color: #991B1B;
            }
        """)
        self.emergency_stop_btn.clicked.connect(self._emergency_stop)
        layout.insertWidget(2, self.emergency_stop_btn)
    
    def _connect_robots(self):
        """Connect to robot control system."""
        if self.robot_connected:
            # Already connected, offer to disconnect
            reply = QMessageBox.question(
                self,
                "Disconnect Robots?",
                "Robots are currently connected. Disconnect?",
                QMessageBox.Yes | QMessageBox.No
            )
            
            if reply == QMessageBox.Yes:
                self._disconnect_robots()
            return
        
        # Ask for serial port
        port, ok = QInputDialog.getText(
            self,
            "Serial Port Configuration",
            "Enter serial port (e.g., COM5, /dev/ttyUSB0):",
            text="COM5"
        )
        
        if not ok or not port:
            return
        
        self.log("=== Connecting to Robots ===")
        self.status_label.setText("Connecting to robot control system...")
        
        # Create status callback
        def status_callback(msg: str):
            self.log(msg)
        
        # Create and connect bridge
        self.robot_bridge = create_bridge(
            port=port.strip(),
            status_callback=status_callback,
            auto_connect=True
        )
        
        if self.robot_bridge:
            self.robot_connected = True
            
            # Update UI
            self.connect_robots_btn.setText("🔌 Disconnect Robots")
            self.connect_robots_btn.setStyleSheet("""
                QPushButton {
                    background-color: #DC2626;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    padding: 12px 18px;
                    font-weight: 600;
                }
                QPushButton:hover {
                    background-color: #B91C1C;
                }
            """)
            
            self.execute_mission_btn.setVisible(True)
            self.emergency_stop_btn.setVisible(True)
            self.emergency_stop_btn.setEnabled(True)
            
            self.log(f"✓ Connected to robots on {port}")
            self.status_label.setText(f"✓ Robots connected on {port}. Draw paths and set waypoints!")
            
            QMessageBox.information(
                self,
                "Robots Connected",
                f"✓ Successfully connected to robot control system on {port}!\n\n"
                "You can now:\n"
                "1. Draw paths for your robots\n"
                "2. Click 'Set Waypoints' to optimize paths\n"
                "3. Waypoints will automatically be sent to robots\n"
                "4. Click 'Execute Mission' to start the robots"
            )
        else:
            self.log(f"✗ Failed to connect to robots on {port}")
            self.status_label.setText(f"✗ Connection failed. Check port and try again.")
            
            QMessageBox.critical(
                self,
                "Connection Failed",
                f"Failed to connect to robot control system on {port}.\n\n"
                "Possible causes:\n"
                "• Port doesn't exist or is incorrect\n"
                "• Port is already in use\n"
                "• Hardware not connected\n\n"
                "Please check your configuration and try again."
            )
    
    def _disconnect_robots(self):
        """Disconnect from robot control system."""
        if self.robot_bridge:
            self.robot_bridge.disconnect()
            self.robot_bridge = None
        
        self.robot_connected = False
        
        # Update UI
        self.connect_robots_btn.setText("🔌 Connect to Robots")
        self.connect_robots_btn.setStyleSheet("""
            QPushButton {
                background-color: #2563EB;
                color: white;
                border: none;
                border-radius: 8px;
                padding: 12px 18px;
                font-weight: 600;
            }
            QPushButton:hover {
                background-color: #1D4ED8;
            }
        """)
        
        self.execute_mission_btn.setVisible(False)
        self.emergency_stop_btn.setVisible(False)
        
        self.log("✓ Disconnected from robots")
        self.status_label.setText("Disconnected from robots. Click 'Connect to Robots' to reconnect.")
    
    def _execute_mission(self):
        """Execute the loaded mission on robots."""
        if not self.robot_connected or not self.robot_bridge:
            QMessageBox.warning(
                self,
                "Not Connected",
                "Please connect to robots first!"
            )
            return
        
        # Check if waypoints are loaded
        loaded_robots = self.robot_bridge.get_loaded_robots()
        if not loaded_robots:
            QMessageBox.warning(
                self,
                "No Waypoints",
                "No waypoints have been sent to robots yet.\n\n"
                "Please:\n"
                "1. Draw paths for your robots\n"
                "2. Click 'Set Waypoints'\n"
                "3. Then try executing the mission"
            )
            return
        
        # Confirm execution
        robot_list = ", ".join([r.upper() for r in loaded_robots])
        reply = QMessageBox.question(
            self,
            "Execute Mission?",
            f"Start mission execution for {len(loaded_robots)} robot(s)?\n\n"
            f"Robots: {robot_list}\n\n"
            "The robots will start moving according to their waypoints.",
            QMessageBox.Yes | QMessageBox.No
        )
        
        if reply == QMessageBox.No:
            return
        
        self.log("=== Executing Mission ===")
        self.status_label.setText("Starting mission execution...")
        
        # Execute
        result = self.robot_bridge.run_all_loaded_robots()
        
        if result.success:
            self.log(f"✓ Mission started for {result.robots_processed} robot(s)")
            self.status_label.setText(f"✓ Mission running ({result.robots_processed} robots)")
            
            # Disable execute button during mission
            self.execute_mission_btn.setEnabled(False)
            
            # Re-enable after a delay (simple approach)
            QTimer.singleShot(5000, lambda: self.execute_mission_btn.setEnabled(True))
            
            QMessageBox.information(
                self,
                "Mission Started",
                f"✓ Mission execution started!\n\n"
                f"Robots active: {result.robots_processed}\n\n"
                "Use 'Emergency Stop' if needed."
            )
        else:
            self.log(f"✗ Mission execution failed: {result.message}")
            for error in result.errors:
                self.log(f"  - {error}")
            
            self.status_label.setText("✗ Mission execution failed")
            
            QMessageBox.critical(
                self,
                "Execution Failed",
                f"Failed to start mission execution.\n\n"
                f"Error: {result.message}\n\n"
                f"Check the log for details."
            )
    
    def _emergency_stop(self):
        """Emergency stop all robots."""
        if not self.robot_connected or not self.robot_bridge:
            return
        
        self.log("=== EMERGENCY STOP ===")
        self.status_label.setText("⚠ Stopping all robots...")
        
        result = self.robot_bridge.stop_all_robots()
        
        if result.success:
            self.log("✓ All robots stopped")
            self.status_label.setText("✓ All robots stopped (EMERGENCY STOP)")
            self.execute_mission_btn.setEnabled(True)
        else:
            self.log(f"✗ Stop failed: {result.message}")
            self.status_label.setText("✗ Emergency stop failed")
    
    def send_to_robots(self):
        """
        Override parent method to send waypoints to robots.
        
        This sends the already-optimized waypoints to the connected robots.
        """
        # If robots are connected and waypoints exist, send them
        if self.robot_connected and self.robot_bridge and self.canvas.optimized_paths:
            self._send_waypoints_to_robots()
        elif not self.robot_connected:
            QMessageBox.warning(
                self,
                "Not Connected",
                "Please connect to robots first!\n\n"
                "Click 'Connect to Robots' button to establish connection."
            )
        elif not self.canvas.optimized_paths:
            QMessageBox.warning(
                self,
                "No Waypoints",
                "No waypoints have been set yet.\n\n"
                "Please:\n"
                "1. Draw paths for your robots\n"
                "2. Click 'Set Waypoints' to optimize paths\n"
                "3. Then click 'Send to Robots'"
            )
    
    def _send_waypoints_to_robots(self):
        """Send optimized waypoints to connected robots."""
        self.log("\n=== Sending Waypoints to Robots ===")
        self.status_label.setText("Sending waypoints to robots...")
        
        # Convert waypoints to robot format (already in mm from GUI)
        robot_commands = {}
        
        for robot in self.current_mission.robots:
            color_key = robot.color.value
            if color_key not in self.canvas.optimized_paths:
                continue
            
            # Get waypoints in canvas coordinates
            waypoints_canvas = self.canvas.optimized_paths[color_key]
            
            # Convert to real-world coordinates (mm)
            waypoints_real = self.coord_converter.path_canvas_to_real(waypoints_canvas)
            
            # Ensure exact start/end positions
            start_real = self.coord_converter.canvas_to_real(*robot.start_pos)
            end_real = self.coord_converter.canvas_to_real(*robot.end_pos)
            
            if waypoints_real:
                waypoints_real[0] = start_real
            
            # Find and replace padded waypoints with exact end
            if len(waypoints_real) > 1:
                last_unique_idx = len(waypoints_real) - 1
                for i in range(len(waypoints_real) - 2, -1, -1):
                    if waypoints_real[i] != waypoints_real[i + 1]:
                        last_unique_idx = i + 1
                        break
                
                for i in range(last_unique_idx, len(waypoints_real)):
                    waypoints_real[i] = end_real
            
            robot_commands[color_key] = waypoints_real
        
        # Send to robots
        result = self.robot_bridge.send_mission_waypoints(
            robot_commands,
            run_after_send=False  # Manual control
        )
        
        if result.success:
            self.log(f"\n✓ Waypoints sent to {result.robots_processed} robot(s)")
            self.status_label.setText(f"✓ Waypoints loaded on robots. Ready to execute!")
            
            # Enable execute button
            self.execute_mission_btn.setEnabled(True)
            
            # Show summary
            summary = []
            for color in robot_commands.keys():
                summary.append(f"• {color.upper()}: 20 waypoints")
            
            QMessageBox.information(
                self,
                "Waypoints Sent to Robots",
                f"✓ Waypoints successfully sent to {result.robots_processed} robot(s)!\n\n"
                + "\n".join(summary) + "\n\n"
                "The robots are now ready to execute the mission.\n"
                "Click 'Execute Mission' to start."
            )
        else:
            self.log(f"\n✗ Failed to send waypoints: {result.message}")
            for error in result.errors:
                self.log(f"  - {error}")
            
            self.status_label.setText("✗ Failed to send waypoints to robots")
            
            QMessageBox.warning(
                self,
                "Waypoint Transmission Failed",
                f"Failed to send waypoints to robots.\n\n"
                f"Error: {result.message}\n\n"
                "Check the log for details."
            )
    
    def closeEvent(self, event):
        """Handle window close - disconnect robots."""
        if self.robot_connected:
            reply = QMessageBox.question(
                self,
                "Disconnect Robots?",
                "Robots are still connected. Disconnect before closing?",
                QMessageBox.Yes | QMessageBox.No | QMessageBox.Cancel
            )
            
            if reply == QMessageBox.Cancel:
                event.ignore()
                return
            elif reply == QMessageBox.Yes:
                self._disconnect_robots()
        
        # Call parent close event
        super().closeEvent(event)


def main():
    """Main entry point for robot-enabled GUI."""
    app = QApplication(sys.argv)
    app.setStyle('Fusion')
    
    # Create and show robot-enabled GUI
    window = RobotEnabledGUI()
    window.show()
    
    sys.exit(app.exec_())


if __name__ == "__main__":
    main()
