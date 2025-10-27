"""
Multi-Robot Path Planning GUI
Production-level interface for student robotics education.
"""

import sys
from typing import Dict, List, Tuple, Optional
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QPushButton, QLabel, QComboBox, QGraphicsView, QGraphicsScene,
    QMessageBox, QGroupBox, QTextEdit, QSplitter, QFrame, QToolTip,
    QScrollArea, QSizePolicy
)
from PyQt5.QtCore import Qt, QPointF, QRectF, QTimer, QSize
from PyQt5.QtGui import (
    QPainter, QColor, QPen, QBrush, QFont, QPainterPath, QPolygonF, QPalette
)

from mission_config import MissionManager, RobotColor, RobotConfig
from path_optimizer import PathInterpolator, WaypointOptimizer, CoordinateConverter
from path_validator import PathValidator


class RobotPathCanvas(QGraphicsView):
    """
    Interactive canvas for drawing robot paths with modern, responsive design.
    """
    
    def __init__(self, parent, width: int = 800, height: int = 800):
        super().__init__(parent)
        self.parent_window = parent
        self.base_width = width
        self.base_height = height
        self.canvas_width = width
        self.canvas_height = height
        
        # Setup scene
        self.scene = QGraphicsScene()
        self.setScene(self.scene)
        self.setSceneRect(0, 0, width, height)
        self.setRenderHint(QPainter.Antialiasing)
        self.setRenderHint(QPainter.SmoothPixmapTransform)
        self.setRenderHint(QPainter.TextAntialiasing)
        
        # Drawing state
        self.current_robot: Optional[RobotColor] = None
        self.drawing = False
        self.drawn_paths: Dict[str, List[Tuple[float, float]]] = {}
        self.optimized_paths: Dict[str, List[Tuple[float, float]]] = {}
        self.waypoints_visible = False
        
        # Mission data
        self.mission_config = None
        
        # Setup canvas with modern styling - responsive sizing
        # Lower the minimum size so smaller screens aren't clipped
        self.setMinimumSize(300, 300)
        self.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        self.setStyleSheet("""
            QGraphicsView {
                border: 2px solid #D0D5DD;
                background-color: #FAFBFC;
                border-radius: 8px;
            }
            QGraphicsView:focus {
                border: 2px solid #004A82;
            }
        """)
        
        # Enable viewport updates for smooth resizing
        self.setViewportUpdateMode(QGraphicsView.FullViewportUpdate)
        self.setHorizontalScrollBarPolicy(Qt.ScrollBarAlwaysOff)
        self.setVerticalScrollBarPolicy(Qt.ScrollBarAlwaysOff)
    
    def resizeEvent(self, event):
        """Handle resize to keep canvas content centered and scaled."""
        super().resizeEvent(event)
        if self.scene:
            # Always fit the full scene in view so the canvas scales with window size
            self.fitInView(self.sceneRect(), Qt.KeepAspectRatio)
    
    def load_mission(self, mission_config):
        """Load a new mission configuration."""
        self.mission_config = mission_config
        self.clear_all_paths()
        self.draw_mission()
    
    def set_drawing_robot(self, robot_color: Optional[RobotColor]):
        """Set which robot to draw paths for."""
        self.current_robot = robot_color
        if robot_color:
            robot = self.mission_config.get_robot_by_color(robot_color)
            if robot:
                self.parent_window.status_label.setText(
                    f"✏️ Drawing mode: {robot.display_name} | "
                    f"Click and drag from START ({int(robot.start_pos[0])}, {int(robot.start_pos[1])}) "
                    f"to END ({int(robot.end_pos[0])}, {int(robot.end_pos[1])})"
                )
    
    def clear_path(self, robot_color: RobotColor):
        """Clear path for specific robot."""
        color_key = robot_color.value
        if color_key in self.drawn_paths:
            del self.drawn_paths[color_key]
        if color_key in self.optimized_paths:
            del self.optimized_paths[color_key]
        self.waypoints_visible = False
        self.draw_mission()
    
    def clear_all_paths(self):
        """Clear all drawn paths."""
        self.drawn_paths.clear()
        self.optimized_paths.clear()
        self.waypoints_visible = False
        if self.mission_config:
            self.draw_mission()
    
    def draw_mission(self):
        """Draw the mission layout with robots and paths."""
        self.scene.clear()
        
        if not self.mission_config:
            return
        
        # Draw grid
        self._draw_grid()
        
        # Draw border
        border_pen = QPen(QColor("#0B1220"), 3)
        self.scene.addRect(0, 0, self.canvas_width, self.canvas_height, border_pen)
        
        # Draw paths (drawn paths as translucent, optimized as solid)
        self._draw_all_paths()
        
        # Draw robot start/end markers
        for robot in self.mission_config.robots:
            self._draw_robot_markers(robot)
    
    def _draw_grid(self):
        """Draw subtle grid lines."""
        grid_pen = QPen(QColor("#E5E7EB"), 1, Qt.DotLine)
        spacing = 100
        
        # Vertical lines
        for x in range(0, self.canvas_width + 1, spacing):
            self.scene.addLine(x, 0, x, self.canvas_height, grid_pen)
        
        # Horizontal lines
        for y in range(0, self.canvas_height + 1, spacing):
            self.scene.addLine(0, y, self.canvas_width, y, grid_pen)
    
    def _draw_robot_markers(self, robot: RobotConfig):
        """Draw modern start and end markers for a robot."""
        # Use app palette override for robot colors when available
        hex_color = self.parent_window.get_robot_hex(robot.color) if self.parent_window else robot.hex_color
        color = QColor(hex_color)
        
        # Start marker - Modern circle with shadow effect
        start_x, start_y = robot.start_pos
        
        # Shadow for start
        shadow_brush = QBrush(QColor(0, 0, 0, 40))
        self.scene.addEllipse(start_x - 18, start_y - 16, 36, 36, QPen(Qt.NoPen), shadow_brush)
        
        # Outer ring
        outer_pen = QPen(color.darker(120), 4)
        self.scene.addEllipse(start_x - 20, start_y - 20, 40, 40, outer_pen, QBrush(Qt.white))
        
        # Inner circle
        inner_brush = QBrush(color)
        self.scene.addEllipse(start_x - 15, start_y - 15, 30, 30, QPen(Qt.NoPen), inner_brush)
        
        # Start label - positioned above the marker
        start_text = self.scene.addText("START", QFont("Segoe UI, Inter", 7, QFont.Bold))
        start_text.setDefaultTextColor(Qt.black)
        text_rect = start_text.boundingRect()
        start_text.setPos(start_x - text_rect.width() / 2, start_y - 20 - text_rect.height())
        
        # End marker - Modern square with rounded corners
        end_x, end_y = robot.end_pos
        
        # Shadow for end
        self.scene.addRect(end_x - 18, end_y - 16, 36, 36, QPen(Qt.NoPen), shadow_brush)
        
        # Outer square with rounded corners
        outer_rect_pen = QPen(color.darker(120), 4)
        outer_rect = self.scene.addRect(end_x - 20, end_y - 20, 40, 40, outer_rect_pen, QBrush(Qt.white))
        
        # Inner square
        inner_rect_brush = QBrush(color)
        self.scene.addRect(end_x - 15, end_y - 15, 30, 30, QPen(Qt.NoPen), inner_rect_brush)
        
        # End label - positioned above the marker
        end_text = self.scene.addText("END", QFont("Segoe UI, Inter", 7, QFont.Bold))
        end_text.setDefaultTextColor(Qt.black)
        text_rect = end_text.boundingRect()
        end_text.setPos(end_x - text_rect.width() / 2, end_y - 20 - text_rect.height())
    
    def _draw_all_paths(self):
        """Draw all robot paths."""
        for robot in self.mission_config.robots:
            color_key = robot.color.value
            
            # Draw user-drawn path (translucent)
            if color_key in self.drawn_paths:
                path = self.drawn_paths[color_key]
                hex_color = self.parent_window.get_robot_hex(robot.color) if self.parent_window else robot.hex_color
                self._draw_path(path, hex_color, alpha=80, width=4, style=Qt.DashLine)
            
            # Draw optimized path with waypoints (solid)
            if self.waypoints_visible and color_key in self.optimized_paths:
                waypoints = self.optimized_paths[color_key]
                self._draw_path(waypoints, hex_color, alpha=255, width=5, style=Qt.SolidLine)
                self._draw_waypoint_markers(waypoints, hex_color)
    
    def _draw_path(self, path: List[Tuple[float, float]], hex_color: str, 
                   alpha: int = 255, width: int = 4, style=Qt.SolidLine):
        """Draw a path on the canvas."""
        if len(path) < 2:
            return
        
        color = QColor(hex_color)
        color.setAlpha(alpha)
        pen = QPen(color, width, style, Qt.RoundCap, Qt.RoundJoin)
        
        painter_path = QPainterPath()
        painter_path.moveTo(path[0][0], path[0][1])
        
        for x, y in path[1:]:
            painter_path.lineTo(x, y)
        
        self.scene.addPath(painter_path, pen)
    
    def _draw_waypoint_markers(self, waypoints: List[Tuple[float, float]], hex_color: str):
        """Draw numbered waypoint markers."""
        color = QColor(hex_color)
        
        for i, (x, y) in enumerate(waypoints):
            # Skip duplicate endpoints at the end
            if i > 0 and (x, y) == waypoints[-1] and i < len(waypoints) - 1:
                continue
            
            # Waypoint circle - BIGGER for better visibility
            wp_brush = QBrush(color)
            wp_pen = QPen(Qt.white, 3)
            self.scene.addEllipse(x - 18, y - 18, 36, 36, wp_pen, wp_brush)
            
            # Waypoint number - BLACK text for readability, bigger font
            wp_text = self.scene.addText(str(i + 1), QFont("Inter", 8, QFont.Bold))
            wp_text.setDefaultTextColor(Qt.black)
            
            # Center text
            text_width = wp_text.boundingRect().width()
            text_height = wp_text.boundingRect().height()
            wp_text.setPos(x - text_width / 2, y - text_height / 2)
    
    def mousePressEvent(self, event):
        """Handle mouse press for starting path drawing."""
        if event.button() == Qt.LeftButton and self.current_robot:
            scene_pos = self.mapToScene(event.pos())
            x, y = scene_pos.x(), scene_pos.y()
            
            # Check if within bounds
            if 0 <= x <= self.canvas_width and 0 <= y <= self.canvas_height:
                self.drawing = True
                color_key = self.current_robot.value
                self.drawn_paths[color_key] = [(x, y)]
                # Clear optimized path when starting new drawing
                if color_key in self.optimized_paths:
                    del self.optimized_paths[color_key]
                self.waypoints_visible = False
    
    def mouseMoveEvent(self, event):
        """Handle mouse move for drawing path."""
        if self.drawing and self.current_robot:
            scene_pos = self.mapToScene(event.pos())
            x, y = scene_pos.x(), scene_pos.y()
            
            # Clamp to bounds
            x = max(0, min(self.canvas_width, x))
            y = max(0, min(self.canvas_height, y))
            
            color_key = self.current_robot.value
            self.drawn_paths[color_key].append((x, y))
            self.draw_mission()
    
    def mouseReleaseEvent(self, event):
        """Handle mouse release for ending path drawing."""
        if event.button() == Qt.LeftButton and self.drawing:
            self.drawing = False
            if self.current_robot:
                robot = self.mission_config.get_robot_by_color(self.current_robot)
                if robot:
                    self.parent_window.status_label.setText(
                        f"✓ Path drawn for {robot.display_name}. "
                        f"Select another robot or click 'Set Waypoints' to continue."
                    )


