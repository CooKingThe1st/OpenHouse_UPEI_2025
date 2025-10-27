# Wixel + ZUMO

Overview

This folder contains firmware, build instructions, wiring, and notes for the Pololu Wixel and Zumo platform used during the demos. It documents how to flash Wixel modules, Zumo motor driver wiring, and sample control code for demonstrations.

Quickstart

1. Install Pololu Wixel SDK and required toolchain (Windows recommended for Pololu tools; cross-platform toolchains available).
2. Connect the Wixel to the host via USB and use the Wixel Configuration utility or `wixel` command-line tools to flash firmware.
3. For Zumo robots, assemble and wire the motors and sensors per Pololu instructions.

Flashing example (high-level):

- Using Wixel Loader GUI on Windows: open the `.wxl` or `.hex` file and click "Flash".
- Command line (example):

  wixel -f path/to/firmware.hex

How it works

- The Wixel acts as a USB-to-serial bridge or custom module to handle wireless communications (depending on firmware). The Zumo runs motor drivers controlled via microcontroller code.
- For demo setups, the Wixel can stream telemetry back to the demo controller and receive high level commands.

Files and structure

- `firmware/` — Compiled hex files and source code for Wixel.
- `zumo/` — Zumo sample control code and wiring diagrams.
- `docs/` — Photos of wiring, BOM, and mechanical notes.

Safety

- Always disconnect power when attaching or changing wiring.
- Use current-limited bench supplies or proper battery holders to avoid motor stalls exploding battery packs.

Troubleshooting

- If the Wixel is not recognized: try reinstalling drivers or using another USB cable/port.
- If motors don't respond: verify motor driver solder joints, battery voltage, and motor connections.

