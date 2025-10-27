# RaspberryPi3

This folder documents the Raspberry Pi 3 setup, provisioning scripts, and the code used for Pi-based clients during demos.

## Status
- Current: basic provisioning and headless setup documented. Pi-based client scripts will consume the TCP OptiTrack bridge output (see `OptiTrack/client_rasp_opti.py`).

## Goals for this folder
- Provide reproducible SD provisioning steps for demo Pis.

## Hardware checklist
- Raspberry Pi 3 (Model B recommended)

## Quickstart (headless, Windows PowerShell)
1. Flash Raspberry Pi OS to SD card using Raspberry Pi Imager or BalenaEtcher.

2. Enable SSH and configure Wi‑Fi (on the SD card `boot` partition):

   - Create an empty file named `ssh` in the `boot` partition.

3. Insert SD card and boot the Pi. Find the Pi IP using your router or `arp -a`.

4. SSH in and update packages (on the Pi):

   sudo apt update; sudo apt upgrade -y

5. Install required packages and project dependencies:

   sudo apt install -y python3 python3-pip git
   python3 -m pip install --user -r requirements.txt

6. Run the example OptiTrack client (adjust host/port as required):

   python3 src/client_rasp_opti.py --host <MOTIVE_HOST_IP> --port 5400

## Provisioning scripts
- `setup/` should contain small scripts for SD customization, `fix-permissions.sh` and an optional `create-image.ps1` helper.

## Services and autostart
- Use `systemd` unit files for long-running clients (example in `setup/pi-client.service`).

Example `systemd` unit (on Pi):

[Unit]
Description=OpenHouse Pi client
After=network.target

[Service]
User=pi
WorkingDirectory=/home/pi/OpenHouse_UPEI_2025/RaspberryPi3
ExecStart=/usr/bin/python3 /home/pi/OpenHouse_UPEI_2025/RaspberryPi3/src/client_rasp_opti.py --host <MOTIVE_HOST_IP> --port 5400
Restart=always

[Install]
WantedBy=multi-user.target

## Security notes
- Replace default passwords and use SSH keys. Lock down the Pi to only necessary ports and services.

## What was completed (notes)
- OptiTrack end-to-end: `OptiTrack/` is documented and the TCP bridge + Python client workflow is implemented and tested.

## Next steps (suggested)
1. Add a small provisioning script in `setup/` that:
   - Applies OS updates, creates a service user, installs packages, and sets up the example systemd unit.
2. Add a short troubleshooting section with common `journalctl` and `dmesg` checks and expected outputs.
3. Create an example `src/` client that validates frames and outputs a JSON log for replay.

## Troubleshooting
- If a service won't start: inspect `journalctl -u <service>` and `dmesg` for hardware errors.

---

Last updated: 2025-10-27

## Background & timeline (notes from development)

- Owner / lead developer on the robot: Duy — his full, legacy codebase is kept for reference in `legacy_code_by_duy/`.
- What happened (short timeline):
  1. Duy developed the robot and the wall-following and motor-control code. His repository is preserved under `legacy_code_by_duy/` and was not modified.
  2. I (you) explored using the robot for the Open House:
     - wrote a TCP client to consume OptiTrack frames (same format as described in `OptiTrack/`),
     - tested motors (using `test_motor` derived from the legacy code),
     - lacked SSH credentials for the Pi, so experimented with an HTTP upload/control approach (files under `http_stuff/`),
     - discovered the robot design is unsuitable for our Open House demos (difficult steering, underpowered drive for ~2.2 kg robot) and shelved it for live demos.

## Code layout (important files you mentioned)

- `legacy_code_by_duy/` — original research and control code by Duy (do not edit; for reference).
- `http_stuff/` — early HTTP upload and remote-control experiments (contains `server_rasp_upload` + `upload.html`, control pages and small web endpoints).
- `pi_openserve_test_com.py` (or similar) — demo server that reads OptiTrack frames and exposes a test interface.
- `pi_power_control.py` — attempts to reboot/shutdown Pi via HTTP (permission-limited; needs root or sudo configuration to work reliably).
- `pi_open_server_test_com_n_motor.py` — combined control page to toggle motors and restart/reload demos after upload.
- `test_motor.py` — motor exercise script adapted from legacy code (used during bench testing).
- `lil_demo_path_tracking.py` — small demo path follower script you used for testing after uploading via HTTP.

