# Wixel + ZUMO — lightweight robot platform for OpenHouse demos

Overview
--------
This folder contains the code, examples and utilities for the lightweight Wixel + Zumo robot platform used in OpenHouse demos. Compared to the Raspberry Pi robot, the Wixel/Zumo robot is much lighter and simpler. The trade-off is lower compute power and more limited tooling (C apps built with the Wixel SDK instead of full Python stacks). The Wixel is used both as a master (host-side RF transmitter) and as identical slave modules (onboard robots). The Zumo board handles motors and buzzer.

This README documents:
- the high-level robot design and wiring pointers
- how we use Wixels as master and slave
- where to find the wiring diagram and example code
- recommended reading and external resources to onboard new students

Robot design (high level)
-------------------------
- Head: marker (OptiTrack) and an RGB LED for visible feedback.
- Middle: Wixel board (the same board is used for master and slave roles).
- Rear / base: Pololu Zumo 32U4 shield (motors, buzzer, power switching). The Zumo and Wixel share the same battery (a 2300 mAh pack in our builds).

Important wiring note
--------------------
- The canonical wiring diagram used in our builds is inside the slave example C file at:

  Wixel_ZUMO/slave/testing_apps/alpha/alpha.c

  That file includes component pin mappings and an ASCII diagram near the top — treat it as the single source-of-truth for wiring.

Master / Slave roles
--------------------
- Master Wixel (host-side): pairs with the host PC via a USB serial connection for programming and may also act as a serial bridge to the laptop. It transmits RF packets to slaves.
- Slave Wixel (robot-side): receives RF packets from the master and forwards commands to the Zumo MCU (or runs directly if the app is self-contained). The same Wixel hardware and firmware image can be used for both roles with simple configuration.

Why this works
---------------
- The Wixel RF link in peer-to-peer mode is fast and stable for our needs. The official Pololu guide recommends peer-to-peer (one-to-one) operation for reliability; we configured a single master to transmit to many slave Wixels that listen on the same radio channel and baud — this is effectively a one-to-many broadcast in our tests and proved reliable for demo use.
- We did not fully exercise the Pololu SDK’s many-to-many or per-node channel features; those are future work.

Essential external references (must read)
----------------------------------------
- Wixel product & basics (driver / upload): https://www.pololu.com/product/1336
- Wixel user guide (sections 9.a/9.b/9.c — blink, Wixel↔Wixel, Wixel↔PC examples): https://www.pololu.com/docs/0J46/9
- Zumo Shield documentation (assembly, motors, buzzer, shields): https://www.pololu.com/product/2508
- Zumo hardware reference (features): https://www.pololu.com/docs/0J57/3.a
- Pololu Wixel SDK (examples and build system): https://github.com/pololu/wixel-sdk/tree/master
- Pololu Wixel all-in-one docs and Windows bundle: https://www.pololu.com/docs/0j46/all#5.c
- Serial terminal helper (recommended for newcomers): https://www.pololu.com/docs/0J23
- Wixel radio link header (API reference): https://pololu.github.io/wixel-sdk/radio__link_8h.html

Repository layout (important folders)
------------------------------------
- host/ — host-side scripts and test harnesses (e.g., test_serial_final_ver.py) used on the laptop to send commands via serial to a master Wixel.
- master/ — master Wixel firmware examples and utilities.
- slave/ — slave Wixel firmware examples for robot-side logic. See testing_apps/alpha/alpha.c for wiring and a working example.
- diagrams/ — wiring/architecture diagrams (this folder).

Quickstart — build and flash Wixel apps (high level)
---------------------------------------------------
1) Install Pololu Wixel tools or the Wixel SDK bundle for your OS. On Windows, the Pololu Wixel bundle provides an installer and driver. See the product page above for download links.

2) Build a Wixel app using the Wixel SDK (Linux / macOS / Windows instructions are in the SDK repo). Example (Linux/macOS with SDK installed):

    make -C path/to/wixel-sdk/apps/your_app

   Copy the resulting firmware file to the Wixel using the Pololu GUI or SDK-deploy tools.

