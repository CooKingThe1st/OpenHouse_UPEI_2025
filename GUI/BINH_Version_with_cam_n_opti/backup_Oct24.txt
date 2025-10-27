import sys
import json
import os
import random
import time
import socket
import threading
from datetime import datetime
import numpy as np
import cv2  # OpenCV for camera streaming
# from scipy.interpolate import splprep, splev
from PyQt5.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, 
                             QHBoxLayout, QPushButton, QTabWidget, QLabel,
                             QComboBox, QGraphicsView, QGraphicsScene, QFrame,
                             QTableWidget, QTableWidgetItem, QHeaderView, QDialog,
                             QLineEdit, QMessageBox, QInputDialog, QSlider, QRadioButton,
                             QButtonGroup, QGroupBox, QTextEdit, QGridLayout)
from PyQt5.QtCore import Qt, QPointF, QUrl, QTimer, pyqtSignal, QObject

from PyQt5.QtGui import QPainter, QColor, QPen, QPixmap, QImage, QBrush, QFont, QPolygonF
from PyQt5.QtMultimedia import QMediaPlayer, QMediaPlaylist, QMediaContent

# Import coordinate transformer
from coordinate_transformer import CoordinateTransformer
from PyQt5.QtMultimedia import QMediaPlayer, QMediaPlaylist, QMediaContent

