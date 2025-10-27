import sys
import json
import os
import random
import time
from datetime import datetime
import numpy as np
# from scipy.interpolate import splprep, splev
from PyQt5.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, 
                             QHBoxLayout, QPushButton, QTabWidget, QLabel,
                             QComboBox, QGraphicsView, QGraphicsScene, QFrame,
                             QTableWidget, QTableWidgetItem, QHeaderView, QDialog,
                             QLineEdit, QMessageBox, QInputDialog, QSlider, QRadioButton,
                             QButtonGroup, QGroupBox, QTextEdit)
from PyQt5.QtCore import Qt, QPointF, QUrl, QTimer, pyqtSignal

from PyQt5.QtGui import QPainter, QColor, QPen, QPixmap
from PyQt5.QtMultimedia import QMediaPlayer, QMediaPlaylist, QMediaContent

class DotConnectGame(QMainWindow):
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
        
        # Setup UI
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
            'reality_velocity': self.reality_velocity
        }
        
        os.makedirs(os.path.dirname(self.settings_file), exist_ok=True)
        with open(self.settings_file, 'w') as f:
            json.dump(settings, f, indent=2)


    def init_levels(self):
        """Initialize level data structure"""
        self.levels = {
            # Fixed levels (1-5)
            1: {
                'name': 'Level 1',
                'fixed': True,
                'boundary': {'width': 600, 'height': 400},
                'dots': {
                    'red': {'start': (50, 50), 'end': (550, 350)},
                    'green': {'start': (550, 50), 'end': (50, 350)},
                    'blue': {'start': (300, 50), 'end': (300, 350)},
                    'yellow': {'start': (50, 200), 'end': (550, 200)}
                }
            },
            2: {
                'name': 'Level 2',
                'fixed': True,
                'boundary': {'width': 600, 'height': 400},
                'dots': {
                    'red': {'start': (100, 100), 'end': (500, 300)},
                    'green': {'start': (500, 100), 'end': (100, 300)},
                    'blue': {'start': (100, 200), 'end': (500, 200)},
                    'yellow': {'start': (300, 100), 'end': (300, 300)}
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
                    'yellow': {'start': (300, 80), 'end': (300, 320)}
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
            5: {
                'name': 'Level 5',
                'fixed': True,
                'boundary': {'width': 600, 'height': 400},
                'dots': {
                    'red': {'start': (120, 120), 'end': (480, 280)},
                    'green': {'start': (480, 120), 'end': (120, 280)},
                    'blue': {'start': (300, 80), 'end': (300, 320)},
                    'yellow': {'start': (80, 200), 'end': (520, 200)}
                }
            },
            # Customizable levels (6-8)
            6: {
                'name': 'Custom Alpha (α)',
                'fixed': False,
                'boundary': {'width': 600, 'height': 400},
                'dots': {
                    'red': {'start': (100, 100), 'end': (500, 300)},
                    'green': {'start': (500, 100), 'end': (100, 300)},
                    'blue': {'start': (100, 200), 'end': (500, 200)},
                    'yellow': {'start': (300, 100), 'end': (300, 300)}
                }
            },
            7: {
                'name': 'Custom Beta (β)',
                'fixed': False,
                'boundary': {'width': 600, 'height': 400},
                'dots': {
                    'red': {'start': (100, 100), 'end': (500, 300)},
                    'green': {'start': (500, 100), 'end': (100, 300)},
                    'blue': {'start': (100, 200), 'end': (500, 200)},
                    'yellow': {'start': (300, 100), 'end': (300, 300)}
                }
            },
            8: {
                'name': 'Custom Omega (Ω)',
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
            initial_scores = {str(i): [] for i in range(1, 9)}
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
                
                # Update customizable levels (6-8) with saved data
                for level_num in [6, 7, 8]:
                    level_key = str(level_num)
                    if level_key in custom_data:
                        self.levels[level_num]['dots'] = custom_data[level_key]['dots']
        except:
            pass
    
    def save_custom_levels(self):
        """Save custom level configurations"""
        custom_data = {}
        for level_num in [6, 7, 8]:
            custom_data[str(level_num)] = {
                'dots': self.levels[level_num]['dots']
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
        for i in range(1, 9):
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
        if self.hs_current_level < 8:
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
        for i in range(1, 9):
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

            
            # Buttons
            send_btn = QPushButton("Check Sending")
            send_btn.setMinimumHeight(40)
            send_btn.setStyleSheet("""
                background-color: #e0e0e0;
                color: black;
                font-weight: bold;
                font-size: 14px;
                border: 2px solid #999999;
            """)
            send_btn.clicked.connect(lambda checked, c=color_name: self.check_sending(c))
            robot_layout.addWidget(send_btn)
            
            receive_btn = QPushButton("Check Receiving")
            receive_btn.setMinimumHeight(40)
            receive_btn.setStyleSheet("""
                background-color: #e0e0e0;
                color: black;
                font-weight: bold;
                font-size: 14px;
                border: 2px solid #999999;
            """)
            receive_btn.clicked.connect(lambda checked, c=color_name: self.check_receiving(c))
            robot_layout.addWidget(receive_btn)
            
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


    def check_sending(self, color):
        """Check sending capability for a robot"""
        color_upper = color.capitalize()
        print(f"[DEBUG] Checking SENDING for {color_upper} Robot")
        print(f"[DEBUG] Attempting to send test packet to {color_upper} Robot...")
        print(f"[DEBUG] Port: /dev/{color}_robot | Protocol: TCP/IP")
        print(f"[DEBUG] Status: PLACEHOLDER - No actual communication yet")
        print("-" * 60)
        
        self.debug_status_label.setText(
            f"✓ SENDING Test - {color_upper} Robot\n"
            f"Port: /dev/{color}_robot\n"
            f"Protocol: TCP/IP\n"
            f"Status: PLACEHOLDER - Ready for implementation\n"
            f"Message: Test packet queued for transmission"
        )
    
    def check_receiving(self, color):
        """Check receiving capability for a robot"""
        # will need to send a "send back" signal to robot, and wait for several seconds
        color_upper = color.capitalize()
        print(f"[DEBUG] Checking RECEIVING for {color_upper} Robot")
        print(f"[DEBUG] Listening for response from {color_upper} Robot...")
        print(f"[DEBUG] Port: /dev/{color}_robot | Protocol: TCP/IP")
        print(f"[DEBUG] Status: PLACEHOLDER - No actual communication yet")
        print("-" * 60)
        
        self.debug_status_label.setText(
            f"✓ RECEIVING Test - {color_upper} Robot\n"
            f"Port: /dev/{color}_robot\n"
            f"Protocol: TCP/IP\n"
            f"Status: PLACEHOLDER - Ready for implementation\n"
            f"Message: Listening for incoming data packets"
        )

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
        dialog.setGeometry(300, 300, 400, 250)
        
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
                
                self.preview_velocity = preview_vel
                self.reality_velocity = reality_vel
                self.save_settings()
                
                QMessageBox.information(dialog, "Success", 
                                       f"Settings updated!\n\n"
                                       f"Preview Velocity: {preview_vel}\n"
                                       f"Reality Velocity: {reality_vel}")
                dialog.accept()
                
            except ValueError:
                QMessageBox.warning(dialog, "Error", "Please enter valid integer values!")
        
        apply_btn.clicked.connect(apply_settings)
        
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
        if self.current_level < 8:
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
        
        # Initialize state
        self.colors = ['red', 'green', 'blue', 'yellow']
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
        QMessageBox.information(self, "Success", "Fastest (straight line) solution generated for all colors!")
    
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
        QMessageBox.information(self, "Success", "Random curved solution generated for all colors!")


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
        self.setGeometry(100, 50, 1200, 900)
        
        # Execution state
        self.execution_status = "BOOTING"  # BOOTING/PREP/EXECUTING/ERROR/DONE/TIMEOUT
        self.start_time = None
        self.completion_time = 999.99  # High penalty if closed early
        self.current_time = 0.0
        self.max_execution_time = 60.0  # Maximum 60 seconds for execution
        
        # Solution overlay opacity
        self.overlay_opacity = 128  # 0-255, default 50% (128)
        
        layout = QVBoxLayout(self)
        
        # Title
        title = QLabel(f"<h2>Execution - {self.level_data['name']}</h2>")
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)
        
        # Player info
        player_label = QLabel(f"<b>Player:</b> {player_name}")
        player_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(player_label)
        
        # Top info bar - Status and Timer
        info_layout = QHBoxLayout()
        
        # Status indicator
        status_frame = QFrame()
        status_frame.setFrameStyle(QFrame.Box | QFrame.Raised)
        status_layout = QVBoxLayout(status_frame)
        status_layout.addWidget(QLabel("<b>Status:</b>"))
        self.status_label = QLabel("BOOTING")
        self.status_label.setStyleSheet("""
            font-size: 24px;
            font-weight: bold;
            padding: 10px;
            background-color: #FFA500;
            color: black;
            border-radius: 5px;
        """)
        self.status_label.setAlignment(Qt.AlignCenter)
        status_layout.addWidget(self.status_label)
        info_layout.addWidget(status_frame)
        
        # Timer
        timer_frame = QFrame()
        timer_frame.setFrameStyle(QFrame.Box | QFrame.Raised)
        timer_layout = QVBoxLayout(timer_frame)
        timer_layout.addWidget(QLabel("<b>Time:</b>"))
        self.timer_label = QLabel("0.00s")
        self.timer_label.setStyleSheet("""
            font-size: 24px;
            font-weight: bold;
            padding: 10px;
            background-color: #2196F3;
            color: white;
            border-radius: 5px;
        """)
        self.timer_label.setAlignment(Qt.AlignCenter)
        timer_layout.addWidget(self.timer_label)
        info_layout.addWidget(timer_frame)
        
        layout.addLayout(info_layout)
        
        # Camera feed with solution overlay
        self.camera_canvas = ExecutionCanvas(self, self.level_data, solution)
        layout.addWidget(self.camera_canvas)
        
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
        
        # Debug/Status log
        log_group = QGroupBox("Execution Log")
        log_layout = QVBoxLayout()
        
        self.log_text = QTextEdit()
        self.log_text.setReadOnly(True)
        self.log_text.setMaximumHeight(150)
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
        
        self.abort_btn = QPushButton("⚠️ Abort Execution")
        self.abort_btn.setStyleSheet("background-color: #f44336; color: white; font-weight: bold; padding: 10px;")
        self.abort_btn.clicked.connect(self.abort_execution)
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
        self.update_timer.start(100)  # Update every 100ms
        
        # Log initial message
        self.log("[SYSTEM] Execution dialog opened")
        self.log(f"[SYSTEM] Player: {player_name}")
        self.log(f"[SYSTEM] Level: {self.level_data['name']}")
        self.log(f"[SYSTEM] Maximum execution time: {self.max_execution_time}s")
        self.log("[SYSTEM] Initializing robot communication...")
        
        # Start execution sequence
        QTimer.singleShot(1000, self.start_execution_sequence)
    
    def update_overlay_opacity(self, value):
        """Update solution overlay opacity"""
        self.overlay_opacity = value
        percentage = int((value / 255) * 100)
        self.opacity_value_label.setText(f"{percentage}%")
        self.camera_canvas.update_overlay_opacity(value)
    
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
            font-size: 24px;
            font-weight: bold;
            padding: 10px;
            background-color: {color};
            color: {'black' if status in ['BOOTING', 'PREP'] else 'white'};
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
        QTimer.singleShot(3000, self.start_execution)
    
    def start_execution(self):
        """Start actual execution"""
        self.update_status("EXECUTING")
        self.log("[SYSTEM] All paths uploaded")
        self.log("[SYSTEM] Starting execution...")
        self.log("[CAMERA] Streaming overhead camera feed...")
        
        # Start timer
        self.start_time = time.time()
        
        # TODO: Actually start robot execution
        # For now, simulate execution with camera feed updates
        self.camera_canvas.start_camera_stream()
        
        # Simulate completion after some time (for testing)
        # In reality, this would be triggered by robot completion signals
        # QTimer.singleShot(10000, self.execution_complete)
    
    def update_execution(self):
        """Update execution state (called every 100ms)"""
        if self.execution_status == "EXECUTING" and self.start_time:
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
                    font-size: 24px;
                    font-weight: bold;
                    padding: 10px;
                    background-color: #FF9800;
                    color: white;
                    border-radius: 5px;
                """)
            elif self.current_time > 40:
                # Caution
                self.timer_label.setStyleSheet("""
                    font-size: 24px;
                    font-weight: bold;
                    padding: 10px;
                    background-color: #FFC107;
                    color: black;
                    border-radius: 5px;
                """)
            
            # TODO: Check robot status and update accordingly
            # For now, check if we should simulate completion
            pass
    
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
        self.setMinimumSize(800, 600)
        
        # Camera feed state
        self.camera_active = False
        self.camera_timer = QTimer(self)
        self.camera_timer.timeout.connect(self.update_camera_feed)
        
        # Overlay items
        self.overlay_items = []
        
        # Draw initial placeholder
        self.draw_placeholder()
    
    def draw_placeholder(self):
        """Draw placeholder before camera starts"""
        self.scene.clear()
        
        # Add placeholder text
        placeholder = QLabel("Waiting for camera feed...")
        placeholder.setStyleSheet("""
            font-size: 24px;
            color: #666666;
            background-color: transparent;
        """)
        placeholder.setAlignment(Qt.AlignCenter)
        
        # Add to scene
        text = self.scene.addText("📷 Waiting for camera feed...\n\n(Camera stream will be implemented)")
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
    
    def start_camera_stream(self):
        """Start streaming camera feed"""
        self.camera_active = True
        self.parent_dialog.log("[CAMERA] Camera stream started")
        
        # Draw solution overlay
        self.draw_solution_overlay()
        
        # Start camera update timer
        self.camera_timer.start(100)  # Update every 100ms
    
    def update_camera_feed(self):
        """Update camera feed frame"""
        # TODO: Actually fetch camera frame from server/stream
        # For now, just show a placeholder with boundary
        
        if not hasattr(self, 'camera_initialized'):
            # Clear overlay items list first (before scene.clear)
            self.overlay_items.clear()
            
            self.scene.clear()
            boundary = self.level_data['boundary']
            
            # Draw boundary
            pen = QPen(QColor(255, 255, 255), 2)
            self.scene.addRect(0, 0, boundary['width'], boundary['height'], pen)
            
            # Draw placeholder for camera feed
            placeholder = self.scene.addText("🎥 LIVE CAMERA FEED\n(Implementation pending)")
            placeholder.setDefaultTextColor(QColor(150, 150, 150))
            font = placeholder.font()
            font.setPointSize(16)
            placeholder.setFont(font)
            placeholder.setPos(50, 50)
            
            # Draw dots for reference
            dot_radius = 15
            for color_name, positions in self.level_data['dots'].items():
                color = self.parent_dialog.parent_window.colors[color_name]
                
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
            
            # Redraw overlay on top (overlay_items is now empty)
            self.draw_solution_overlay()
            
            self.camera_initialized = True
            self.fitInView(self.scene.sceneRect(), Qt.KeepAspectRatio)

    def draw_solution_overlay(self):
        """Draw solution paths as overlay"""
        # Remove old overlay
        for item in self.overlay_items:
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
                x1, y1 = path[i]
                x2, y2 = path[i + 1]
                line = self.scene.addLine(x1, y1, x2, y2, pen)
                self.overlay_items.append(line)
    
    def update_overlay_opacity(self, opacity):
        """Update overlay opacity"""
        self.draw_solution_overlay()
    
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