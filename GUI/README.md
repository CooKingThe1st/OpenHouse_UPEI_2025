# GUI

Overview

This folder contains user interface code and artefacts used in demos and the Open House. It can host multiple frontends (PyQt/PySide, Qt, Electron, or web-based React/Vue apps). The goal is a polished, cross-platform GUI that integrates with the motion capture system and robot controllers for live demos.

Quickstart

- Recommended: run the GUI inside a virtual environment or Node container depending on stack.

PyQt example (Python):

1. Create a venv and install dependencies:

   python -m venv .venv
   .\.venv\Scripts\Activate.ps1; python -m pip install -r requirements.txt

2. Run the app:

   .\.venv\Scripts\Activate.ps1; python main.py

Electron example (Node):

1. Install dependencies:

   npm install

2. Start in dev mode:

   npm run dev

Usage

- The GUI should have clear controls for connecting to the OptiTrack stream and for controlling/disabling the robot outputs.
- Provide a simple "demo mode" with pre-recorded motion paths for offline demos.

How it works

- The GUI is a thin layer: it connects to data sources (NATNet / websocket / REST) and forwards control commands to robot controllers using a well-defined API.
- Keep hardware-specific code in the lower-level modules to keep the UI testable and platform independent.

Files and structure

- `src/` — GUI source code.
- `docs/` — Design notes, screenshots, and interaction diagrams.
- `requirements.txt` or `package.json` — Dependencies.

Notes

- Include screenshots and short GIFs in `docs/` for the README preview on GitHub.
- Prefer cross-platform frameworks for ease of display on different machines during Open House.
