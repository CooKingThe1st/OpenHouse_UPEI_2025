
# OpenHouse_UPEI_2025

Production-quality documentation for demos prepared for the UPEI Open House (2025). This repository collects per-demo code, wiring, scripts, and instructions so others can reproduce the setups and run live demos.

## Quick summary
- Purpose: provide reproducible, well-documented demos that integrate motion capture (OptiTrack), robot platforms (Zumo + Wixel), a demo GUI, and Raspberry Pi-based clients.
- Status: OptiTrack integration completed (see `OptiTrack/`); Raspberry Pi work in progress (`RaspberryPi3/`).

## Table of contents
- Overview
- Quickstart
- Repository layout
- How it works (architecture)
- Component docs and usage
- Contributing & development
- License & maintainers

## Quickstart
Follow these steps to get a demo environment running locally for development or testing.

1. Clone the repository:

   git clone https://github.com/CooKingThe1st/OpenHouse_UPEI_2025.git
   cd OpenHouse_UPEI_2025

2. Read the top-level README (this file) and then the README inside the folder for the component you're using:

   - `OptiTrack/` — motion-capture server, NATNet/TCP bridge, and client examples (completed).
   - `RaspberryPi3/` — Pi provisioning scripts, image notes, and headless setup (in progress).
   - `GUI/` — demonstration GUI and integration examples.
   - `Wixel_ZUMO/` — firmware and Zumo wiring/flash instructions.

3. Follow the chosen component quickstart (each component README contains step-by-step commands and prerequisites).

## Repository layout
Top-level folders and purpose:

- `GUI/` — demo UI code, screenshots, and usage notes. Should contain `requirements.txt` or `package.json` depending on stack.
- `OptiTrack/` — completed OptiTrack integration, NATNet->TCP bridge notes, example clients (`client_rasp_opti.py`).
- `RaspberryPi3/` — Raspberry Pi provisioning scripts, `setup/`, `src/`, and `images/` references.
- `Wixel_ZUMO/` — Wixel firmware, Zumo robot code, wiring and safety notes.

## How it works (architecture)
High-level data flows used in the demos:

- OptiTrack cameras capture markers -> Motive (OptiTrack host) -> streaming via NATNet/VRPN or the NATNet->TCP bridge -> clients (GUI, Pi, robots).
- GUI connects to the demo data sources (NATNet/bridge/websocket) and sends high-level commands to robot controllers.
- Raspberry Pi clients run lightweight Python scripts or services that receive pose/command data and control attached peripherals (motors, sensors) via GPIO, I2C, SPI, or microcontrollers.

For a visual summary see `OptiTrack/diagrams/` (if present).

## Component highlights and usage
- OptiTrack: use `OptiTrack/README.md` — includes NATNet->TCP bridge rationale, sample `client_rasp_opti.py`, and camera tuning notes.
- Raspberry Pi 3: `RaspberryPi3/README.md` — provisioning scripts and headless setup. This folder will include precise SD image instructions and systemd unit examples.
- GUI: inspect `GUI/README.md` for framework-specific steps (PyQt or Electron examples).
- Wixel + Zumo: firmware flashing and wiring in `Wixel_ZUMO/README.md`.

## Development & reproducibility
- Use virtual environments (Python venv) or containers for GUI and client development.
- Do not commit large binary images (SD card images). Instead include checksums and torrent or release assets if needed.
- Add `requirements.txt` or `package.json` to top-level subfolders for clearer reproducibility.

## Contributing
- Keep PRs small and focused. Include a short description of the change, which demo it affects, and any hardware consequences.
- Update the relevant subfolder README with new steps when you add scripts, services, or hardware changes.
- Add automated checks later (linting / README structure checks) if we decide to add CI.

## Maintainers and contact
- Repo owner: GitHub: `@CooKingThe1st` — https://github.com/CooKingThe1st
- Contact workflow: open an issue for questions, or mention `@CooKingThe1st` on GitHub. If you prefer direct email contact, add a `MAINTAINERS.md` with addresses (keeps this repo public-friendly).

## License
This repository includes a `LICENSE` file. Respect the license terms for code and any third-party assets.

---

Last updated: 2025-10-27

If you'd like, I can now (a) polish each subfolder README for consistency, (b) add a CONTRIBUTING.md and MAINTAINERS.md, and (c) wire a minimal CI check for README presence per folder. Tell me which you'd like me to do next.