class DotConnectGame(QMainWindow):
    # Signal for communication test results (color, success, message)
    communication_result = pyqtSignal(str, bool, str) 
    
    def __init__(self):
        super().__init__()
        self.setWindowTitle("DotConnect - Multi-Robot System Demo")
        self.setGeometry(100, 100, 1400, 900)
        
        # Color palettes for different modes
        self.color_palettes = {
            'normal': {
                'red': QColor(255, 0, 0),
                'green': QColor(0, 255, 0),
                'blue': QColor(0, 0, 255),
                'yellow': QColor(255, 255, 0)
            },
            'anomalous': {
                'red': QColor(255, 140, 0),      # Orange
                'green': QColor(0, 191, 255),    # Deep Sky Blue
                'blue': QColor(138, 43, 226),    # Blue Violet
                'yellow': QColor(0, 255, 255)    # Cyan
            },
            'monochromacy': {
                'red': QColor(30, 30, 30),       # Dark Gray
                'green': QColor(100, 100, 100),  # Light Gray
                'blue': QColor(160, 160, 160),   # Very Light Gray
                'yellow': QColor(210, 210, 210)  # Almost White
            }
        }
        
        # Current color mode
        self.colorblind_mode = 'normal'
        self.colors = self.color_palettes['normal'].copy()
        
        # Settings
        self.settings_file = 'dotconnect_data/settings.json'
        self.load_settings()
        
        # Audio setup
        self.setup_audio()
        
        # Initialize levels
        self.init_levels()
        self.current_level = 1
        
        # Initialize data storage
        self.data_dir = 'dotconnect_data'
        self.init_data_storage()
        
        # Initialize coordinate transformer
        self.coordinate_transformer = CoordinateTransformer()
        
        # OptiTrack visualization mode calibration
        self.optitrack_viz_calibration_file = 'dotconnect_data/optitrack_viz_calibration.json'
        self.optitrack_viz_corners = None  # 4 OptiTrack coordinates for corners
        self.optitrack_viz_transform = None  # Transformation matrix for OptiTrack -> Canvas
        self.optitrack_viz_bounds = None  # Bounds for linear transformation
        self.load_optitrack_viz_calibration()
        
        # Latest OptiTrack position (for calibration preview real-time updates)
        self.latest_optitrack_position = (0.0, 0.0)  # Default to origin (x, y)
        
        # OptiTrack configuration
        self.optitrack_server_ip = "192.168.0.100"
        self.optitrack_port = 5400
        
        # OptiTrack default bounds (can be changed in Advanced Settings)
        # Based on real calibration: TL(-2.8,1.4), TR(-2.8,-0.4), BL(-1.0,1.4), BR(-1.0,-0.4)
        # These will be loaded from settings if available, otherwise use defaults
        if not hasattr(self, 'optitrack_bounds_min_x'):
            self.optitrack_bounds_min_x = -2.8
            self.optitrack_bounds_max_x = -1.0
            self.optitrack_bounds_min_y = -0.4
            self.optitrack_bounds_max_y = 1.4
        
        # Connect signal for communication results
        self.communication_result.connect(self._update_communication_result)
        
        # Setup UI
        self.setup_ui()
        self.setup_ui()


    def setup_audio(self):
        """Setup audio player and load BGM files"""
        self.player = QMediaPlayer()
        self.playlist = QMediaPlaylist()
        self.playlist.setPlaybackMode(QMediaPlaylist.Loop)
        
        # Load BGM files from BGM subfolder
        bgm_folder = os.path.join(os.path.dirname(__file__), 'BGM')
        if os.path.exists(bgm_folder):
            bgm_files = [f for f in os.listdir(bgm_folder) 
                        if f.lower().endswith(('.mp3', '.wav', '.ogg', '.flac'))]
            
            if bgm_files:
                # Shuffle the files for random start
                random.shuffle(bgm_files)
                
                for bgm_file in bgm_files:
                    file_path = os.path.join(bgm_folder, bgm_file)
                    url = QUrl.fromLocalFile(file_path)
                    self.playlist.addMedia(QMediaContent(url))
                
                self.player.setPlaylist(self.playlist)
                self.player.setVolume(self.volume)
                self.player.play()
        
    def load_settings(self):
        """Load settings from file"""
        default_settings = {
            'volume': 50,
            'colorblind_mode': 'normal',
            'preview_velocity': 5,
            'reality_velocity': 50
        }
        
        if os.path.exists(self.settings_file):
            try:
                with open(self.settings_file, 'r') as f:
                    loaded_settings = json.load(f)
                    self.volume = loaded_settings.get('volume', 50)
                    self.colorblind_mode = loaded_settings.get('colorblind_mode', 'normal')
                    self.preview_velocity = loaded_settings.get('preview_velocity', 100)
                    self.reality_velocity = loaded_settings.get('reality_velocity', 50)
                    # Load OptiTrack bounds (will be overridden later if present in main init)
                    self.optitrack_bounds_min_x = loaded_settings.get('optitrack_bounds_min_x', -2.0)
                    self.optitrack_bounds_max_x = loaded_settings.get('optitrack_bounds_max_x', 2.0)
                    self.optitrack_bounds_min_y = loaded_settings.get('optitrack_bounds_min_y', -1.5)
                    self.optitrack_bounds_max_y = loaded_settings.get('optitrack_bounds_max_y', 1.5)
            except:
                self.volume = 50
                self.colorblind_mode = 'normal'
                self.preview_velocity = 100
                self.reality_velocity = 50
        else:
            self.volume = 50
            self.colorblind_mode = 'normal'
            self.preview_velocity = 100
            self.reality_velocity = 50

        # always default to normal at start
        self.colorblind_mode = 'normal'


    def save_settings(self):
        """Save settings to file"""
        settings = {
            'volume': self.volume,
            'colorblind_mode': self.colorblind_mode,
            'preview_velocity': self.preview_velocity,
            'reality_velocity': self.reality_velocity,
            'optitrack_bounds_min_x': self.optitrack_bounds_min_x,
            'optitrack_bounds_max_x': self.optitrack_bounds_max_x,
            'optitrack_bounds_min_y': self.optitrack_bounds_min_y,
            'optitrack_bounds_max_y': self.optitrack_bounds_max_y
        }
        
        os.makedirs(os.path.dirname(self.settings_file), exist_ok=True)
        with open(self.settings_file, 'w') as f:
            json.dump(settings, f, indent=2)

    def load_optitrack_viz_calibration(self):
        """Load OptiTrack visualization calibration from file"""
        if os.path.exists(self.optitrack_viz_calibration_file):
            try:
                with open(self.optitrack_viz_calibration_file, 'r') as f:
                    data = json.load(f)
                    self.optitrack_viz_corners = data.get('corners', None)
                    if self.optitrack_viz_corners:
                        self._compute_optitrack_viz_transform()
            except Exception as e:
                print(f"[WARNING] Failed to load OptiTrack viz calibration: {e}")
                self.optitrack_viz_corners = None
                self.optitrack_viz_transform = None
                self.optitrack_viz_bounds = None
    
    def save_optitrack_viz_calibration(self):
        """Save OptiTrack visualization calibration to file"""
        data = {
            'corners': self.optitrack_viz_corners
        }
        os.makedirs(os.path.dirname(self.optitrack_viz_calibration_file), exist_ok=True)
        with open(self.optitrack_viz_calibration_file, 'w') as f:
            json.dump(data, f, indent=2)
    
    def set_optitrack_viz_calibration(self, corners):
        """Set OptiTrack visualization calibration with 4 approximate corners"""
        # corners: list of 4 (x, y) tuples from OptiTrack (approximate corners)
        # We'll adjust them to form a proper rectangle
        self.optitrack_viz_corners = self._adjust_to_rectangle(corners)
        self._compute_optitrack_viz_transform()
        self.save_optitrack_viz_calibration()
        return True
    
    def _adjust_to_rectangle(self, corners):
        """Adjust 4 approximate points to form a proper rectangle
        
        OptiTrack coordinate system (same as user's definition):
        - X increases to the RIGHT (positive X = right)
        - Y increases UPWARD (positive Y = up)
        - Top-Left = (-X, +Y), Top-Right = (+X, +Y)
        - Bottom-Right = (+X, -Y), Bottom-Left = (-X, -Y)
        """
        # Find center of the 4 points
        center_x = sum(p[0] for p in corners) / 4
        center_y = sum(p[1] for p in corners) / 4
        
        # Find average distances from center to corners
        distances_x = [abs(p[0] - center_x) for p in corners]
        distances_y = [abs(p[1] - center_y) for p in corners]
        
        avg_dx = sum(distances_x) / 4
        avg_dy = sum(distances_y) / 4
        
        # Create rectangle centered at center with average dimensions
        # OptiTrack: Y increases upward, so +avg_dy is TOP, -avg_dy is BOTTOM
        adjusted = [
            (center_x - avg_dx, center_y + avg_dy),  # Top-Left: (-X, +Y)
            (center_x + avg_dx, center_y + avg_dy),  # Top-Right: (+X, +Y)
            (center_x + avg_dx, center_y - avg_dy),  # Bottom-Right: (+X, -Y)
            (center_x - avg_dx, center_y - avg_dy)   # Bottom-Left: (-X, -Y)
        ]
        
        return adjusted
    
    def _compute_optitrack_viz_transform(self):
        """Compute transformation matrix from OptiTrack coords to canvas coords (600x400)"""
        if not self.optitrack_viz_corners or len(self.optitrack_viz_corners) != 4:
            self.optitrack_viz_transform = None
            self.optitrack_viz_bounds = None
            return
        
        # Store bounds for linear transformation
        # Corners are: [Top-Left, Top-Right, Bottom-Right, Bottom-Left]
        # Top-Left = (-X, +Y), Top-Right = (+X, +Y), etc.
        xs = [c[0] for c in self.optitrack_viz_corners]
        ys = [c[1] for c in self.optitrack_viz_corners]
        
        self.optitrack_viz_bounds = {
            'min_x': min(xs),
            'max_x': max(xs),
            'min_y': min(ys),
            'max_y': max(ys)
        }
        
        # Update main bounds used for drawing axes
        self.optitrack_bounds_min_x = min(xs)
        self.optitrack_bounds_max_x = max(xs)
        self.optitrack_bounds_min_y = min(ys)
        self.optitrack_bounds_max_y = max(ys)
        
        # Save updated bounds to settings
        self.save_settings()
        
        # We'll use linear transformation instead of perspective
        self.optitrack_viz_transform = True  # Just a flag to indicate calibration is done
    
    def optitrack_to_canvas(self, opti_x, opti_y):
        """Transform OptiTrack coordinates to canvas coordinates using linear mapping"""
        if not self.optitrack_viz_transform or not self.optitrack_viz_bounds:
            return None, None
        
        bounds = self.optitrack_viz_bounds
        
        # Linear mapping from OptiTrack bounds to canvas (600x400)
        # X: min_x → 0, max_x → 600
        if bounds['max_x'] != bounds['min_x']:
            norm_x = (opti_x - bounds['min_x']) / (bounds['max_x'] - bounds['min_x'])
        else:
            norm_x = 0.5
        
        # Y: max_y (top) → 0, min_y (bottom) → 400
        # OptiTrack Y increases upward, Canvas Y increases downward
        if bounds['max_y'] != bounds['min_y']:
            norm_y = (opti_y - bounds['min_y']) / (bounds['max_y'] - bounds['min_y'])
        else:
            norm_y = 0.5
        
        canvas_x = norm_x * 600
        canvas_y = (1 - norm_y) * 400  # Flip Y: high OptiTrack Y → low canvas Y
        
        # Clamp to canvas bounds to ensure visibility
        canvas_x = max(0, min(600, canvas_x))
        canvas_y = max(0, min(400, canvas_y))
        
        return canvas_x, canvas_y
    
    def is_optitrack_viz_calibrated(self):
        """Check if OptiTrack visualization mode is calibrated"""
        return self.optitrack_viz_transform is not None


    def init_levels(self):
        """Initialize level data structure"""
        self.levels = {
            # Fixed levels (1-4)
            1: {
                'name': 'Level 1',
                'fixed': True,
                'boundary': {'width': 600, 'height': 400},
                'dots': {
                    'red': {'start': (50, 50), 'end': (550, 350)},
                    'green': {'start': None, 'end': None},
                    'blue': {'start': None, 'end': None},
                    'yellow': {'start': None, 'end': None}
                }
            },
            2: {
                'name': 'Level 2',
                'fixed': True,
                'boundary': {'width': 600, 'height': 400},
                'dots': {
                    'red': {'start': (100, 100), 'end': (500, 300)},
                    'green': {'start': (500, 100), 'end': (100, 300)},
                    'blue': {'start': None, 'end': None},
                    'yellow': {'start': None, 'end': None}
                }
            },
            3: {
                'name': 'Level 3',
                'fixed': True,
                'boundary': {'width': 600, 'height': 400},
                'dots': {
                    'red': {'start': (150, 80), 'end': (450, 320)},
                    'green': {'start': (450, 80), 'end': (150, 320)},
                    'blue': {'start': (80, 200), 'end': (520, 200)},
                    'yellow': {'start': None, 'end': None}
                }
            },
            4: {
                'name': 'Level 4',
                'fixed': True,
                'boundary': {'width': 600, 'height': 400},
                'dots': {
                    'red': {'start': (100, 50), 'end': (500, 350)},
                    'green': {'start': (500, 50), 'end': (100, 350)},
                    'blue': {'start': (200, 150), 'end': (400, 250)},
                    'yellow': {'start': (50, 200), 'end': (550, 200)}
                }
            },
            # Customizable level (5)
            5: {
                'name': 'Custom Level',
                'fixed': False,
                'boundary': {'width': 600, 'height': 400},
                'dots': {
                    'red': {'start': (100, 100), 'end': (500, 300)},
                    'green': {'start': (500, 100), 'end': (100, 300)},
                    'blue': {'start': (100, 200), 'end': (500, 200)},
                    'yellow': {'start': (300, 100), 'end': (300, 300)}
                }
            }
        }
        
    def init_data_storage(self):
        """Initialize data storage directory and files"""
        # Create data directory if it doesn't exist
        if not os.path.exists(self.data_dir):
            os.makedirs(self.data_dir)
        
        # Initialize highscores file
        self.highscores_file = os.path.join(self.data_dir, 'highscores.json')
        if not os.path.exists(self.highscores_file):
            initial_scores = {str(i): [] for i in range(1, 6)}
            with open(self.highscores_file, 'w') as f:
                json.dump(initial_scores, f, indent=2)
        
        # Initialize custom levels file
        self.custom_levels_file = os.path.join(self.data_dir, 'custom_levels.json')
        if os.path.exists(self.custom_levels_file):
            self.load_custom_levels()
        
        # Initialize cache file for temporary solutions
        self.cache_file = os.path.join(self.data_dir, 'solution_cache.json')
        
        # Clear cache on boot (fresh session)
        if os.path.exists(self.cache_file):
            os.remove(self.cache_file)
            print("[INFO] Cleared solution cache from previous session")
        
        # Initialize empty session cache in memory
        self.session_cache = {}
        
        # Load highscores
        self.load_highscores()

    def save_solution_cache(self, level_num, solution):
        """Save solution to cache (temporary storage for current session)"""
        # Save to in-memory cache
        self.session_cache[str(level_num)] = solution
        
        # Also save to file for crash recovery
        try:
            with open(self.cache_file, 'w') as f:
                json.dump(self.session_cache, f, indent=2)
            
            print(f"[INFO] Solution cached for level {level_num}")
        except Exception as e:
            print(f"[WARNING] Failed to save cache: {e}")
    
    def load_solution_cache(self, level_num):
        """Load solution from cache"""
        # Load from in-memory cache first
        level_key = str(level_num)
        if level_key in self.session_cache:
            print(f"[INFO] Loading cached solution for level {level_num}")
            return self.session_cache[level_key]
        
        print(f"[INFO] No cached solution for level {level_num}")
        return None

    def load_custom_levels(self):
        """Load saved custom level configurations"""
        try:
            with open(self.custom_levels_file, 'r') as f:
                custom_data = json.load(f)
                
                # Update customizable level (5) with saved data
                if '5' in custom_data:
                    self.levels[5]['dots'] = custom_data['5']['dots']
        except:
            pass
    
    def save_custom_levels(self):
        """Save custom level configurations"""
        custom_data = {
            '5': {
                'dots': self.levels[5]['dots']
            }
        }
        
        with open(self.custom_levels_file, 'w') as f:
            json.dump(custom_data, f, indent=2)

    
    def load_highscores(self):
        """Load highscores from file"""
        with open(self.highscores_file, 'r') as f:
            self.highscores = json.load(f)
    
    def save_highscores(self):
        """Save highscores to file"""
        with open(self.highscores_file, 'w') as f:
            json.dump(self.highscores, f, indent=2)
    
    def add_highscore(self, level, name, time_seconds, solution):
        """Add a new highscore entry"""
        level_key = str(level)
        entry = {
            'name': name,
            'time': time_seconds,
            'solution': solution,
            'timestamp': datetime.now().isoformat()
        }
        
        self.highscores[level_key].append(entry)
        
        # Sort by time (ascending)
        self.highscores[level_key].sort(key=lambda x: x['time'])
        
        self.save_highscores()
        
        # Refresh highscore tab if visible
        if hasattr(self, 'highscore_table'):
            self.update_highscore_table()
        
    def setup_ui(self):
        """Setup the main user interface"""
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        layout = QVBoxLayout(central_widget)
        
        # Create tab widget with large tabs
        self.tabs = QTabWidget()
        self.tabs.setStyleSheet("""
            QTabWidget::pane {
                border: 2px solid #cccccc;
            }
            QTabBar::tab {
                background: #e0e0e0;
                padding: 20px 20px;
                margin: 2px;
                font-size: 15px;
                font-weight: bold;
            }
            QTabBar::tab:selected {
                background: #4CAF50;
                color: white;
            }
        """)
        
        # Create tabs
        self.dotconnect_tab = self.create_dotconnect_tab()
        self.highscore_tab = self.create_highscore_tab()
        self.debug_tab = self.create_debug_tab()
        self.settings_tab = self.create_settings_tab()
        
        # Add tabs
        self.tabs.addTab(self.dotconnect_tab, "DotConnect")
        self.tabs.addTab(self.highscore_tab, "HighScore")
        self.tabs.addTab(self.debug_tab, "DebugNetwork")
        self.tabs.addTab(self.settings_tab, "Settings")
        
        layout.addWidget(self.tabs)

        
    def create_dotconnect_tab(self):
        """Create the main game tab"""
        tab = QWidget()
        layout = QHBoxLayout(tab)
        
        # Left side: Game canvas
        canvas_layout = QVBoxLayout()
        
        # Level navigation
        nav_layout = QHBoxLayout()
        nav_layout.addWidget(QLabel("Level:"))
        
        self.prev_btn = QPushButton("◀ Previous")
        self.prev_btn.clicked.connect(self.prev_level)
        nav_layout.addWidget(self.prev_btn)
        
        self.level_combo = QComboBox()
        for i in range(1, 6):
            level_name = self.levels[i]['name']
            self.level_combo.addItem(f"{i}: {level_name}")
        self.level_combo.currentIndexChanged.connect(self.change_level)
        nav_layout.addWidget(self.level_combo)
        
        self.next_btn = QPushButton("Next ▶")
        self.next_btn.clicked.connect(self.next_level)
        nav_layout.addWidget(self.next_btn)
        
        nav_layout.addStretch()
        canvas_layout.addLayout(nav_layout)
        
        # Game canvas
        self.game_canvas = GameCanvas(self)
        canvas_layout.addWidget(self.game_canvas)
        
        layout.addLayout(canvas_layout, 3)
        
        # Right side: Control buttons
        controls_layout = QVBoxLayout()
        controls_layout.addWidget(QLabel("<b>Game Controls</b>"))
        
        self.customize_btn = QPushButton("Customize Level")
        self.customize_btn.setMinimumHeight(50)
        self.customize_btn.clicked.connect(self.customize_level)
        controls_layout.addWidget(self.customize_btn)
        
        self.draw_btn = QPushButton("Draw Solution")
        self.draw_btn.setMinimumHeight(50)
        self.draw_btn.clicked.connect(self.draw_solution)
        controls_layout.addWidget(self.draw_btn)
        
        self.clear_btn = QPushButton("Clear Solution")
        self.clear_btn.setMinimumHeight(50)
        self.clear_btn.clicked.connect(self.clear_solution)
        controls_layout.addWidget(self.clear_btn)
        
        self.preview_btn = QPushButton("Preview")
        self.preview_btn.setMinimumHeight(50)
        self.preview_btn.clicked.connect(self.preview_solution)
        controls_layout.addWidget(self.preview_btn)
        
        self.execute_btn = QPushButton("Execute")
        self.execute_btn.setMinimumHeight(50)
        self.execute_btn.setStyleSheet("background-color: #4CAF50; color: white; font-weight: bold;")
        self.execute_btn.clicked.connect(self.execute_solution)
        controls_layout.addWidget(self.execute_btn)
        
        controls_layout.addStretch()
        
        layout.addLayout(controls_layout, 1)
        
        # Update customize button state
        self.update_customize_button()
        
        return tab



    def hs_change_level(self, index):
        """Change highscore level view"""
        self.hs_current_level = index + 1
        self.update_highscore_table()
    
    def hs_prev_level(self):
        """Go to previous level in highscore"""
        if self.hs_current_level > 1:
            self.hs_current_level -= 1
            self.hs_level_combo.setCurrentIndex(self.hs_current_level - 1)
    
    def hs_next_level(self):
        """Go to next level in highscore"""
        if self.hs_current_level < 5:
            self.hs_current_level += 1
            self.hs_level_combo.setCurrentIndex(self.hs_current_level - 1)


    def create_highscore_tab(self):
        """Create the highscore tab"""
        tab = QWidget()
        layout = QVBoxLayout(tab)
        
        # Title
        title = QLabel("<h2>High Scores</h2>")
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        # Level navigation for highscores
        nav_layout = QHBoxLayout()
        nav_layout.addWidget(QLabel("View Level:"))
        
        self.hs_prev_btn = QPushButton("◀ Previous")
        self.hs_prev_btn.clicked.connect(self.hs_prev_level)
        nav_layout.addWidget(self.hs_prev_btn)
        
        self.hs_level_combo = QComboBox()
        for i in range(1, 6):
            level_name = self.levels[i]['name']
            self.hs_level_combo.addItem(f"{i}: {level_name}")
        self.hs_level_combo.currentIndexChanged.connect(self.hs_change_level)
        nav_layout.addWidget(self.hs_level_combo)
        
        self.hs_next_btn = QPushButton("Next ▶")
        self.hs_next_btn.clicked.connect(self.hs_next_level)
        nav_layout.addWidget(self.hs_next_btn)
        
        nav_layout.addStretch()
        
        # Toggle rickroll filter button
        self.toggle_rickroll_btn = QPushButton("Hide Rickroll Entries ( ͡° ͜ʖ ͡°)")
        self.toggle_rickroll_btn.setCheckable(True)
        self.toggle_rickroll_btn.setChecked(False)
        self.toggle_rickroll_btn.clicked.connect(self.toggle_rickroll_filter)
        self.toggle_rickroll_btn.setStyleSheet("""
            QPushButton {
                background-color: #FF9800;
                color: white;
                font-weight: bold;
                padding: 5px 15px;
            }
            QPushButton:checked {
                background-color: #4CAF50;
            }
        """)
        nav_layout.addWidget(self.toggle_rickroll_btn)
        
        layout.addLayout(nav_layout)
        
        # Highscore table
        self.highscore_table = QTableWidget()
        self.highscore_table.setColumnCount(5)
        self.highscore_table.setHorizontalHeaderLabels(['Rank', 'Name', 'Time (s)', 'Solution', 'Delete'])
        self.highscore_table.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        self.highscore_table.setEditTriggers(QTableWidget.NoEditTriggers)
        self.highscore_table.setSelectionBehavior(QTableWidget.SelectRows)
        
        layout.addWidget(self.highscore_table)
        
        # Manual add button (with rickroll penalty)
        add_btn = QPushButton("Add Manual Entry")
        add_btn.clicked.connect(self.add_manual_highscore)
        layout.addWidget(add_btn)
        
        # Initial load
        self.hs_current_level = 1
        self.hide_rickroll = False
        self.update_highscore_table()
        
        return tab

    def toggle_rickroll_filter(self):
        """Toggle showing/hiding rickroll entries"""
        self.hide_rickroll = self.toggle_rickroll_btn.isChecked()
        
        if self.hide_rickroll:
            self.toggle_rickroll_btn.setText("Show Rickroll Entries ( ͡° ͜ʖ ͡°)")
        else:
            self.toggle_rickroll_btn.setText("Hide Rickroll Entries ( ͡° ͜ʖ ͡°)")
        
        self.update_highscore_table()

    def update_highscore_table(self):
        """Update the highscore table for current level"""
        level_key = str(self.hs_current_level)
        scores = self.highscores[level_key]
        
        # Filter out rickroll entries if toggle is on
        if self.hide_rickroll:
            filtered_scores = [entry for entry in scores if "( ͡° ͜ʖ ͡°)" not in entry['name']]
        else:
            filtered_scores = scores
        
        self.highscore_table.setRowCount(len(filtered_scores))
        
        for display_row, entry in enumerate(filtered_scores):
            # Get original row index for delete functionality
            original_row = scores.index(entry)
            
            # Rank
            rank_item = QTableWidgetItem(str(display_row + 1))
            rank_item.setTextAlignment(Qt.AlignCenter)
            self.highscore_table.setItem(display_row, 0, rank_item)
            
            # Name
            name_item = QTableWidgetItem(entry['name'])
            name_item.setTextAlignment(Qt.AlignCenter)
            self.highscore_table.setItem(display_row, 1, name_item)
            
            # Time
            time_item = QTableWidgetItem(f"{entry['time']:.2f}")
            time_item.setTextAlignment(Qt.AlignCenter)
            self.highscore_table.setItem(display_row, 2, time_item)
            
            # Show button
            show_btn = QPushButton("Show")
            show_btn.clicked.connect(lambda checked, r=original_row: self.show_solution(r))
            self.highscore_table.setCellWidget(display_row, 3, show_btn)
            
            # Delete button
            delete_btn = QPushButton("🗑️")
            delete_btn.setStyleSheet("background-color: #f44336; color: white;")
            delete_btn.clicked.connect(lambda checked, r=original_row: self.delete_highscore(r))
            self.highscore_table.setCellWidget(display_row, 4, delete_btn)

    def show_solution(self, row):
        """Show solution popup for a highscore entry"""
        level_key = str(self.hs_current_level)
        entry = self.highscores[level_key][row]
        
        dialog = SolutionViewDialog(self, self.hs_current_level, entry)
        dialog.exec_()


    def delete_highscore(self, row):
        """Delete a highscore entry with password protection"""
        # Password dialog
        password, ok = QInputDialog.getText(self, "Delete Entry", 
                                           "Enter password to delete:", 
                                           QLineEdit.Password)
        
        if not ok:
            return
        
        if password != "morelab":
            QMessageBox.warning(self, "Access Denied", "Incorrect password!")
            return
        
        # Delete the entry
        level_key = str(self.hs_current_level)
        del self.highscores[level_key][row]
        
        # Save and refresh
        self.save_highscores()
        self.update_highscore_table()
        
        QMessageBox.information(self, "Success", "Entry deleted successfully!")

    def add_manual_highscore(self):
        """Add a manual highscore entry (with rickroll penalty)"""
        dialog = QDialog(self)
        dialog.setWindowTitle("Add Manual Entry")
        dialog.setGeometry(300, 300, 400, 200)
        
        layout = QVBoxLayout(dialog)
        
        # Name input
        layout.addWidget(QLabel("Player Name:"))
        name_input = QLineEdit()
        layout.addWidget(name_input)
        
        # Time input
        layout.addWidget(QLabel("Time (seconds):"))
        time_input = QLineEdit()
        time_input.setPlaceholderText("e.g., 45.50")
        layout.addWidget(time_input)
        
        # Buttons
        button_layout = QHBoxLayout()
        ok_btn = QPushButton("OK")
        cancel_btn = QPushButton("Cancel")
        button_layout.addWidget(ok_btn)
        button_layout.addWidget(cancel_btn)
        layout.addLayout(button_layout)
        
        cancel_btn.clicked.connect(dialog.reject)
        
        def add_entry():
            name = name_input.text().strip()
            time_text = time_input.text().strip()
            
            if not name or not time_text:
                QMessageBox.warning(dialog, "Error", "Please fill in all fields!")
                return
            
            try:
                time_seconds = float(time_text)
            except ValueError:
                QMessageBox.warning(dialog, "Error", "Invalid time format!")
                return
            
            # Add suffix to indicate manual entry
            name_with_suffix = f"{name} ( ͡° ͜ʖ ͡°)"
            
            # Create rickroll solution (empty/corrupted)
            solution = {
                'red': [],
                'green': [],
                'blue': [],
                'yellow': []
            }
            
            # Add to highscores
            self.add_highscore(self.hs_current_level, name_with_suffix, time_seconds, solution)
            
            dialog.accept()
            QMessageBox.information(self, "Success", 
                                   f"Manual entry added for {name_with_suffix}!\n\n"
                                   "⚠️ Note: Solution will show rickroll image.")
        
        ok_btn.clicked.connect(add_entry)
        
        dialog.exec_()
    
    def add_test_highscore(self):
        """DEPRECATED - Use add_manual_highscore instead"""
        # This function is kept for backwards compatibility but redirects
        self.add_manual_highscore()

    def create_debug_tab(self):
        """Create the debug network tab"""
        tab = QWidget()
        layout = QVBoxLayout(tab)
        
        # Title
        title = QLabel("<h2>Network Debug - Robot Communication</h2>")
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        # Create grid layout for 4 robots (2x2)
        grid_layout = QHBoxLayout()
        
        robot_colors = ['red', 'green', 'blue', 'yellow']
        
        # Pi IP addresses (configure these with your actual Pi IPs)
        self.pi_ip_addresses = {
            'red': '192.168.0.232',    # Tested and working
            'green': '192.168.0.233',  # Update with your Pi's IP
            'blue': '192.168.0.234',   # Update with your Pi's IP
            'yellow': '192.168.0.235'  # Update with your Pi's IP
        }
        
        # Base robot names
        self.robot_base_names = {
            'red': 'Red Robot',
            'green': 'Green Robot',
            'blue': 'Blue Robot',
            'yellow': 'Yellow Robot'
        }
        
        # Color mode specific names
        self.robot_color_names = {
            'normal': {
                'red': 'Red Robot',
                'green': 'Green Robot',
                'blue': 'Blue Robot',
                'yellow': 'Yellow Robot'
            },
            'anomalous': {
                'red': 'Orange Robot',
                'green': 'Deep Sky Blue Robot',
                'blue': 'Blue Violet Robot',
                'yellow': 'Cyan Robot'
            },
            'monochromacy': {
                'red': 'Dark Gray Robot',
                'green': 'Gray Robot',
                'blue': 'Light Gray Robot',
                'yellow': 'Almost White Robot'
            }
        }
        
        self.debug_nameplates = {}
        self.debug_comm_buttons = {}  # Store button references

        for i, color_name in enumerate(robot_colors):
            # Create robot frame
            robot_frame = QFrame()
            robot_frame.setFrameStyle(QFrame.Box | QFrame.Raised)
            robot_frame.setLineWidth(2)
            robot_frame.setStyleSheet("border: 2px solid #cccccc;")
            
            robot_layout = QVBoxLayout(robot_frame)
            
            # Robot image placeholder
            robot_image_label = QLabel()
            robot_image_label.setAlignment(Qt.AlignCenter)
            robot_image_label.setMinimumHeight(200)
            robot_image_label.setStyleSheet("""
                background-color: #f0f0f0;
                border: 2px solid #999999;
                border-radius: 10px;
                font-size: 48px;
                color: black;
                font-weight: bold;
            """)
            icon_set = ["👾♤", "👾♧", "👾♡", "👾♢"]  # Different icon for each robot
            robot_image_label.setText(icon_set[i])
            robot_layout.addWidget(robot_image_label)
            
            # Nameplate (uses color and color-specific name)
            robot_name = self.robot_color_names[self.colorblind_mode][color_name]
            nameplate = QLabel(robot_name)
            nameplate.setAlignment(Qt.AlignCenter)
            nameplate.setStyleSheet(f"""
                background-color: {self.colors[color_name].name()};
                color: black;
                font-size: 20px;
                font-weight: bold;
                padding: 10px;
                border-radius: 5px;
                border: 2px solid black;
            """)
            robot_layout.addWidget(nameplate)
            # Store reference for updates
            self.debug_nameplates[color_name] = nameplate
            
            # IP Address display
            ip_label = QLabel(f"IP: {self.pi_ip_addresses[color_name]}")
            ip_label.setAlignment(Qt.AlignCenter)
            ip_label.setStyleSheet("""
                font-size: 12px;
                color: #666666;
                padding: 5px;
            """)
            robot_layout.addWidget(ip_label)
            
            # Single Communication Check Button
            comm_btn = QPushButton("Check Communication")
            comm_btn.setMinimumHeight(50)
            comm_btn.setStyleSheet("""
                background-color: #2196F3;
                color: white;
                font-weight: bold;
                font-size: 14px;
                border: 2px solid #1976D2;
                border-radius: 5px;
            """)
            comm_btn.clicked.connect(lambda checked, c=color_name: self.check_communication(c))
            robot_layout.addWidget(comm_btn)
            
            # Store button reference
            self.debug_comm_buttons[color_name] = comm_btn
            
            robot_layout.addStretch()
            
            grid_layout.addWidget(robot_frame)
        
        layout.addLayout(grid_layout)
        
        # Status output area
        status_group = QGroupBox("Communication Status")
        status_layout = QVBoxLayout()
        
        self.debug_status_label = QLabel("Ready to test robot communication...")
        self.debug_status_label.setStyleSheet("""
            background-color: #f5f5f5;
            padding: 10px;
            border: 1px solid #cccccc;
            font-family: monospace;
            color: black;
        """)
        self.debug_status_label.setWordWrap(True)
        status_layout.addWidget(self.debug_status_label)
        
        status_group.setLayout(status_layout)
        layout.addWidget(status_group)
        
        layout.addStretch()
        
        return tab


    def check_communication(self, color):
        """Check bidirectional communication with a robot Pi"""
        import socket
        import threading
        
        color_upper = color.capitalize()
        pi_ip = self.pi_ip_addresses[color]
        port = 5000
        timeout = 2
        
        # Get button reference
        btn = self.debug_comm_buttons[color]
        
        # Set button to "testing" state
        btn.setText("Testing...")
        btn.setStyleSheet("""
            background-color: #FFC107;
            color: black;
            font-weight: bold;
            font-size: 14px;
            border: 2px solid #FFA000;
            border-radius: 5px;
        """)
        btn.setEnabled(False)
        
        # Update status
        self.debug_status_label.setText(
            f"Testing {color_upper} Robot ({pi_ip})...\n"
            f"Connecting to {pi_ip}:{port}\n"
            f"Timeout: {timeout}s"
        )
        
        # Process events to update UI
        QApplication.processEvents()
        
        def test_connection():
            """Test connection in thread to avoid blocking UI"""
            result = {'success': False, 'message': '', 'response': ''}
            client_socket = None
            
            try:
                # Create socket
                client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                client_socket.settimeout(timeout)
                
                print(f"[DEBUG] Connecting to {pi_ip}:{port}...")
                
                # Connect to Pi
                client_socket.connect((pi_ip, port))
                print(f"[DEBUG] Connected to {color_upper} Robot")
                
                # Send test message
                test_message = f"Hello from Laptop to {color_upper} Robot!"
                client_socket.send(test_message.encode('utf-8'))
                print(f"[DEBUG] Sent: '{test_message}'")
                
                # Receive response
                response = client_socket.recv(1024).decode('utf-8')
                print(f"[DEBUG] Received: '{response}'")
                
                # Verify response matches sent message
                if response == test_message:
                    result['success'] = True
                    result['message'] = f"✓ Communication successful with {color_upper} Robot"
                    result['response'] = response
                else:
                    result['success'] = False
                    result['message'] = f"✗ Response mismatch!\nSent: '{test_message}'\nReceived: '{response}'"
                
            except socket.timeout:
                result['message'] = f"✗ Connection timeout ({timeout}s)\nServer may not be running on Pi"
            except ConnectionRefusedError:
                result['message'] = f"✗ Connection refused\nIs pi_server.py running on the Pi?"
            except OSError as e:
                if "No route to host" in str(e):
                    result['message'] = f"✗ No route to host\nCheck network and firewall settings"
                else:
                    result['message'] = f"✗ Network error: {str(e)}"
            except Exception as e:
                result['message'] = f"✗ Unexpected error: {type(e).__name__}: {str(e)}"
            finally:
                if client_socket:
                    try:
                        client_socket.close()
                    except:
                        pass
            
            # Emit signal to update UI in main thread (thread-safe)
            self.communication_result.emit(color, result['success'], result['message'])
        
        # Start thread
        thread = threading.Thread(target=test_connection)
        thread.daemon = True
        thread.start()
    
    def _update_communication_result(self, color, success, message):
        """Update button and status based on communication test result (called from main thread)"""
        btn = self.debug_comm_buttons[color]
        color_upper = color.capitalize()
        pi_ip = self.pi_ip_addresses[color]
        
        if success:
            # Success - Green button with checkmark
            btn.setText("✓ Check Communication")
            btn.setStyleSheet("""
                background-color: #4CAF50;
                color: white;
                font-weight: bold;
                font-size: 14px;
                border: 2px solid #388E3C;
                border-radius: 5px;
            """)
            
            status_text = (
                f"✓ SUCCESS - {color_upper} Robot ({pi_ip})\n"
                f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
                f"Status: Connected and verified\n"
                f"Port: 5000\n"
                f"Protocol: TCP/IP\n"
                f"Message: Sent test message and received matching echo\n"
                f"Result: Communication channel is operational ✓"
            )
        else:
            # Failure - Red button with X
            btn.setText("✗ Check Communication")
            btn.setStyleSheet("""
                background-color: #F44336;
                color: white;
                font-weight: bold;
                font-size: 14px;
                border: 2px solid #D32F2F;
                border-radius: 5px;
            """)
            
            status_text = (
                f"✗ FAILED - {color_upper} Robot ({pi_ip})\n"
                f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
                f"{message}\n"
                f"Port: 5000\n"
                f"Protocol: TCP/IP\n"
                f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
                f"Troubleshooting:\n"
                f"1. Verify pi_server.py is running on the Pi\n"
                f"2. Check Pi IP address: {pi_ip}\n"
                f"3. Ensure both devices are on same network\n"
                f"4. Check firewall settings on both devices"
            )
        
        self.debug_status_label.setText(status_text)
        btn.setEnabled(True)
        
        print(f"[DEBUG] {color_upper} Robot communication test: {'SUCCESS' if success else 'FAILED'}")

    def create_settings_tab(self):
        """Create the settings tab"""
        tab = QWidget()
        layout = QVBoxLayout(tab)
        
        # Title
        title = QLabel("<h2>Settings</h2>")
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        # Volume Control Section
        volume_group = QGroupBox("Volume Control")
        volume_layout = QVBoxLayout()
        
        volume_label = QLabel(f"Volume: {self.volume}%")
        volume_layout.addWidget(volume_label)
        
        volume_slider = QSlider(Qt.Horizontal)
        volume_slider.setMinimum(0)
        volume_slider.setMaximum(100)
        volume_slider.setValue(self.volume)
        volume_slider.setTickPosition(QSlider.TicksBelow)
        volume_slider.setTickInterval(10)
        
        def update_volume(value):
            self.volume = value
            volume_label.setText(f"Volume: {value}%")
            self.player.setVolume(value)
            self.save_settings()
        
        volume_slider.valueChanged.connect(update_volume)
        volume_layout.addWidget(volume_slider)
        
        volume_group.setLayout(volume_layout)
        layout.addWidget(volume_group)
        
        # Colorblind Mode Section
        colorblind_group = QGroupBox("Colorblind Mode")
        colorblind_layout = QVBoxLayout()
        
        self.colorblind_button_group = QButtonGroup()
        
        normal_radio = QRadioButton("Normal")
        normal_radio.setChecked(self.colorblind_mode == 'normal')
        self.colorblind_button_group.addButton(normal_radio, 0)
        colorblind_layout.addWidget(normal_radio)
        
        anomalous_radio = QRadioButton("Anomalous Trichromacy (Red-Green adjusted)")
        anomalous_radio.setChecked(self.colorblind_mode == 'anomalous')
        self.colorblind_button_group.addButton(anomalous_radio, 1)
        colorblind_layout.addWidget(anomalous_radio)
        
        mono_radio = QRadioButton("Monochromacy (Grayscale)")
        mono_radio.setChecked(self.colorblind_mode == 'monochromacy')
        self.colorblind_button_group.addButton(mono_radio, 2)
        colorblind_layout.addWidget(mono_radio)
        

        # Update colorblind mode change handler
        def change_colorblind_mode():
            button_id = self.colorblind_button_group.checkedId()
            if button_id == 0:
                self.colorblind_mode = 'normal'
            elif button_id == 1:
                self.colorblind_mode = 'anomalous'
            elif button_id == 2:
                self.colorblind_mode = 'monochromacy'
            
            # Update colors
            self.colors = self.color_palettes[self.colorblind_mode].copy()
            
            # Refresh game canvas
            if hasattr(self, 'game_canvas'):
                self.game_canvas.load_level(self.current_level)
            
            # Refresh highscore table
            if hasattr(self, 'highscore_table'):
                self.update_highscore_table()
            
            # Refresh debug network nameplates with both color AND text
            if hasattr(self, 'debug_nameplates'):
                for color_name, nameplate in self.debug_nameplates.items():
                    # Update color background
                    nameplate.setStyleSheet(f"""
                        background-color: {self.colors[color_name].name()};
                        color: black;
                        font-size: 20px;
                        font-weight: bold;
                        padding: 10px;
                        border-radius: 5px;
                        border: 2px solid black;
                    """)
                    # Update text to match color mode
                    robot_name = self.robot_color_names[self.colorblind_mode][color_name]
                    nameplate.setText(robot_name)
            
            self.save_settings()
            QMessageBox.information(self, "Color Mode Changed", 
                                   f"Color palette changed to: {self.colorblind_mode.title()}")
        
        normal_radio.clicked.connect(change_colorblind_mode)
        anomalous_radio.clicked.connect(change_colorblind_mode)
        mono_radio.clicked.connect(change_colorblind_mode)
        
        colorblind_group.setLayout(colorblind_layout)
        layout.addWidget(colorblind_group)
        
        # Camera Calibration Section
        camera_calib_group = QGroupBox("Camera Calibration")
        camera_calib_layout = QVBoxLayout()
        
        calibration_btn = QPushButton("📐 Calibrate Coordinate System (Camera)")
        calibration_btn.setStyleSheet("background-color: #2196F3; color: white; font-weight: bold; padding: 10px;")
        calibration_btn.clicked.connect(self.open_calibration_dialog)
        camera_calib_layout.addWidget(calibration_btn)
        
        # Calibration status label
        calib_status = "✓ Calibrated" if self.coordinate_transformer.is_calibrated else "✗ Not Calibrated"
        self.calibration_status_label = QLabel(f"<b>Status:</b> {calib_status}")
        camera_calib_layout.addWidget(self.calibration_status_label)
        
        camera_calib_group.setLayout(camera_calib_layout)
        layout.addWidget(camera_calib_group)
        
        # OptiTrack Visualization Calibration Section
        opti_viz_group = QGroupBox("OptiTrack Visualization Mode Calibration")
        opti_viz_layout = QVBoxLayout()
        
        opti_viz_btn = QPushButton("🎯 Calibrate OptiTrack Visualization Mode")
        opti_viz_btn.setStyleSheet("background-color: #9C27B0; color: white; font-weight: bold; padding: 10px;")
        opti_viz_btn.clicked.connect(self.open_optitrack_viz_calibration_dialog)
        opti_viz_layout.addWidget(opti_viz_btn)
        
        # OptiTrack viz calibration status label
        opti_viz_status = "✓ Calibrated" if self.is_optitrack_viz_calibrated() else "✗ Not Calibrated"
        self.optitrack_viz_status_label = QLabel(f"<b>Status:</b> {opti_viz_status}")
        opti_viz_layout.addWidget(self.optitrack_viz_status_label)
        
        opti_viz_group.setLayout(opti_viz_layout)
        layout.addWidget(opti_viz_group)
        
        # Advanced Settings Button
        advanced_btn = QPushButton("Advanced Settings (Password Protected)")
        advanced_btn.setStyleSheet("background-color: #FF5722; color: white; font-weight: bold; padding: 10px;")
        advanced_btn.clicked.connect(self.open_advanced_settings)
        layout.addWidget(advanced_btn)
        
        layout.addStretch()
        
        return tab


    def open_advanced_settings(self):
        """Open advanced settings dialog with password protection"""
        # Password dialog
        password, ok = QInputDialog.getText(self, "Advanced Settings", 
                                           "Enter password:", 
                                           QLineEdit.Password)
        
        if not ok:
            return
        
        if password != "morelab":
            QMessageBox.warning(self, "Access Denied", "Incorrect password!")
            return
        
        # Create advanced settings dialog
        dialog = QDialog(self)
        dialog.setWindowTitle("Advanced Settings")
        dialog.setGeometry(300, 300, 500, 450)
        
        layout = QVBoxLayout(dialog)
        
        layout.addWidget(QLabel("<b>Robot Velocity Settings</b>"))
        layout.addWidget(QLabel("(Higher values = faster movement)"))
        
        # Preview velocity
        layout.addWidget(QLabel("\nPreview Velocity:"))
        preview_input = QLineEdit()
        preview_input.setText(str(self.preview_velocity))
        preview_input.setPlaceholderText("e.g., 100")
        layout.addWidget(preview_input)
        
        # Reality velocity
        layout.addWidget(QLabel("Reality Velocity:"))
        reality_input = QLineEdit()
        reality_input.setText(str(self.reality_velocity))
        reality_input.setPlaceholderText("e.g., 50")
        layout.addWidget(reality_input)
        
        # OptiTrack Bounds Settings
        layout.addWidget(QLabel("\n<b>OptiTrack Coordinate Bounds (meters)</b>"))
        layout.addWidget(QLabel("(Defines the visualization area for OptiTrack)"))
        
        bounds_layout = QGridLayout()
        
        # X bounds
        bounds_layout.addWidget(QLabel("X Min:"), 0, 0)
        x_min_input = QLineEdit()
        x_min_input.setText(str(self.optitrack_bounds_min_x))
        x_min_input.setPlaceholderText("e.g., -2.0")
        bounds_layout.addWidget(x_min_input, 0, 1)
        
        bounds_layout.addWidget(QLabel("X Max:"), 0, 2)
        x_max_input = QLineEdit()
        x_max_input.setText(str(self.optitrack_bounds_max_x))
        x_max_input.setPlaceholderText("e.g., 2.0")
        bounds_layout.addWidget(x_max_input, 0, 3)
        
        # Y bounds
        bounds_layout.addWidget(QLabel("Y Min:"), 1, 0)
        y_min_input = QLineEdit()
        y_min_input.setText(str(self.optitrack_bounds_min_y))
        y_min_input.setPlaceholderText("e.g., -1.5")
        bounds_layout.addWidget(y_min_input, 1, 1)
        
        bounds_layout.addWidget(QLabel("Y Max:"), 1, 2)
        y_max_input = QLineEdit()
        y_max_input.setText(str(self.optitrack_bounds_max_y))
        y_max_input.setPlaceholderText("e.g., 1.5")
        bounds_layout.addWidget(y_max_input, 1, 3)
        
        layout.addLayout(bounds_layout)
        
        # Buttons
        button_layout = QHBoxLayout()
        apply_btn = QPushButton("Apply")
        apply_btn.setStyleSheet("background-color: #4CAF50; color: white;")
        cancel_btn = QPushButton("Cancel")
        button_layout.addWidget(apply_btn)
        button_layout.addWidget(cancel_btn)
        layout.addLayout(button_layout)
        
        cancel_btn.clicked.connect(dialog.reject)
        
        def apply_settings():
            try:
                preview_vel = int(preview_input.text())
                reality_vel = int(reality_input.text())
                
                if preview_vel < 1 or reality_vel < 1:
                    QMessageBox.warning(dialog, "Error", "Velocities must be positive integers!")
                    return
                
                # Validate OptiTrack bounds
                x_min = float(x_min_input.text())
                x_max = float(x_max_input.text())
                y_min = float(y_min_input.text())
                y_max = float(y_max_input.text())
                
                # Check that bounds define a valid area (can be negative, just need different values)
                if x_min == x_max:
                    QMessageBox.warning(dialog, "Error", "X Min and X Max must be different!")
                    return
                
                if y_min == y_max:
                    QMessageBox.warning(dialog, "Error", "Y Min and Y Max must be different!")
                    return
                
                self.preview_velocity = preview_vel
                self.reality_velocity = reality_vel
                self.optitrack_bounds_min_x = x_min
                self.optitrack_bounds_max_x = x_max
                self.optitrack_bounds_min_y = y_min
                self.optitrack_bounds_max_y = y_max
                self.save_settings()
                
                QMessageBox.information(dialog, "Success", 
                                       f"Settings updated!\n\n"
                                       f"Preview Velocity: {preview_vel}\n"
                                       f"Reality Velocity: {reality_vel}\n\n"
                                       f"OptiTrack Bounds:\n"
                                       f"X: [{x_min}, {x_max}]\n"
                                       f"Y: [{y_min}, {y_max}]")
                dialog.accept()
                
            except ValueError:
                QMessageBox.warning(dialog, "Error", "Please enter valid numeric values!")
        
        apply_btn.clicked.connect(apply_settings)
        
        dialog.exec_()

    def open_calibration_dialog(self):
        """Open robot-based calibration dialog"""
        self.open_robot_calibration_dialog()
    
    def open_robot_calibration_dialog(self):
        """Calibrate by positioning robots at corners and capturing their positions"""
        from PyQt5.QtCore import QTimer
        
        dialog = QDialog(self)
        dialog.setWindowTitle("Robot-Based Calibration")
        dialog.setGeometry(100, 50, 850, 800)
        
        layout = QVBoxLayout(dialog)
        
        # Title and instructions
        title = QLabel("<h2>🤖 Robot-Based Calibration</h2>")
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        info = QLabel(
            "<b>Instructions:</b><br>"
            "1. Manually move a robot to the <b>Top-Left corner</b> of the camera view<br>"
            "2. When positioned correctly, click <b>'Set Top-Left'</b> button<br>"
            "3. Repeat for all 4 corners (Top-Left → Top-Right → Bottom-Right → Bottom-Left)<br>"
            "4. Click <b>'Calibrate'</b> when all 4 corners are set"
        )
        info.setWordWrap(True)
        info.setStyleSheet("background-color: #fff3cd; padding: 10px; border: 1px solid #ffc107;")
        layout.addWidget(info)
        
        # OptiTrack status
        optitrack_status = QLabel("📡 OptiTrack: Connecting...")
        optitrack_status.setStyleSheet("font-weight: bold; padding: 5px;")
        layout.addWidget(optitrack_status)
        
        # Camera view with corner markers
        camera_label = QLabel()
        camera_label.setFixedSize(600, 400)
        camera_label.setStyleSheet("border: 2px solid #4CAF50; background-color: black;")
        camera_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(camera_label, alignment=Qt.AlignCenter)
        
        # Corner points storage
        corner_data = {
            'TL': None,  # {'pixmap': (x, y), 'real': (x, y), 'robot_id': id}
            'TR': None,
            'BR': None,
            'BL': None
        }
        robot_positions = {}  # Current robot positions from OptiTrack
        
        # Status label
        status_label = QLabel("📡 Connecting to OptiTrack... Please wait")
        status_label.setStyleSheet("font-weight: bold; color: #2196F3; font-size: 14px;")
        status_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(status_label)
        
        # Current robot info (which robot to use)
        current_robot_label = QLabel("")
        current_robot_label.setStyleSheet("background-color: #e8f5e9; padding: 10px; border: 1px solid #4CAF50; font-size: 13px;")
        current_robot_label.setWordWrap(True)
        layout.addWidget(current_robot_label)
        
        # Corner setting buttons
        corner_buttons_layout = QHBoxLayout()
        
        set_tl_btn = QPushButton("Set Top-Left")
        set_tl_btn.setStyleSheet("background-color: #2196F3; color: white; font-weight: bold; padding: 10px;")
        
        set_tr_btn = QPushButton("Set Top-Right")
        set_tr_btn.setStyleSheet("background-color: #2196F3; color: white; font-weight: bold; padding: 10px;")
        set_tr_btn.setEnabled(False)
        
        set_br_btn = QPushButton("Set Bottom-Right")
        set_br_btn.setStyleSheet("background-color: #2196F3; color: white; font-weight: bold; padding: 10px;")
        set_br_btn.setEnabled(False)
        
        set_bl_btn = QPushButton("Set Bottom-Left")
        set_bl_btn.setStyleSheet("background-color: #2196F3; color: white; font-weight: bold; padding: 10px;")
        set_bl_btn.setEnabled(False)
        
        corner_buttons_layout.addWidget(set_tl_btn)
        corner_buttons_layout.addWidget(set_tr_btn)
        corner_buttons_layout.addWidget(set_br_btn)
        corner_buttons_layout.addWidget(set_bl_btn)
        layout.addLayout(corner_buttons_layout)
        
        # Action buttons
        action_layout = QHBoxLayout()
        
        reset_btn = QPushButton("Reset All")
        reset_btn.setStyleSheet("background-color: #FF9800; color: white; padding: 10px;")
        
        calibrate_btn = QPushButton("Calibrate")
        calibrate_btn.setStyleSheet("background-color: #4CAF50; color: white; font-weight: bold; padding: 10px;")
        calibrate_btn.setEnabled(False)
        
        cancel_btn = QPushButton("Cancel")
        cancel_btn.setStyleSheet("padding: 10px;")
        
        action_layout.addWidget(reset_btn)
        action_layout.addWidget(calibrate_btn)
        action_layout.addWidget(cancel_btn)
        layout.addLayout(action_layout)
        
        # Initialize camera
        camera_capture = cv2.VideoCapture(0)
        camera_timer = QTimer()
        camera_pixmap = None
        
        # Initialize OptiTrack connection
        optitrack_socket = None
        optitrack_connected = False
        
        def connect_optitrack():
            nonlocal optitrack_socket, optitrack_connected
            try:
                optitrack_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                optitrack_socket.settimeout(2)
                optitrack_socket.connect((self.optitrack_server_ip, self.optitrack_port))
                optitrack_socket.setblocking(False)
                optitrack_connected = True
                optitrack_status.setText("📡 OptiTrack: ✓ Connected")
                optitrack_status.setStyleSheet("font-weight: bold; color: #4CAF50; padding: 5px;")
                status_label.setText("Click on Robot 2 (Top-Left corner)")
                status_label.setStyleSheet("font-weight: bold; color: #4CAF50; font-size: 14px;")
            except Exception as e:
                optitrack_status.setText(f"📡 OptiTrack: ✗ Failed - {str(e)}")
                optitrack_status.setStyleSheet("font-weight: bold; color: #F44336; padding: 5px;")
                status_label.setText("⚠️ OptiTrack not connected. Cannot calibrate.")
                status_label.setStyleSheet("font-weight: bold; color: #FF9800; font-size: 14px;")
        
        def read_optitrack_data():
            nonlocal robot_positions
            if not optitrack_connected or not optitrack_socket:
                return
            
            try:
                data = optitrack_socket.recv(4096).decode('utf-8')
                if data:
                    # Parse robot data: id,x,y,z,rotation;
                    robot_positions.clear()
                    entries = data.strip().split(';')
                    
                    for entry in entries:
                        if entry.strip():
                            parts = entry.split(',')
                            if len(parts) >= 5:
                                robot_id = int(parts[0])
                                x = float(parts[1])
                                y = -float(parts[2])  # Invert Y sign (server sends inverted Y)
                                z = float(parts[3])
                                rotation = float(parts[4])
                                
                                robot_positions[robot_id] = {
                                    'x': x, 'y': y, 'z': z, 'rotation': rotation
                                }
                    
                    # Update current robot info
                    if robot_positions and len(robot_positions) > 0:
                        # Get first robot (or specific robot if needed)
                        first_robot_id = sorted(robot_positions.keys())[0]
                        pos = robot_positions[first_robot_id]
                        info_text = f"<b>Current Robot {first_robot_id} Position:</b><br>"
                        info_text += f"X = {pos['x']:.3f}m, Y = {pos['y']:.3f}m, Z = {pos['z']:.3f}m, Rotation = {pos['rotation']:.1f}°"
                        current_robot_label.setText(info_text)
                    
            except socket.error:
                pass  # No data available
            except Exception as e:
                print(f"OptiTrack read error: {e}")
        
        def update_camera_frame():
            nonlocal camera_pixmap
            
            # Read OptiTrack data
            read_optitrack_data()
            
            # Update camera
            ret, frame = camera_capture.read()
            if ret:
                # Convert to QPixmap
                frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                h, w, ch = frame_rgb.shape
                bytes_per_line = ch * w
                qt_image = QImage(frame_rgb.data, w, h, bytes_per_line, QImage.Format_RGB888)
                
                # Scale to fit camera_label with KeepAspectRatio
                camera_pixmap = QPixmap.fromImage(qt_image).scaled(
                    camera_label.width(), 
                    camera_label.height(), 
                    Qt.KeepAspectRatio
                )
                
                # Draw corner markers on set corners
                painter = QPainter(camera_pixmap)
                painter.setRenderHint(QPainter.Antialiasing)
                
                # Calculate actual scaled size for corner positions
                actual_width = camera_pixmap.width()
                actual_height = camera_pixmap.height()
                
                # Draw corner markers for already-set corners
                corner_positions = {
                    'TL': (10, 10),  # Top-left corner of camera
                    'TR': (actual_width - 10, 10),  # Top-right
                    'BR': (actual_width - 10, actual_height - 10),  # Bottom-right
                    'BL': (10, actual_height - 10)  # Bottom-left
                }
                
                for corner_key, (cx, cy) in corner_positions.items():
                    if corner_data[corner_key] is not None:
                        # Draw filled circle for set corner
                        painter.setPen(QPen(QColor(0, 255, 0), 3))
                        painter.setBrush(QBrush(QColor(0, 255, 0, 200)))
                        painter.drawEllipse(int(cx - 12), int(cy - 12), 24, 24)
                        
                        # Draw label
                        painter.setPen(QPen(QColor(255, 255, 255), 2))
                        painter.setFont(QFont("Arial", 10, QFont.Bold))
                        robot_id = corner_data[corner_key]['robot_id']
                        painter.drawText(int(cx - 8), int(cy + 5), f"{corner_key}\nR{robot_id}")
                    else:
                        # Draw empty circle for unset corner
                        painter.setPen(QPen(QColor(255, 255, 0), 2))
                        painter.setBrush(QBrush(QColor(255, 255, 0, 100)))
                        painter.drawEllipse(int(cx - 10), int(cy - 10), 20, 20)
                        
                        # Draw label
                        painter.setPen(QPen(QColor(255, 255, 0), 2))
                        painter.setFont(QFont("Arial", 9, QFont.Bold))
                        painter.drawText(int(cx - 8), int(cy + 5), corner_key)
                
                painter.end()
                camera_label.setPixmap(camera_pixmap)
        
        # Button handlers for setting corners
        def set_corner(corner_key):
            """Set a corner position when button is clicked"""
            if not robot_positions or len(robot_positions) == 0:
                QMessageBox.warning(dialog, "No Robot Detected", 
                                   "No robot detected from OptiTrack!\n\n"
                                   "Make sure:\n"
                                   "1. OptiTrack is connected\n"
                                   "2. Robot is being tracked\n"
                                   "3. Data is being sent to port 5400")
                return
            
            # Get first robot's position
            robot_id = sorted(robot_positions.keys())[0]
            pos = robot_positions[robot_id]
            
            # Get camera frame dimensions for pixmap coordinate calculation
            if camera_pixmap:
                actual_width = camera_pixmap.width()
                actual_height = camera_pixmap.height()
                
                # Calculate scaling to 600x400 boundary
                scale_x = 600 / actual_width
                scale_y = 400 / actual_height
                
                # Offset in boundary (letterbox offset)
                offset_x = (600 - actual_width * scale_x) / 2
                offset_y = (400 - actual_height * scale_y) / 2
                
                # Calculate pixmap position for this corner
                corner_positions = {
                    'TL': (10, 10),
                    'TR': (actual_width - 10, 10),
                    'BR': (actual_width - 10, actual_height - 10),
                    'BL': (10, actual_height - 10)
                }
                
                cam_x, cam_y = corner_positions[corner_key]
                
                # Scale to boundary coordinates
                pix_x = cam_x * scale_x + offset_x
                pix_y = cam_y * scale_y + offset_y
                
                # Store corner data
                corner_data[corner_key] = {
                    'pixmap': (pix_x, pix_y),
                    'real': (pos['x'], pos['y']),
                    'robot_id': robot_id
                }
                
                # Update status
                corner_names = {'TL': 'Top-Left', 'TR': 'Top-Right', 'BR': 'Bottom-Right', 'BL': 'Bottom-Left'}
                status_label.setText(f"✓ {corner_names[corner_key]} corner set (Robot {robot_id})")
                
                # Check if all corners are set
                if all(corner_data[k] is not None for k in ['TL', 'TR', 'BR', 'BL']):
                    status_label.setText("✓ All 4 corners set! Click 'Calibrate' to finish.")
                    status_label.setStyleSheet("font-weight: bold; color: #2196F3; font-size: 14px;")
                    calibrate_btn.setEnabled(True)
        
        # Connect buttons to set_corner function
        set_tl_btn.clicked.connect(lambda: set_corner('TL'))
        set_tr_btn.clicked.connect(lambda: set_corner('TR'))
        set_br_btn.clicked.connect(lambda: set_corner('BR'))
        set_bl_btn.clicked.connect(lambda: set_corner('BL'))
        
        def reset_points():
            """Reset all corner data"""
            for key in corner_data:
                corner_data[key] = None
            status_label.setText("Position robot at Top-Left corner, then click 'Set Top-Left'")
            status_label.setStyleSheet("font-weight: bold; color: #4CAF50; font-size: 14px;")
            calibrate_btn.setEnabled(False)
        
        def do_calibration():
            """Perform calibration using captured corner data"""
            try:
                # Check if all corners are set
                if any(corner_data[k] is None for k in ['TL', 'TR', 'BR', 'BL']):
                    QMessageBox.warning(dialog, "Incomplete Calibration",
                                       "Not all corners have been set!\n\n"
                                       "Please set all 4 corners before calibrating.")
                    return
                
                # Extract pixmap and real-world coordinates in correct order
                corner_order = ['TL', 'TR', 'BR', 'BL']
                pixmap_corners = [corner_data[k]['pixmap'] for k in corner_order]
                realworld_corners = [corner_data[k]['real'] for k in corner_order]
                
                # Set calibration
                success = self.coordinate_transformer.set_calibration(pixmap_corners, realworld_corners)
                
                if success:
                    # Save calibration
                    self.coordinate_transformer.save_calibration()
                    
                    # Update status label
                    self.calibration_status_label.setText("<b>Status:</b> ✓ Calibrated (Robot-Based)")
                    
                    # Stop camera and close OptiTrack
                    camera_timer.stop()
                    camera_capture.release()
                    if optitrack_socket:
                        optitrack_socket.close()
                    
                    # Show success message with details
                    details = "Calibration Points:\n\n"
                    corner_names = {'TL': 'Top-Left', 'TR': 'Top-Right', 'BR': 'Bottom-Right', 'BL': 'Bottom-Left'}
                    for k in corner_order:
                        px, py = corner_data[k]['pixmap']
                        rx, ry = corner_data[k]['real']
                        robot_id = corner_data[k]['robot_id']
                        details += f"{corner_names[k]} (Robot {robot_id}):\n"
                        details += f"  Pixmap: ({px:.1f}, {py:.1f})\n"
                        details += f"  Real: ({rx:.3f}, {ry:.3f})m\n\n"
                    
                    QMessageBox.information(dialog, "Success", 
                                           "Robot-based calibration successful!\n\n" + details)
                    dialog.accept()
                else:
                    QMessageBox.warning(dialog, "Error", "Calibration failed! Please check your corner positions.")
                
            except Exception as e:
                QMessageBox.warning(dialog, "Error", f"Calibration failed: {str(e)}")
        
        def cleanup():
            camera_timer.stop()
            camera_capture.release()
            if optitrack_socket:
                try:
                    optitrack_socket.close()
                except:
                    pass
        
        reset_btn.clicked.connect(reset_points)
        calibrate_btn.clicked.connect(do_calibration)
        cancel_btn.clicked.connect(lambda: (cleanup(), dialog.reject()))
        
        # Connect to OptiTrack
        connect_optitrack()
        
        # Start camera updates
        camera_timer.timeout.connect(update_camera_frame)
        camera_timer.start(30)  # 30ms = ~33 FPS
        
        dialog.exec_()
        cleanup()
    
    def open_optitrack_viz_calibration_dialog(self):
        """Enhanced calibration dialog with live preview"""
        dialog = QDialog(self)
        dialog.setWindowTitle("OptiTrack Visualization Calibration")
        dialog.setGeometry(100, 50, 1200, 700)
        
        main_layout = QHBoxLayout(dialog)
        
        # Left side: Input fields
        left_layout = QVBoxLayout()
        
        # Title and instructions
        title = QLabel("<h2>🎯 OptiTrack Calibration</h2>")
        title.setAlignment(Qt.AlignCenter)
        left_layout.addWidget(title)
        
        info = QLabel(
            "<b>Instructions:</b><br>"
            "1. Enter the 4 corners of your frame in OptiTrack coordinates<br>"
            "2. Place your robot at (0, 0) to verify centering<br>"
            "3. The preview shows a red dot at (0, 0) - it should be centered<br>"
            "4. White frame updates as you type<br><br>"
            "<b>Coordinate System:</b> X+ = Right, Y+ = Up"
        )
        info.setWordWrap(True)
        info.setStyleSheet("padding: 10px; background-color: #f0f0f0; border: 1px solid #ccc;")
        left_layout.addWidget(info)
        
        # Corner input fields
        corner_names = ["Top-Left", "Top-Right", "Bottom-Right", "Bottom-Left"]
        corner_inputs = []
        
        for i, corner_name in enumerate(corner_names):
            corner_group = QGroupBox(f"{corner_name} (OptiTrack Coordinates)")
            corner_layout = QHBoxLayout()
            
            corner_layout.addWidget(QLabel("X (m):"))
            x_input = QLineEdit()
            x_input.setPlaceholderText("e.g., -0.7" if i in [0, 3] else "e.g., 0.7")
            corner_layout.addWidget(x_input)
            
            corner_layout.addWidget(QLabel("Y (m):"))
            y_input = QLineEdit()
            y_input.setPlaceholderText("e.g., 0.5" if i in [0, 1] else "e.g., -0.5")
            corner_layout.addWidget(y_input)
            
            corner_group.setLayout(corner_layout)
            left_layout.addWidget(corner_group)
            
            corner_inputs.append((x_input, y_input))
        
        left_layout.addStretch()
        
        # Buttons
        button_layout = QHBoxLayout()
        
        calibrate_btn = QPushButton("Calibrate")
        calibrate_btn.setStyleSheet("background-color: #9C27B0; color: white; font-weight: bold; padding: 10px;")
        
        cancel_btn = QPushButton("Cancel")
        cancel_btn.setStyleSheet("padding: 10px;")
        
        button_layout.addWidget(calibrate_btn)
        button_layout.addWidget(cancel_btn)
        left_layout.addLayout(button_layout)
        
        main_layout.addLayout(left_layout, 1)
        
        # Right side: Live preview canvas
        preview_widget = QWidget()
        preview_layout = QVBoxLayout(preview_widget)
        preview_layout.setContentsMargins(0, 0, 0, 0)
        
        preview_label = QLabel("<h3>Live Preview</h3>")
        preview_label.setAlignment(Qt.AlignCenter)
        preview_layout.addWidget(preview_label)
        
        # Create preview canvas (black background)
        preview_canvas = OptiTrackCalibrationPreview(dialog, self)
        preview_layout.addWidget(preview_canvas)
        
        main_layout.addWidget(preview_widget, 2)
        
        # Connect input changes to preview update
        def update_preview():
            try:
                corners = []
                for x_input, y_input in corner_inputs:
                    x_text = x_input.text().strip()
                    y_text = y_input.text().strip()
                    if x_text and y_text:
                        corners.append((float(x_text), float(y_text)))
                
                if len(corners) == 4:
                    # Pass raw corners - do NOT adjust them yet
                    # Let update_frame use the exact values entered
                    preview_canvas.update_frame(corners, adjust=False)
                else:
                    preview_canvas.update_frame(None, adjust=False)
            except ValueError:
                preview_canvas.update_frame(None, adjust=False)
        
        for x_input, y_input in corner_inputs:
            x_input.textChanged.connect(update_preview)
            y_input.textChanged.connect(update_preview)
        
        # Initial preview with default frame
        preview_canvas.update_frame(None, adjust=False)
        
        cancel_btn.clicked.connect(dialog.reject)
        
        def do_calibration():
            try:
                # Parse corner inputs
                corners = []
                for x_input, y_input in corner_inputs:
                    x = float(x_input.text())
                    y = float(y_input.text())
                    corners.append((x, y))
                
                # Set calibration (will auto-adjust to rectangle)
                success = self.set_optitrack_viz_calibration(corners)
                
                if success:
                    # Update status label
                    self.optitrack_viz_status_label.setText("<b>Status:</b> ✓ Calibrated")
                    
                    adjusted_text = "Calibration successful!\\n\\n"
                    adjusted_text += "Your input corners were auto-adjusted to form a rectangle:\\n"
                    for i, (x, y) in enumerate(self.optitrack_viz_corners):
                        adjusted_text += f"{corner_names[i]}: ({x:.4f}, {y:.4f})\\n"
                    
                    QMessageBox.information(dialog, "Success", adjusted_text)
                    
                    # Update preview to show the calibrated frame (adjusted corners)
                    preview_canvas.update_frame(self.optitrack_viz_corners, adjust=False)
                    
                    # Redraw axes with new bounds
                    preview_canvas.draw_axes()
                    
                    # Don't close - let user see the frame and close manually
                    # dialog.accept()  # Removed - user clicks Cancel/X to close
                else:
                    QMessageBox.warning(dialog, "Error", "Calibration failed! Please check your values.")
                
            except ValueError:
                QMessageBox.warning(dialog, "Error", "Please enter valid numeric values for all corners!")
        
        calibrate_btn.clicked.connect(do_calibration)
        
        dialog.exec_()
    
    def open_pixmap_calibration_dialog(self):
        """Original calibration method with fixed pixmap coordinates"""
        dialog = QDialog(self)
        dialog.setWindowTitle("Pixmap Coordinate Calibration")
        dialog.setGeometry(200, 100, 600, 500)
        
        layout = QVBoxLayout(dialog)
        
        # Title and instructions
        title = QLabel("<h2> ️ Pixmap Calibration</h2>")
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        info = QLabel(
            "<b>Instructions:</b><br>"
            "Enter the real-world OptiTrack coordinates for the 4 corners of your playing field.<br>"
            "Pixmap coordinates are fixed as: (0,0), (600,0), (600,400), (0,400)"
        )
        info.setWordWrap(True)
        layout.addWidget(info)
        
        # Corner input fields
        corner_names = ["Top-Left (0, 0)", "Top-Right (600, 0)", 
                       "Bottom-Right (600, 400)", "Bottom-Left (0, 400)"]
        
        corner_inputs = []
        for i, corner_name in enumerate(corner_names):
            corner_group = QGroupBox(corner_name)
            corner_layout = QHBoxLayout()
            
            corner_layout.addWidget(QLabel("Real X (m):"))
            x_input = QLineEdit()
            x_input.setPlaceholderText("e.g., 0.5")
            corner_layout.addWidget(x_input)
            
            corner_layout.addWidget(QLabel("Real Y (m):"))
            y_input = QLineEdit()
            y_input.setPlaceholderText("e.g., -0.3")
            corner_layout.addWidget(y_input)
            
            corner_group.setLayout(corner_layout)
            layout.addWidget(corner_group)
            
            corner_inputs.append((x_input, y_input))
        
        # Current calibration status
        if self.coordinate_transformer.is_calibrated:
            status_text = "<b>Current Calibration:</b><br>" + self.coordinate_transformer.get_calibration_info().replace('\n', '<br>')
            status_label = QLabel(status_text)
            status_label.setWordWrap(True)
            status_label.setStyleSheet("background-color: #e8f5e9; padding: 10px; border: 1px solid #4caf50;")
            layout.addWidget(status_label)
        
        # Buttons
        button_layout = QHBoxLayout()
        
        calibrate_btn = QPushButton("Calibrate")
        calibrate_btn.setStyleSheet("background-color: #4CAF50; color: white; font-weight: bold; padding: 10px;")
        
        test_btn = QPushButton("Test Conversion")
        test_btn.setStyleSheet("background-color: #2196F3; color: white; padding: 10px;")
        
        cancel_btn = QPushButton("Cancel")
        cancel_btn.setStyleSheet("padding: 10px;")
        
        button_layout.addWidget(calibrate_btn)
        button_layout.addWidget(test_btn)
        button_layout.addWidget(cancel_btn)
        layout.addLayout(button_layout)
        
        cancel_btn.clicked.connect(dialog.reject)
        
        def do_calibration():
            try:
                # Parse corner inputs
                realworld_corners = []
                for x_input, y_input in corner_inputs:
                    x = float(x_input.text())
                    y = float(y_input.text())
                    realworld_corners.append((x, y))
                
                # Pixmap corners (fixed)
                pixmap_corners = [(0, 0), (600, 0), (600, 400), (0, 400)]
                
                # Set calibration
                success = self.coordinate_transformer.set_calibration(pixmap_corners, realworld_corners)
                
                if success:
                    # Save calibration
                    self.coordinate_transformer.save_calibration()
                    
                    # Update status label
                    self.calibration_status_label.setText("<b>Status:</b> ✓ Calibrated (Fixed Pixmap)")
                    
                    QMessageBox.information(dialog, "Success", 
                                           "Calibration successful!\n\n" + 
                                           self.coordinate_transformer.get_calibration_info())
                    dialog.accept()
                else:
                    QMessageBox.warning(dialog, "Error", "Calibration failed! Please check your values.")
                
            except ValueError:
                QMessageBox.warning(dialog, "Error", "Please enter valid numeric values for all corners!")
        
        def test_conversion():
            try:
                # Test conversion with center point
                test_x, test_y = 300, 200  # Center of pixmap
                real_x, real_y = self.coordinate_transformer.pixmap_to_realworld(test_x, test_y)
                
                QMessageBox.information(dialog, "Test Conversion",
                                       f"Test Point Conversion:\n\n"
                                       f"Pixmap: ({test_x}, {test_y})\n"
                                       f"Real World: ({real_x:.4f}, {real_y:.4f}) meters\n\n"
                                       f"Note: This uses current calibration data.")
            except Exception as e:
                QMessageBox.warning(dialog, "Error", f"Test failed: {e}")
        
        calibrate_btn.clicked.connect(do_calibration)
        test_btn.clicked.connect(test_conversion)
        
        dialog.exec_()

    def change_level(self, index):
        """Change the current level"""
        # Calculate the NEW level number first
        new_level = index + 1
        
        # No need to save current solution to cache before changing levels 
        # already done in draw_solution
        
        # Clear current solution display before loading new level
        self.game_canvas.clear_solution()
        
        # Update current level to NEW level
        self.current_level = new_level
        print(f"[DEBUG] Switching to NEW level {self.current_level}")
        
        # Load the level first (this sets up the scene properly)
        self.game_canvas.load_level(self.current_level)
        
        # Load cached solution for NEW level if it exists
        cached_solution = self.load_solution_cache(self.current_level)
        
        # Check if cached solution is valid (same as execute_solution check)
        if cached_solution and not all(len(path) == 0 for path in cached_solution.values()):
            print(f"[DEBUG] Applying cached solution to NEW level {self.current_level}")
            self.game_canvas.solution_paths = cached_solution
            self.game_canvas.draw_solution_overlay()
        else:
            print(f"[DEBUG] No valid cache for NEW level {self.current_level}, starting fresh")
            self.game_canvas.solution_paths = {}
        
        self.update_customize_button()


    def prev_level(self):
        """Go to previous level"""
        if self.current_level > 1:
            self.current_level -= 1
            self.level_combo.setCurrentIndex(self.current_level - 1)
    
    def next_level(self):
        """Go to next level"""
        if self.current_level < 5:
            self.current_level += 1
            self.level_combo.setCurrentIndex(self.current_level - 1)
    
    def update_customize_button(self):
        """Enable/disable customize button based on current level"""
        is_custom = not self.levels[self.current_level]['fixed']
        self.customize_btn.setEnabled(is_custom)
        if is_custom:
            self.customize_btn.setStyleSheet("background-color: #2196F3; color: white;")
        else:
            self.customize_btn.setStyleSheet("background-color: #cccccc; color: #666666;")
    
    def customize_level(self):
        """Open customize level popup"""
        if self.levels[self.current_level]['fixed']:
            QMessageBox.warning(self, "Cannot Customize", "This is a fixed level and cannot be customized!")
            return
        
        dialog = CustomizeLevelDialog(self, self.current_level)
        if dialog.exec_() == QDialog.Accepted:
            # Save custom levels to file
            self.save_custom_levels()
            
            # Reload the level with new configuration
            self.game_canvas.load_level(self.current_level)
            QMessageBox.information(self, "Success", "Level customized and saved successfully!")

    def draw_solution(self):
        """Open draw solution popup"""
        dialog = DrawSolutionDialog(self, self.current_level)
        if dialog.exec_() == QDialog.Accepted:
            # Get the solution from dialog
            solution = dialog.get_solution()
            
            # Store solution in game canvas
            self.game_canvas.solution_paths = solution
            
            # Save to cache only (not permanent storage)
            self.save_solution_cache(self.current_level, solution)
            
            # Reload canvas to show overlay
            self.game_canvas.draw_solution_overlay()
            
            QMessageBox.information(self, "Success", "Solution saved to session!")



    def save_solution(self, level_num, solution):
        """Save solution data and image locally"""
        solution_dir = os.path.join(self.data_dir, 'solutions')
        os.makedirs(solution_dir, exist_ok=True)
        
        # Normalize solution paths to always start from the start dot
        normalized_solution = self.normalize_solution_paths(level_num, solution)
        
        # Save solution path data as JSON
        solution_file = os.path.join(solution_dir, f'level_{level_num}_solution.json')
        with open(solution_file, 'w') as f:
            json.dump(normalized_solution, f, indent=2)
        
        # Generate and save solution image
        image_file = os.path.join(solution_dir, f'level_{level_num}_solution.png')
        self.game_canvas.save_solution_image(image_file, normalized_solution)
        
        print(f"[INFO] Solution saved: {solution_file}")
        print(f"[INFO] Solution image saved: {image_file}")

    def normalize_solution_paths(self, level_num, solution):
        """Normalize solution paths to always start from the start dot"""
        level_data = self.levels[level_num]
        normalized = {}
        
        for color_name, path in solution.items():
            if len(path) < 2:
                normalized[color_name] = path
                continue
            
            start_pos = level_data['dots'][color_name]['start']
            end_pos = level_data['dots'][color_name]['end']
            
            path_start = path[0]
            path_end = path[-1]
            
            # Calculate distances
            start_to_start = ((path_start[0] - start_pos[0]) ** 2 + 
                            (path_start[1] - start_pos[1]) ** 2) ** 0.5
            start_to_end = ((path_start[0] - end_pos[0]) ** 2 + 
                        (path_start[1] - end_pos[1]) ** 2) ** 0.5
            
            # If path starts at end dot, reverse it
            if start_to_end < start_to_start:
                normalized[color_name] = list(reversed(path))
                print(f"[INFO] Reversed {color_name} path to start from start dot")
            else:
                normalized[color_name] = path
        
        return normalized

    def load_solution(self, level_num):
        """Load solution data from file"""
        solution_file = os.path.join(self.data_dir, 'solutions', f'level_{level_num}_solution.json')
        if os.path.exists(solution_file):
            with open(solution_file, 'r') as f:
                return json.load(f)
        return None
    
    def clear_solution(self):
        """Clear current solution"""
        self.game_canvas.clear_solution()
        QMessageBox.information(self, "Cleared", "Solution cleared from canvas.")

  
    def preview_solution(self):
        """Preview solution animation"""
        # Check if solution exists in current session (not from disk)
        solution = self.game_canvas.solution_paths
        
        if not solution or all(len(path) == 0 for path in solution.values()):
            QMessageBox.warning(self, "No Solution", 
                               "No solution drawn for this level!\n\n"
                               "Please draw a solution first using 'Draw Solution' button.")
            return
        
        # Open preview dialog
        dialog = PreviewDialog(self, self.current_level, solution, self.preview_velocity)
        dialog.exec_()


    def execute_solution(self):
        """Execute solution with multi-robot system"""
        # Check if solution exists in current session (not from disk)
        solution = self.game_canvas.solution_paths
        
        # Check if solution is empty or not drawn yet
        if not solution or all(len(path) == 0 for path in solution.values()):
            QMessageBox.warning(self, "No Solution", 
                               "No solution drawn for this level!\n\n"
                               "Please draw a solution first using 'Draw Solution' button.")
            return
        
        # Ask for player name
        player_name, ok = QInputDialog.getText(self, "Execute Solution",
                                              "Enter your name:",
                                              QLineEdit.Normal,
                                              "Player")
        
        if not ok or not player_name.strip():
            return
        
        player_name = player_name.strip()
        
        # Open execution dialog
        exec_dialog = ExecutionDialog(self, self.current_level, solution, player_name)
        result = exec_dialog.exec_()
        
        # Get completion time and status
        completion_time = exec_dialog.completion_time
        execution_status = exec_dialog.execution_status
        
        # Show result and ask if user wants to save to highscore
        if execution_status == "DONE":
            # Successfully completed
            reply = QMessageBox.question(
                self, 
                "Execution Complete",
                f"Solution executed successfully!\n\n"
                f"Player: {player_name}\n"
                f"Time: {completion_time:.2f} seconds\n\n"
                f"Would you like to save this score to the highscore table?",
                QMessageBox.Yes | QMessageBox.No
            )
            
            if reply == QMessageBox.Yes:
                # Save to permanent storage (for highscore)
                self.save_solution(self.current_level, solution)
                
                # Add to highscore
                self.add_highscore(self.current_level, player_name, completion_time, solution)
                
                QMessageBox.information(self, "Saved", 
                                       "Your score has been added to the highscore table!")
                
                # Switch to highscore tab to show the new entry
                self.tabs.setCurrentIndex(1)  # Switch to HighScore tab
                self.hs_level_combo.setCurrentIndex(self.current_level - 1)  # Show current level
                
                print(f"[INFO] Solution executed for {player_name}")
                print(f"[INFO] Level: {self.current_level}")
                print(f"[INFO] Time: {completion_time:.2f}s")
                print(f"[INFO] Added to highscore table")
            else:
                QMessageBox.information(self, "Not Saved", 
                                       "Score was not saved to highscore table.")
                print(f"[INFO] Solution executed for {player_name} but not saved")
        else:
            # Dialog was closed early, aborted, or timed out - with penalty
            penalty_reason = "unknown"
            if "timeout" in execution_status.lower():
                penalty_reason = "execution timeout (>60s)"
            elif "abort" in execution_status.lower():
                penalty_reason = "user aborted"
            elif "error" in execution_status.lower():
                penalty_reason = "closed early"
            
            reply = QMessageBox.question(
                self,
                "Execution Incomplete",
                f"Execution was not completed!\n\n"
                f"Reason: {penalty_reason}\n"
                f"Status: {execution_status}\n"
                f"Time: {completion_time:.2f}s (penalty applied)\n\n"
                f"Would you like to save this penalized score to the highscore table?",
                QMessageBox.Yes | QMessageBox.No
            )
            
            if reply == QMessageBox.Yes:
                # Save even the penalized score if user wants
                self.save_solution(self.current_level, solution)
                self.add_highscore(self.current_level, player_name, completion_time, solution)
                
                QMessageBox.information(self, "Saved", 
                                       "Your penalized score has been added to the highscore table.")
                
                self.tabs.setCurrentIndex(1)
                self.hs_level_combo.setCurrentIndex(self.current_level - 1)
                
                print(f"[INFO] Penalized score saved for {player_name}")
            else:
                QMessageBox.information(self, "Not Saved", 
                                       "Score was not saved to highscore table.")
                print(f"[WARNING] Execution incomplete for {player_name}, not saved")
            
            print(f"[WARNING] Status: {execution_status}, Time: {completion_time:.2f}s")