3) Use Pololu’s Wixel GUI (Windows) or the SDK tools to upload the produced app to the module via USB.

4) Test serial with the laptop using our provided script:

    python Wixel_ZUMO/host/test_serial_final_ver.py

   This script demonstrates how the host interacts over serial with the master Wixel and shows the format of commands we send in the demos.

Notes on serial/host workflow
-----------------------------
- When the master Wixel is connected to the laptop via USB it appears as a serial port. Our host scripts open that port and send commands which the master then transmits over RF to slave Wixels.
- Use the Pololu serial helper (link above) to confirm raw traffic before using our Python scripts.

Power considerations and safety
------------------------------
- The robots share a single 2300 mAh battery for both the Zumo board and the Wixel. Verify battery polarity and connector seating before powering the Zumo board; incorrect wiring risks damage.
- Wixel boards are sensitive to power and ESD. Use safe handling and avoid shorting exposed pins when assembled on the robot.

Testing checklist (recommended for new students)
-----------------------------------------------
1. Read the Pololu Wixel product page and the Wixel guide (links above).
2. Plug a Wixel into your laptop and upload the blink example from Pololu to learn the upload workflow.
3. Upload the Wixel↔Wixel example to two modules and verify they communicate in peer-to-peer mode (9.b examples).
4. Connect the master Wixel to your laptop and run host/test_serial_final_ver.py to view the command/response flow.
5. Review Wixel_ZUMO/slave/testing_apps/alpha/alpha.c for the exact wiring diagram we used in our hardware builds.

Where to find the wiring diagram in this repo
--------------------------------------------
- Exact wiring and pinouts are shown at the top of: Wixel_ZUMO/slave/testing_apps/alpha/alpha.c — check that file first when assembling or repairing a robot.

Next steps and improvements (recommended)
----------------------------------------
- Add a short flash_wixel.ps1 launcher that runs the Windows Pololu GUI or automates copying firmware to a mounted Wixel for repeatable flashes.
- Add a requirements.txt entry documenting the host Python dependencies used by test_serial_final_ver.py (if not present already).
- Add CI-compatible small tests (where possible) to validate the host-side framing logic.

Contact & maintainers
---------------------
If you need help with the Wixel/Zumo setup contact the repo owner (see top-level README) or raise an issue in this repository with the Wixel tag.

Last updated: 2025-10-27

Workflow & code notes (host → master → slave)
---------------------------------------------
Workflow summary
---------------
- You operate the multi-robot demo from your laptop. The typical workflow is:
  1. Upload the master firmware to the master Wixel (connected to your laptop via USB).
  2. Upload the slave firmware to each robot's Wixel (each slave should be flashed with the appropriate address/ID).
  3. Run the host script `host/test_serial_final_ver.py` on your laptop. The script opens the USB serial port to the master Wixel and sends command packets typed from the keyboard or scripted by other host code.
  4. The master Wixel relays the exact packet(s) over RF to slave Wixels.
  5. Each slave receives the packet and controls its Zumo board (motors, buzzer, LED) according to the packet contents.

Packet format & focus
----------------------
- The single most important thing to understand when working on the host and robot apps is the message packet format. The host, master and slave must all agree on the framing, field order and number formats. Small changes (e.g., reversing an axis) can break orientation computations downstream.
- In this project the host sends ASCII/byte-framed packets that include robot id, X, Y, Z, and orientation fields (the precise schema is implemented in `host/test_serial_final_ver.py` and parsed by the master/slave apps). When reading or changing code, focus on the packet encoder/decoder at the edges (host serial framing and slave RF parsing).
- NOTE TO FUTURE STUDENTS: trust the position data we receive from OptiTrack (x,y,z,orientation). Reversing axes or changing the interpretation of orientation without carefully verifying all transforms will produce incorrect behavior — orientation is often computed relative to the position data and can break if positions are transformed unexpectedly.

