# Multi-Robot Path Planning System

> An educational GUI for teaching robotics path planning with intelligent waypoint optimization

[![Python](https://img.shields.io/badge/python-3.7+-blue.svg)](https://www.python.org/downloads/)
[![PyQt5](https://img.shields.io/badge/PyQt5-5.15+-green.svg)](https://pypi.org/project/PyQt5/)
[![License](https://img.shields.io/badge/license-Educational-orange.svg)](LICENSE)

## 🎯 Overview

This is a production-level, educational GUI designed for teaching robotics path planning to students. Users can draw paths for 1-4 robots, which are then intelligently optimized into exactly 20 waypoints per robot for execution on real hardware.

### Key Features

- **🎓 Mission-Based Learning**: 4 progressive missions from single robot (easy) to 4 robots (expert)
- **✏️ Intuitive Drawing**: Click and drag to draw paths with real-time visual feedback
- **🧠 Smart Optimization**: Curvature-based waypoint distribution - more waypoints on curves, fewer on straight sections
- **✅ Robust Validation**: Comprehensive path checking with clear, actionable error messages
- **📊 Real-World Coordinates**: Automatic transformation from canvas (800×800px) to arena (2000×2000mm)


## 🚀 Quick Start

### Prerequisites

- Python 3.7 or higher
- pip (Python package manager)

### Installation

```bash
# Clone the repository
git clone https://github.com/8zism8/StudentShowcaseOct25.git
cd StudentShowcaseOct25

# Install dependencies
pip install -r requirements.txt
```

### Running the Application

```bash
python robot_path_planner.py
```

## 📖 Usage

### Basic Workflow

1. **Select Mission**: Choose from 4 difficulty levels (1-4 robots)
2. **Select Robot**: Click on a robot button to start drawing
3. **Draw Path**: Click and drag from START (S) to END (E) markers
4. **Validate**: Click "✓ Validate Paths" to check for errors
5. **Set Waypoints**: Click "📍 Set Waypoints" to optimize paths
6. **Send**: Click "📤 Send to Robots" to generate commands

### Mission Configurations

| Mission | Robots | Difficulty | Description |
|---------|--------|------------|-------------|
| Mission 1 | 1 (Red) | Easy | Learn basic path drawing |
| Mission 2 | 2 (Red, Green) | Medium | Coordinate crossing paths |
| Mission 3 | 3 (Red, Green, Blue) | Hard | Complex multi-robot coordination |
| Mission 4 | 4 (All colors) | Expert | Maximum complexity challenge |

## 🧠 How It Works

### Path Optimization Pipeline

```
User Drawing (1000+ points)
    ↓
Spline Interpolation (500 smooth points)
    ↓
Curvature Analysis (calculate bend at each point)
    ↓
Smart Waypoint Placement (more on curves, fewer on straight)
    ↓
Distance Enforcement (minimum 10cm between waypoints)
    ↓
Coordinate Transformation (canvas pixels → real-world mm)
    ↓
Final Output (exactly 20 waypoints)
```

### Intelligent Waypoint Distribution

The system uses **curvature analysis** to intelligently place waypoints:

- **High curvature** (sharp turns): More waypoints for precision
- **Low curvature** (straight lines): Fewer waypoints for efficiency
- **Adaptive thresholding**: Analyzes overall path geometry
- **Distance scaling**: 400mm spacing on straight sections, 50-150mm on curves

### Curvature Formula

$$\kappa = \frac{|x'y'' - y'x''|}{(x'^2 + y'^2)^{3/2}}$$

Where:
- $\kappa$ = curvature at a point
- $x', y'$ = first derivatives (velocity)
- $x'', y''$ = second derivatives (acceleration)

## 📁 Project Structure

```
robot-path-planner/
├── robot_path_planner.py    # Main GUI application
├── mission_config.py         # Mission and robot configurations
├── path_optimizer.py         # Path interpolation and waypoint optimization
├── path_validator.py         # Path validation logic
├── requirements.txt          # Python dependencies
├── README.md                 # This file
├── LICENSE                   # License information
├── docs/                     # Documentation
│   ├── QUICKSTART.md        # 5-minute tutorial
│   ├── ARCHITECTURE.md      # Technical architecture details
│   └── BUGFIXES_SUMMARY.md  # Bug fix history
├── tests/                    # Test suite
│   ├── test_integration.py
│   ├── test_waypoint_optimization.py
│   └── test_path_direction.py
├── dotconnect_data/         # Application data
│   ├── calibration.json
│   └── highscores.json
└── archive/                 # Legacy files and development history
```

## 🧪 Testing

Run the test suite to verify functionality:

```bash
# Run all tests
python -m pytest tests/

# Run specific test
python tests/test_integration.py
```

## 🎨 Customization

### Adjust Waypoint Parameters

```python
# In robot_path_planner.py
waypoint_optimizer = WaypointOptimizer(
    min_distance_mm=100.0,  # Minimum 10cm between waypoints
    max_waypoints=20        # Always output exactly 20
)
```

### Change Arena Size

```python
coord_converter = CoordinateConverter(
    canvas_width=800,
    canvas_height=800,
    real_width_mm=2000.0,   # Modify for different arena
    real_height_mm=2000.0
)
```

### Modify Missions

Edit `mission_config.py` to customize:
- Robot start/end positions
- Number of robots per mission
- Robot colors and names
- Difficulty progression

## 📊 Output Format

When "Send to Robots" is clicked, formatted commands are printed:

```python
RED_ROBOT_WAYPOINTS = [
    (250.00, 250.00),   # WP1 - Start
    (389.70, 277.50),   # WP2
    (557.93, 390.12),   # WP3
    ...
    (1700.00, 1700.00), # WP20 - End (may be padded)
]
```

Coordinates are in millimeters, ready for robot control system integration.

## 🐛 Troubleshooting

### Common Issues

**GUI doesn't start**
```bash
# Ensure PyQt5 is installed
pip install --upgrade PyQt5
```

**Paths not validating**
- Ensure paths start near START (S) marker
- Ensure paths end near END (E) marker
- Draw longer paths (minimum 50px)
- Paths can be drawn in either direction (auto-corrected)

**Waypoints look wrong**
- System uses smoothing to filter mouse jitter
- Straight sections intentionally have fewer waypoints
- Curved sections have denser waypoint placement

## 📚 Documentation

- **[Quick Start Guide](docs/QUICKSTART.md)**: 5-minute tutorial for new users
- **[Architecture Guide](docs/ARCHITECTURE.md)**: Technical details and system design
- **[Bug Fixes Summary](docs/BUGFIXES_SUMMARY.md)**: History of improvements

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup

```bash
# Clone the repository
git clone https://github.com/8zism8/StudentShowcaseOct25.git
cd StudentShowcaseOct25

# Create virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run tests
python -m pytest tests/
```

## 📄 License

This project is licensed for educational use in robotics courses. See [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- **Author**: Soroush Izadan, PhD Student
- **Lab**: [MoreLab](https://www.upei.ca/vet-med/research-facilities-services), University of Prince Edward Island
- **Purpose**: Educational robotics path planning for student learning
- **Built with**: PyQt5, NumPy, and SciPy
- **Year**: 2025

## 📞 Support

For issues, questions, or suggestions:
- Open an [issue](https://github.com/8zism8/StudentShowcaseOct25/issues)
- Check existing documentation in the `docs/` folder
- Review test files in `tests/` for usage examples

## 🔄 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.

---

**Made with ❤️ for robotics education**
