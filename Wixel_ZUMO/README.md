
# Wixel + ZUMO

Overview

This folder documents the Pololu Wixel modules and Zumo robot platform used in demos. It contains firmware, flashing instructions, wiring diagrams, and safety notes.

Status

- Work in progress: firmware examples and wiring notes present. Add compiled artifacts as release assets rather than committing large binaries.

Quickstart

1. Install Pololu Wixel SDK and toolchain (Windows recommended for Pololu utilities; cross-platform toolchains possible).
2. Connect Wixel via USB and flash using the Wixel Loader GUI or command line.
3. Assemble and wire the Zumo motors and sensor harness per Pololu guides.

Flashing examples

- GUI (Windows): use the Wixel Loader to open `.wxl` / `.hex` and flash.
- CLI (example):

  wixel -f path/to/firmware.hex

Files and structure

- `firmware/` — source and compiled firmware (avoid committing large compiled files; prefer tagged release assets).
- `zumo/` — Zumo sample code, motor wiring diagrams and sensor notes.
- `docs/` — photos, BOM, and instructions for physical assembly.

How it works (high-level)

- The Wixel can provide USB-to-serial bridging, wireless telemetry, or custom MCU functionality depending on the flashed firmware. The Zumo robot executes motor-control code and reports telemetry.
- For demos: connect the Wixel to a coordinator (PC or Pi) that relays telemetry to the GUI and accepts high-level commands.

Safety and test tips

- Always disconnect power before changing motor wiring.
- Validate battery voltage and use current-limited bench supplies when testing motors.
- Test firmware on a single module before scaling to many robots.

Troubleshooting

- Wixel not enumerated: try different USB cable/port and reinstall drivers.
- Motors don't respond: check battery, motor driver solder joints, and wiring order.

Last updated: 2025-10-27