class GameCanvas(QGraphicsView):
    def __init__(self, parent):
        super().__init__(parent)
        self.parent_window = parent
        self.scene = QGraphicsScene()
        self.setScene(self.scene)
        
        self.setRenderHint(QPainter.Antialiasing)
        self.setStyleSheet("background-color: white; border: 2px solid #333333;")
        
        # Set minimum size to prevent tiny initial viewport
        self.setMinimumSize(600, 400)
        
        self.current_level = None
        self.solution_paths = {}
        self.solution_items = []  # Store solution graphic items for easy removal
        
        self.load_level(1)
    
    def load_level(self, level_num):
        """Load and display a level"""
        self.current_level = level_num
        level_data = self.parent_window.levels[level_num]
        
        # Clear scene
        self.scene.clear()
        
        # Get boundary
        boundary = level_data['boundary']
        
        # Draw boundary rectangle
        pen = QPen(QColor(0, 0, 0), 2)
        self.scene.addRect(0, 0, boundary['width'], boundary['height'], pen)
        
        # Draw dots
        dot_radius = 15
        for color_name, positions in level_data['dots'].items():
            # Skip if positions are None (robot not active in this level)
            if positions['start'] is None or positions['end'] is None:
                continue
                
            color = self.parent_window.colors[color_name]
            
            # Start dot
            start_x, start_y = positions['start']
            self.scene.addEllipse(start_x - dot_radius, start_y - dot_radius,
                                 dot_radius * 2, dot_radius * 2,
                                 QPen(color, 2), color)
            
            # End dot
            end_x, end_y = positions['end']
            self.scene.addEllipse(end_x - dot_radius, end_y - dot_radius,
                                 dot_radius * 2, dot_radius * 2,
                                 QPen(color, 2), color)
        
        # Fit view
        self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)
    
    def resizeEvent(self, event):
        """Re-fit view when widget is resized"""
        super().resizeEvent(event)
        if self.scene.sceneRect():
            self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)


    def draw_solution_overlay(self):
        """Draw solution paths as overlay on the canvas"""
        # Remove old solution overlay
        for item in self.solution_items:
            self.scene.removeItem(item)
        self.solution_items.clear()
        
        # Draw new solution
        if not self.solution_paths:
            return
        
        for color_name, path in self.solution_paths.items():
            if len(path) < 2:
                continue
            
            color = self.parent_window.colors[color_name]
            pen = QPen(color, 6, Qt.SolidLine, Qt.RoundCap, Qt.RoundJoin)
            pen.setColor(QColor(color.red(), color.green(), color.blue(), 180))  # Semi-transparent
            
            for i in range(len(path) - 1):
                x1, y1 = path[i]
                x2, y2 = path[i + 1]
                line = self.scene.addLine(x1, y1, x2, y2, pen)
                self.solution_items.append(line)
    

    def save_solution_image(self, filepath, solution):
        """Save solution as an image file"""
        # Create a temporary scene with full solution
        temp_scene = QGraphicsScene()
        level_data = self.parent_window.levels[self.current_level]
        boundary = level_data['boundary']
        
        # Draw boundary
        pen = QPen(QColor(0, 0, 0), 2)
        temp_scene.addRect(0, 0, boundary['width'], boundary['height'], pen)
        
        # Draw dots
        dot_radius = 15
        for color_name, positions in level_data['dots'].items():
            # Skip if positions are None (robot not active in this level)
            if positions['start'] is None or positions['end'] is None:
                continue
                
            color = self.parent_window.colors[color_name]
            
            # Start dot
            start_x, start_y = positions['start']
            temp_scene.addEllipse(start_x - dot_radius, start_y - dot_radius,
                                 dot_radius * 2, dot_radius * 2,
                                 QPen(color, 2), color)
            
            # End dot
            end_x, end_y = positions['end']
            temp_scene.addEllipse(end_x - dot_radius, end_y - dot_radius,
                                 dot_radius * 2, dot_radius * 2,
                                 QPen(color, 2), color)
        
        # Draw solution paths
        for color_name, path in solution.items():
            if len(path) < 2:
                continue
            
            color = self.parent_window.colors[color_name]
            pen = QPen(color, 4)
            
            for i in range(len(path) - 1):
                x1, y1 = path[i]
                x2, y2 = path[i + 1]
                temp_scene.addLine(x1, y1, x2, y2, pen)
        
        # Render to image
        image = QPixmap(boundary['width'], boundary['height'])
        image.fill(Qt.white)
        painter = QPainter(image)
        painter.setRenderHint(QPainter.Antialiasing)
        temp_scene.render(painter)
        painter.end()
        
        # Save image
        image.save(filepath)
    
    def clear_solution(self):
        """Clear the current solution"""
        self.solution_paths = {}
        for item in self.solution_items:
            self.scene.removeItem(item)
        self.solution_items.clear()



