# NATNet -> TCP Bridge (notes)

This document explains the simple NATNet->TCP bridge approach used in the project and references the original C++ implementation used during development (`OptiTrack_serverTCP.cpp` in your attachments).

Why a bridge?
- NATNet is OptiTrack's native protocol; it's efficient and feature-rich but UDP/multicast-based and requires a client SDK for full implementations.
- Many lightweight robot boards or constrained clients prefer a simple TCP ASCII socket interface.

Bridge behaviour (recommended contract)
- Subscribe to NATNet locally on the Motive host and extract rigid-body pose data for the labeled robots used in the demo.
- Convert each rigid-body to a compact ASCII record: `id,x,y,z,rotation;` where:
  - `id` is the rigid-body ID assigned in Motive
  - `x,y,z` are positions in Motive's coordinate frame (meters)
  - `rotation` is a single yaw/heading angle in degrees (or radians, but be explicit)
- Aggregate multiple records into one newline-terminated packet and serve that over a plain TCP socket to any connecting client.

Operational notes
- Keep the bridge single-threaded or with a small worker pool — NATNet callbacks should push updates into a thread-safe structure and the TCP server loop reads and sends snapshots.
- Use a simple text protocol (no binary) for easier debugging and cross-platform clients.
- Consider a simple heartbeat or sequence number to detect lost packets on the client side.

Security and reliability
- The bridge runs on the Motive host; restrict access to trusted client IPs or the demo LAN, especially if running on a campus network.
- Use a short TCP keepalive and timeouts on the client to detect disconnects.

Reference implementation
- The file `OptiTrack_serverTCP.cpp` (attached in your original project) is an example bridge that listens on port 5400, subscribes to NATNet, and writes ASCII robot records to connected TCP clients. That file is Apache 2.0 licensed in its header and can be copied into this repo (I can do that if you want).

Next steps (optional)
- Add a small Python/TCP server reference implementation for quick testing (useful for testing clients without Motive).
- Add unit tests for the Python client parser (`client_rasp_opti.py`) to validate edge cases.
