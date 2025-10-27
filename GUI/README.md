
# GUI

Overview

This folder contains the demonstration user interface used in Open House sessions. The GUI acts as the visual control and monitoring surface — receiving pose updates (from OptiTrack or replay logs) and sending high-level commands to robots.

Status

- Example frontends: PyQt (Python) and an optional Electron-based UI (Node). Add `requirements.txt` or `package.json` depending on the stack you prefer.

Quickstart (PyQt / Python)

1. Create a virtual environment and install dependencies:

   python -m venv .venv
   .\.venv\Scripts\Activate.ps1; python -m pip install -r requirements.txt

2. Run the app (example):

   .\.venv\Scripts\Activate.ps1; python main.py

Quickstart (Electron / Node)

1. Install dependencies and start the dev server:

   npm install
   npm run dev

Usage notes

- Connection: the GUI should be configurable to connect to a TCP bridge (OptiTrack bridge), NATNet client, or a replay file. Keep connection settings in a single config file.
- Demo mode: provide an offline replay mode which reads pre-recorded pose logs for demo environments without live OptiTrack hardware.

How it works

- Architecture: GUI <-> data source (NATNet/TCP bridge/replay) and GUI -> controller API (HTTP / MQTT / socket) to send commands.
- Keep hardware-specific code isolated in an adapter layer to make the UI mockable for testing.

Files and structure

- `src/` — UI source code.
- `docs/` — screenshots, GIFs, and user flows.
- `requirements.txt` or `package.json` — dependency manifest.
- `config/` — example connection profiles (host, port, demo-mode toggles).

Developer tips

- Test UI flows using recorded motion logs rather than live hardware during development to avoid hardware risks.
- Add automated UI smoke tests if you plan to iterate frequently.

Last updated: 2025-10-27
