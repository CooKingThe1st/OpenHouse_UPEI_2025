# Legacy GUI — OpenHouse Demo (DotConnect)

Overview
--------
This is the original demo GUI used for early OpenHouse runs. It provides a local, standalone PyQt5 application called DotConnect that lets visitors draw multi-robot paths on a 2D canvas and execute them on hardware (when connected). It served as the initial prototype and user-facing demo.

Why keep it
-----------
- Simple, self-contained single-file implementation (great for fast demos and recovery).
- Lightweight dependencies and easy to run on most developer machines.

Contents
--------
- `OpenDay_MRS_v1_0.py` — main application (PyQt5). Contains UI, drawing tools, preview and execution flows.
- `dependencies.txt` / `requirements.txt` — Python packages used by this folder (PyQt5, numpy, optional multimedia codecs).
- `BGM/` — optional background music assets used by the app (if present).

Quickstart (developer)
----------------------
1. Create a virtual environment and install dependencies:

   python -m venv .venv; .\.venv\Scripts\Activate.ps1; pip install -r requirements.txt

2. Launch the app:

   python OpenDay_MRS_v1_0.py

Notes:
- The app expects a writable `dotconnect_data` directory next to the script for settings and highscores. The app will create it on first run.
- If audio playback is required, ensure your OS has a suitable backend for PyQtMultimedia and that BGM files are present in the `BGM/` folder.

How it works (high level)
-------------------------
1. UI allows drawing solutions per-color (red/green/blue/yellow) on a bounded canvas.
2. Solutions can be previewed locally or executed on the robot fleet if a serial/bridge connection is present.
3. Highscores and custom levels are stored under `dotconnect_data`.

Known issues
------------
- This legacy GUI implements several convenience passwords and placeholders (e.g., `morelab`) for demo-time features — treat these as examples, not secure defaults.
- Integration with OptiTrack / real hardware is minimal; use the Soroush or Minh versions for robust serial/OptiTrack integration.

Where to go next
----------------
- For camera or OptiTrack integration, see `../BINH_Version_with_cam_n_opti/` and `../Soroush_version_with_integrate_serial/`.
- For a more modular GUI+serial split, see `../Minh_version_with_separate_serial_n_gui/`.

License & contact
-----------------
This repo follows the top-level LICENSE. For questions about this folder contact the project owner listed in the top-level README.
