
# OptiTrack

Overview

This folder documents the OptiTrack motion-capture integration used during demos and testing. It includes streaming choices (NATNet, VRPN), a lightweight NATNet->TCP bridge approach used for simple robot clients, tuning notes, sample client code, and diagrams.

Status

- Completed: NATNet->TCP bridge workflow validated; example Python client (`client_rasp_opti.py`) used in Pi and robot tests.

Quickstart (host / Motive)

1. Ensure OptiTrack cameras are mounted, powered, and connected to a dedicated camera network/switch.
2. On the Motive host: open Motive, create or load a take, and enable streaming (View -> Communication -> NATNet or VRPN).
3. If using the NATNet->TCP bridge: run the bridge on the Motive host (bridge subscribes to NATNet locally and publishes a compact ASCII TCP stream on e.g. port 5400).
4. On the client (Pi / laptop): run `client_rasp_opti.py --host <MOTIVE_HOST_IP> --port 5400` to receive pose frames.

Files and structure

- `client_rasp_opti.py` — example TCP client for the NATNet->TCP bridge.
- `natnet_tcp_bridge.md` — notes describing the bridge rationale and usage.
- `bridge/` — (optional) C++ bridge source and build notes (if present).
- `diagrams/` — pipeline, camera layout images and SVGs.

Design notes and practical tips

- Bridge rationale: some embedded clients and microcontrollers implement simple TCP sockets more easily than NATNet or VRPN clients. The bridge converts NATNet rigid-body frames into a concise ASCII/timestamped record.
- Client mapping: clients must rely on rigid-body `id` fields (not positional ordering) because the bridge sorts entries deterministically.
- Reconnect behavior: the current bridge is basic and does not implement client auto-reconnect; implement reconnect in the client for production use.

Camera tuning highlights

- Tune thresholds and LED brightness per-camera while watching the global reconstructed marker cloud in Motive.
- Re-run calibration after moving cameras or changing mountings.

Troubleshooting quick checklist

- Fewer rigid bodies than expected: verify marker visibility, labeling in Motive, and that all markers are seen by multiple cameras.
- Network / firewall: ensure the chosen TCP port (e.g., 5400) is open for the bridge; NATNet uses UDP (ports like 1510/1511) and may use multicast.
- Local test: use `nc`/`telnet` to confirm the bridge port is serving lines of ASCII frames.

Next steps (optional)

- Add a small service wrapper (systemd on Linux, scheduled task or NSSM on Windows) to auto-start the bridge on boot.
- Add a small unit test for `client_rasp_opti.py` to validate parsing of common frame cases (missing fields, partial frames).

Last updated: 2025-10-27
																		robot --------------------------------->   should head y toward here
