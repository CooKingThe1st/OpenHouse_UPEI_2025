# System Architecture Diagram

## Component Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                    MULTI-ROBOT PATH PLANNER                         │
│                     (robot_path_planner.py)                         │
│                                                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐            │
│  │  Mission     │  │   Drawing    │  │   Control    │            │
│  │  Selector    │  │   Canvas     │  │   Panel      │            │
│  │  (Dropdown)  │  │  (800x800)   │  │  (Buttons)   │            │
│  └──────────────┘  └──────────────┘  └──────────────┘            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
           │                    │                    │
           │                    │                    │
           ▼                    ▼                    ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│  MissionManager  │  │ RobotPathCanvas  │  │  User Controls   │
│                  │  │                  │  │                  │
│ • 4 Missions     │  │ • Draw paths     │  │ • Validate       │
│ • 1-4 Robots     │  │ • Show waypoints │  │ • Set Waypoints  │
│ • Configurations │  │ • Dual-layer     │  │ • Send to Robots │
└──────────────────┘  └──────────────────┘  └──────────────────┘
           │                    │                    │
           └────────────────────┴────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
                    ▼                         ▼
        ┌─────────────────────┐   ┌─────────────────────┐
        │  PathValidator      │   │  PathOptimizer      │
        │                     │   │                     │
        │ • Check start/end   │   │ • Interpolate       │
        │ • Check length      │   │ • Analyze curvature │
        │ • Check geometry    │   │ • Optimize waypts   │
        │ • Error messages    │   │ • Transform coords  │
        └─────────────────────┘   └─────────────────────┘
                                            │
                                            ▼
                                ┌─────────────────────┐
                                │  Robot Control      │
                                │  System Interface   │
                                │                     │
                                │ • 20 Waypoints/bot  │
                                │ • Real-world coords │
                                │ • Formatted output  │
                                └─────────────────────┘
```

---

## Data Flow

```
USER ACTION                    SYSTEM PROCESSING                OUTPUT
─────────────                  ──────────────────               ───────

Select Mission  ──────────►  MissionManager        ──────────►  Canvas
   (1-4)                     • Load configuration              displays
                             • Set robot positions             • Start (S)
                                                                • End (E)
                                                                • Grid
      │
      ▼
Select Robot    ──────────►  RobotPathCanvas       ──────────►  Status:
  (Red/Green/                • Enable drawing                  "Drawing
   Blue/Yellow)              • Set current robot               mode: Red"
      │
      ▼
Draw Path       ──────────►  RobotPathCanvas       ──────────►  Translucent
 (Click & Drag)              • Capture points                  dashed line
                             • Store in drawn_paths            on canvas
      │
      ▼
Click           ──────────►  PathValidator         ──────────►  Success/
"Validate"                   • Check start point               Error dialog
                             • Check end point                 + detailed
                             • Check length                    messages
                             • Check geometry
      │
      ▼
Click           ──────────►  PathOptimizer         ──────────►  Optimized
"Set Waypoints"              1. Interpolate (B-spline)        path shown:
                             2. Calculate curvature           • Solid line
                             3. Place waypoints               • Numbered
                             4. Enforce min distance            circles
                             5. Pad to 20                     • 20 waypts
                             6. Transform coords
      │
      ▼
Click           ──────────►  Format Output         ──────────►  Console:
"Send to Robots"             • Real-world coords (mm)         waypoint
                             • Python array format             arrays ready
                             • 20 points per robot             for robots
```

---

## Path Optimization Pipeline

```
Step 1: USER DRAWING
─────────────────────
Input: Mouse drag creates ~1000 pixel coordinates

Example:
(120, 120) → (125, 123) → (131, 127) → ... → (680, 680)
     ╱╲                                              
    ╱  ╲         [1000+ points, very dense]
   ╱    ╲                                             


Step 2: INTERPOLATION
─────────────────────
Process: Fit B-spline to create smooth 500-point curve

Math: splprep([x_coords, y_coords], s=0, k=3)

Result:
(120.0, 120.0) → (145.2, 138.7) → (170.8, 158.2) → ... → (680.0, 680.0)
         ∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼∼
      [500 points, perfectly smooth]


Step 3: CURVATURE ANALYSIS
───────────────────────────
Formula: κ = |x'y'' - y'x''| / (x'² + y'²)^(3/2)

For each point, calculate how sharply the path curves:
• High curvature = tight turn → NEEDS waypoint
• Low curvature = straight → SKIP waypoint