class DrawSolutionDialog(QDialog):
    """Dialog for drawing solution paths"""


    def __init__(self, parent, level_num):
        super().__init__(parent)
        self.parent_window = parent
        self.level_num = level_num
        self.level_data = parent.levels[level_num]
        
        self.setWindowTitle(f"Draw Solution - {self.level_data['name']}")
        self.setGeometry(150, 100, 900, 750)
        
        layout = QVBoxLayout(self)
        
        # Title
        title = QLabel(f"<h2>Draw Solution - {self.level_data['name']}</h2>")
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        # Instructions
        instructions = QLabel(
            "Click and drag to draw paths connecting Start to End dots.\n"
            "Draw one color at a time. Click 'Next Color' when finished with current color.\n"
            "Paths must be continuous and connect the start to end dot.\n"
            "💡 Press SPACEBAR to advance to next color."
        )
        instructions.setAlignment(Qt.AlignCenter)
        instructions.setStyleSheet("padding: 10px; background-color: #f0f0f0; border: 1px solid #ccc;")
        layout.addWidget(instructions)
        
        # Current mode display
        self.mode_label = QLabel()
        self.mode_label.setAlignment(Qt.AlignCenter)
        self.mode_label.setStyleSheet("font-size: 16px; font-weight: bold; padding: 10px;")
        layout.addWidget(self.mode_label)
        
        # Initialize state - only include colors that are active in this level
        all_colors = ['red', 'green', 'blue', 'yellow']
        self.colors = [
            color for color in all_colors 
            if self.level_data['dots'][color]['start'] is not None 
            and self.level_data['dots'][color]['end'] is not None
        ]
        self.current_color_idx = 0
        
        # Store drawn paths
        self.solution_paths = {
            'red': [],
            'green': [],
            'blue': [],
            'yellow': []
        }
        
        # Canvas for drawing
        self.canvas = DrawSolutionCanvas(self, self.level_data)
        layout.addWidget(self.canvas)
        
        # Control buttons - Row 1
        control_layout = QHBoxLayout()
        
        self.next_btn = QPushButton("Next Color (Space)")
        self.next_btn.setStyleSheet("background-color: #2196F3; color: white; font-weight: bold; padding: 10px;")
        self.next_btn.clicked.connect(self.next_color)
        control_layout.addWidget(self.next_btn)
        
        clear_current_btn = QPushButton("Clear Current Color")
        clear_current_btn.setStyleSheet("background-color: #FF9800; color: white; font-weight: bold; padding: 10px;")
        clear_current_btn.clicked.connect(self.clear_current_color)
        control_layout.addWidget(clear_current_btn)
        
        reset_btn = QPushButton("Reset All")
        reset_btn.setStyleSheet("background-color: #f44336; color: white; font-weight: bold; padding: 10px;")
        reset_btn.clicked.connect(self.reset_all)
        control_layout.addWidget(reset_btn)
        
        layout.addLayout(control_layout)
        
        # Auto-generate buttons - Row 2
        auto_layout = QHBoxLayout()
        
        fastest_btn = QPushButton("⚡ Generate Fastest Solution")
        fastest_btn.setStyleSheet("background-color: #9C27B0; color: white; font-weight: bold; padding: 10px;")
        fastest_btn.clicked.connect(self.generate_fastest_solution)
        auto_layout.addWidget(fastest_btn)
        
        random_btn = QPushButton("🎲 Generate Random Solution")
        random_btn.setStyleSheet("background-color: #00BCD4; color: white; font-weight: bold; padding: 10px;")
        random_btn.clicked.connect(self.generate_random_solution)
        auto_layout.addWidget(random_btn)
        
        layout.addLayout(auto_layout)
        
        # Confirm/Cancel buttons
        button_layout = QHBoxLayout()
        
        confirm_btn = QPushButton("Confirm Solution")
        confirm_btn.setStyleSheet("background-color: #4CAF50; color: white; font-weight: bold; padding: 15px;")
        confirm_btn.clicked.connect(self.confirm_solution)
        button_layout.addWidget(confirm_btn)
        
        cancel_btn = QPushButton("Cancel")
        cancel_btn.setStyleSheet("background-color: #9E9E9E; color: white; font-weight: bold; padding: 15px;")
        cancel_btn.clicked.connect(self.reject)
        button_layout.addWidget(cancel_btn)
        
        layout.addLayout(button_layout)
        
        self.update_mode_label()

    def generate_fastest_solution(self):
        """Generate fastest (straight line) solution for all colors"""
        reply = QMessageBox.question(self, "Generate Fastest Solution",
                                     "This will replace all current paths with straight lines.\n\n"
                                     "Continue?",
                                     QMessageBox.Yes | QMessageBox.No)
        
        if reply != QMessageBox.Yes:
            return
        
        for color in self.colors:
            start_pos = self.level_data['dots'][color]['start']
            end_pos = self.level_data['dots'][color]['end']
            
            # Generate straight line with points every 5 pixels
            x1, y1 = start_pos
            x2, y2 = end_pos
            
            distance = ((x2 - x1) ** 2 + (y2 - y1) ** 2) ** 0.5
            num_points = max(2, int(distance / 5))  # Point every 5 pixels
            
            path = []
            for i in range(num_points):
                t = i / (num_points - 1)
                x = int(x1 + t * (x2 - x1))
                y = int(y1 + t * (y2 - y1))
                path.append((x, y))
            
            self.solution_paths[color] = path
        
        self.canvas.update()
        QMessageBox.information(self, "Success", "Fastest (straight line) solution generated for all active colors!")
    
    def generate_random_solution(self):
        """Generate random curved solution using simple waypoints"""
        reply = QMessageBox.question(self, "Generate Random Solution",
                                     "This will replace all current paths with random curves.\n\n"
                                     "Continue?",
                                     QMessageBox.Yes | QMessageBox.No)
        
        if reply != QMessageBox.Yes:
            return
        
        boundary = self.level_data['boundary']
        
        for color in self.colors:
            start_pos = self.level_data['dots'][color]['start']
            end_pos = self.level_data['dots'][color]['end']
            
            x1, y1 = start_pos
            x2, y2 = end_pos
            
            # Generate random waypoints between start and end (within boundary)
            num_waypoints = random.randint(2, 3)  # 2-3 waypoints for variety
            
            waypoints = [(x1, y1)]  # Start with start position
            
            # Add random waypoints within safe boundary margins
            margin = 50
            for _ in range(num_waypoints):
                rand_x = random.uniform(margin, boundary['width'] - margin)
                rand_y = random.uniform(margin, boundary['height'] - margin)
                waypoints.append((rand_x, rand_y))
            
            waypoints.append((x2, y2))  # End with end position
            
            # Create smooth path by interpolating between waypoints
            path = []
            points_per_segment = 20  # Points between each waypoint pair
            
            for i in range(len(waypoints) - 1):
                wx1, wy1 = waypoints[i]
                wx2, wy2 = waypoints[i + 1]
                
                # Linear interpolation between waypoints
                for j in range(points_per_segment):
                    t = j / points_per_segment
                    x = int(wx1 + t * (wx2 - wx1))
                    y = int(wy1 + t * (wy2 - wy1))
                    
                    # Clamp to boundary (safety check)
                    x = max(0, min(boundary['width'], x))
                    y = max(0, min(boundary['height'], y))
                    
                    path.append((x, y))
            
            # Add final point
            path.append((int(x2), int(y2)))
            
            self.solution_paths[color] = path
        
        self.canvas.update()
        QMessageBox.information(self, "Success", "Random curved solution generated for all active colors!")


    def update_mode_label(self):
        """Update the current mode label"""
        color = self.colors[self.current_color_idx]
        color_upper = color.capitalize()
        
        color_obj = self.parent_window.colors[color]
        self.mode_label.setText(f"Drawing: {color_upper} Robot Path")
        self.mode_label.setStyleSheet(f"""
            font-size: 18px; 
            font-weight: bold; 
            padding: 10px;
            background-color: {color_obj.name()};
            color: black;
            border: 2px solid black;
            border-radius: 5px;
        """)
    
    def keyPressEvent(self, event):
        """Handle keyboard shortcuts"""
        if event.key() == Qt.Key_Space:
            self.next_color()
        else:
            super().keyPressEvent(event)

    def next_color(self):
        """Move to next color"""
        self.current_color_idx = (self.current_color_idx + 1) % len(self.colors)
        self.update_mode_label()
        self.canvas.update()
    
    def clear_current_color(self):
        """Clear current color's path"""
        color = self.colors[self.current_color_idx]
        self.solution_paths[color] = []
        self.canvas.update()
    
    def reset_all(self):
        """Reset all paths"""
        reply = QMessageBox.question(self, "Reset All",
                                     "Are you sure you want to reset all paths?",
                                     QMessageBox.Yes | QMessageBox.No)
        
        if reply == QMessageBox.Yes:
            for color in self.colors:
                self.solution_paths[color] = []
            self.current_color_idx = 0
            self.update_mode_label()
            self.canvas.update()
    
    def validate_solution(self):
        """Validate the solution before accepting"""
        dot_radius = 20  # Tolerance for reaching dots
        
        for color in self.colors:
            path = self.solution_paths[color]
            
            # Check if path exists
            if len(path) < 2:
                return False, f"{color.capitalize()} robot has no path drawn!"
            
            # Check continuity (consecutive points should be reasonably close)
            for i in range(len(path) - 1):
                x1, y1 = path[i]
                x2, y2 = path[i + 1]
                distance = ((x2 - x1) ** 2 + (y2 - y1) ** 2) ** 0.5
                
                if distance > 50:  # Max gap between consecutive points
                    return False, f"{color.capitalize()} path has gaps! Draw continuously."
            
            # Get both dot positions
            start_pos = self.level_data['dots'][color]['start']
            end_pos = self.level_data['dots'][color]['end']
            
            path_start = path[0]
            path_end = path[-1]
            
            # Check if path connects the two dots (in either direction)
            # Distance from path start to start dot
            start_to_start = ((path_start[0] - start_pos[0]) ** 2 + 
                             (path_start[1] - start_pos[1]) ** 2) ** 0.5
            # Distance from path start to end dot
            start_to_end = ((path_start[0] - end_pos[0]) ** 2 + 
                           (path_start[1] - end_pos[1]) ** 2) ** 0.5
            
            # Distance from path end to start dot
            end_to_start = ((path_end[0] - start_pos[0]) ** 2 + 
                           (path_end[1] - start_pos[1]) ** 2) ** 0.5
            # Distance from path end to end dot
            end_to_end = ((path_end[0] - end_pos[0]) ** 2 + 
                         (path_end[1] - end_pos[1]) ** 2) ** 0.5
            
            # Check if path connects both dots (either direction)
            connects_correctly = (
                (start_to_start <= dot_radius and end_to_end <= dot_radius) or  # Start->End
                (start_to_end <= dot_radius and end_to_start <= dot_radius)     # End->Start
            )
            
            if not connects_correctly:
                return False, f"{color.capitalize()} path doesn't connect both dots!\nMake sure your path touches both colored dots."
        
        return True, "Solution is valid!"
    
    def confirm_solution(self):
        """Confirm and validate the solution"""
        is_valid, message = self.validate_solution()
        
        if not is_valid:
            QMessageBox.warning(self, "Invalid Solution", message)
            return
        
        self.accept()
    
    def get_solution(self):
        """Return the drawn solution"""
        return self.solution_paths.copy()


