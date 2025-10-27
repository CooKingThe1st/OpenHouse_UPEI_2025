# http_stuff — Raspberry Pi HTTP tooling

This folder contains small HTTP utilities and a TCP backdoor client used during development to control and iterate on the Raspberry Pi robot without SSH access.

Purpose
- Provide a fast developer workflow to upload scripts, run/stop demo processes, monitor the OptiTrack client, and send direct commands to the demo via a local TCP backdoor.
- Not intended to be exposed to the public internet — use only on a trusted, private LAN for development and demos.

Contents (key files)
- `server_rasp_upload.py` — very small file upload server (port 8000 by default). Uploads overwrite files in the current working directory.
- `upload.html` — simple web UI for `server_rasp_upload.py` (drag/drop file upload).
- `pi_open_server.py` — control server for starting/stopping the demo and emergency motor stop (port 8000 by default).
- `pi_open_server_test_com.py` — OptiTrack communication testing server (port 8001). Connects to the OptiTrack TCP bridge and shows live data + stats.
- `pi_open_server_test_com_n_motor.py` — extended control server with mode selection and TCP backdoor support (port 8000). Uses a TCP command channel to send mode commands to the running demo (TCP backdoor port 5500).
- `pi_power_control.py` — simple power control web UI (port 8069). Exposes /shutdown and /reboot endpoints (requires system permissions to actually work).
- `backdoor_pi_test_lil.py` — a small TCP client to send JSON commands to the demo's backdoor (used from a workstation to talk to the Pi).
- `client_rasp_opti.py` — TCP client that connects to the NATNet->TCP bridge and parses pose frames.

Quickstart — run the servers (on the Pi)

Notes: run these from the `RaspberryPi3/Codebase/http_stuff/` directory on the Pi. Use Python 3.

1) Upload server (quick file iteration)

```powershell
# start the upload server (serves on port 8000)
python3 server_rasp_upload.py
```

- Open `upload.html` from your workstation pointing to the Pi (e.g., `http://192.168.0.232:8000/upload.html` or copy `upload.html` locally and hit the Pi root `/` which serves the upload form if placed in the same directory). The provided `upload.html` expects the server at `/`.
- Files are written into the server's current working directory and will overwrite existing files with the same name. Use carefully.

2) Demo control server (start/stop demo, emergency stop)

```powershell
python3 pi_open_server.py
```

- Default port: 8000
- Endpoints:
  - GET `/` — control panel HTML UI (Start / Stop / Emergency Stop)
  - GET `/status` — JSON status of the demo process
  - POST `/start` — start `lil_demo_path_tracking.py` (the demo script)
  - POST `/stop` — stop the demo and ensure motors are stopped
  - POST `/emergency_stop` — immediately send stop command to motors (uses serial port `/dev/serial0`)

- Important: the server uses serial to send a motor stop and launches the demo as a subprocess. Ensure the demo script path/permissions are correct.

3) OptiTrack communication test server

```powershell
python3 pi_open_server_test_com.py
```

- Default port: 8001
- Purpose: connect to OptiTrack bridge (`OPTITRACK_SERVER_IP`/`OPTITRACK_PORT` in the file), parse incoming frames and display live stats.
- Endpoints:
  - GET `/` — UI showing connection controls and live stats
  - GET `/status` — JSON status (connected, total_frames, fps, robots, raw_data)
  - POST `/connect` — connect to configured OptiTrack host
  - POST `/disconnect` — disconnect
  - POST `/start` — start monitoring thread
  - POST `/stop` — stop monitoring thread

4) Control server with TCP backdoor + mode commands

```powershell
python3 pi_open_server_test_com_n_motor.py
```

- Default port: 8000 (web UI)
- TCP backdoor port (local): 5500 (demo should listen on this port for JSON commands)
- Adds mode endpoints (POST JSON):
  - `/mode/manual_velocity` — send manual velocities (JSON: {"vL": <float>, "vR": <float>})
  - `/mode/test_motor` — run motor test
  - `/mode/goal_reaching` — JSON with `goal_x`, `goal_y`
  - `/mode/path_tracking` — JSON with `waypoints`: [[x1,y1],[x2,y2],...]

- The server sends JSON commands to the demo via TCP (127.0.0.1:5500). The demo process must implement a small TCP listener to accept these commands and act accordingly.

5) Pi power control server

```powershell
python3 pi_power_control.py
```

- Default port: 8069
- Endpoints:
  - GET `/` — UI with Shutdown / Reboot buttons
  - POST `/shutdown` — will call `shutdown` (the script currently calls the `shutdown` command; it requires root or sudo privileges to actually shut down)
  - POST `/reboot` — will call `reboot`

- Security: granting a web process the ability to reboot/shutdown requires careful `sudoers` configuration (not enabled by default). Do not expose this server on untrusted networks.

TCP backdoor & `backdoor_pi_test_lil.py`
- The expected JSON command format (used by `backdoor_pi_test_lil.py`) is a small dict with a `command` field and optional parameters. Examples:

```json
{"command": "manual_velocity", "vL": 40.0, "vR": 40.0}
{"command": "test_motor"}
{"command": "goal_reaching", "goal_x": 0.5, "goal_y": 0.5}
{"command": "path_tracking", "waypoints": [[0.5,0.5],[1.0,1.0]]}
```

- The backdoor client defaults to `TCP_PORT = 5500`. Update `ROBOT_PI_IP` in `backdoor_pi_test_lil.py` to your Pi's IP if running remotely.

Security & operational notes (read carefully)
- These servers were built for local development and convenience. They are not hardened and should NOT be exposed to public or untrusted networks.
- Recommended mitigations:
  - Run behind a trusted LAN. Use host-only firewall rules to allow only your dev workstation IPs.
  - Replace `server_rasp_upload.py` with a more secure transfer mechanism (SFTP/rsync over SSH) for production.
  - Use SSH key-based access and restore SSH credentials — do not rely on upload-only workflows long-term.
  - If you need remote reboot/shutdown from the web UI, configure `/etc/sudoers.d/pi_power` to allow only the web process user to run `shutdown`/`reboot` without a password; log and audit access.

Tips for making this production-safe
- Use `systemd` to run servers with a dedicated user and limited privileges.
- Add simple token-based auth to the web servers (check header token before allowing POST actions) if you must run them on a larger lab network.
- Use HTTPS (nginx reverse proxy with TLS) if you need secure browser access.

Where this fits in the workflow
- Typical dev loop used during testing:
  1. Start `server_rasp_upload.py` on Pi.
  2. Upload edited `lil_demo_path_tracking.py` via `upload.html` from workstation.
  3. Use `pi_open_server.py` to stop the demo process (if running) and start the new script.
  4. Use `pi_open_server_test_com_n_motor.py` or the backdoor client to run modes and tests.

If you'd like, I can:
- Add a small `install.sh` that creates a dedicated `pi-http` user, configures `systemd` service units for the chosen servers, and installs a minimal token auth wrapper.
- Harden `server_rasp_upload.py` with file-type and path whitelisting to prevent accidental overwrites outside the expected directory.

---

Last updated: 2025-10-27