If a filename differs slightly in the repo, these names are conceptual; see the `RaspberryPi3/` listing for exact names.

## Robot hardware summary (what I observed)

- Physical design: Raspberry Pi 3 + internal camera & LED + Zumo board + Arduino interface + custom power regulation board.
- Approx weight: ~2.2 kg (robot heavy; Zumo v1.2 struggles to provide sufficient torque for differential steering).
- Power sources:
  - Zumo motors: 4x Bonai 2300 mAh Ni-MH cells (HR6 1.2V each) — supply motor driver on the Zumo board.
  - Pi + camera + white LED: 2S LiPo (SUNPADOW orange pack, 900 mAh, 7.4V) feeding a small regulator module to 5V for the Pi.
  - Note: the orange LiPo also powers internal white LED and camera — LED on indicates battery + regulator path intact.
- Known hardware issues:
  - The soldered positive lead on Robot1 and Robot2 was accidentally pulled — needs re-soldering to restore reliable power.
  - One of the OptiTrack marker "heads" is missing (only 3 remain; one robot may not be trackable until a marker head is added).

## Robot wiring (high-level)

This section describes the key power and signal connections — treat as a checklist rather than PCB-level wiring.

1. Battery (2S LiPo, 7.4V) -> small regulator module -> 5V output -> Raspberry Pi 3 5V input.
   - Check the regulator wiring polarity carefully before connecting. The internal white LED and camera should power on when connected.
2. Zumo battery pack (4x NiMH) -> Zumo board motor power input -> Zumo on/off switch (must be ON to power motors and Arduino).
3. Zumo board (motor driver) -> Arduino headers -> Arduino -> serial (TX/RX) to Raspberry Pi (UART) or via USB depending on the robot.
4. Raspberry Pi -> camera (CSI) + internal white LED (power feed), and Pi -> OptiTrack marker mount on the head.

If you open the robot, visually confirm:
- the orange LiPo connection and the regulator board is soldered and intact,
- the Zumo switch is in the ON position when testing motors,
- motor batteries are installed and charged.

## Diagrams

I added two diagrams to make the architecture and wiring clear. See `RaspberryPi3/diagrams/`:

- `diagrams/robot_design.svg` — robot component layout (Pi, regulator, LiPo, camera, Zumo, Arduino, motor batteries).
- `diagrams/network_flow.svg` — network & control flow (OptiTrack -> NATNet/bridge -> demo host -> Pi (socket client) and optional HTTP upload/control channel).

Open these SVGs in your browser or image viewer. They are intentionally simple, schematic diagrams for documentation and the Open House handout.

## Quickstart (developer view)

1. Inspect hardware & fix solder issues
   - Confirm the LiPo regulator positive lead is soldered correctly (repair Robot1/Robot2 if needed). Verify the internal LED and camera power on when the LiPo is connected.

2. Bring up the Pi and network
   - Boot the Pi from a prepared SD card. Use headless SSH or local terminal if you have credentials; otherwise the HTTP upload approach can be used to transfer scripts.

3. Test motors (basic)
   - Ensure Zumo switch is ON and motor battery pack is installed.
   - Run `test_motor.py` on the Pi (or from a local workstation via SSH) to verify motor driver output and basic forward/back commands.

4. Test OptiTrack client flow
   - Start your OptiTrack bridge (see `OptiTrack/`) on the demo host.
   - Run the Pi TCP client: `python3 src/client_rasp_opti.py --host <MOTIVE_HOST_IP> --port 5400` and watch for frames.

5. Use the HTTP upload for quick iteration
   - On the Pi: start the upload server `server_rasp_upload` (found under `http_stuff/`).
   - From your workstation, open `upload.html`, select the updated demo script (e.g., `lil_demo_path_tracking.py`) and upload it; the server will overwrite the file on the Pi.
   - Use the control endpoint (or `pi_open_server_test_com_n_motor.py`) UI to stop the running demo process and restart the new script. Note: the server may need additional permissions to restart system processes.