class DrawSolutionCanvas(QGraphicsView):
    """Canvas for drawing solution paths"""
    def __init__(self, parent_dialog, level_data):
        super().__init__(parent_dialog)
        self.parent_dialog = parent_dialog
        self.level_data = level_data
        self.scene = QGraphicsScene()
        self.setScene(self.scene)
        
        self.setRenderHint(QPainter.Antialiasing)
        self.setStyleSheet("background-color: white; border: 2px solid #333333;")
        self.setMinimumSize(600, 400)
        
        self.is_drawing = False
        self.current_path = []
        
        self.draw_canvas()
    
    def draw_canvas(self):
        """Draw the canvas with boundary, dots, and current paths"""
        self.scene.clear()
        
        boundary = self.level_data['boundary']
        
        # Draw boundary
        pen = QPen(QColor(0, 0, 0), 2)
        self.scene.addRect(0, 0, boundary['width'], boundary['height'], pen)
        
        # Draw all solution paths
        for color_name, path in self.parent_dialog.solution_paths.items():
            if len(path) < 2:
                continue
            
            color = self.parent_dialog.parent_window.colors[color_name]
            pen = QPen(color, 4)
            
            for i in range(len(path) - 1):
                x1, y1 = path[i]
                x2, y2 = path[i + 1]
                self.scene.addLine(x1, y1, x2, y2, pen)
        
        # Draw dots (on top of paths)
        dot_radius = 15
        for color_name, positions in self.level_data['dots'].items():
            # Skip if positions are None (robot not active in this level)
            if positions['start'] is None or positions['end'] is None:
                continue
                
            color = self.parent_dialog.parent_window.colors[color_name]
            
            # Start dot
            start_x, start_y = positions['start']
            self.scene.addEllipse(start_x - dot_radius, start_y - dot_radius,
                                 dot_radius * 2, dot_radius * 2,
                                 QPen(color, 2), color)
            text = self.scene.addText("S")
            text.setPos(start_x - 5, start_y - 12)
            text.setDefaultTextColor(QColor(0, 0, 0))
            
            # End dot
            end_x, end_y = positions['end']
            self.scene.addEllipse(end_x - dot_radius, end_y - dot_radius,
                                 dot_radius * 2, dot_radius * 2,
                                 QPen(color, 2), color)
            text = self.scene.addText("E")
            text.setPos(end_x - 5, end_y - 12)
            text.setDefaultTextColor(QColor(0, 0, 0))
        
        self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)
    
    def mousePressEvent(self, event):
        """Start drawing on mouse press"""
        scene_pos = self.mapToScene(event.pos())
        x, y = scene_pos.x(), scene_pos.y()
        
        boundary = self.level_data['boundary']
        if 0 <= x <= boundary['width'] and 0 <= y <= boundary['height']:
            self.is_drawing = True
            self.current_path = [(int(x), int(y))]
    
    def mouseMoveEvent(self, event):
        """Continue drawing on mouse move"""
        if not self.is_drawing:
            return
        
        scene_pos = self.mapToScene(event.pos())
        x, y = scene_pos.x(), scene_pos.y()
        
        boundary = self.level_data['boundary']
        if 0 <= x <= boundary['width'] and 0 <= y <= boundary['height']:
            self.current_path.append((int(x), int(y)))
            
            # Draw temporary line
            if len(self.current_path) >= 2:
                color = self.parent_dialog.colors[self.parent_dialog.current_color_idx]
                color_obj = self.parent_dialog.parent_window.colors[color]
                pen = QPen(color_obj, 4)
                
                x1, y1 = self.current_path[-2]
                x2, y2 = self.current_path[-1]
                self.scene.addLine(x1, y1, x2, y2, pen)
    
    def mouseReleaseEvent(self, event):
        """Finish drawing on mouse release"""
        if self.is_drawing:
            self.is_drawing = False
            
            # Save the path to current color
            if len(self.current_path) >= 2:
                color = self.parent_dialog.colors[self.parent_dialog.current_color_idx]
                self.parent_dialog.solution_paths[color] = self.current_path
            
            self.current_path = []
            self.draw_canvas()
    
    def resizeEvent(self, event):
        """Re-fit view when widget is resized"""
        super().resizeEvent(event)
        if self.scene.sceneRect():
            self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)
    
    def update(self):
        """Redraw canvas"""
        self.draw_canvas()
        super().update()



class CustomizeLevelDialog(QDialog):
    """Dialog for customizing level dot positions"""

    def __init__(self, parent, level_num):
        super().__init__(parent)
        self.parent_window = parent
        self.level_num = level_num
        self.level_data = parent.levels[level_num]
        
        # Minimum distance between dots (in pixels)
        self.min_distance = 30
        
        self.setWindowTitle(f"Customize {self.level_data['name']}")
        self.setGeometry(200, 150, 800, 700)
        
        layout = QVBoxLayout(self)
        
        # Title
        title = QLabel(f"<h2>Customize {self.level_data['name']}</h2>")
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        # Instructions
        instructions = QLabel(
            "Click on the canvas to place dots. Each color needs a Start and End position.\n"
            "Current mode will be shown below. Click 'Next Color' to move to the next dot.\n"
            "⚠️ Dots must be at least 30 pixels apart from each other.\n"
            "💡 Press SPACEBAR to advance to next position."
        )
        instructions.setAlignment(Qt.AlignCenter)
        instructions.setStyleSheet("padding: 10px; background-color: #f0f0f0; border: 1px solid #ccc;")
        layout.addWidget(instructions)
        
        # Current mode display
        self.mode_label = QLabel()
        self.mode_label.setAlignment(Qt.AlignCenter)
        self.mode_label.setStyleSheet("font-size: 16px; font-weight: bold; padding: 10px;")
        layout.addWidget(self.mode_label)
        
        # Initialize state BEFORE creating canvas
        self.colors = ['red', 'green', 'blue', 'yellow']
        self.positions = ['start', 'end']
        self.current_color_idx = 0
        self.current_position_idx = 0
        
        # Store temporary positions
        self.temp_dots = {
            'red': {'start': None, 'end': None},
            'green': {'start': None, 'end': None},
            'blue': {'start': None, 'end': None},
            'yellow': {'start': None, 'end': None}
        }
        
        # Load existing positions
        for color in self.colors:
            self.temp_dots[color]['start'] = self.level_data['dots'][color]['start']
            self.temp_dots[color]['end'] = self.level_data['dots'][color]['end']
        
        # Canvas for customization (now temp_dots is populated)
        self.canvas = CustomizeCanvas(self, self.level_data)
        self.canvas.temp_dots = self.temp_dots  # Pass the temp_dots to canvas
        self.canvas.draw_canvas()  # Redraw with dots
        layout.addWidget(self.canvas)
        
        # Control buttons
        control_layout = QHBoxLayout()
        
        self.next_btn = QPushButton("Next Color/Position (Space)")
        self.next_btn.setStyleSheet("background-color: #2196F3; color: white; font-weight: bold; padding: 10px;")
        self.next_btn.clicked.connect(self.next_dot)
        control_layout.addWidget(self.next_btn)
        
        reset_btn = QPushButton("Reset All")
        reset_btn.setStyleSheet("background-color: #FF9800; color: white; font-weight: bold; padding: 10px;")
        reset_btn.clicked.connect(self.reset_positions)
        control_layout.addWidget(reset_btn)
        
        layout.addLayout(control_layout)
        
        # Save/Cancel buttons
        button_layout = QHBoxLayout()
        
        save_btn = QPushButton("Save & Apply")
        save_btn.setStyleSheet("background-color: #4CAF50; color: white; font-weight: bold; padding: 15px;")
        save_btn.clicked.connect(self.save_customization)
        button_layout.addWidget(save_btn)
        
        cancel_btn = QPushButton("Cancel")
        cancel_btn.setStyleSheet("background-color: #f44336; color: white; font-weight: bold; padding: 15px;")
        cancel_btn.clicked.connect(self.reject)
        button_layout.addWidget(cancel_btn)
        
        layout.addLayout(button_layout)
        
        self.update_mode_label()
    
    def keyPressEvent(self, event):
        """Handle keyboard shortcuts"""
        if event.key() == Qt.Key_Space:
            self.next_dot()
        else:
            super().keyPressEvent(event)

    def update_mode_label(self):
        """Update the current mode label"""
        color = self.colors[self.current_color_idx]
        position = self.positions[self.current_position_idx]
        color_upper = color.capitalize()
        position_upper = position.capitalize()
        
        color_obj = self.parent_window.colors[color]
        self.mode_label.setText(f"Place: {color_upper} Robot - {position_upper} Position")
        self.mode_label.setStyleSheet(f"""
            font-size: 18px; 
            font-weight: bold; 
            padding: 10px;
            background-color: {color_obj.name()};
            color: black;
            border: 2px solid black;
            border-radius: 5px;
        """)
    
    def next_dot(self):
        """Move to next dot position"""
        # Move to next position
        self.current_position_idx += 1
        
        # If we've done both start and end, move to next color
        if self.current_position_idx >= len(self.positions):
            self.current_position_idx = 0
            self.current_color_idx += 1
            
            # If we've done all colors, wrap around
            if self.current_color_idx >= len(self.colors):
                self.current_color_idx = 0
        
        self.update_mode_label()
        self.canvas.update()
    
    def validate_position(self, new_x, new_y):
        """Validate if the new position is far enough from all other dots"""
        # Collect all existing positions except the current one being placed
        all_positions = []
        
        current_color = self.colors[self.current_color_idx]
        current_position = self.positions[self.current_position_idx]
        
        for color in self.colors:
            for pos_type in self.positions:
                # Skip the position we're currently placing
                if color == current_color and pos_type == current_position:
                    continue
                
                pos = self.temp_dots[color][pos_type]
                if pos is not None:
                    all_positions.append(pos)
        
        # Check distance to all existing positions
        for (x, y) in all_positions:
            distance = ((new_x - x) ** 2 + (new_y - y) ** 2) ** 0.5
            if distance < self.min_distance:
                return False, (x, y)
        
        return True, None
    
    def set_dot_position(self, x, y):
        """Set the current dot position"""
        # Validate position
        is_valid, conflicting_pos = self.validate_position(x, y)
        
        if not is_valid:
            QMessageBox.warning(self, "Invalid Position",
                               f"This position is too close to another dot!\n\n"
                               f"Conflicting dot at: ({conflicting_pos[0]}, {conflicting_pos[1]})\n"
                               f"Minimum distance required: {self.min_distance} pixels\n\n"
                               "Please choose a different location.")
            return
        
        color = self.colors[self.current_color_idx]
        position = self.positions[self.current_position_idx]
        
        self.temp_dots[color][position] = (x, y)
        self.canvas.temp_dots = self.temp_dots
        self.canvas.update()
        
        # Auto advance to next
        self.next_dot()
    
    def reset_positions(self):
        """Reset all positions to original"""
        reply = QMessageBox.question(self, "Reset Positions",
                                     "Are you sure you want to reset all positions to original?",
                                     QMessageBox.Yes | QMessageBox.No)
        
        if reply == QMessageBox.Yes:
            for color in self.colors:
                self.temp_dots[color]['start'] = self.level_data['dots'][color]['start']
                self.temp_dots[color]['end'] = self.level_data['dots'][color]['end']
            
            self.canvas.temp_dots = self.temp_dots
            self.canvas.update()
            self.current_color_idx = 0
            self.current_position_idx = 0
            self.update_mode_label()
    
    def validate_board(self):
        """Validate the entire board before saving"""
        # Check if all positions are set
        for color in self.colors:
            if self.temp_dots[color]['start'] is None or self.temp_dots[color]['end'] is None:
                return False, f"Please set both start and end positions for {color.capitalize()} robot!"
        
        # Collect all positions
        all_positions = []
        for color in self.colors:
            for pos_type in self.positions:
                pos = self.temp_dots[color][pos_type]
                if pos is not None:
                    all_positions.append((color, pos_type, pos))
        
        # Check all pairs of positions
        for i in range(len(all_positions)):
            for j in range(i + 1, len(all_positions)):
                color1, type1, (x1, y1) = all_positions[i]
                color2, type2, (x2, y2) = all_positions[j]
                
                distance = ((x1 - x2) ** 2 + (y1 - y2) ** 2) ** 0.5
                
                if distance < self.min_distance:
                    return False, (f"Dots are too close together!\n\n"
                                  f"{color1.capitalize()} {type1.capitalize()} at ({x1}, {y1})\n"
                                  f"{color2.capitalize()} {type2.capitalize()} at ({x2}, {y2})\n\n"
                                  f"Distance: {distance:.1f} pixels\n"
                                  f"Minimum required: {self.min_distance} pixels")
        
        return True, "Board is valid!"
    
    def save_customization(self):
        """Save the customized positions"""
        # Validate the entire board
        is_valid, message = self.validate_board()
        
        if not is_valid:
            QMessageBox.warning(self, "Invalid Board Configuration", message)
            return
        
        # Update the level data
        for color in self.colors:
            self.level_data['dots'][color]['start'] = self.temp_dots[color]['start']
            self.level_data['dots'][color]['end'] = self.temp_dots[color]['end']
        
        self.accept()


class CustomizeCanvas(QGraphicsView):
    """Canvas for customizing dot positions"""
    def __init__(self, parent_dialog, level_data):
        super().__init__(parent_dialog)
        self.parent_dialog = parent_dialog
        self.level_data = level_data
        self.scene = QGraphicsScene()
        self.setScene(self.scene)
        
        self.setRenderHint(QPainter.Antialiasing)
        self.setStyleSheet("background-color: white; border: 2px solid #333333;")
        
        # Set minimum size to prevent tiny initial viewport
        self.setMinimumSize(600, 400)
        
        self.temp_dots = None
        self.draw_canvas()
    
    def draw_canvas(self):
        """Draw the canvas with boundary and current dots"""
        self.scene.clear()
        
        boundary = self.level_data['boundary']
        
        # Draw boundary
        pen = QPen(QColor(0, 0, 0), 2)
        self.scene.addRect(0, 0, boundary['width'], boundary['height'], pen)
        
        # Draw current dots if they exist
        if self.temp_dots:
            dot_radius = 15
            for color_name, positions in self.temp_dots.items():
                color = self.parent_dialog.parent_window.colors[color_name]
                
                # Start dot
                if positions['start']:
                    start_x, start_y = positions['start']
                    ellipse = self.scene.addEllipse(start_x - dot_radius, start_y - dot_radius,
                                         dot_radius * 2, dot_radius * 2,
                                         QPen(color, 2), color)
                    # Add "S" text
                    text = self.scene.addText("S")
                    text.setPos(start_x - 5, start_y - 12)
                    text.setDefaultTextColor(QColor(0, 0, 0))
                
                # End dot
                if positions['end']:
                    end_x, end_y = positions['end']
                    ellipse = self.scene.addEllipse(end_x - dot_radius, end_y - dot_radius,
                                         dot_radius * 2, dot_radius * 2,
                                         QPen(color, 2), color)
                    # Add "E" text
                    text = self.scene.addText("E")
                    text.setPos(end_x - 5, end_y - 12)
                    text.setDefaultTextColor(QColor(0, 0, 0))
        
        # Fit view
        self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)
    
    def resizeEvent(self, event):
        """Re-fit view when widget is resized"""
        super().resizeEvent(event)
        if self.scene.sceneRect():
            self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)

    def mousePressEvent(self, event):
        """Handle mouse click to place dots"""
        # Get click position in scene coordinates
        scene_pos = self.mapToScene(event.pos())
        x, y = scene_pos.x(), scene_pos.y()
        
        # Check if click is within boundary
        boundary = self.level_data['boundary']
        if 0 <= x <= boundary['width'] and 0 <= y <= boundary['height']:

            self.parent_dialog.set_dot_position(int(x), int(y))
            self.draw_canvas()
    
    def update(self):
        """Redraw canvas"""
        self.draw_canvas()
        super().update()