Point    Curvature    Decision
1        0.001        Skip (straight)
2        0.002        Skip (straight)
3        0.015        PLACE (curve!)
4        0.022        PLACE (curve!)
5        0.019        PLACE (curve!)
6        0.003        Skip (straight)
...


Step 4: WAYPOINT PLACEMENT
───────────────────────────
Rules:
1. Always include start point
2. Place waypoint if:
   - High curvature OR
   - Distance from last waypoint ≥ threshold
3. Minimum distance: 100mm (10cm)
4. Always include end point

Result: ~10-18 waypoints


Step 5: COORDINATE TRANSFORMATION
──────────────────────────────────
Convert: Canvas pixels → Real-world millimeters

Canvas:      (0, 0) → (800, 800) pixels
Real-world:  (0, 0) → (2000, 2000) mm

Formula:
real_x = canvas_x × (2000 / 800) = canvas_x × 2.5
real_y = canvas_y × (2000 / 800) = canvas_y × 2.5

Example:
(120, 120) px → (300, 300) mm
(680, 680) px → (1700, 1700) mm


Step 6: PADDING
───────────────
If waypoints < 20, duplicate the final point:

Waypoints generated: 14
Need: 20
Padding needed: 6

Result:
WP1:  (300.0, 300.0)
WP2:  (450.0, 400.0)
...
WP14: (1700.0, 1700.0)
WP15: (1700.0, 1700.0)  ← duplicate
WP16: (1700.0, 1700.0)  ← duplicate
WP17: (1700.0, 1700.0)  ← duplicate
WP18: (1700.0, 1700.0)  ← duplicate
WP19: (1700.0, 1700.0)  ← duplicate
WP20: (1700.0, 1700.0)  ← duplicate


FINAL OUTPUT
────────────
RED_ROBOT_WAYPOINTS = [
    (300.00, 300.00),   # WP1 - Start
    (410.45, 348.12),   # WP2
    (557.93, 390.12),   # WP3
    (677.73, 423.50),   # WP4
    (778.09, 462.61),   # WP5
    (875.80, 518.73),   # WP6
    (960.86, 586.18),   # WP7
    (1039.71, 671.08),  # WP8
    (1117.86, 782.76),  # WP9
    (1192.90, 907.58),  # WP10
    (1265.93, 1023.91), # WP11
    (1352.82, 1145.55), # WP12
    (1429.11, 1253.90), # WP13
    (1490.72, 1356.85), # WP14
    (1549.85, 1485.94), # WP15
    (1595.33, 1579.00), # WP16
    (1655.52, 1661.46), # WP17
    (1700.00, 1700.00), # WP18 - End
    (1700.00, 1700.00), # WP19 - Padded
    (1700.00, 1700.00), # WP20 - Padded
]
```

---

## Visual Representation

```
CANVAS VIEW (800x800 pixels)
────────────────────────────────────────────────────────

┌────────────────────────────────────────────────────┐
│                                                    │
│    S ←─────────────────────────────┐              │  S = Start (Red circle)
│    ●                                │              │  E = End (Red square)
│     ╲                               │              │  
│      ╲  Drawn Path                 │              │  Dashed line = User drawing
│       ╲ (translucent dashed)       │              │  Solid line = Optimized path
│        ╲                            │              │  ① = Waypoint markers
│         ╲                           │              │
│          ●①←──────────────────┐    │              │
│           ╲                    │    │              │
│            ╲                   │    │              │
│             ●②                 │    │              │
│              ╲                 │    │              │
│               ●③               │    │              │
│                ╲               │    │              │
│                 ●④             │    │              │
│                  ╲   Optimized │    │              │
│                   ╲  Path      │    │              │
│                    ●⑤ (solid)  │    │              │
│                     ╲          │    │              │
│                      ●⑥────────┘    │              │
│                       ╲             │              │
│                        ●⑦           │              │
│                         ╲           │              │
│                          ●⑧─────────┘              │
│                           ╲                        │
│                            ╲                       │
│                             ╲                      │
│                              ╲                     │
│                               ╲                    │
│                                ●⑨                  │
│                                 ╲                  │
│                                  ■ E               │
│                                                    │
└────────────────────────────────────────────────────┘