6. Automate at boot (optional)
   - If you want the demo to run at boot, add a `cron` or `systemd` unit. Example cron line saved at `setup/cronjob.txt`.

## Example `setup/cronjob.txt`

```
@reboot /usr/bin/python3 /home/pi/OpenHouse_UPEI_2025/RaspberryPi3/src/lil_demo_path_tracking.py >> /var/log/lil_demo.log 2>&1
```

Place this in the Pi's crontab (edit via `crontab -e` for the `pi` user) or convert into a `systemd` unit for better control.

## HTTP upload / control notes

- `server_rasp_upload` + `upload.html` — quick dev flow to push small script changes to the Pi over the LAN. Files are overwritten if the same name exists.
- Security note: this is a convenience tool on a local LAN and is not secure for untrusted networks. Limit access to a local, private network for demos.
- Reboot/shutdown via HTTP (`pi_power_control`) usually requires `sudo` privileges; to allow a web process to run reboot/shutdown you must configure appropriate `sudoers` entries or have the process run under a user with permissions—exercise caution.

## What worked and why we stopped

- What worked: motor control test and OptiTrack client integration worked; HTTP upload made quick file iteration possible without SSH credentials.
- Why we shelved it for Open House: the robot's mechanical design and weight made steering poor; the Zumo v1.2 motor driver could not reliably provide the traction/steering we needed for a stable differential-drive demo.

## Next steps (recommended)

1. If we keep the robot for further work:
   - Re-solder the pulled positive leads and replace the missing OptiTrack head marker.
   - Replace the Zumo motor driver with a higher-current motor driver or reduce robot weight.
   - Consolidate the HTTP upload server and provide a secure restart endpoint (or use `systemd` with a controlled reload command).

2. For Open House demo readiness: prefer a lighter robot or one built for differential steering. Use this Pi-based framework for clients that receive pose data and control actuators.

---

Last updated: 2025-10-27

# RaspberryPi3

This folder documents the Raspberry Pi 3 setup, provisioning scripts, and the code used for Pi-based clients during demos.

## Status
- Current: basic provisioning and headless setup documented. Pi-based client scripts will consume the TCP OptiTrack bridge output (see `OptiTrack/client_rasp_opti.py`).

## Goals for this folder
- Provide reproducible SD provisioning steps for demo Pis.
- Store provisioning scripts (`setup/`) and small example clients (`src/`).
- Document hardware wiring and attach photos or small diagrams in `docs/`.

## Hardware checklist
- Raspberry Pi 3 (Model B recommended)
- SD card (at least 8 GB, class 10)
- Power supply (5V, 2.5A recommended)
- Optional: USB-to-serial adapter, motor controllers, sensors, cables

## Quickstart (headless, Windows PowerShell)
1. Flash Raspberry Pi OS to SD card using Raspberry Pi Imager or BalenaEtcher.

2. Enable SSH and configure Wi‑Fi (on the SD card `boot` partition):

   - Create an empty file named `ssh` in the `boot` partition.
   - Create `wpa_supplicant.conf` with your SSID and passphrase (UTF-8, CRLF ok).

3. Insert SD card and boot the Pi. Find the Pi IP using your router or `arp -a`.

4. SSH in and update packages (on the Pi):

   sudo apt update; sudo apt upgrade -y

5. Install required packages and project dependencies:

   sudo apt install -y python3 python3-pip git
   python3 -m pip install --user -r requirements.txt

6. Run the example OptiTrack client (adjust host/port as required):

   python3 src/client_rasp_opti.py --host <MOTIVE_HOST_IP> --port 5400

## Provisioning scripts
- `setup/` should contain small scripts for SD customization, `fix-permissions.sh` and an optional `create-image.ps1` helper.
- Do not commit large binary images; instead produce them as release artifacts and list checksums in this folder.

## Services and autostart
- Use `systemd` unit files for long-running clients (example in `setup/pi-client.service`).

Example `systemd` unit (on Pi):

```
[Unit]
Description=OpenHouse Pi client
After=network.target

[Service]
User=pi
WorkingDirectory=/home/pi/OpenHouse_UPEI_2025/RaspberryPi3
ExecStart=/usr/bin/python3 /home/pi/OpenHouse_UPEI_2025/RaspberryPi3/src/client_rasp_opti.py --host <MOTIVE_HOST_IP> --port 5400
Restart=always

[Install]
WantedBy=multi-user.target
```