class SolutionViewDialog(QDialog):
    """Dialog to view a solution from highscore"""
    def __init__(self, parent, level_num, entry):
        super().__init__(parent)
        self.parent_window = parent
        self.level_num = level_num
        self.entry = entry
        
        self.setWindowTitle(f"Solution - {entry['name']} - {entry['time']:.2f}s")
        self.setGeometry(200, 200, 700, 500)
        
        layout = QVBoxLayout(self)
        
        # Info label
        info_label = QLabel(f"<b>Player:</b> {entry['name']} | <b>Time:</b> {entry['time']:.2f}s | <b>Level:</b> {level_num}")
        info_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(info_label)
        
        # Check if solution is valid or corrupted (manual entry)
        solution = self.entry.get('solution', {})
        is_corrupted = all(len(path) == 0 for path in solution.values())
        
        if is_corrupted:
            # Show rickroll image for corrupted/manual entries
            rickroll_label = QLabel()
            rickroll_path = os.path.join(os.path.dirname(__file__), 'temp.jpg')
            
            if os.path.exists(rickroll_path):
                pixmap = QPixmap(rickroll_path)
                scaled_pixmap = pixmap.scaled(600, 400, Qt.KeepAspectRatio, Qt.SmoothTransformation)
                rickroll_label.setPixmap(scaled_pixmap)
            else:
                rickroll_label.setText("🎵 Never Gonna Give You Up 🎵\n\n(temp.jpg not found)")
                rickroll_label.setStyleSheet("font-size: 24px; color: red;")
            
            rickroll_label.setAlignment(Qt.AlignCenter)
            layout.addWidget(rickroll_label)
        else:
            # Canvas to show real solution
            self.solution_canvas = QGraphicsView()
            self.solution_scene = QGraphicsScene()
            self.solution_canvas.setScene(self.solution_scene)
            self.solution_canvas.setRenderHint(QPainter.Antialiasing)
            self.solution_canvas.setStyleSheet("background-color: white; border: 2px solid #333333;")
            
            layout.addWidget(self.solution_canvas)
            
            # Draw the solution
            self.draw_solution()
        
        # Close button
        close_btn = QPushButton("Close")
        close_btn.clicked.connect(self.close)
        layout.addWidget(close_btn)
    
    def draw_solution(self):
        """Draw the solution on the canvas"""
        level_data = self.parent_window.levels[self.level_num]
        boundary = level_data['boundary']
        
        # Draw boundary
        pen = QPen(QColor(0, 0, 0), 2)
        self.solution_scene.addRect(0, 0, boundary['width'], boundary['height'], pen)
        
        # Draw dots
        dot_radius = 15
        for color_name, positions in level_data['dots'].items():
            # Skip if positions are None (robot not active in this level)
            if positions['start'] is None or positions['end'] is None:
                continue
                
            color = self.parent_window.colors[color_name]
            
            # Start dot
            start_x, start_y = positions['start']
            self.solution_scene.addEllipse(start_x - dot_radius, start_y - dot_radius,
                                          dot_radius * 2, dot_radius * 2,
                                          QPen(color, 2), color)
            
            # End dot
            end_x, end_y = positions['end']
            self.solution_scene.addEllipse(end_x - dot_radius, end_y - dot_radius,
                                          dot_radius * 2, dot_radius * 2,
                                          QPen(color, 2), color)
        
        # Draw solution paths
        solution = self.entry['solution']
        for color_name, path in solution.items():
            if len(path) < 2:
                continue
            
            color = self.parent_window.colors[color_name]
            pen = QPen(color, 4)
            
            for i in range(len(path) - 1):
                x1, y1 = path[i]
                x2, y2 = path[i + 1]
                self.solution_scene.addLine(x1, y1, x2, y2, pen)
        
        # Fit view
        self.solution_canvas.fitInView(self.solution_scene.sceneRect(), Qt.KeepAspectRatio)


class PreviewDialog(QDialog):
    """Dialog for previewing solution animation"""
    def __init__(self, parent, level_num, solution, velocity):
        super().__init__(parent)
        self.parent_window = parent
        self.level_num = level_num
        self.solution = solution
        self.velocity = velocity  # pixels per timer tick
        self.level_data = parent.levels[level_num]
        
        self.setWindowTitle(f"Preview - {self.level_data['name']}")
        self.setGeometry(150, 100, 900, 750)
        
        layout = QVBoxLayout(self)
        
        # Title
        title = QLabel(f"<h2>Preview - {self.level_data['name']}</h2>")
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        # Info label
        self.info_label = QLabel(f"Velocity: {velocity} px/tick | Status: Ready")
        self.info_label.setAlignment(Qt.AlignCenter)
        self.info_label.setStyleSheet("padding: 10px; background-color: #f0f0f0; border: 1px solid #ccc;")
        layout.addWidget(self.info_label)
        
        # Canvas for animation
        self.canvas = PreviewCanvas(self, self.level_data, solution)
        layout.addWidget(self.canvas)
        
        # Control buttons
        control_layout = QHBoxLayout()
        
        self.start_btn = QPushButton("▶ Start")
        self.start_btn.setStyleSheet("background-color: #4CAF50; color: white; font-weight: bold; padding: 10px;")
        self.start_btn.clicked.connect(self.start_animation)
        control_layout.addWidget(self.start_btn)
        
        self.pause_btn = QPushButton("⏸ Pause")
        self.pause_btn.setStyleSheet("background-color: #FF9800; color: white; font-weight: bold; padding: 10px;")
        self.pause_btn.clicked.connect(self.pause_animation)
        self.pause_btn.setEnabled(False)
        control_layout.addWidget(self.pause_btn)
        
        self.reset_btn = QPushButton("↻ Reset")
        self.reset_btn.setStyleSheet("background-color: #2196F3; color: white; font-weight: bold; padding: 10px;")
        self.reset_btn.clicked.connect(self.reset_animation)
        control_layout.addWidget(self.reset_btn)
        
        layout.addLayout(control_layout)
        
        # Close button
        close_btn = QPushButton("Close")
        close_btn.setStyleSheet("padding: 10px;")
        close_btn.clicked.connect(self.close)
        layout.addWidget(close_btn)
        
        # Animation state
        self.is_animating = False
        self.is_paused = False
        
        # Timer for animation
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.animate_step)
        self.animation_interval = 50  # milliseconds
    
    def start_animation(self):
        """Start the animation"""
        if self.is_animating and self.is_paused:
            # Resume from pause
            self.is_paused = False
            self.timer.start(self.animation_interval)
            self.info_label.setText(f"Velocity: {self.velocity} px/tick | Status: Running")
            self.start_btn.setEnabled(False)
            self.pause_btn.setEnabled(True)
        elif not self.is_animating:
            # Start fresh
            self.canvas.start_animation()
            self.is_animating = True
            self.is_paused = False
            self.timer.start(self.animation_interval)
            self.info_label.setText(f"Velocity: {self.velocity} px/tick | Status: Running")
            self.start_btn.setEnabled(False)
            self.pause_btn.setEnabled(True)
    
    def pause_animation(self):
        """Pause the animation"""
        if self.is_animating and not self.is_paused:
            self.is_paused = True
            self.timer.stop()
            self.info_label.setText(f"Velocity: {self.velocity} px/tick | Status: Paused")
            self.start_btn.setEnabled(True)
            self.pause_btn.setEnabled(False)
    
    def reset_animation(self):
        """Reset the animation"""
        self.timer.stop()
        self.is_animating = False
        self.is_paused = False
        self.canvas.reset_animation()
        self.info_label.setText(f"Velocity: {self.velocity} px/tick | Status: Ready")
        self.start_btn.setEnabled(True)
        self.pause_btn.setEnabled(False)
    
    def animate_step(self):
        """Perform one animation step"""
        finished = self.canvas.animate_step(self.velocity)
        
        if finished:
            self.timer.stop()
            self.is_animating = False
            self.is_paused = False
            self.info_label.setText(f"Velocity: {self.velocity} px/tick | Status: Completed!")
            self.start_btn.setEnabled(True)
            self.pause_btn.setEnabled(False)


class PreviewCanvas(QGraphicsView):
    """Canvas for previewing solution animation"""
    def __init__(self, parent_dialog, level_data, solution):
        super().__init__(parent_dialog)
        self.parent_dialog = parent_dialog
        self.level_data = level_data
        self.solution = solution
        self.scene = QGraphicsScene()
        self.setScene(self.scene)
        
        self.setRenderHint(QPainter.Antialiasing)
        self.setStyleSheet("background-color: white; border: 2px solid #333333;")
        self.setMinimumSize(600, 400)
        
        # Robot tracking
        self.robot_positions = {}  # Current position index in path for each color
        self.robot_graphics = {}   # Graphics items for each robot
        self.path_graphics = {}    # Graphics items for traced paths
        
        self.draw_static_elements()
    
    def draw_static_elements(self):
        """Draw boundary, dots, and solution paths (faded)"""
        self.scene.clear()
        
        boundary = self.level_data['boundary']
        
        # Draw boundary
        pen = QPen(QColor(0, 0, 0), 2)
        self.scene.addRect(0, 0, boundary['width'], boundary['height'], pen)
        
        # Draw solution paths (faded as guide)
        for color_name, path in self.solution.items():
            if len(path) < 2:
                continue
            
            color = self.parent_dialog.parent_window.colors[color_name]
            pen = QPen(QColor(color.red(), color.green(), color.blue(), 60), 2, Qt.DashLine)
            
            for i in range(len(path) - 1):
                x1, y1 = path[i]
                x2, y2 = path[i + 1]
                self.scene.addLine(x1, y1, x2, y2, pen)
        
        # Draw dots
        dot_radius = 15
        for color_name, positions in self.level_data['dots'].items():
            # Skip if positions are None (robot not active in this level)
            if positions['start'] is None or positions['end'] is None:
                continue
                
            color = self.parent_dialog.parent_window.colors[color_name]
            
            # Start dot
            start_x, start_y = positions['start']
            self.scene.addEllipse(start_x - dot_radius, start_y - dot_radius,
                                 dot_radius * 2, dot_radius * 2,
                                 QPen(color, 2), color)
            text = self.scene.addText("S")
            text.setPos(start_x - 5, start_y - 12)
            text.setDefaultTextColor(QColor(0, 0, 0))
            
            # End dot
            end_x, end_y = positions['end']
            self.scene.addEllipse(end_x - dot_radius, end_y - dot_radius,
                                 dot_radius * 2, dot_radius * 2,
                                 QPen(color, 2), color)
            text = self.scene.addText("E")
            text.setPos(end_x - 5, end_y - 12)
            text.setDefaultTextColor(QColor(0, 0, 0))
        
        self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)
    
    def start_animation(self):
        """Initialize animation state"""
        self.robot_positions = {}
        self.robot_graphics = {}
        self.path_graphics = {}
        
        # Create robot graphics at start positions
        robot_radius = 10
        for color_name, path in self.solution.items():
            if len(path) < 2:
                continue
            
            color = self.parent_dialog.parent_window.colors[color_name]
            
            # Initialize position
            self.robot_positions[color_name] = 0
            
            # Create robot circle
            x, y = path[0]
            robot = self.scene.addEllipse(x - robot_radius, y - robot_radius,
                                         robot_radius * 2, robot_radius * 2,
                                         QPen(QColor(0, 0, 0), 2), color)
            self.robot_graphics[color_name] = robot
            
            # Initialize path graphics list
            self.path_graphics[color_name] = []
    
    def animate_step(self, velocity):
        """Move robots one step along their paths"""
        all_finished = True
        
        for color_name, path in self.solution.items():
            if len(path) < 2:
                continue
            
            current_idx = self.robot_positions.get(color_name, 0)
            
            # Check if this robot has finished
            if current_idx >= len(path) - 1:
                continue
            
            all_finished = False
            
            # Calculate how many steps to move based on velocity
            steps_to_move = max(1, velocity // 10)  # Convert velocity to path steps
            new_idx = min(current_idx + steps_to_move, len(path) - 1)
            
            # Update robot position
            robot = self.robot_graphics[color_name]
            x, y = path[new_idx]
            robot_radius = 10
            robot.setRect(x - robot_radius, y - robot_radius, robot_radius * 2, robot_radius * 2)
            
            # Draw traced path
            color = self.parent_dialog.parent_window.colors[color_name]
            pen = QPen(color, 4)
            
            for i in range(current_idx, new_idx):
                x1, y1 = path[i]
                x2, y2 = path[i + 1]
                line = self.scene.addLine(x1, y1, x2, y2, pen)
                self.path_graphics[color_name].append(line)
            
            # Update position index
            self.robot_positions[color_name] = new_idx
        
        return all_finished
    
    def reset_animation(self):
        """Reset animation to initial state"""
        # Remove robots and traced paths
        for robot in self.robot_graphics.values():
            self.scene.removeItem(robot)
        
        for color_paths in self.path_graphics.values():
            for line in color_paths:
                self.scene.removeItem(line)
        
        self.robot_positions = {}
        self.robot_graphics = {}
        self.path_graphics = {}
    
    def resizeEvent(self, event):
        """Re-fit view when widget is resized"""
        super().resizeEvent(event)
        if self.scene.sceneRect():
            self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)



class ExecutionDialog(QDialog):
    """Dialog for executing solution with real robots and camera feed"""
    
    def __init__(self, parent, level_num, solution, player_name):
        super().__init__(parent)
        self.parent_window = parent
        self.level_num = level_num
        self.solution = solution
        self.player_name = player_name
        self.level_data = parent.levels[level_num]
        
        self.setWindowTitle(f"Executing - {self.level_data['name']} - {player_name}")
        self.setGeometry(100, 50, 1000, 800)  # Optimized size for new layout
        
        # Execution state
        self.execution_status = "BOOTING"  # BOOTING/PREP/EXECUTING/ERROR/DONE/TIMEOUT
        self.start_time = None
        self.completion_time = 999.99  # High penalty if closed early
        self.current_time = 0.0
        self.max_execution_time = 60.0  # Maximum 60 seconds for execution
        
        # Solution overlay opacity
        self.overlay_opacity = 128  # 0-255, default 50% (128)
        
        # Visualization mode state - OptiTrack is now default
        self.viz_mode = "optitrack"  # "camera" or "optitrack"
        
        # Timer control
        self.timer_started = False  # Timer only starts when user clicks Start button
        
        layout = QVBoxLayout(self)

        
        self.log_text = QTextEdit()
        
        # Title
        title = QLabel(f"<h2>Execution - {self.level_data['name']}</h2>")
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        # Player info
        player_label = QLabel(f"<b>Player:</b> {player_name}")
        player_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(player_label)
        
        # Top info bar - Status, Timer, and Mode Toggle
        info_layout = QHBoxLayout()
        
        # Status indicator (smaller)
        status_frame = QFrame()
        status_frame.setFrameStyle(QFrame.Box | QFrame.Raised)
        status_layout = QVBoxLayout(status_frame)
        status_layout.addWidget(QLabel("<b>Status:</b>"))
        self.status_label = QLabel("BOOTING")
        self.status_label.setStyleSheet("""
            font-size: 18px;
            font-weight: bold;
            padding: 5px;
            background-color: #FFA500;
            color: black;
            border-radius: 5px;
        """)
        self.status_label.setAlignment(Qt.AlignCenter)
        status_layout.addWidget(self.status_label)
        info_layout.addWidget(status_frame)
        
        # Timer (smaller)
        timer_frame = QFrame()
        timer_frame.setFrameStyle(QFrame.Box | QFrame.Raised)
        timer_layout = QVBoxLayout(timer_frame)
        timer_layout.addWidget(QLabel("<b>Time:</b>"))
        self.timer_label = QLabel("0.00s")
        self.timer_label.setStyleSheet("""
            font-size: 18px;
            font-weight: bold;
            padding: 5px;
            background-color: #2196F3;
            color: white;
            border-radius: 5px;
        """)
        self.timer_label.setAlignment(Qt.AlignCenter)
        timer_layout.addWidget(self.timer_label)
        info_layout.addWidget(timer_frame)
        
        # Visualization Mode Toggle (OptiTrack is default)
        viz_mode_frame = QFrame()
        viz_mode_frame.setFrameStyle(QFrame.Box | QFrame.Raised)
        viz_mode_layout = QVBoxLayout(viz_mode_frame)
        viz_mode_layout.addWidget(QLabel("<b>View Mode:</b>"))
        self.viz_mode_toggle = QPushButton("🎯 OptiTrack View")
        self.viz_mode_toggle.setStyleSheet("""
            font-size: 16px;
            font-weight: bold;
            padding: 5px;
            background-color: #9C27B0;
            color: white;
            border-radius: 5px;
        """)
        self.viz_mode_toggle.clicked.connect(self.toggle_viz_mode)
        viz_mode_layout.addWidget(self.viz_mode_toggle)
        info_layout.addWidget(viz_mode_frame)
        
        layout.addLayout(info_layout)
        
        # Camera selection
        camera_select_layout = QHBoxLayout()
        camera_select_layout.addWidget(QLabel("Camera Source:"))
        
        self.camera_combo = QComboBox()
        self.detect_cameras()
        self.camera_combo.currentIndexChanged.connect(self.change_camera)
        camera_select_layout.addWidget(self.camera_combo)
        
        camera_select_layout.addStretch()
        layout.addLayout(camera_select_layout)
        
        # Canvas container for both camera and OptiTrack visualization
        self.canvas_container = QWidget()
        self.canvas_layout = QVBoxLayout(self.canvas_container)
        self.canvas_layout.setContentsMargins(0, 0, 0, 0)
        
        # Camera feed canvas (hidden initially, OptiTrack is default)
        self.camera_canvas = ExecutionCanvas(self, self.level_data, solution)
        self.camera_canvas.hide()
        self.canvas_layout.addWidget(self.camera_canvas)
        
        # OptiTrack visualization canvas (shown by default)
        self.optitrack_canvas = OptiTrackVizCanvas(self, self.level_data, solution)
        self.canvas_layout.addWidget(self.optitrack_canvas)
        
        layout.addWidget(self.canvas_container)
        
        # Overlay opacity slider
        opacity_layout = QHBoxLayout()
        opacity_layout.addWidget(QLabel("Solution Overlay Opacity:"))
        
        self.opacity_slider = QSlider(Qt.Horizontal)
        self.opacity_slider.setMinimum(0)
        self.opacity_slider.setMaximum(255)
        self.opacity_slider.setValue(128)
        self.opacity_slider.setTickPosition(QSlider.TicksBelow)
        self.opacity_slider.setTickInterval(25)
        self.opacity_slider.valueChanged.connect(self.update_overlay_opacity)
        opacity_layout.addWidget(self.opacity_slider)
        
        self.opacity_value_label = QLabel("50%")
        opacity_layout.addWidget(self.opacity_value_label)
        
        layout.addLayout(opacity_layout)
        
        # Debug/Status log (smaller)
        log_group = QGroupBox("Execution Log")
        log_layout = QVBoxLayout()
        
        self.log_text.setReadOnly(True)
        self.log_text.setMaximumHeight(80)  # Restored to 80px for better readability
        self.log_text.setStyleSheet("""
            background-color: #1e1e1e;
            color: #00ff00;
            font-family: monospace;
            font-size: 10px;
        """)
        log_layout.addWidget(self.log_text)
        
        log_group.setLayout(log_layout)
        layout.addWidget(log_group)
        
        # Control buttons
        button_layout = QHBoxLayout()
        
        self.start_btn = QPushButton("▶️ Start Execution")
        self.start_btn.setStyleSheet("background-color: #4CAF50; color: white; font-weight: bold; padding: 10px; font-size: 14px;")
        self.start_btn.clicked.connect(self.manual_start_execution)
        button_layout.addWidget(self.start_btn)
        
        self.abort_btn = QPushButton("⚠️ Abort Execution")
        self.abort_btn.setStyleSheet("background-color: #f44336; color: white; font-weight: bold; padding: 10px;")
        self.abort_btn.clicked.connect(self.abort_execution)
        self.abort_btn.setEnabled(False)  # Disabled until execution starts
        button_layout.addWidget(self.abort_btn)
        
        self.close_btn = QPushButton("Close")
        self.close_btn.setEnabled(False)
        self.close_btn.setStyleSheet("padding: 10px;")
        self.close_btn.clicked.connect(self.accept)
        button_layout.addWidget(self.close_btn)
        
        layout.addLayout(button_layout)
        
        # Timer for updating display and execution
        self.update_timer = QTimer(self)
        self.update_timer.timeout.connect(self.update_execution)
        self.update_timer.start(20)  # Update every 20ms
        
        # OptiTrack connection
        self.optitrack_socket = None
        self.optitrack_running = False
        self.init_optitrack_connection()
        
        # Log initial message
        self.log("[SYSTEM] Execution dialog opened")
        self.log(f"[SYSTEM] Player: {player_name}")
        self.log(f"[SYSTEM] Level: {self.level_data['name']}")
        self.log(f"[SYSTEM] Maximum execution time: {self.max_execution_time}s")
        self.log("[SYSTEM] Initializing robot communication...")
        
        # Start OptiTrack visualization immediately since it's the default view
        if self.parent_window.is_optitrack_viz_calibrated() and self.optitrack_running:
            self.optitrack_canvas.start_visualization()
            self.log("[OPTITRACK VIZ] Visualization started (default view)")
        
        # Prepare robots (but don't start timer automatically)
        QTimer.singleShot(1000, self.start_execution_sequence)
    
    def toggle_viz_mode(self):
        """Toggle between Camera View and OptiTrack Visualization Mode"""
        if self.viz_mode == "optitrack":
            # Switch to Camera mode
            self.viz_mode = "camera"
            self.optitrack_canvas.hide()
            self.optitrack_canvas.stop_visualization()  # Stop updating when hidden
            self.camera_canvas.show()
            self.viz_mode_toggle.setText("📷 Camera View")
            self.viz_mode_toggle.setStyleSheet("""
                font-size: 16px;
                font-weight: bold;
                padding: 5px;
                background-color: #4CAF50;
                color: white;
                border-radius: 5px;
            """)
            self.log("[SYSTEM] Switched to Camera View")
        else:
            # Switch to OptiTrack mode
            if not self.parent_window.is_optitrack_viz_calibrated():
                QMessageBox.warning(self, "Not Calibrated",
                                   "OptiTrack Visualization Mode is not calibrated!\n\n"
                                   "Please calibrate it in Settings before using this mode.")
                return
            
            self.viz_mode = "optitrack"
            self.camera_canvas.hide()
            self.optitrack_canvas.show()
            self.viz_mode_toggle.setText("🎯 OptiTrack View")
            self.viz_mode_toggle.setStyleSheet("""
                font-size: 16px;
                font-weight: bold;
                padding: 5px;
                background-color: #9C27B0;
                color: white;
                border-radius: 5px;
            """)
            self.log("[SYSTEM] Switched to OptiTrack Visualization Mode")
            
            # Start OptiTrack visualization
            if self.optitrack_running:
                self.optitrack_canvas.start_visualization()
                self.log("[OPTITRACK VIZ] Visualization started")
    
    def detect_cameras(self):
        """Detect available cameras and populate combo box"""
        self.camera_combo.clear()
        self.log("[SYSTEM] Detecting available cameras...")
        
        # Try to detect up to 3 camera indices (reduced to avoid errors)
        available_cameras = []
        for i in range(3):
            cap = cv2.VideoCapture(i, cv2.CAP_DSHOW)  # Use DirectShow on Windows
            if cap.isOpened():
                # Try to read a frame to verify camera works
                ret, frame = cap.read()
                if ret:
                    available_cameras.append(i)
                    self.log(f"[SYSTEM] Camera {i} detected and verified")
                cap.release()
                # Small delay to ensure camera is released
                QTimer.singleShot(100, lambda: None)
        
        if available_cameras:
            for cam_id in available_cameras:
                self.camera_combo.addItem(f"Camera {cam_id}", cam_id)
            self.log(f"[SYSTEM] Found {len(available_cameras)} camera(s): {available_cameras}")
        else:
            self.camera_combo.addItem("No camera detected", -1)
            self.log("[SYSTEM] ⚠️ No cameras detected!")
    
    def change_camera(self, index):
        """Change the active camera"""
        if index >= 0:
            camera_id = self.camera_combo.itemData(index)
            if camera_id >= 0:
                self.log(f"[CAMERA] Switching to Camera {camera_id}")
                self.camera_canvas.set_camera(camera_id)
    
    def update_overlay_opacity(self, value):
        """Update solution overlay opacity"""
        self.overlay_opacity = value
        percentage = int((value / 255) * 100)
        self.opacity_value_label.setText(f"{percentage}%")
        self.camera_canvas.update_overlay_opacity(value)
    
    #smal bug here
    def log(self, message):
        """Add message to log"""
        from datetime import datetime
        timestamp = datetime.now().strftime("%H:%M:%S.%f")[:-3]
        self.log_text.append(f"[{timestamp}] {message}")
        # Auto-scroll to bottom
        self.log_text.verticalScrollBar().setValue(
            self.log_text.verticalScrollBar().maximum()
        )
    
    def update_status(self, status):
        """Update execution status"""
        self.execution_status = status
        self.status_label.setText(status)
        
        # Update color based on status
        if status == "BOOTING":
            color = "#FFA500"  # Orange
        elif status == "PREP":
            color = "#2196F3"  # Blue
        elif status == "READY":
            color = "#00E676"  # Bright green - ready to start
        elif status == "EXECUTING":
            color = "#4CAF50"  # Green
        elif status == "ERROR":
            color = "#f44336"  # Red
        elif status == "DONE":
            color = "#00C853"  # Success green
        elif status == "TIMEOUT":
            color = "#FF5722"  # Deep orange
        else:
            color = "#9E9E9E"  # Gray
        
        self.status_label.setStyleSheet(f"""
            font-size: 18px;
            font-weight: bold;
            padding: 5px;
            background-color: {color};
            color: {'black' if status in ['BOOTING', 'PREP', 'READY'] else 'white'};
            border-radius: 5px;
        """)
    
    def start_execution_sequence(self):
        """Start the execution sequence"""
        self.log("[SYSTEM] Boot complete")
        self.log("[ROBOT] Checking robot connections...")
        
        # TODO: Actually check robot connections
        # Simulate connection check
        QTimer.singleShot(500, lambda: self.log("[ROBOT] Red robot: CONNECTED"))
        QTimer.singleShot(700, lambda: self.log("[ROBOT] Green robot: CONNECTED"))
        QTimer.singleShot(900, lambda: self.log("[ROBOT] Blue robot: CONNECTED"))
        QTimer.singleShot(1100, lambda: self.log("[ROBOT] Yellow robot: CONNECTED"))
        QTimer.singleShot(1300, self.prep_robots)
    
    def prep_robots(self):
        """Prepare robots for execution"""
        self.update_status("PREP")
        self.log("[SYSTEM] All robots connected")
        self.log("[SYSTEM] Uploading solution paths to robots...")
        
        # TODO: Actually upload paths to robots
        QTimer.singleShot(1000, lambda: self.log("[UPLOAD] Uploading red robot path..."))
        QTimer.singleShot(1500, lambda: self.log("[UPLOAD] Uploading green robot path..."))
        QTimer.singleShot(2000, lambda: self.log("[UPLOAD] Uploading blue robot path..."))
        QTimer.singleShot(2500, lambda: self.log("[UPLOAD] Uploading yellow robot path..."))
        QTimer.singleShot(3000, self.ready_to_start)
    
    def ready_to_start(self):
        """All robots ready, waiting for user to click Start button"""
        self.update_status("READY")
        self.log("[SYSTEM] All paths uploaded")
        self.log("[SYSTEM] ✓ Ready to start execution")
        self.log("[SYSTEM] Click 'Start Execution' button to begin")
        
        # Enable Start button
        self.start_btn.setEnabled(True)
        self.start_btn.setStyleSheet("""
            background-color: #4CAF50; 
            color: white; 
            font-weight: bold; 
            padding: 10px; 
            font-size: 14px;
            border: 3px solid #00ff00;
        """)
    
    def manual_start_execution(self):
        """User clicked Start button - begin execution and timer"""
        self.start_btn.setEnabled(False)
        self.start_btn.setStyleSheet("background-color: #666; color: white; font-weight: bold; padding: 10px; font-size: 14px;")
        self.abort_btn.setEnabled(True)
        
        self.start_execution()
    
    def start_execution(self):
        """Start actual execution"""
        self.update_status("EXECUTING")
        self.log("[SYSTEM] 🚀 Execution started!")
        self.log("[SYSTEM] Timer started")
        
        # Start timer NOW (when user clicks Start)
        self.start_time = time.time()
        self.timer_started = True
        
        # TODO: Actually start robot execution
        # For now, simulate execution with camera feed updates
        self.camera_canvas.start_camera_stream()
        
        # Simulate completion after some time (for testing)
        # In reality, this would be triggered by robot completion signals
        # QTimer.singleShot(10000, self.execution_complete)
    
    def update_execution(self):
        """Update execution state (called every 20ms)"""
        # Only update timer if user has clicked Start button
        if self.timer_started and self.execution_status == "EXECUTING" and self.start_time:
            # Update timer
            self.current_time = time.time() - self.start_time
            self.timer_label.setText(f"{self.current_time:.2f}s")
            
            # Check for timeout (execution longer than 60 seconds)
            if self.current_time > self.max_execution_time:
                self.execution_timeout()
            
            # Update timer color based on time
            if self.current_time > 50:
                # Warning - getting close to timeout
                self.timer_label.setStyleSheet("""
                    font-size: 18px;
                    font-weight: bold;
                    padding: 5px;
                    background-color: #FF9800;
                    color: white;
                    border-radius: 5px;
                """)
            elif self.current_time > 40:
                # Caution
                self.timer_label.setStyleSheet("""
                    font-size: 18px;
                    font-weight: bold;
                    padding: 5px;
                    background-color: #FFC107;
                    color: black;
                    border-radius: 5px;
                """)
            
            # TODO: Check robot status and update accordingly
            # For now, check if we should simulate completion
            pass
    
    def init_optitrack_connection(self):
        """Initialize connection to OptiTrack server"""
        try:
            self.optitrack_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.optitrack_socket.settimeout(2)
            self.optitrack_socket.connect((self.parent_window.optitrack_server_ip, 
                                          self.parent_window.optitrack_port))
            self.optitrack_socket.setblocking(False)
            self.optitrack_running = True
            self.log("[OPTITRACK] Connected to OptiTrack server")
            
            # Start reading OptiTrack data
            self.optitrack_timer = QTimer(self)
            self.optitrack_timer.timeout.connect(self.read_optitrack_data)
            self.optitrack_timer.start(30)  # Read every 30ms
            
        except Exception as e:
            self.log(f"[OPTITRACK] ⚠️ Failed to connect: {str(e)}")
            self.optitrack_socket = None
            self.optitrack_running = False
    
    def read_optitrack_data(self):
        """Read robot position data from OptiTrack"""
        if not self.optitrack_socket or not self.optitrack_running:
            return
        
        try:
            data = self.optitrack_socket.recv(4096)
            if data:
                # Decode and clean data (remove null bytes)
                decoded = data.decode('utf-8', errors='ignore')
                cleaned = decoded.replace('\x00', '').strip()
                
                if not cleaned:
                    return
                
                # Parse robot data: id,x,y,z,rotation;
                robot_positions = {}
                entries = cleaned.split(';')
                
                for entry in entries:
                    entry = entry.strip()
                    if not entry:
                        continue
                    
                    parts = entry.split(',')
                    if len(parts) >= 5:
                        try:
                            robot_id = int(parts[0].strip())
                            x = float(parts[1].strip())
                            y = -float(parts[2].strip())  # Invert Y sign (server sends inverted Y)
                            z = float(parts[3].strip())
                            rotation = float(parts[4].strip())
                            
                            # Skip if any value is NaN
                            if any(v != v for v in [x, y, z, rotation]):
                                continue
                            
                            robot_positions[robot_id] = {
                                'x': x, 'y': y, 'z': z, 'rotation': rotation
                            }
                            
                            # Store latest position of robot 2 (currently active robot) in main window for calibration preview
                            if robot_id == 2:
                                self.parent_window.latest_optitrack_position = (x, y)
                                
                        except (ValueError, IndexError):
                            # Skip invalid data
                            continue
                
                # Update OptiTrack visualization canvas
                if self.viz_mode == "optitrack":
                    self.optitrack_canvas.set_robot_positions(robot_positions)
                
        except socket.error:
            pass  # No data available
        except Exception as e:
            self.log(f"[OPTITRACK] ⚠️ Read error: {str(e)}")
    
    def stop_optitrack_connection(self):
        """Stop OptiTrack connection"""
        self.optitrack_running = False
        if hasattr(self, 'optitrack_timer'):
            self.optitrack_timer.stop()
        if self.optitrack_socket:
            try:
                self.optitrack_socket.close()
                self.log("[OPTITRACK] Connection closed")
            except:
                pass
            self.optitrack_socket = None
    
    def execution_timeout(self):
        """Called when execution exceeds maximum time"""
        self.log("[SYSTEM] ⚠️ EXECUTION TIMEOUT!")
        self.log(f"[SYSTEM] Maximum execution time ({self.max_execution_time}s) exceeded")
        self.update_status("TIMEOUT")
        
        # Apply abort penalty
        self.completion_time = self.current_time + 100.0  # Add 100s penalty
        
        self.log(f"[SYSTEM] Abort penalty applied: +100s")
        self.log(f"[SYSTEM] Final time: {self.completion_time:.2f}s")
        
        # TODO: Send stop commands to robots
        
        self.update_timer.stop()
        self.abort_btn.setEnabled(False)
        self.close_btn.setEnabled(True)
        
        QMessageBox.warning(self, "Timeout", 
                           f"Execution exceeded maximum time limit!\n\n"
                           f"Max time: {self.max_execution_time}s\n"
                           f"Actual time: {self.current_time:.2f}s\n"
                           f"Penalty: +100s\n"
                           f"Final time: {self.completion_time:.2f}s")
    
    def execution_complete(self):
        """Called when execution completes successfully"""
        self.update_status("DONE")
        self.completion_time = self.current_time
        self.log(f"[SYSTEM] Execution complete!")
        self.log(f"[SYSTEM] Total time: {self.completion_time:.2f}s")
        self.log("[SYSTEM] All robots returned to start position")
        
        self.update_timer.stop()
        self.abort_btn.setEnabled(False)
        self.close_btn.setEnabled(True)
        
        # Don't show success popup here - let execute_solution() handle it
        # QMessageBox.information(self, "Success", 
        #                        f"Execution completed successfully!\n\n"
        #                        f"Time: {self.completion_time:.2f} seconds")
    
    def abort_execution(self):
        """Abort execution"""
        reply = QMessageBox.question(self, "Abort Execution",
                                     "Are you sure you want to abort the execution?\n\n"
                                     "This will apply a +100s time penalty.",
                                     QMessageBox.Yes | QMessageBox.No)
        
        if reply != QMessageBox.Yes:
            return
        
        self.log("[USER] Execution aborted by user")
        self.update_status("ERROR_ABORT")
        
        # Apply penalty
        if self.start_time:
            self.completion_time = self.current_time + 100.0  # Add 100s penalty
        else:
            self.completion_time = 999.99  # Max penalty if not started
        
        self.log(f"[SYSTEM] Abort penalty applied: +100s")
        self.log(f"[SYSTEM] Final time: {self.completion_time:.2f}s")
        
        # TODO: Send stop commands to robots
        
        self.update_timer.stop()
        self.reject()
    
    def closeEvent(self, event):
        """Handle dialog close"""
        if self.execution_status not in ["DONE", "ERROR_ABORT", "TIMEOUT"]:
            # Closing early - apply penalty
            self.log("[SYSTEM] Dialog closed early - applying penalty")
            if self.start_time:
                self.completion_time = time.time() - self.start_time + 150.0  # Add 150s penalty
            else:
                self.completion_time = 999.99
            
            self.execution_status = "ERROR_CLOSE"
            self.log(f"[SYSTEM] Close penalty applied: +150s")
            self.log(f"[SYSTEM] Final time: {self.completion_time:.2f}s")
        
        # Stop camera and release resources
        self.camera_canvas.stop_camera_stream()
        
        # Stop OptiTrack connection
        self.stop_optitrack_connection()
        
        # Stop OptiTrack visualization
        self.optitrack_canvas.stop_visualization()
        
        self.update_timer.stop()
        event.accept()

