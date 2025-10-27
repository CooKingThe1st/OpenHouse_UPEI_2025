
# GUI

Overview

This folder collects the demonstration user interfaces used for Open House. The repository contains several independent GUI snapshots and utilities written in Python (PyQt5) that were used during development and demonstrations. These GUIs act as the visual control and monitoring surface — receiving pose updates (from OptiTrack or replay logs) and sending high-level commands to robots.

Status

- Primary maintained variants in this repo are Python / PyQt5 frontends (see subfolders). There is no maintained Electron/Node GUI in this repository; remove any Electron references unless you add a dedicated `package.json` and implementation.

Quickstart (PyQt / Windows PowerShell)

1. Create and activate a virtual environment and install dependencies (run from the repository root):

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

2. Run one of the example GUIs. Pick the variant that matches your needs:

- Legacy (minimal, standalone demo):

```powershell
python GUI\Legacy_version\OpenDay_MRS_v1_0.py
```

- Soroush (integrated serial + OptiTrack wiring; recommended for hardware-in-the-loop demos):

```powershell
python GUI\Soroush_version_with_integrate_serial\gui_with_robots.py
```

- Minh (modular: separate serial bridge + GUI; use for development and debugging):

```powershell
python GUI\Minh_version_with_separate_serial_n_gui\robot_path_planner.py
```

Notes

- Some folders include their own `requirements.txt` or dependency notes. If a top-level `requirements.txt` is present it attempts to provide a common baseline; check the variant folder for additional dependencies (e.g., multimedia codecs, OpenCV).
- The GUIs write runtime data (settings, highscores, caches) to local folders such as `dotconnect_data` — ensure the process has write permissions in the working directory.

Usage notes

- Connection: the GUI should be configurable to connect to a TCP bridge (OptiTrack bridge), NATNet client, or a replay file. Keep connection settings in a single config file or environment variables.
- Demo mode: use recorded pose logs or replay mode while developing to avoid dependence on live OptiTrack hardware during development.

How it works (high level)

- Architecture: GUI <-> data source (NATNet/TCP bridge/replay). GUI -> controller adapter (serial / TCP / HTTP) to send commands to robots.
- Keep hardware-specific code isolated in an adapter/bridge layer so the UI can be tested with mock data.

Files and structure (high level)

- `Legacy_version/` — single-file demo app (fast to run, minimal wiring).
- `Soroush_version_with_integrate_serial/` — integrated GUI with serial adapters and extensive documentation (good for hardware demos).
- `Minh_version_with_separate_serial_n_gui/` — modular split between GUI and serial bridge; useful for development and testing.
- `BINH_Version_with_cam_n_opti/` — camera/transform utilities (coordinate_transformer.py).
- `docs/` and `diagrams/` — screenshots, diagrams and design notes (may be in each subfolder).

Developer tips

- Use recorded motion logs for repeatable UI tests instead of live hardware.
- If you plan to run demos on different machines, pin dependencies and provide a small launcher script per variant that sets up environment variables (bridge host/port, demo mode toggles).

Where to go next

- For robust, hardware-connected demos use `Soroush_version_with_integrate_serial`.
- For quick recovery/fallback, run the `Legacy_version` app.

Last updated: 2025-10-27