## Security notes
- Replace default passwords and use SSH keys. Lock down the Pi to only necessary ports and services.

## What was completed (notes)
- OptiTrack end-to-end: `OptiTrack/` is documented and the TCP bridge + Python client workflow is implemented and tested.

## Next steps (suggested)
1. Add a small provisioning script in `setup/` that:
   - Applies OS updates, creates a service user, installs packages, and sets up the example systemd unit.
2. Add a short troubleshooting section with common `journalctl` and `dmesg` checks and expected outputs.
3. Create an example `src/` client that validates frames and outputs a JSON log for replay.

## Troubleshooting
- If a service won't start: inspect `journalctl -u <service>` and `dmesg` for hardware errors.

---

Last updated: 2025-10-27
## Background & timeline (notes from development)

- Owner / lead developer on the robot: Duy — his full, legacy codebase is kept for reference in `legacy_code_by_duy/`.
- What happened (short timeline):
  1. Duy developed the robot and the wall-following and motor-control code. His repository is preserved under `legacy_code_by_duy/` and was not modified.
  2. I (you) explored using the robot for the Open House:
     - wrote a TCP client to consume OptiTrack frames (same format as described in `OptiTrack/`),
     - tested motors (using `test_motor` derived from the legacy code),
     - lacked SSH credentials for the Pi, so experimented with an HTTP upload/control approach (files under `http_stuff/`),
     - discovered the robot design is unsuitable for our Open House demos (difficult steering, underpowered drive for ~2.2 kg robot) and shelved it for live demos.

## Code layout (important files you mentioned)

- `legacy_code_by_duy/` — original research and control code by Duy (do not edit; for reference).
- `http_stuff/` — early HTTP upload and remote-control experiments (contains `server_rasp_upload` + `upload.html`, control pages and small web endpoints).
- `pi_openserve_test_com.py` (or similar) — demo server that reads OptiTrack frames and exposes a test interface.
- `pi_power_control.py` — attempts to reboot/shutdown Pi via HTTP (permission-limited; needs root or sudo configuration to work reliably).
- `pi_open_server_test_com_n_motor.py` — combined control page to toggle motors and restart/reload demos after upload.
- `test_motor.py` — motor exercise script adapted from legacy code (used during bench testing).
- `lil_demo_path_tracking.py` — small demo path follower script you used for testing after uploading via HTTP.

If a filename differs slightly in the repo, these names are conceptual; see the `RaspberryPi3/` listing for exact names.

## Robot hardware summary (what I observed)

- Physical design: Raspberry Pi 3 + internal camera & LED + Zumo board + Arduino interface + custom power regulation board.
- Approx weight: ~2.2 kg (robot heavy; Zumo v1.2 struggles to provide sufficient torque for differential steering).
- Power sources:
  - Zumo motors: 4x Bonai 2300 mAh Ni-MH cells (HR6 1.2V each) — supply motor driver on the Zumo board.
  - Pi + camera + white LED: 2S LiPo (SUNPADOW orange pack, 900 mAh, 7.4V) feeding a small regulator module to 5V for the Pi.
  - Note: the orange LiPo also powers internal white LED and camera — LED on indicates battery + regulator path intact.
- Known hardware issues:
  - The soldered positive lead on Robot1 and Robot2 was accidentally pulled — needs re-soldering to restore reliable power.
  - One of the OptiTrack marker "heads" is missing (only 3 remain; one robot may not be trackable until a marker head is added).

## Robot wiring (high-level)

This section describes the key power and signal connections — treat as a checklist rather than PCB-level wiring.

1. Battery (2S LiPo, 7.4V) -> small regulator module -> 5V output -> Raspberry Pi 3 5V input.
   - Check the regulator wiring polarity carefully before connecting. The internal white LED and camera should power on when connected.
2. Zumo battery pack (4x NiMH) -> Zumo board motor power input -> Zumo on/off switch (must be ON to power motors and Arduino).
3. Zumo board (motor driver) -> Arduino headers -> Arduino -> serial (TX/RX) to Raspberry Pi (UART) or via USB depending on the robot.
4. Raspberry Pi -> camera (CSI) + internal white LED (power feed), and Pi -> OptiTrack marker mount on the head.