Uploading master vs slave
-------------------------
- Master: flash the master app to the Wixel mounted on the laptop. The master app reads serial and sends RF packets exactly as it receives them from the host.
- Slaves: flash the slave app to each robot Wixel. Each slave should be identified by an address (or ID). We used fixed addresses in the example C code; a recommended improvement is to move the address into a configurable area (so you can change addresses without recompiling).

Recommended improvement (address/config)
----------------------------------------
- Current example code uses fixed addresses in C. For maintainability, move the address/ID into a small config sector or use a serial-config command at boot time so addresses can be changed without rebuilding.

Host tools, calibration and analysis
-----------------------------------
- `host/calibration.py` — a helper that runs a calibration sequence: commands the robot to drive a predefined set of motor PWM values and records the observed position/orientation changes. The output is a CSV used for analysis.
- `host/analyze_calib.py` — analyzes the calibration CSV to determine the relationship between PWM inputs and motion (delta-x, delta-y, delta-theta). This analysis supports the modeling work.
- `digitalTwinSim_v3.py`, `digitalTwinSim_v4.py` — scripts that attempt to model and simulate robot behavior using the calibration results. These are useful reference simulations but were not fully integrated into closed-loop control on the robot.

Hot-upload, bootloader and practical tips
----------------------------------------
- Many of the `testing_apps` include a short delay on boot so the Wixel USB enumerates and the host-side uploader can replace the firmware (hot-upload). The alpha app deliberately delays motor control to allow uploads without manual intervention.
- If hot-upload fails or you want to force the Wixel into bootloader mode, wire 3.3V to `P2_2` on the Wixel (see Pololu docs) to enter the bootloader before uploading.
- NOTE: fiddling with boot pins is a last resort. The alpha hot-upload pattern works most of the time but since it depends on timing, it can occasionally interfere with serial reliability when the app grows in complexity.

Testing apps and tooling in this repo
-----------------------------------
- `slave/testing_apps/` — contains the example firmware used on robots: `alpha` (LED + motor test + hot-upload friendly), `master` and other communication tests. Use these to validate hardware and communication before putting them on the robot.
- `host/test_serial_final_ver.py` — primary host-side script used to exercise the system. It:
  - opens the master Wixel serial port
  - allows keyboard-driven packet sending
  - logs sent packets and incoming OptiTrack updates to `.log` files
  - demonstrates the framing format for the rest of the stack
- `host/test_serial_legacy*` — legacy scripts are kept for reference; prefer `test_serial_final_ver.py` for current testing.

Logs and analysis
-----------------
- While running demos the host and master scripts log what is sent and what is received from OptiTrack to `.log` files. These logs are useful for debugging and post-run analysis.
- Use `host/optitrack_analysis.py` to parse logs and perform quick sanity checks on delivered pose streams.

State machine and robot control modes
------------------------------------
- The official working firmware supports basic modes implemented as a simple state machine: `IDLE`, `GO_TO` (run to a position), and `TRACK_PATH` (follow a sequence of waypoints). The master/host instructs slaves to switch modes via the packet format.
- The mode switching logic is intentionally simple so students can reason about timing and command sequencing.

What is in `refined_code/`
--------------------------
- `refined_code/` contains a cleaner refactor of the robot firmware/parsers. It was not fully regression-tested on hardware; treat it as a refactor candidate and test carefully before replacing the working `testing_apps` code.

Final notes and recommendations
--------------------------------
- Always verify the `alpha.c` wiring diagram before wiring a robot — it is the single source-of-truth for our build.
- Add a small `flash_wixel.ps1` to automate opening the Pololu upload GUI or calling the SDK uploader for repeatable flashes.
- Consider moving packet schemas to a small shared file (e.g., `host/packet_schema.md` or a JSON schema) so host and firmware agree explicitly and tests can assert framing compatibility.

*** End Patch

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