class ExecutionCanvas(QGraphicsView):
    """Canvas for showing camera feed with solution overlay"""
    
    def __init__(self, parent_dialog, level_data, solution):
        super().__init__(parent_dialog)
        self.parent_dialog = parent_dialog
        self.level_data = level_data
        self.solution = solution
        self.scene = QGraphicsScene()
        self.setScene(self.scene)
        
        self.setRenderHint(QPainter.Antialiasing)
        self.setStyleSheet("background-color: #1e1e1e; border: 2px solid #333333;")
        self.setMinimumSize(700, 700)  # Match OptiTrack canvas size (square)
        
        # Camera feed state
        self.camera_active = False
        self.camera_capture = None
        self.camera_id = 0  # Default camera
        self.camera_timer = QTimer(self)
        self.camera_timer.timeout.connect(self.update_camera_feed)
        
        # Overlay items
        self.overlay_items = []
        
        # Camera frame item
        self.camera_frame_item = None
        
        # Scaling factors for coordinate transformation (level coords -> camera frame coords)
        self.scale_x = 1.0
        self.scale_y = 1.0
        self.offset_x = 0.0
        self.offset_y = 0.0
        
        # Draw initial placeholder
        self.draw_placeholder()
    
    def draw_placeholder(self):
        """Draw placeholder before camera starts"""
        self.scene.clear()
        
        # Add to scene
        text = self.scene.addText("📷 Waiting for camera feed...\n\nClick 'Start' to begin execution")
        text.setDefaultTextColor(QColor(100, 100, 100))
        font = text.font()
        font.setPointSize(20)
        text.setFont(font)
        
        # Center text
        boundary = self.level_data['boundary']
        text_rect = text.boundingRect()
        text.setPos((boundary['width'] - text_rect.width()) / 2,
                   (boundary['height'] - text_rect.height()) / 2)
        
        self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)
    
    def set_camera(self, camera_id):
        """Set/change the camera device"""
        # Stop timer first
        self.camera_timer.stop()
        
        # Release old camera if exists
        if self.camera_capture is not None:
            self.camera_capture.release()
            self.camera_capture = None
            # Wait for camera to be fully released
            import time
            time.sleep(0.2)
        
        # Open new camera
        self.camera_id = camera_id
        if camera_id >= 0:
            # Use DirectShow backend on Windows for better compatibility
            self.camera_capture = cv2.VideoCapture(camera_id, cv2.CAP_DSHOW)
            
            if self.camera_capture.isOpened():
                # Set camera resolution (optional, adjust as needed)
                self.camera_capture.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
                self.camera_capture.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
                # Set buffer size to 1 to reduce lag
                self.camera_capture.set(cv2.CAP_PROP_BUFFERSIZE, 1)
                
                self.parent_dialog.log(f"[CAMERA] Camera {camera_id} opened successfully")
                
                # If already streaming, restart
                if self.camera_active:
                    self.camera_timer.start(30)  # ~30 FPS
            else:
                self.parent_dialog.log(f"[CAMERA] ⚠️ Failed to open Camera {camera_id}")
                self.camera_capture = None
    
    def start_camera_stream(self):
        """Start streaming camera feed"""
        self.camera_active = True
        self.parent_dialog.log("[CAMERA] Starting camera stream...")
        
        # Initialize camera if not already done
        if self.camera_capture is None:
            camera_id = self.parent_dialog.camera_combo.currentData()
            if camera_id is None or camera_id < 0:
                camera_id = 0  # Default to first camera
            self.set_camera(camera_id)
        
        # Start camera update timer (30ms = ~33 FPS)
        if self.camera_capture is not None and self.camera_capture.isOpened():
            self.camera_timer.start(30)
            self.parent_dialog.log("[CAMERA] Camera stream active")
        else:
            self.parent_dialog.log("[CAMERA] ⚠️ No camera available!")
            self.draw_error_message()
    
    def draw_error_message(self):
        """Draw error message when camera is not available"""
        self.scene.clear()
        
        text = self.scene.addText("❌ Camera not available\n\nPlease check camera connection")
        text.setDefaultTextColor(QColor(255, 100, 100))
        font = text.font()
        font.setPointSize(20)
        text.setFont(font)
        
        boundary = self.level_data['boundary']
        text_rect = text.boundingRect()
        text.setPos((boundary['width'] - text_rect.width()) / 2,
                   (boundary['height'] - text_rect.height()) / 2)
        
        self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)
    
    def update_camera_feed(self):
        """Update camera feed frame - captures and displays real camera frame"""
        if self.camera_capture is None or not self.camera_capture.isOpened():
            self.camera_timer.stop()
            return
        
        try:
            # Capture frame from camera
            ret, frame = self.camera_capture.read()
            
            if not ret or frame is None:
                self.parent_dialog.log("[CAMERA] ⚠️ Failed to read frame")
                return
            
            # Convert BGR (OpenCV) to RGB (Qt)
            frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            
            # Get frame dimensions
            h, w, ch = frame_rgb.shape
            bytes_per_line = ch * w
            
            # Convert to QImage - make a copy to prevent data corruption
            q_image = QImage(frame_rgb.data, w, h, bytes_per_line, QImage.Format_RGB888).copy()
            
            # Convert to QPixmap
            pixmap = QPixmap.fromImage(q_image)
            
            # Scale pixmap to fit the boundary while maintaining aspect ratio
            boundary = self.level_data['boundary']
            scaled_pixmap = pixmap.scaled(boundary['width'], boundary['height'], 
                                          Qt.KeepAspectRatio, Qt.SmoothTransformation)
            
            # Get actual scaled pixmap dimensions (may be smaller than boundary due to aspect ratio)
            actual_width = scaled_pixmap.width()
            actual_height = scaled_pixmap.height()
            
            # Calculate scaling factors to transform level coordinates to camera frame coordinates
            self.scale_x = actual_width / boundary['width']
            self.scale_y = actual_height / boundary['height']
            
            # Calculate offsets to center the camera frame (if aspect ratios differ)
            self.offset_x = (boundary['width'] - actual_width) / 2.0
            self.offset_y = (boundary['height'] - actual_height) / 2.0
            
            # Clear scene and add camera frame
            self.scene.clear()
            self.overlay_items.clear()  # Clear overlay items when scene is cleared
            
            # Add camera frame as background, centered if needed
            self.camera_frame_item = self.scene.addPixmap(scaled_pixmap)
            self.camera_frame_item.setPos(self.offset_x, self.offset_y)
            
            # Draw solution overlay on top of camera feed
            self.draw_solution_overlay()
            
            # Draw dots on top for reference
            self.draw_reference_dots()
            
            # Fit view (don't do this every frame - causes lag)
            # self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)
            
        except Exception as e:
            self.parent_dialog.log(f"[CAMERA] ⚠️ Error updating feed: {str(e)}")
            self.camera_timer.stop()
    
    def draw_reference_dots(self):
        """Draw reference dots on top of camera feed"""
        dot_radius = 15
        for color_name, positions in self.level_data['dots'].items():
            # Skip if positions are None (robot not active in this level)
            if positions['start'] is None or positions['end'] is None:
                continue
                
            color = self.parent_dialog.parent_window.colors[color_name]
            
            # Transform coordinates from level space to camera frame space
            start_x = positions['start'][0] * self.scale_x + self.offset_x
            start_y = positions['start'][1] * self.scale_y + self.offset_y
            end_x = positions['end'][0] * self.scale_x + self.offset_x
            end_y = positions['end'][1] * self.scale_y + self.offset_y
            
            # Start dot (semi-transparent)
            pen = QPen(color, 3)
            brush = QColor(color.red(), color.green(), color.blue(), 100)
            self.scene.addEllipse(start_x - dot_radius, start_y - dot_radius,
                                 dot_radius * 2, dot_radius * 2, pen, brush)
            
            # Label
            text = self.scene.addText("S")
            text.setPos(start_x - 5, start_y - 12)
            text.setDefaultTextColor(QColor(255, 255, 255))
            font = text.font()
            font.setBold(True)
            text.setFont(font)
            
            # End dot (semi-transparent)
            self.scene.addEllipse(end_x - dot_radius, end_y - dot_radius,
                                 dot_radius * 2, dot_radius * 2, pen, brush)
            
            # Label
            text = self.scene.addText("E")
            text.setPos(end_x - 5, end_y - 12)
            text.setDefaultTextColor(QColor(255, 255, 255))
            font = text.font()
            font.setBold(True)
            text.setFont(font)

    def draw_solution_overlay(self):
        """Draw solution paths as overlay"""
        # Remove old overlay safely
        for item in self.overlay_items:
            if item.scene() == self.scene:  # Only remove if item belongs to this scene
                self.scene.removeItem(item)
        self.overlay_items.clear()
        
        # Draw solution paths with current opacity
        for color_name, path in self.solution.items():
            if len(path) < 2:
                continue
            
            color = self.parent_dialog.parent_window.colors[color_name]
            
            # Apply opacity
            overlay_color = QColor(color.red(), color.green(), color.blue(), 
                                  self.parent_dialog.overlay_opacity)
            pen = QPen(overlay_color, 6, Qt.SolidLine, Qt.RoundCap, Qt.RoundJoin)
            
            for i in range(len(path) - 1):
                # Transform coordinates from level space to camera frame space
                x1 = path[i][0] * self.scale_x + self.offset_x
                y1 = path[i][1] * self.scale_y + self.offset_y
                x2 = path[i + 1][0] * self.scale_x + self.offset_x
                y2 = path[i + 1][1] * self.scale_y + self.offset_y
                
                line = self.scene.addLine(x1, y1, x2, y2, pen)
                self.overlay_items.append(line)
    
    def update_overlay_opacity(self, opacity):
        """Update overlay opacity"""
        self.draw_solution_overlay()
    
    def stop_camera_stream(self):
        """Stop camera stream and release camera"""
        self.camera_active = False
        self.camera_timer.stop()
        
        if self.camera_capture is not None:
            self.camera_capture.release()
            self.camera_capture = None
            self.parent_dialog.log("[CAMERA] Camera released")
    
    def resizeEvent(self, event):
        """Re-fit view when widget is resized"""
        super().resizeEvent(event)
        if self.scene.sceneRect():
            self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)