If you open the robot, visually confirm:
- the orange LiPo connection and the regulator board is soldered and intact,
- the Zumo switch is in the ON position when testing motors,
- motor batteries are installed and charged.

## Diagrams

I added two diagrams to make the architecture and wiring clear. See `RaspberryPi3/diagrams/`:

- `diagrams/robot_design.svg` — robot component layout (Pi, regulator, LiPo, camera, Zumo, Arduino, motor batteries).
- `diagrams/network_flow.svg` — network & control flow (OptiTrack -> NATNet/bridge -> demo host -> Pi (socket client) and optional HTTP upload/control channel).

Open these SVGs in your browser or image viewer. They are intentionally simple, schematic diagrams for documentation and the Open House handout.

## Quickstart (developer view)

1. Inspect hardware & fix solder issues
   - Confirm the LiPo regulator positive lead is soldered correctly (repair Robot1/Robot2 if needed). Verify the internal LED and camera power on when the LiPo is connected.

2. Bring up the Pi and network
   - Boot the Pi from a prepared SD card. Use headless SSH or local terminal if you have credentials; otherwise the HTTP upload approach can be used to transfer scripts.

3. Test motors (basic)
   - Ensure Zumo switch is ON and motor battery pack is installed.
   - Run `test_motor.py` on the Pi (or from a local workstation via SSH) to verify motor driver output and basic forward/back commands.

4. Test OptiTrack client flow
   - Start your OptiTrack bridge (see `OptiTrack/`) on the demo host.
   - Run the Pi TCP client: `python3 src/client_rasp_opti.py --host <MOTIVE_HOST_IP> --port 5400` and watch for frames.

5. Use the HTTP upload for quick iteration
   - On the Pi: start the upload server `server_rasp_upload` (found under `http_stuff/`).
   - From your workstation, open `upload.html`, select the updated demo script (e.g., `lil_demo_path_tracking.py`) and upload it; the server will overwrite the file on the Pi.
   - Use the control endpoint (or `pi_open_server_test_com_n_motor.py`) UI to stop the running demo process and restart the new script. Note: the server may need additional permissions to restart system processes.

6. Automate at boot (optional)
   - If you want the demo to run at boot, add a `cron` or `systemd` unit. Example cron line saved at `setup/cronjob.txt`.

## Example `setup/cronjob.txt`

```
@reboot /usr/bin/python3 /home/pi/OpenHouse_UPEI_2025/RaspberryPi3/src/lil_demo_path_tracking.py >> /var/log/lil_demo.log 2>&1
```

Place this in the Pi's crontab (edit via `crontab -e` for the `pi` user) or convert into a `systemd` unit for better control.

## HTTP upload / control notes

- `server_rasp_upload` + `upload.html` — quick dev flow to push small script changes to the Pi over the LAN. Files are overwritten if the same name exists.
- Security note: this is a convenience tool on a local LAN and is not secure for untrusted networks. Limit access to a local, private network for demos.
- Reboot/shutdown via HTTP (`pi_power_control`) usually requires `sudo` privileges; to allow a web process to run reboot/shutdown you must configure appropriate `sudoers` entries or have the process run under a user with permissions—exercise caution.

## What worked and why we stopped

- What worked: motor control test and OptiTrack client integration worked; HTTP upload made quick file iteration possible without SSH credentials.
- Why we shelved it for Open House: the robot's mechanical design and weight made steering poor; the Zumo v1.2 motor driver could not reliably provide the traction/steering we needed for a stable differential-drive demo.

## Next steps (recommended)

1. If we keep the robot for further work:
   - Re-solder the pulled positive leads and replace the missing OptiTrack head marker.
   - Replace the Zumo motor driver with a higher-current motor driver or reduce robot weight.
   - Consolidate the HTTP upload server and provide a secure restart endpoint (or use `systemd` with a controlled reload command).

2. For Open House demo readiness: prefer a lighter robot or one built for differential steering. Use this Pi-based framework for clients that receive pose data and control actuators.

---

Last updated: 2025-10-27