class MultiRobotGUI(QMainWindow):
    """
    Main GUI window for multi-robot path planning.
    """
    
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Multi-Robot Path Planner")
        
        # Responsive window sizing
        screen = QApplication.primaryScreen().geometry()
        window_width = min(1800, int(screen.width() * 0.9))
        window_height = min(1100, int(screen.height() * 0.9))
        
        # Center on screen
        x = (screen.width() - window_width) // 2
        y = (screen.height() - window_height) // 2
        self.setGeometry(x, y, window_width, window_height)
        
        # Set minimum size for usability (smaller to avoid clipping on modest screens)
        self.setMinimumSize(960, 640)
        
        # Initialize components
        self.mission_manager = MissionManager(canvas_width=800, canvas_height=800)
        self.path_validator = PathValidator(tolerance_pixels=30.0, min_path_length=50.0)
        # Smoothness parameter helps ignore mouse jitter and focus on actual path intent
        # Higher values = more smoothing. Range 100-500 good for hand-drawn paths.
        self.path_interpolator = PathInterpolator(smoothness=200.0)
        # RDP epsilon controls simplification: lower = more waypoints preserved, higher = more aggressive
        # 50mm is a good balance for preserving curves while simplifying straights
        self.waypoint_optimizer = WaypointOptimizer(epsilon_mm=50.0, max_waypoints=20)
        self.coord_converter = CoordinateConverter(
            canvas_width=800, canvas_height=800,
            real_width_mm=2000.0, real_height_mm=2000.0
        )
        
        # Current mission
        self.current_mission = None
        self.current_mission_id = 1

        # Robot color palette overrides (by color string value)
        # Applies app-wide consistently for buttons and drawing
        self.robot_color_palette = {
            'blue':  '#004A82',
            'red':   '#FC2D38',
            'green': '#43E67C',
            'yellow':'#FFCC00'
        }
        
        # Setup UI
        self.setup_ui()
        
        # Load first mission
        self.load_mission(1)
    
    def setup_ui(self):
        """Setup the main user interface with modern, responsive design."""
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        main_layout = QHBoxLayout(central_widget)
        # Tighter spacing and margins to reclaim horizontal space
        main_layout.setSpacing(12)
        main_layout.setContentsMargins(16, 16, 16, 16)
        
        # Left side: Canvas with modern container
        canvas_container = QVBoxLayout()
        canvas_container.setSpacing(12)
        
        # Canvas title with modern typography
        canvas_title = QLabel("Mission Canvas")
        canvas_title.setFont(QFont("Inter", 64, QFont.Bold))
        canvas_title.setStyleSheet("""
            color: #1A1A1A;
            padding: 12px 0px;
            font-weight: 700;
        """)
        canvas_container.addWidget(canvas_title)
        
        # Canvas with clean container
        canvas_frame = QFrame()
        canvas_frame.setStyleSheet("""
            QFrame {
                background: #FFFFFF;
                border-radius: 8px;
                border: 1px solid #D0D5DD;
            }
        """)
        canvas_frame_layout = QVBoxLayout(canvas_frame)
        canvas_frame_layout.setContentsMargins(12, 12, 12, 12)
        
        # Canvas
        self.canvas = RobotPathCanvas(self, width=800, height=800)
        # Let the canvas fill its container instead of centering with fixed size
        canvas_frame_layout.addWidget(self.canvas)
        
        # Canvas info bar - shows waypoint counts and helpful tips
        self.canvas_info_bar = QLabel("Ready to start! Select a robot and draw a path.")
        self.canvas_info_bar.setFont(QFont("Inter", 28))
        self.canvas_info_bar.setWordWrap(True)
        self.canvas_info_bar.setAlignment(Qt.AlignCenter)
        self.canvas_info_bar.setStyleSheet("""
            QLabel {
                background: #F0F7FF;
                color: #0B3A5B;
                padding: 12px 16px;
                border-radius: 6px;
                border: 1px solid #B3D7F5;
                font-size: 28px;
                min-height: 40px;
            }
        """)
        canvas_frame_layout.addWidget(self.canvas_info_bar)
        
        canvas_container.addWidget(canvas_frame, 1)
        
        main_layout.addLayout(canvas_container, 3)
        
        # Right side: Control panel with scrollable area
        scroll_area = QScrollArea()
        scroll_area.setWidgetResizable(True)
        scroll_area.setHorizontalScrollBarPolicy(Qt.ScrollBarAlwaysOff)
        scroll_area.setFrameShape(QFrame.NoFrame)
        scroll_area.setStyleSheet("""
            QScrollArea {
                border: none;
                background-color: transparent;
            }
            QScrollArea > QWidget > QWidget {
                background-color: transparent;
            }
        """)
        # Ensure viewport consumes full width; we'll pad inside the content instead
        scroll_area.setViewportMargins(0, 0, 0, 0)
        
        control_panel = self.create_control_panel()
        scroll_area.setWidget(control_panel)
        # Increase width significantly so buttons have plenty of room
        scroll_area.setMinimumWidth(700)
        scroll_area.setMaximumWidth(900)
        
        main_layout.addWidget(scroll_area, 1)
        
        # Apply global stylesheet
        self.setStyleSheet(self.get_modern_stylesheet())
    
    def create_control_panel(self) -> QWidget:
        """Create the right-side control panel."""
        panel = QWidget()
        layout = QVBoxLayout(panel)
        layout.setSpacing(16)
        # Only left padding - let scrollbar sit naturally on the right edge
        layout.setContentsMargins(16, 0, 0, 0)
        
        # Mission Selection
        mission_group = self.create_mission_selector()
        layout.addWidget(mission_group)
        
        # Robot Selection
        robot_group = self.create_robot_selector()
        layout.addWidget(robot_group)
        self.robot_group = robot_group
        
        # Drawing Controls
        drawing_group = self.create_drawing_controls()
        layout.addWidget(drawing_group)
        
        # Path Operations
        path_ops_group = self.create_path_operations()
        layout.addWidget(path_ops_group)
        
        # Status Display
        status_group = self.create_status_display()
        layout.addWidget(status_group)
        
        layout.addStretch()
        
        return panel
    
    def create_mission_selector(self) -> QGroupBox:
        """Create mission selection controls with modern design."""
        group = QGroupBox("Mission Selection")
        group.setFont(QFont("Inter", 36, QFont.DemiBold))
        layout = QVBoxLayout()
        layout.setSpacing(14)
        layout.setContentsMargins(18, 28, 18, 18)
        
        # Mission dropdown
        self.mission_combo = QComboBox()
        self.mission_combo.setMinimumHeight(64)
        self.mission_combo.setFont(QFont("Inter", 32))
        for mission in self.mission_manager.get_all_missions():
            self.mission_combo.addItem(f"{mission.name} ({mission.difficulty})")
        self.mission_combo.currentIndexChanged.connect(self.on_mission_changed)
        layout.addWidget(self.mission_combo)
        
        # Mission description with modern card
        self.mission_desc_label = QLabel()
        self.mission_desc_label.setWordWrap(True)
        self.mission_desc_label.setFont(QFont("Inter", 30))
        self.mission_desc_label.setStyleSheet("""
            padding: 18px;
            background: #FEF3E2;
            border-radius: 8px;
            border: 2px solid #F5E7A9;
            color: #613000;
            line-height: 1.7;
        """)
        layout.addWidget(self.mission_desc_label)
        
        group.setLayout(layout)
        return group
    
    def create_robot_selector(self) -> QGroupBox:
        """Create robot selection controls with modern design."""
        group = QGroupBox("Robot Selection")
        group.setFont(QFont("Inter", 36, QFont.DemiBold))
        layout = QVBoxLayout()
        layout.setSpacing(12)
        layout.setContentsMargins(18, 28, 18, 18)
        
        self.robot_buttons = {}
        
        # Will be populated when mission loads
        self.robot_buttons_container = QVBoxLayout()
        self.robot_buttons_container.setSpacing(12)
        layout.addLayout(self.robot_buttons_container)
        
        group.setLayout(layout)
        return group
    
    def create_drawing_controls(self) -> QGroupBox:
        """Create drawing control buttons with modern design."""
        group = QGroupBox("Drawing Controls")
        group.setFont(QFont("Inter", 36, QFont.DemiBold))
        layout = QVBoxLayout()
        layout.setSpacing(12)
        layout.setContentsMargins(18, 28, 18, 18)
        
        # Clear current robot path - neutral gray (less destructive)
        self.clear_current_btn = QPushButton("Clear Current Robot")
        self.clear_current_btn.setMinimumHeight(72)
        self.clear_current_btn.setFont(QFont("Inter", 32, QFont.DemiBold))
        self.clear_current_btn.setStyleSheet("""
            QPushButton {
                background-color: #6B7280; /* neutral gray */
                color: #FFFFFF;
                border: none;
                border-radius: 8px;
                padding: 12px 18px;
                font-weight: 700;
            }
            QPushButton:hover {
                background-color: #4B5563;
            }
            QPushButton:pressed {
                background-color: #374151;
            }
        """)
        self.clear_current_btn.clicked.connect(self.clear_current_path)
        layout.addWidget(self.clear_current_btn)
        
        # Clear all paths - Warning Orange/Red
        self.clear_all_btn = QPushButton("Clear All Paths")
        self.clear_all_btn.setMinimumHeight(72)
        self.clear_all_btn.setFont(QFont("Inter", 32, QFont.DemiBold))
        self.clear_all_btn.setStyleSheet("""
            QPushButton {
                background-color: #DC2626; /* stronger red for destructive action */
                color: #FFFFFF;
                border: none;
                border-radius: 8px;
                padding: 12px 18px;
                font-weight: 600;
            }
            QPushButton:hover {
                background-color: #B91C1C;
            }
            QPushButton:pressed {
                background-color: #991B1B;
            }
        """)
        self.clear_all_btn.clicked.connect(self.clear_all_paths)
        layout.addWidget(self.clear_all_btn)
        
        group.setLayout(layout)
        return group
    
    def create_path_operations(self) -> QGroupBox:
        """Create path operation buttons with modern design."""
        group = QGroupBox("Path Operations")
        group.setFont(QFont("Inter", 36, QFont.DemiBold))
        layout = QVBoxLayout()
        layout.setSpacing(12)
        layout.setContentsMargins(18, 28, 18, 18)
        
        # Validate paths - Blue (informational/check action)
        self.validate_btn = QPushButton("Validate Paths")
        self.validate_btn.setMinimumHeight(72)
        self.validate_btn.setFont(QFont("Inter", 32, QFont.DemiBold))
        self.validate_btn.setStyleSheet("""
            QPushButton {
                background-color: #004A82; /* palette blue */
                color: white;
                border: none;
                border-radius: 8px;
                padding: 12px 18px;
                font-weight: 600;
            }
            QPushButton:hover {
                background-color: #003C69;
            }
            QPushButton:pressed {
                background-color: #002F51;
            }
        """)
        self.validate_btn.clicked.connect(self.validate_paths)
        layout.addWidget(self.validate_btn)
        
        # Set waypoints - Green (positive/continue action)
        self.set_waypoints_btn = QPushButton("Set Waypoints")
        self.set_waypoints_btn.setMinimumHeight(72)
        self.set_waypoints_btn.setFont(QFont("Inter", 32, QFont.DemiBold))
        self.set_waypoints_btn.setStyleSheet("""
            QPushButton {
                background-color: #10B981; /* success green */
                color: #FFFFFF;
                border: none;
                border-radius: 8px;
                padding: 12px 18px;
                font-weight: 600;
            }
            QPushButton:hover {
                background-color: #059669;
            }
            QPushButton:pressed {
                background-color: #047857;
            }
        """)
        self.set_waypoints_btn.clicked.connect(self.set_waypoints)
        layout.addWidget(self.set_waypoints_btn)
        
        # Send to robots - Vibrant Yellow (primary action/execute)
        self.send_btn = QPushButton("Send to Robots")
        self.send_btn.setMinimumHeight(84)
        self.send_btn.setFont(QFont("Inter", 36, QFont.Bold))
        self.send_btn.setEnabled(False)
        self.send_btn.setStyleSheet("""
            QPushButton {
                background-color: #F59E0B; /* amber/warning yellow for execute */
                color: #1F2937;
                border: none;
                border-radius: 10px;
                padding: 14px 20px;
                font-weight: 700;
            }
            QPushButton:hover:enabled {
                background-color: #D97706;
            }
            QPushButton:pressed:enabled {
                background-color: #B45309;
            }
            QPushButton:disabled {
                background-color: #E0E0E0;
                color: #9E9E9E;
            }
        """)
        self.send_btn.clicked.connect(self.send_to_robots)
        layout.addWidget(self.send_btn)
        
        group.setLayout(layout)
        return group
    
    def create_status_display(self) -> QGroupBox:
        """Create status display area with modern design."""
        group = QGroupBox("Status")
        group.setFont(QFont("Inter", 36, QFont.DemiBold))
        layout = QVBoxLayout()
        layout.setSpacing(14)
        layout.setContentsMargins(18, 28, 18, 18)
        
        # Status label (for quick messages)
        self.status_label = QLabel("Ready to start. Select a robot and draw a path!")
        self.status_label.setWordWrap(True)
        self.status_label.setFont(QFont("Inter", 30))
        self.status_label.setStyleSheet("""
            padding: 18px;
            background: #D1E9FA;
            border-radius: 8px;
            border: 2px solid #76BDEF;
            color: #0B3A5B;
            line-height: 1.7;
        """)
        layout.addWidget(self.status_label)
        
        # Detailed log
        log_label = QLabel("Detailed Log:")
        log_label.setFont(QFont("Inter", 30, QFont.Medium))
        layout.addWidget(log_label)
        
        self.log_display = QTextEdit()
        self.log_display.setReadOnly(True)
        self.log_display.setMinimumHeight(200)
        self.log_display.setMaximumHeight(280)
        self.log_display.setFont(QFont("Consolas, Courier New, monospace", 26))
        self.log_display.setStyleSheet("""
            QTextEdit {
                background-color: #263238;
                color: #E6C229;
                padding: 14px;
                border-radius: 8px;
                border: 2px solid #37474F;
                line-height: 1.7;
            }
        """)
        layout.addWidget(self.log_display)
        
        group.setLayout(layout)
        return group
    
    def load_mission(self, mission_id: int):
        """Load a mission configuration."""
        self.current_mission = self.mission_manager.get_mission(mission_id)
        self.current_mission_id = mission_id
        
        if not self.current_mission:
            return
        
        # Update UI
        self.mission_desc_label.setText(self.current_mission.description)
        self.canvas.load_mission(self.current_mission)
        
        # Update robot selection buttons
        self.update_robot_buttons()
        
        # Reset state
        self.canvas.set_drawing_robot(None)
        self.send_btn.setEnabled(False)
        
        self.log(f"✓ Loaded {self.current_mission.name}")
        self.status_label.setText(f"Mission loaded: {self.current_mission.name}. Select a robot to begin!")
    
    def update_robot_buttons(self):
        """Update robot selection buttons with modern, clean design."""
        # Clear existing buttons
        for i in reversed(range(self.robot_buttons_container.count())):
            widget = self.robot_buttons_container.itemAt(i).widget()
            if widget:
                widget.deleteLater()
        
        self.robot_buttons.clear()
        
        # Create new buttons for each robot in mission
        for robot in self.current_mission.robots:
            btn = QPushButton(robot.display_name)
            btn.setCheckable(True)
            btn.setMinimumHeight(72)
            btn.setFont(QFont("Inter", 32, QFont.DemiBold))
            
            # Modern button style with robot color - clean flat design
            hex_color = self.get_robot_hex(robot.color)
            btn.setStyleSheet(f"""
                QPushButton {{
                    background-color: {hex_color};
                    color: white;
                    font-weight: 600;
                    font-size: 32px;
                    border: 3px solid transparent;
                    border-radius: 8px;
                    padding: 12px 16px;
                    text-align: center;
                }}
                QPushButton:hover {{
                    background-color: {self.adjust_brightness(hex_color, 0.9)};
                    border: 3px solid {self.adjust_brightness(hex_color, 0.7)};
                }}
                QPushButton:pressed {{
                    background-color: {self.adjust_brightness(hex_color, 0.8)};
                }}
                QPushButton:checked {{
                    border: 4px solid #004A82;
                    background-color: {self.adjust_brightness(hex_color, 0.85)};
                    font-weight: 700;
                }}
                QPushButton:disabled {{
                    background-color: #E0E0E0;
                    color: #9E9E9E;
                    border: 3px solid #BDBDBD;
                }}
            """)
            btn.clicked.connect(lambda checked, r=robot: self.on_robot_selected(r))
            
            self.robot_buttons[robot.color] = btn
            self.robot_buttons_container.addWidget(btn)
    
    def on_mission_changed(self, index):
        """Handle mission selection change."""
        mission_id = index + 1
        if mission_id != self.current_mission_id:
            # Confirm if paths exist
            if self.canvas.drawn_paths:
                reply = QMessageBox.question(
                    self,
                    "Change Mission",
                    "Changing missions will clear all drawn paths. Continue?",
                    QMessageBox.Yes | QMessageBox.No
                )
                if reply == QMessageBox.No:
                    self.mission_combo.setCurrentIndex(self.current_mission_id - 1)
                    return
            
            self.load_mission(mission_id)
    
    def on_robot_selected(self, robot: RobotConfig):
        """Handle robot selection for drawing."""
        # Uncheck other buttons
        for color, btn in self.robot_buttons.items():
            if color != robot.color:
                btn.setChecked(False)
        
        # Set current robot
        if self.robot_buttons[robot.color].isChecked():
            self.canvas.set_drawing_robot(robot.color)
            self.log(f"Selected {robot.display_name} for drawing")
            self.canvas_info_bar.setText(f"✏ Draw path for {robot.display_name}")
            self.canvas_info_bar.setStyleSheet("""
                QLabel {
                    background: #F0F7FF;
                    color: #0B3A5B;
                    padding: 12px 16px;
                    border-radius: 6px;
                    border: 1px solid #B3D9FF;
                    font-size: 28px;
                    min-height: 40px;
                    font-weight: 600;
                }
            """)
        else:
            self.canvas.set_drawing_robot(None)
            self.status_label.setText("No robot selected. Select a robot to draw paths.")
            self.canvas_info_bar.setText("No robot selected. Click a robot button to start drawing.")
            self.canvas_info_bar.setStyleSheet("""
                QLabel {
                    background: #F0F0F0;
                    color: #666666;
                    padding: 12px 16px;
                    border-radius: 6px;
                    border: 1px solid #CCCCCC;
                    font-size: 28px;
                    min-height: 40px;
                    font-weight: 600;
                }
            """)
    
    def clear_current_path(self):
        """Clear path for currently selected robot."""
        if self.canvas.current_robot:
            robot = self.current_mission.get_robot_by_color(self.canvas.current_robot)
            self.canvas.clear_path(self.canvas.current_robot)
            self.log(f"Cleared path for {robot.display_name}")
            self.status_label.setText(f"Path cleared for {robot.display_name}")
            self.canvas_info_bar.setText(f"✏ Draw path for {robot.display_name}")
            self.canvas_info_bar.setStyleSheet("""
                QLabel {
                    background: #F0F7FF;
                    color: #0B3A5B;
                    padding: 12px 16px;
                    border-radius: 6px;
                    border: 1px solid #B3D9FF;
                    font-size: 28px;
                    min-height: 40px;
                    font-weight: 600;
                }
            """)
            self.send_btn.setEnabled(False)
        else:
            QMessageBox.warning(self, "No Robot Selected", "Please select a robot first!")
    
    def clear_all_paths(self):
        """Clear all drawn paths."""
        if not self.canvas.drawn_paths:
            QMessageBox.information(self, "No Paths", "There are no paths to clear!")
            return
        
        reply = QMessageBox.question(
            self,
            "Clear All Paths",
            "Are you sure you want to clear all paths?",
            QMessageBox.Yes | QMessageBox.No
        )
        
        if reply == QMessageBox.Yes:
            self.canvas.clear_all_paths()
            self.log("Cleared all paths")
            self.status_label.setText("All paths cleared. Start drawing new paths!")
            self.canvas_info_bar.setText("All paths cleared. Select a robot to start drawing.")
            self.canvas_info_bar.setStyleSheet("""
                QLabel {
                    background: #F0F0F0;
                    color: #666666;
                    padding: 12px 16px;
                    border-radius: 6px;
                    border: 1px solid #CCCCCC;
                    font-size: 28px;
                    min-height: 40px;
                    font-weight: 600;
                }
            """)
            self.send_btn.setEnabled(False)
    
    def validate_paths(self):
        """Validate all drawn paths."""
        if not self.canvas.drawn_paths:
            QMessageBox.warning(self, "No Paths", "Please draw at least one path first!")
            return
        
        self.log("=== Validating Paths ===")
        result = self.path_validator.validate_all_paths(
            self.canvas.drawn_paths,
            self.current_mission.robots
        )
        
        # Log individual results
        for line in result.message.split('\n'):
            self.log(line)
        
        if result.valid:
            QMessageBox.information(
                self,
                "Validation Successful",
                "✓ All paths are valid!\n\nYou can now click 'Set Waypoints' to optimize the paths."
            )
            self.status_label.setText("✓ All paths valid! Click 'Set Waypoints' to continue.")
        else:
            QMessageBox.warning(
                self,
                "Validation Failed",
                f"Some paths have issues:\n\n{result.message}\n\n"
                "Please fix the issues and try again."
            )
            self.status_label.setText("✗ Validation failed. Check the log for details.")
    
    def set_waypoints(self):
        """Generate optimized waypoints from drawn paths."""
        # First validate
        if not self.canvas.drawn_paths:
            QMessageBox.warning(self, "No Paths", "Please draw at least one path first!")
            return
        
        self.log("=== Setting Waypoints ===")
        
        # Validate paths
        result = self.path_validator.validate_all_paths(
            self.canvas.drawn_paths,
            self.current_mission.robots
        )
        
        if not result.valid:
            QMessageBox.warning(
                self,
                "Invalid Paths",
                f"Please fix path issues before setting waypoints:\n\n{result.message}"
            )
            return
        
        # Generate waypoints for each robot
        self.canvas.optimized_paths.clear()
        waypoint_summary = []
        
        for robot in self.current_mission.robots:
            color_key = robot.color.value
            if color_key not in self.canvas.drawn_paths:
                continue
            
            drawn_path = self.canvas.drawn_paths[color_key]
            
            # Normalize path direction (auto-reverse if drawn backwards)
            normalized_path = self.path_validator.normalize_path_direction(drawn_path, robot)
            
            # Update the stored path if it was reversed
            if normalized_path != drawn_path:
                self.canvas.drawn_paths[color_key] = normalized_path
                self.log(f"ℹ {robot.display_name}: Path was drawn backwards, auto-reversed")
            
            # Interpolate path
            interpolated = self.path_interpolator.interpolate_path(normalized_path, num_samples=500)
            if not interpolated:
                self.log(f"✗ {robot.display_name}: Interpolation failed")
                continue
            
            # Convert to real-world coordinates
            real_path = self.coord_converter.path_canvas_to_real(interpolated)
            
            # Optimize waypoints
            waypoints_real = self.waypoint_optimizer.optimize_waypoints(real_path)
            
            # Convert back to canvas for display
            waypoints_canvas = self.coord_converter.path_real_to_canvas(waypoints_real)
            self.canvas.optimized_paths[color_key] = waypoints_canvas
            
            # Count unique waypoints (excluding duplicates at end)
            unique_count = len(set(waypoints_real))
            self.log(f"✓ {robot.display_name}: {unique_count} unique waypoints generated (padded to 20)")
            waypoint_summary.append(f"{robot.display_name}: {unique_count} WPs")
        
        # Show waypoints on canvas
        self.canvas.waypoints_visible = True
        self.canvas.draw_mission()
        
        # Update canvas info bar with waypoint summary
        summary_text = " | ".join(waypoint_summary)
        self.canvas_info_bar.setText(f"✓ Waypoints optimized: {summary_text}")
        self.canvas_info_bar.setStyleSheet("""
            QLabel {
                background: #D4EDDA;
                color: #155724;
                padding: 12px 16px;
                border-radius: 6px;
                border: 1px solid #C3E6CB;
                font-size: 28px;
                min-height: 40px;
                font-weight: 600;
            }
        """)
        
        # Enable send button
        self.send_btn.setEnabled(True)
        
        self.status_label.setText("✓ Waypoints set! Review them on the canvas, then click 'Send to Robots'.")
        QMessageBox.information(
            self,
            "Waypoints Generated",
            "✓ Waypoints have been generated and displayed on the canvas!\n\n"
            "• Solid lines show the optimized paths\n"
            "• Numbered circles show waypoint positions\n"
            "• Straight sections have fewer waypoints\n"
            "• Curved sections have more waypoints\n\n"
            "Click 'Send to Robots' when ready to execute!"
        )
    
    def send_to_robots(self):
        """Send waypoints to robot control system."""
        if not self.canvas.optimized_paths:
            QMessageBox.warning(self, "No Waypoints", "Please set waypoints first!")
            return
        
        self.log("=== Sending to Robots ===")
        
        # Format waypoints for each robot
        robot_commands = {}
        
        for robot in self.current_mission.robots:
            color_key = robot.color.value
            if color_key not in self.canvas.optimized_paths:
                self.log(f"⚠ {robot.display_name}: No path defined (skipped)")
                continue
            
            # Get waypoints in canvas coordinates
            waypoints_canvas = self.canvas.optimized_paths[color_key]
            
            # Convert to real-world coordinates
            waypoints_real = self.coord_converter.path_canvas_to_real(waypoints_canvas)
            
            # Ensure WP1 and final WP are exactly at start and end positions
            start_real = self.coord_converter.canvas_to_real(*robot.start_pos)
            end_real = self.coord_converter.canvas_to_real(*robot.end_pos)
            
            # Replace first waypoint with exact start position
            if waypoints_real:
                waypoints_real[0] = start_real
            
            # Find where padding starts (consecutive duplicate waypoints at the end)
            # and replace all padded waypoints with exact end position
            if len(waypoints_real) > 1:
                # Find the last unique waypoint before padding starts
                last_unique_idx = len(waypoints_real) - 1
                for i in range(len(waypoints_real) - 2, -1, -1):
                    if waypoints_real[i] != waypoints_real[i + 1]:
                        last_unique_idx = i + 1
                        break
                
                # Replace all waypoints from last_unique_idx onwards with exact end position
                for i in range(last_unique_idx, len(waypoints_real)):
                    waypoints_real[i] = end_real
            
            robot_commands[color_key] = waypoints_real
            
            # Log waypoints
            self.log(f"\n{robot.display_name} Waypoints (mm):")
            for i, (x, y) in enumerate(waypoints_real):
                self.log(f"  WP{i+1:2d}: ({x:7.1f}, {y:7.1f})")
        
        # Print formatted output for control system
        print("\n" + "="*60)
        print("ROBOT COMMAND OUTPUT - READY FOR CONTROL SYSTEM")
        print("="*60)
        
        for color_key, waypoints in robot_commands.items():
            print(f"\n{color_key.upper()}_ROBOT_WAYPOINTS = [")
            for i, (x, y) in enumerate(waypoints):
                print(f"    ({x:.2f}, {y:.2f}),  # WP{i+1}")
            print("]")
        
        print("\n" + "="*60 + "\n")
        
        self.log("\n✓ Commands formatted and printed to console!")
        self.log("✓ Ready to send to robot control system")
        
        # Update canvas info bar with success message
        robot_count = len(robot_commands)
        self.canvas_info_bar.setText(f"✓ Commands sent! {robot_count} robot(s) ready")
        self.canvas_info_bar.setStyleSheet("""
            QLabel {
                background: #D4EDDA;
                color: #155724;
                padding: 12px 16px;
                border-radius: 6px;
                border: 1px solid #C3E6CB;
                font-size: 28px;
                min-height: 40px;
                font-weight: 600;
            }
        """)
        
        QMessageBox.information(
            self,
            "Commands Ready",
            "✓ Waypoint commands have been generated!\n\n"
            f"• {len(robot_commands)} robot(s) ready\n"
            "• 20 waypoints per robot\n"
            "• Real-world coordinates (mm)\n\n"
            "Check the console output for formatted commands.\n"
            "These can be sent to the robot control system."
        )
        
        self.status_label.setText("✓ Commands ready! Check console for formatted output.")
    
    def log(self, message: str):
        """Add message to log display."""
        self.log_display.append(message)
        # Auto-scroll to bottom
        scrollbar = self.log_display.verticalScrollBar()
        scrollbar.setValue(scrollbar.maximum())
    
    @staticmethod
    def adjust_brightness(hex_color: str, factor: float) -> str:
        """Adjust brightness of a hex color by a factor (0.0 to 1.0 darkens, >1.0 lightens)."""
        color = QColor(hex_color)
        h, s, v, a = color.getHsv()
        new_v = max(0, min(255, int(v * factor)))
        color.setHsv(h, s, new_v, a)
        return color.name()
    
    @staticmethod
    def get_modern_stylesheet() -> str:
        """Get modern, clean stylesheet with vibrant color palette."""
        return """
            /* Main Window */
            QMainWindow {
                /* Soft warm gradient background - professional and modern */
                background: qlineargradient(x1:0, y1:0, x2:1, y2:1,
                    stop:0 #F8F9FA, stop:1 #E9ECEF);
            }
            
            /* Global font family fallback */
            QWidget, QGroupBox, QPushButton, QComboBox, QLabel, QTextEdit {
                font-family: 'Inter', 'Segoe UI', 'Noto Sans', Ubuntu, Arial, sans-serif;
            }
            
            /* Group Boxes - Clean Cards */
            QGroupBox {
                background-color: #FFFFFF;
                border: 2px solid #D0D5DD;
                border-radius: 10px;
                margin-top: 28px;
                padding-top: 32px;
                font-size: 36px;
                font-weight: 600;
                color: #1A1A1A;
            }
            
            QGroupBox::title {
                subcontrol-origin: margin;
                subcontrol-position: top left;
                left: 18px;
                top: 4px;
                padding: 8px 14px;
                background-color: #FFFFFF;
                border-radius: 6px;
                color: #1A1A1A;
                font-weight: 600;
                font-size: 36px;
            }
            
            /* Primary Buttons - Vibrant Tufts Blue */
            QPushButton {
                background-color: #004A82; /* palette blue */
                color: white;
                border: none;
                border-radius: 8px;
                padding: 12px 18px;
                font-size: 32px;
                font-weight: 600;
                min-height: 64px;
            }
            
            QPushButton:hover {
                background-color: #003C69;
            }
            
            QPushButton:pressed {
                background-color: #002F51;
            }
            
            QPushButton:disabled {
                background-color: #E0E0E0;
                color: #9E9E9E;
            }
            
            /* Combo Box - Clean Dropdown */
            QComboBox {
                border: 2px solid #D0D5DD;
                border-radius: 8px;
                padding: 12px 16px;
                background-color: #FFFFFF;
                font-size: 32px;
                color: #1A1A1A;
                min-height: 64px;
            }
            
            QComboBox:hover {
                border: 2px solid #004A82;
                background-color: #F9FAFB;
            }
            
            QComboBox:focus {
                border: 3px solid #004A82;
            }
            
            QComboBox::drop-down {
                border: none;
                width: 40px;
            }
            
            QComboBox::down-arrow {
                image: none;
                border-left: 7px solid transparent;
                border-right: 7px solid transparent;
                border-top: 8px solid #4B5563;
                margin-right: 16px;
            }
            
            QComboBox QAbstractItemView {
                background-color: #FFFFFF;
                border: 2px solid #D0D5DD;
                border-radius: 8px;
                selection-background-color: #E8F4FF;
                selection-color: #0B3A5B;
                padding: 8px;
                font-size: 32px;
            }
            
            QComboBox QAbstractItemView::item {
                min-height: 90px;
                padding: 8px;
            }
            
            /* Labels */
            QLabel {
                color: #1A1A1A;
                font-size: 30px;
            }
            
            /* Text Edit - Log Display */
            QTextEdit {
                background-color: #263238;
                color: #E6C229;
                padding: 14px;
                border-radius: 8px;
                font-family: 'Consolas', 'Courier New', monospace;
                font-size: 26px;
                border: 2px solid #37474F;
            }
            
            /* Scroll Bars - Vibrant with Electric Indigo */
            QScrollBar:vertical {
                background-color: #F3F4F6;
                width: 16px;
                margin: 0px;
                border: none;
            }
            
            QScrollBar::handle:vertical {
                background-color: #004A82;
                border-radius: 6px;
                min-height: 40px;
                margin: 2px;
            }
            
            QScrollBar::handle:vertical:hover {
                background-color: #003C69;
            }
            
            QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical {
                height: 0px;
                width: 0px;
            }
            
            QScrollBar::add-page:vertical, QScrollBar::sub-page:vertical {
                background: none;
            }
            
            QScrollBar:horizontal {
                background-color: #F3F4F6;
                height: 16px;
                margin: 0px;
                border: none;
            }
            
            QScrollBar::handle:horizontal {
                background-color: #004A82;
                border-radius: 6px;
                min-width: 40px;
                margin: 2px;
            }
            
            QScrollBar::handle:horizontal:hover {
                background-color: #003C69;
            }
            
            QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal {
                height: 0px;
                width: 0px;
            }
            
            QScrollBar::add-page:horizontal, QScrollBar::sub-page:horizontal {
                background: none;
            }
            
            /* Message Boxes */
            QMessageBox {
                background-color: #FFFFFF;
            }
            
            QMessageBox QLabel {
                font-size: 30px;
                color: #374151;
                padding: 10px;
            }
            
            QMessageBox QPushButton {
                min-width: 100px;
                min-height: 64px;
                padding: 12px 26px;
                font-size: 30px;
                font-weight: 600;
            }
        """

    def get_robot_hex(self, robot_color: RobotColor) -> str:
        """Resolve the hex color for a robot using the app palette overrides."""
        try:
            key = robot_color.value.lower()
        except Exception:
            return "#004A82"
        return self.robot_color_palette.get(key, "#004A82")


def main():
    """Main entry point."""
    app = QApplication(sys.argv)
    app.setStyle('Fusion')
    
    window = MultiRobotGUI()
    window.show()
    
    sys.exit(app.exec_())


if __name__ == "__main__":
    main()
