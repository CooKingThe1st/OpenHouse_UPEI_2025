# OpenHouse_UPEI_2025

This repository documents the work completed for the Open House at UPEI 2025. It contains per-project subfolders (GUI, OptiTrack, Raspberry Pi 3, Wixel + ZUMO) with production-quality README templates, usage notes, and developer-oriented quickstarts.

## Purpose
Provide a centralized, well-documented record of demos, software, configurations, and instructions so others can reproduce hardware setups, run demos, and extend the work.

## Repository layout
- `GUI/` — User interface code and documentation (desktop/web demos, design notes).
- `OptiTrack/` — Motion capture integration, NATNet notes, calibration, sample scripts.
- `RaspberryPi3/` — OS images, setup instructions, scripts and hardware wiring for Raspberry Pi 3 demos.
- `Wixel_ZUMO/` — Wixel firmware examples and Zumo robot code, wiring and flashing instructions.

## Quickstart
1. Clone the repo:

   git clone <your-remote-url> OpenHouse_UPEI_2025

2. Open the folder in your editor (VS Code recommended).
3. Read the top-level README and then the README inside the subfolder relevant to the demo you want to run.

## How to use this repo
- Each subfolder contains a self-contained `README.md` with a Quickstart that describes dependencies, flashing and run commands, and where to find demo artifacts (binaries, images, scripts).
- Keep commits small and focused. Use branches for experimental changes.

## Contribution guidelines
- Add changes to a subfolder and update that subfolder's README with any new prerequisites or instructions.
- Add scripts or configuration files (e.g., Dockerfile, requirements.txt) for reproducible environment setup.

## Next steps / Suggested additions
- Add demonstrative artifacts (small example binaries or screenshots) where licensing permits.
- Add CI that lints code and validates README structure (optional).

---

Maintainers: Add names and contact information in a `MAINTAINERS.md` when available.