Notice:
• Straight sections (top): Fewer waypoints (①②③④)
• Curved sections (middle): More waypoints (⑤⑥⑦⑧⑨)
• This is the curvature analysis in action!
```

---

## Module Interaction Diagram

```
┌─────────────────────────────────────────────────────────┐
│                  robot_path_planner.py                  │
│                   (Main Application)                    │
│                                                         │
│  ┌─────────────────────────────────────────────────┐  │
│  │         MultiRobotGUI (QMainWindow)             │  │
│  │                                                 │  │
│  │  • setup_ui()                                   │  │
│  │  • load_mission()                               │  │
│  │  • validate_paths()                             │  │
│  │  • set_waypoints()                              │  │
│  │  • send_to_robots()                             │  │
│  │                                                 │  │
│  │  Contains:                                      │  │
│  │  ┌──────────────────────────────────────────┐  │  │
│  │  │   RobotPathCanvas (QGraphicsView)        │  │  │
│  │  │                                          │  │  │
│  │  │  • load_mission()                        │  │  │
│  │  │  • draw_mission()                        │  │  │
│  │  │  • mousePressEvent()                     │  │  │
│  │  │  • mouseMoveEvent()                      │  │  │
│  │  │  • mouseReleaseEvent()                   │  │  │
│  │  │                                          │  │  │
│  │  │  Storage:                                │  │  │
│  │  │  • drawn_paths: {color: [(x,y), ...]}   │  │  │
│  │  │  • optimized_paths: {color: [20 pts]}   │  │  │
│  │  └──────────────────────────────────────────┘  │  │
│  └─────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                     │
                     │ imports and uses
                     │
        ┌────────────┼────────────────────────┐
        │            │                        │
        ▼            ▼                        ▼
┌───────────────┐ ┌──────────────┐ ┌──────────────────┐
│mission_config │ │path_validator│ │path_optimizer    │
│               │ │              │ │                  │
│MissionManager │ │PathValidator │ │PathInterpolator  │
│  └─creates    │ │  └─validates │ │  └─interpolates  │
│               │ │              │ │                  │
│MissionConfig  │ │ValidationRes.│ │WaypointOptimizer │
│  └─contains   │ │              │ │  └─optimizes     │
│               │ │              │ │                  │
│RobotConfig    │ │              │ │CoordinateConvert.│
│RobotColor     │ │              │ │  └─transforms    │
└───────────────┘ └──────────────┘ └──────────────────┘
```

---

## Class Hierarchy

```
QMainWindow
    └── MultiRobotGUI
            │
            ├─ Component: RobotPathCanvas (QGraphicsView)
            │      └─ QGraphicsScene (drawing surface)
            │
            ├─ Uses: MissionManager
            │      └─ manages: MissionConfig
            │             └─ contains: List[RobotConfig]
            │
            ├─ Uses: PathValidator
            │      └─ returns: ValidationResult
            │
            ├─ Uses: PathInterpolator
            │      └─ method: interpolate_path()
            │
            ├─ Uses: WaypointOptimizer
            │      └─ method: optimize_waypoints()
            │
            └─ Uses: CoordinateConverter
                   └─ methods: canvas_to_real()
                              path_canvas_to_real()
```

---

## Workflow State Machine

```
┌─────────┐
│  START  │
└────┬────┘
     │
     ▼
┌─────────────────┐
│ Mission Selected│──┐
└────┬────────────┘  │
     │               │ Change Mission
     ▼               │
┌─────────────────┐  │
│ Robot Selected  │◄─┘
└────┬────────────┘
     │
     ▼
┌─────────────────┐
│ Drawing Path    │◄──┐
└────┬────────────┘   │
     │                │ Draw Another Robot
     ▼                │
┌─────────────────┐   │
│ Path Drawn      │───┘
└────┬────────────┘
     │
     ▼
┌─────────────────┐
│ Validate Paths  │
└────┬────────────┘
     │
     ├─►[FAIL]──► Show Errors ──► Fix Paths
     │
     ▼
   [PASS]
     │
     ▼
┌─────────────────┐
│ Set Waypoints   │
└────┬────────────┘
     │
     ▼
┌─────────────────┐
│ Review Waypoints│◄──┐
└────┬────────────┘   │
     │                │ Not Happy?
     ├────────────────┘ Clear & Redraw
     │
     ▼
   [Happy]
     │
     ▼
┌─────────────────┐
│ Send to Robots  │
└────┬────────────┘
     │
     ▼
┌─────────────────┐
│ Output to       │
│ Console         │
└────┬────────────┘
     │
     ▼
┌─────────┐
│   END   │
└─────────┘
```

---

This architecture provides:
- ✅ Clear separation of concerns
- ✅ Modular, testable components
- ✅ Easy to understand data flow
- ✅ Simple state management
- ✅ Professional code organization