class OptiTrackCalibrationPreview(QWidget):
    """Live preview canvas for OptiTrack calibration dialog with coordinate axes and log display"""
    
    def __init__(self, parent_dialog, main_window):
        super().__init__(parent_dialog)
        self.parent_dialog = parent_dialog
        self.main_window = main_window
        
        # Main layout
        layout = QVBoxLayout(self)
        layout.setContentsMargins(0, 0, 0, 0)
        
        # Graphics view for canvas
        self.graphics_view = QGraphicsView()
        self.scene = QGraphicsScene()
        self.graphics_view.setScene(self.scene)
        
        # Black background
        self.graphics_view.setStyleSheet("background-color: black;")
        self.scene.setBackgroundBrush(QBrush(QColor(0, 0, 0)))
        
        # Set fixed scene size (square for 1.8x1.8m bounds)
        self.scene.setSceneRect(0, 0, 600, 600)
        
        layout.addWidget(self.graphics_view)
        
        # Log display frame
        log_frame = QFrame()
        log_frame.setFrameStyle(QFrame.Box | QFrame.Raised)
        log_frame.setStyleSheet("background-color: #1e1e1e; border: 2px solid #444;")
        log_layout = QVBoxLayout(log_frame)
        
        log_title = QLabel("<b style='color: white;'>Robot Position (OptiTrack)</b>")
        log_layout.addWidget(log_title)
        
        # Connection status
        self.connection_label = QLabel()
        self.connection_label.setStyleSheet("""
            color: #ffa500;
            font-family: 'Courier New', monospace;
            font-size: 11px;
            padding: 3px;
        """)
        self.connection_label.setText("Status: Connecting...")
        log_layout.addWidget(self.connection_label)
        
        # Position display
        self.position_label = QLabel()
        self.position_label.setStyleSheet("""
            color: #00ff00;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            padding: 5px;
        """)
        self.position_label.setText("X = 0.000 m\nY = 0.000 m\nZ = 0.000 m\nRotation = 0.0°")
        log_layout.addWidget(self.position_label)
        
        # Raw data display (for debugging)
        self.raw_data_label = QLabel()
        self.raw_data_label.setStyleSheet("""
            color: #888888;
            font-family: 'Courier New', monospace;
            font-size: 9px;
            padding: 3px;
        """)
        self.raw_data_label.setText("Raw: (waiting for data...)")
        log_layout.addWidget(self.raw_data_label)
        
        layout.addWidget(log_frame)
        
        # Canvas state
        self.robot_dot = None
        self.frame_rect = None
        self.current_frame_corners = None
        self.axes_items = []  # Store axes graphics items
        
        # Debug counters
        self.data_receive_count = 0
        self.last_update_time = time.time()
        
        # Timer for real-time robot position updates
        self.update_timer = QTimer(self)
        self.update_timer.timeout.connect(self.update_robot_position)
        self.update_timer.start(50)  # Update every 50ms
        
        # OptiTrack connection for real-time preview
        self.optitrack_socket = None
        self.optitrack_timer = None
        self.start_optitrack_connection()
        
        self.draw_initial_view()
    
    def draw_initial_view(self):
        """Draw the red dot at initial position and coordinate axes"""
        # Red dot - will be updated with real robot position
        robot_radius = 12
        center_x = 300  # Center of 600px width
        center_y = 300  # Center of 600px height (square canvas)
        
        self.robot_dot = self.scene.addEllipse(
            center_x - robot_radius, center_y - robot_radius,
            robot_radius * 2, robot_radius * 2,
            QPen(QColor(255, 255, 255), 2),
            QBrush(QColor(255, 0, 0))  # Red
        )
        
        # Draw coordinate axes
        self.draw_axes()
        
        # Fit view
        self.graphics_view.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)
    
    def draw_axes(self):
        """Draw coordinate axes with labels (OptiTrack coordinate system)"""
        # Clear previous axes
        for item in self.axes_items:
            self.scene.removeItem(item)
        self.axes_items.clear()
        
        # Get bounds from main window settings
        BACKGROUND_MIN_X = self.main_window.optitrack_bounds_min_x
        BACKGROUND_MAX_X = self.main_window.optitrack_bounds_max_x
        BACKGROUND_MIN_Y = self.main_window.optitrack_bounds_min_y
        BACKGROUND_MAX_Y = self.main_window.optitrack_bounds_max_y
        
        # Draw Y-axis grid (VERTICAL lines, since Y is horizontal)
        # Y range: -0.4 to 1.4 (1.8m range)
        y_range = abs(BACKGROUND_MAX_Y - BACKGROUND_MIN_Y)
        y_step = 0.2 if y_range <= 2 else 0.5
        y_values = [BACKGROUND_MIN_Y + i * y_step for i in range(int(y_range / y_step) + 1)]
        
        for y in y_values:
            # Y maps to canvas X (horizontal position)
            norm_y = (y - BACKGROUND_MIN_Y) / (BACKGROUND_MAX_Y - BACKGROUND_MIN_Y)
            canvas_x = (1 - norm_y) * 600  # Y: 1.4 (left=0) → -0.4 (right=600)
            
            # Draw vertical line (all values in gray/white)
            if abs(y) < 0.01:  # Y=0 - white line
                pen = QPen(QColor(255, 255, 255), 1)
            else:
                pen = QPen(QColor(100, 100, 100), 1)  # Gray grid
            
            line = self.scene.addLine(canvas_x, 0, canvas_x, 600, pen)
            self.axes_items.append(line)
            
            # Add label on horizontal center line (y=300) - just the number
            text = self.scene.addText(f"{y:.1f}", QFont("Arial", 8, QFont.Bold))
            text.setDefaultTextColor(QColor(255, 255, 255))
            text.setPos(canvas_x - 15, 295)  # On horizontal center line
            self.axes_items.append(text)
        
        # Draw X-axis grid (HORIZONTAL lines, since X is vertical)
        # X range: -2.8 to -1.0 (1.8m range)
        x_range = abs(BACKGROUND_MAX_X - BACKGROUND_MIN_X)
        x_step = 0.2 if x_range <= 2 else 0.5
        x_values = [BACKGROUND_MIN_X + i * x_step for i in range(int(x_range / x_step) + 1)]
        
        for x in x_values:
            # X maps to canvas Y (vertical position)
            norm_x = (x - BACKGROUND_MIN_X) / (BACKGROUND_MAX_X - BACKGROUND_MIN_X)
            canvas_y = norm_x * 600  # REVERSED: X: -2.8 (bottom=600) → -1.0 (top=0)
            
            # Draw horizontal line (all values in gray, no X=0 in range)
            pen = QPen(QColor(100, 100, 100), 1)  # Gray grid
            
            line = self.scene.addLine(0, canvas_y, 600, canvas_y, pen)
            self.axes_items.append(line)
            
            # Add label on vertical center line (x=300) - just the number
            text = self.scene.addText(f"{x:.1f}", QFont("Arial", 8, QFont.Bold))
            text.setDefaultTextColor(QColor(255, 255, 255))
            text.setPos(260, canvas_y - 10)  # Left of vertical center line to avoid overlap
            self.axes_items.append(text)
        
        # Draw center cross lines (GREEN axes)
        center_x = 300  # Canvas center
        center_y = 300
        
        # Vertical center line (green - Y axis)
        center_v_line = self.scene.addLine(center_x, 0, center_x, 600, QPen(QColor(0, 255, 0), 2))
        self.axes_items.append(center_v_line)
        
        # Horizontal center line (green - X axis)
        center_h_line = self.scene.addLine(0, center_y, 600, center_y, QPen(QColor(0, 255, 0), 2))
        self.axes_items.append(center_h_line)
        
        # Note: Axis direction labels removed as real-world X/Y directions don't match screen intuition
        # X increases from bottom to top (opposite of screen), Y increases from right to left
    
    def update_robot_position(self):
        """Update robot dot position from OptiTrack real-time data"""
        try:
            # Check connection status
            current_time = time.time()
            time_since_update = current_time - self.last_update_time
            
            # Update connection status display
            if time_since_update > 2.0:
                self.connection_label.setText(f"Status: ⚠️ No data ({time_since_update:.1f}s)")
                self.connection_label.setStyleSheet("""
                    color: #ff0000;
                    font-family: 'Courier New', monospace;
                    font-size: 11px;
                    padding: 3px;
                """)
            elif time_since_update > 0.5:
                self.connection_label.setText(f"Status: ⏸️ Slow ({time_since_update:.1f}s)")
                self.connection_label.setStyleSheet("""
                    color: #ffa500;
                    font-family: 'Courier New', monospace;
                    font-size: 11px;
                    padding: 3px;
                """)
            else:
                self.connection_label.setText(f"Status: ✓ Connected ({self.data_receive_count} packets)")
                self.connection_label.setStyleSheet("""
                    color: #00ff00;
                    font-family: 'Courier New', monospace;
                    font-size: 11px;
                    padding: 3px;
                """)
            
            # Get latest OptiTrack position from main window
            if hasattr(self.main_window, 'latest_optitrack_position'):
                opti_x, opti_y = self.main_window.latest_optitrack_position
                
                # Also get Z and rotation if available
                opti_z = 0.0
                opti_rotation = 0.0
                if hasattr(self.main_window, 'latest_optitrack_full'):
                    data = self.main_window.latest_optitrack_full
                    opti_z = data.get('z', 0.0)
                    opti_rotation = data.get('rotation', 0.0)
                
                # Update position label
                self.position_label.setText(
                    f"X = {opti_x:+.3f} m\n"
                    f"Y = {opti_y:+.3f} m\n"
                    f"Z = {opti_z:+.3f} m\n"
                    f"Rotation = {opti_rotation:.1f}°"
                )
                
                # Transform using fixed background bounds
                canvas_x, canvas_y = self._preview_transform(opti_x, opti_y)
                
                # Update robot dot position - use setRect instead of setPos for QGraphicsEllipseItem
                robot_radius = 12
                self.robot_dot.setRect(
                    canvas_x - robot_radius, 
                    canvas_y - robot_radius,
                    robot_radius * 2, 
                    robot_radius * 2
                )
        except Exception as e:
            # Silent - already debugged
            pass

    
    def start_optitrack_connection(self):
        """Start OptiTrack connection for real-time preview"""
        try:
            import socket
            self.optitrack_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.optitrack_socket.settimeout(3)  # 3 second timeout for connection
            
            self.optitrack_socket.connect((self.main_window.optitrack_server_ip, self.main_window.optitrack_port))
            self.optitrack_socket.setblocking(False)
            
            # Start timer to read data
            self.optitrack_timer = QTimer(self)
            self.optitrack_timer.timeout.connect(self.read_optitrack_data)
            self.optitrack_timer.start(30)  # Read every 30ms
            
            self.connection_label.setText("Status: ✓ Connected (waiting for data...)")
            self.connection_label.setStyleSheet("""
                color: #00ff00;
                font-family: 'Courier New', monospace;
                font-size: 11px;
                padding: 3px;
            """)
        except Exception as e:
            self.connection_label.setText(f"Status: ✗ Connection Failed")
            self.connection_label.setStyleSheet("""
                color: #ff0000;
                font-family: 'Courier New', monospace;
                font-size: 11px;
                padding: 3px;
            """)
            self.optitrack_socket = None
    
    def read_optitrack_data(self):
        """Read robot position data from OptiTrack"""
        if not self.optitrack_socket:
            return
        
        try:
            data = self.optitrack_socket.recv(4096)
            if data:
                # Decode and clean data (remove null bytes)
                decoded = data.decode('utf-8', errors='ignore')
                cleaned = decoded.replace('\x00', '').strip()
                
                # Update raw data display (first 100 chars)
                display_data = cleaned[:100] + "..." if len(cleaned) > 100 else cleaned
                self.raw_data_label.setText(f"Raw: {display_data}")
                
                if not cleaned:
                    return
                
                # Increment data receive counter
                self.data_receive_count += 1
                self.last_update_time = time.time()
                
                # Parse robot data: id,x,y,z,rotation;
                entries = cleaned.split(';')
                
                robot_found = False
                for entry in entries:
                    entry = entry.strip()
                    if not entry:
                        continue
                    
                    parts = entry.split(',')
                    if len(parts) >= 5:
                        try:
                            robot_id = int(parts[0].strip())
                            x = float(parts[1].strip())
                            y = -float(parts[2].strip())  # Invert Y sign (server sends inverted Y)
                            z = float(parts[3].strip())
                            rotation = float(parts[4].strip())
                            
                            # Skip if any value is NaN
                            if x != x or y != y:
                                continue
                            
                            # Update main window's latest position (robot 2 = currently active robot)
                            if robot_id == 2:
                                self.main_window.latest_optitrack_position = (x, y)
                                # Store full data for display
                                self.main_window.latest_optitrack_full = {
                                    'x': x, 'y': y, 'z': z, 'rotation': rotation
                                }
                                robot_found = True
                                
                        except (ValueError, IndexError):
                            continue
                
        except socket.error:
            # No data available (non-blocking socket)
            pass
        except Exception:
            # Silent - errors not critical
            pass

    
    def stop_optitrack_connection(self):
        """Stop OptiTrack connection"""
        if self.optitrack_timer:
            self.optitrack_timer.stop()
            self.optitrack_timer = None
        
        if self.optitrack_socket:
            try:
                self.optitrack_socket.close()
            except:
                pass
            self.optitrack_socket = None
    
    def update_frame(self, corners, adjust=True):
        """Update the white frame based on entered corners
        
        Args:
            corners: List of 4 (x, y) tuples in OptiTrack coordinates, or None for default
            adjust: If True, auto-adjust corners to form rectangle. If False, use as-is.
        """
        # Fixed background bounds
        BACKGROUND_MIN_X = -2.0
        BACKGROUND_MAX_X = 2.0
        BACKGROUND_MIN_Y = -1.5
        BACKGROUND_MAX_Y = 1.5
        
        # Remove old frame if exists
        if self.frame_rect is not None:
            self.scene.removeItem(self.frame_rect)
            self.frame_rect = None
        
        # Don't show frame if no corners provided or incomplete
        if corners is None or len(corners) != 4:
            self.current_frame_corners = None
            # Redraw axes (may have been cleared)
            self.draw_axes()
            return
        
        # Determine frame corners
        if adjust:
            frame_corners = self._adjust_to_rectangle(corners)
        else:
            # Use exact corners as entered by user
            frame_corners = corners
        
        # Validate: all corners must be within background bounds
        for x, y in frame_corners:
            if (x < BACKGROUND_MIN_X or x > BACKGROUND_MAX_X or 
                y < BACKGROUND_MIN_Y or y > BACKGROUND_MAX_Y):
                # Frame is outside bounds, don't show it
                self.current_frame_corners = None
                self.draw_axes()
                return
        
        # Store current frame for robot position transformation
        self.current_frame_corners = frame_corners
        
        # Transform OptiTrack corners to canvas coordinates for preview
        canvas_corners = []
        for opti_x, opti_y in frame_corners:
            canvas_x, canvas_y = self._preview_transform(opti_x, opti_y)
            canvas_corners.append((canvas_x, canvas_y))
        
        # Redraw axes (to ensure they're visible)
        self.draw_axes()
        
        # Draw frame as white rectangle outline (on top of axes)
        if len(canvas_corners) == 4:
            # Create polygon from corners
            polygon = QPolygonF()
            for x, y in canvas_corners:
                polygon.append(QPointF(x, y))
            
            self.frame_rect = self.scene.addPolygon(
                polygon,
                QPen(QColor(255, 255, 255), 3),  # White, 3px thick
                QBrush(Qt.NoBrush)  # No fill
            )

    
    def _adjust_to_rectangle(self, corners):
        """Same logic as main window's _adjust_to_rectangle"""
        center_x = sum(p[0] for p in corners) / 4
        center_y = sum(p[1] for p in corners) / 4
        
        distances_x = [abs(p[0] - center_x) for p in corners]
        distances_y = [abs(p[1] - center_y) for p in corners]
        
        avg_dx = sum(distances_x) / 4
        avg_dy = sum(distances_y) / 4
        
        adjusted = [
            (center_x - avg_dx, center_y + avg_dy),  # Top-Left
            (center_x + avg_dx, center_y + avg_dy),  # Top-Right
            (center_x + avg_dx, center_y - avg_dy),  # Bottom-Right
            (center_x - avg_dx, center_y - avg_dy)   # Bottom-Left
        ]
        
        return adjusted
    
    def _preview_transform(self, opti_x, opti_y, frame_corners=None):
        """Transform OptiTrack coordinates to canvas coordinates for preview
        
        Maps OptiTrack coordinates to canvas using background bounds from settings:
        Canvas: 600x600 (square)
        Real-world: X goes vertical (top to bottom), Y goes horizontal (left to right)
        """
        # Get background bounds from main window settings
        BACKGROUND_MIN_X = self.main_window.optitrack_bounds_min_x
        BACKGROUND_MAX_X = self.main_window.optitrack_bounds_max_x
        BACKGROUND_MIN_Y = self.main_window.optitrack_bounds_min_y
        BACKGROUND_MAX_Y = self.main_window.optitrack_bounds_max_y
        
        # Normalize to 0-1 based on BACKGROUND bounds
        norm_x = (opti_x - BACKGROUND_MIN_X) / (BACKGROUND_MAX_X - BACKGROUND_MIN_X)
        norm_y = (opti_y - BACKGROUND_MIN_Y) / (BACKGROUND_MAX_Y - BACKGROUND_MIN_Y)
        
        # SWAP X and Y for proper orientation:
        # - OptiTrack Y → Canvas X (horizontal: Y decreases left to right)
        # - OptiTrack X → Canvas Y (vertical: X decreases top to bottom)
        canvas_x = (1 - norm_y) * 600  # Y: 1.4 (left) → -0.4 (right)
        canvas_y = norm_x * 600  # REVERSED: X: -2.8 (bottom) → -1.0 (top)
        
        return canvas_x, canvas_y
    
    def resizeEvent(self, event):
        """Re-fit view when widget is resized"""
        super().resizeEvent(event)
        if self.scene.sceneRect():
            self.graphics_view.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)
    
    def closeEvent(self, event):
        """Cleanup when preview is closed"""
        self.stop_optitrack_connection()
        super().closeEvent(event)


class OptiTrackVizCanvas(QGraphicsView):
    """Canvas for OptiTrack visualization mode - with coordinate axes like calibration preview"""
    
    def __init__(self, parent_dialog, level_data, solution):
        super().__init__(parent_dialog)
        self.parent_dialog = parent_dialog
        self.level_data = level_data
        self.solution = solution
        self.scene = QGraphicsScene()
        self.setScene(self.scene)
        
        self.setRenderHint(QPainter.Antialiasing)
        self.setStyleSheet("background-color: #000000; border: 2px solid #333333;")
        
        # Set fixed scene size (square for 1.8x1.8m bounds)
        self.scene.setSceneRect(0, 0, 700, 700)
        
        # Robot position state (from OptiTrack)
        self.robot_positions = {}  # {robot_id: {'x': x, 'y': y, 'z': z, 'rotation': rot}}
        self.robot_graphics = {}    # {robot_id: QGraphicsEllipseItem}
        self.axes_items = []  # Store axes graphics items
        
        # Update timer
        self.update_timer = QTimer(self)
        self.update_timer.timeout.connect(self.update_robot_positions)
        
        # Draw initial elements
        self.draw_axes()
        self.draw_static_elements()
    
    def draw_axes(self):
        """Draw coordinate axes with labels (OptiTrack coordinate system)"""
        # Clear previous axes
        for item in self.axes_items:
            self.scene.removeItem(item)
        self.axes_items.clear()
        
        # Get background bounds from main window settings
        BACKGROUND_MIN_X = self.parent_dialog.parent_window.optitrack_bounds_min_x
        BACKGROUND_MAX_X = self.parent_dialog.parent_window.optitrack_bounds_max_x
        BACKGROUND_MIN_Y = self.parent_dialog.parent_window.optitrack_bounds_min_y
        BACKGROUND_MAX_Y = self.parent_dialog.parent_window.optitrack_bounds_max_y
        
        # Draw Y-axis grid (VERTICAL lines, since Y is horizontal)
        # Y range: -0.4 to 1.4 (1.8m range)
        y_range = abs(BACKGROUND_MAX_Y - BACKGROUND_MIN_Y)
        y_step = 0.2 if y_range <= 2 else 0.5
        y_values = [BACKGROUND_MIN_Y + i * y_step for i in range(int(y_range / y_step) + 1)]
        
        for y in y_values:
            # Y maps to canvas X (horizontal position)
            norm_y = (y - BACKGROUND_MIN_Y) / (BACKGROUND_MAX_Y - BACKGROUND_MIN_Y)
            canvas_x = (1 - norm_y) * 700  # Y: 1.4 (left=0) → -0.4 (right=700)
            
            # Draw vertical line (all values in gray/white)
            if abs(y) < 0.01:  # Y=0 - white line
                pen = QPen(QColor(255, 255, 255), 1)
            else:
                pen = QPen(QColor(100, 100, 100), 1)  # Gray grid
            
            line = self.scene.addLine(canvas_x, 0, canvas_x, 700, pen)
            self.axes_items.append(line)
            
            # Add label on horizontal center line (y=350) - just the number
            text = self.scene.addText(f"{y:.1f}", QFont("Arial", 8, QFont.Bold))
            text.setDefaultTextColor(QColor(255, 255, 255))
            text.setPos(canvas_x - 15, 345)  # On horizontal center line
            self.axes_items.append(text)
        
        # Draw X-axis grid (HORIZONTAL lines, since X is vertical)
        # X range: -2.8 to -1.0 (1.8m range)
        x_range = abs(BACKGROUND_MAX_X - BACKGROUND_MIN_X)
        x_step = 0.2 if x_range <= 2 else 0.5
        x_values = [BACKGROUND_MIN_X + i * x_step for i in range(int(x_range / x_step) + 1)]
        
        for x in x_values:
            # X maps to canvas Y (vertical position)
            norm_x = (x - BACKGROUND_MIN_X) / (BACKGROUND_MAX_X - BACKGROUND_MIN_X)
            canvas_y = norm_x * 700  # REVERSED: X: -2.8 (bottom=700) → -1.0 (top=0)
            
            # Draw horizontal line (all values in gray, no X=0 in range)
            pen = QPen(QColor(100, 100, 100), 1)  # Gray grid
            
            line = self.scene.addLine(0, canvas_y, 700, canvas_y, pen)
            self.axes_items.append(line)
            
            # Add label on vertical center line (x=350) - just the number
            text = self.scene.addText(f"{x:.1f}", QFont("Arial", 8, QFont.Bold))
            text.setDefaultTextColor(QColor(255, 255, 255))
            text.setPos(310, canvas_y - 10)  # Left of vertical center line to avoid overlap
            self.axes_items.append(text)
        
        # Draw center cross lines (GREEN axes)
        center_x = 350  # Canvas center (700/2)
        center_y = 350
        
        # Vertical center line (green - Y axis)
        center_v_line = self.scene.addLine(center_x, 0, center_x, 700, QPen(QColor(0, 255, 0), 2))
        self.axes_items.append(center_v_line)
        
        # Horizontal center line (green - X axis)
        center_h_line = self.scene.addLine(0, center_y, 700, center_y, QPen(QColor(0, 255, 0), 2))
        self.axes_items.append(center_h_line)
        
        # Note: Axis direction labels removed as real-world X/Y directions don't match screen intuition
        # X increases from bottom to top (opposite of screen), Y increases from right to left
    
    def _transform_to_canvas(self, opti_x, opti_y):
        """Transform OptiTrack coordinates to canvas coordinates (same as calibration)
        Real-world: X goes vertical (top to bottom), Y goes horizontal (left to right)
        """
        # Get background bounds from main window settings
        BACKGROUND_MIN_X = self.parent_dialog.parent_window.optitrack_bounds_min_x
        BACKGROUND_MAX_X = self.parent_dialog.parent_window.optitrack_bounds_max_x
        BACKGROUND_MIN_Y = self.parent_dialog.parent_window.optitrack_bounds_min_y
        BACKGROUND_MAX_Y = self.parent_dialog.parent_window.optitrack_bounds_max_y
        
        # Normalize to 0-1
        norm_x = (opti_x - BACKGROUND_MIN_X) / (BACKGROUND_MAX_X - BACKGROUND_MIN_X)
        norm_y = (opti_y - BACKGROUND_MIN_Y) / (BACKGROUND_MAX_Y - BACKGROUND_MIN_Y)
        
        # SWAP X and Y for proper orientation:
        # - OptiTrack Y → Canvas X (horizontal: Y decreases left to right)
        # - OptiTrack X → Canvas Y (vertical: X decreases top to bottom)
        canvas_x = (1 - norm_y) * 700  # Y: 1.4 (left) → -0.4 (right)
        canvas_y = norm_x * 700  # REVERSED: X: -2.8 (bottom) → -1.0 (top)
        
        return canvas_x, canvas_y
    
    def draw_static_elements(self):
        """Draw START and END dots on the coordinate system"""
        # Map robot IDs to colors
        robot_color_map = {
            1: 'red',
            2: 'green',
            3: 'blue',
            4: 'yellow'
        }
        
        # Note: START/END dots are drawn in game coordinate system (0-600, 0-400)
        # not OptiTrack coordinate system. We can skip them or transform them.
        # For now, skip to keep clean axes view
        pass

    
    def start_visualization(self):
        """Start updating robot positions"""
        self.update_timer.start(30)  # 30ms = ~33 FPS
    
    def stop_visualization(self):
        """Stop updating robot positions"""
        self.update_timer.stop()
    
    def set_robot_positions(self, positions):
        """Update robot positions from OptiTrack data"""
        # positions: {robot_id: {'x': x, 'y': y, 'z': z, 'rotation': rot}}
        self.robot_positions = positions
    
    def update_robot_positions(self):
        """Update robot graphics based on OptiTrack data"""
        if not self.robot_positions:
            return
        
        # Map robot IDs to colors
        robot_color_map = {
            1: 'red',
            2: 'green',
            3: 'blue',
            4: 'yellow'
        }
        
        for robot_id, pos_data in self.robot_positions.items():
            color_name = robot_color_map.get(robot_id)
            if not color_name:
                continue
            
            # Transform OptiTrack coordinates to canvas coordinates
            opti_x = pos_data['x']
            opti_y = pos_data['y']
            
            canvas_x, canvas_y = self._transform_to_canvas(opti_x, opti_y)
            
            # Clamp to visible area (700x700 square)
            canvas_x = max(0, min(700, canvas_x))
            canvas_y = max(0, min(700, canvas_y))
            
            # Update or create robot graphic
            robot_radius = 12
            color = self.parent_dialog.parent_window.colors[color_name]
            
            if robot_id in self.robot_graphics:
                # Update existing robot position - use setRect for ellipse
                robot_item = self.robot_graphics[robot_id]
                robot_item.setRect(
                    canvas_x - robot_radius, 
                    canvas_y - robot_radius,
                    robot_radius * 2, 
                    robot_radius * 2
                )
            else:
                # Create new robot graphic
                robot_item = self.scene.addEllipse(
                    canvas_x - robot_radius, canvas_y - robot_radius,
                    robot_radius * 2, robot_radius * 2,
                    QPen(QColor(255, 255, 255), 2),
                    QBrush(color)
                )
                self.robot_graphics[robot_id] = robot_item
    
    def resizeEvent(self, event):
        """Re-fit view when widget is resized"""
        super().resizeEvent(event)
        if self.scene.sceneRect():
            self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)


def main():
    app = QApplication(sys.argv)
    window = DotConnectGame()
    window.show()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()