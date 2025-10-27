# OptiTrack

Overview

This folder documents the OptiTrack motion-capture integration used during demos. It includes:

- A short wiring / data-flow diagram describing how markers, cameras, and clients connect.
- Practical notes about markers, camera configuration and when to perform calibration/lighting adjustments.
- Host machine guidance (Motive settings, services, firewall and networking).
- Communication options (NATNet and VRPN) and a lightweight NATNet->TCP bridge approach (C++ server attached separately).
- A small Python client example (`client_rasp_opti.py`) that connects to a TCP server and parses the robot data format used in demos.

Wiring / Data-flow diagram

The pipeline for demos is intentionally simple and robust. Visual (SVG) diagram is included in `diagrams/optitrack_pipeline.svg`.

Markers (Real world) -> Camera System -> Host machine running Motive (OptiTrack) -> Communication choice (NATNet / VRPN or NATNet->TCP bridge) -> Laptop / board on robot

Quickstart

1. Ensure OptiTrack cameras are mounted and powered, and the camera network is connected to a dedicated switch or the same subnet as the Motive host.
2. On the Motive host: open Motive, load your take or create a new subject/rigid body and enable streaming (Streaming -> Enable streaming).
3. Choose a streaming protocol (NATNet or VRPN) or use the NATNet->TCP bridge if you need simple TCP socket clients (see `natnet_tcp_bridge.md`).
4. If using the TCP bridge, run the bridge on the Motive host; then start `client_rasp_opti.py` on the robot board or laptop and point it to the host IP and TCP port.

Markers: types, effects and notes

- We will use three types of markers in the project: tape, small ball, and big ball.

- Tape: easy to attach, but the least reliable. Use when profile or weight is critical and you accept more drop-outs.

- Small ball: plentiful in our inventory and many are new. They can perform very well, but in bright conditions (for example morning sunlight) they may pick up a lot of noise — so their performance is not as consistent across the day as the big balls.

- Big ball: fewer available and many are old/chippy, but overall the big balls are the most consistent and reliable throughout the day. If you need stability across lighting changes, prefer big balls when possible.

- Mix-and-match: depending on your needs, mix marker types. For reliability prefer big balls on critical points and use small balls or tape where profile/quantity matters.

Orientation / registration guidance

- To reduce orientation offset between the robot frame and the OptiTrack frame, register robots with a consistent physical pose:
	- Robot +X should point to the lab right side.
	- Robot +Y should point toward the door.

Text layout (for clarity):

										robot should head positive X to here                    door (<- from outside)
																			 |
																			 |
																		robot --------------------------------->   should head y toward here

Make sure the robot is physically oriented exactly as above before you register its markers in Motive. If registration is performed with the robot rotated, that rotation becomes the rigid-body definition and will introduce a constant heading offset.

Camera System: changing threshold, LED brightness and timing advice

- Threshold / exposure / gain: Use Motive's camera settings panel. Lower thresholds reduce false detections but may drop weak markers; raise threshold if there is a lot of background noise.
- LED brightness: Increase LED brightness to improve reflective marker detectability at the cost of power and potential saturation. Start at medium and increase in steps while watching for blooming.
- Best time to tune:
	- Tune cameras when the arena is in the same lighting as run-time (day vs night, indoor lighting changes).
	- Adjust one camera at a time while observing the global marker cloud in Motive.
	- Re-run calibration after physically moving cameras or changing mounting.

How to check what the camera is seeing (practical notes)

- In Motive you can view each camera's live image and the reconstructed 3D points. Motive also shows marker positions as orange dots in the 3D view.
- If the orange dots flicker or you see duplicate points, the detection is unstable. Adjust the threshold slider and LED brightness until dots are stable (no flicker) and duplicates disappear.
- Tune one camera at a time and then check the global reconstruction; small incremental adjustments are safer than large jumps.

Host Machine (Motive) - what to run and what to be aware of

- Recommended host: a machine with a dedicated NIC for the camera network (GigE preferred), adequate CPU, and SSD for recording.
- Important Motive settings:
	- Streaming: enable NATNet or VRPN depending on client needs.
	- Recording: if you need offline playback, record takes to local storage.
	- Frame rate: match your demo requirements (30-120 Hz typical). Higher rates increase network and processing load.
- Networking & firewall:
	- If using NATNet, ensure UDP ports used by NATNet are open on the host (Motive typically uses 1510/1511). NATNet uses multicast in some configurations.
	- For VRPN, ensure the VRPN server configuration and ports are reachable by clients.
	- For the TCP bridge approach, open the chosen TCP port (e.g., 5400) on the host firewall.
- Services and reliability:
	- Run the NATNet/VRPN services on the host and keep Motive running for streaming.
	- Consider creating a small systemd/service (Linux) or scheduled task (Windows) to start the bridge server on boot for unattended demos.

Host machine exact steps (what to click/run)

- Open Motive and open View -> Communication (open the Communication tab). This tab must be open regardless of which streaming option you intend to use.
- If you use VRPN: tick the VRPN box in the Communication tab on the host — that's all you need to enable VRPN streaming.
- If you use NATNet (pure): tick the NATNet box in the Communication tab — that's usually all needed on Motive.
- If you use NATNet + our TCP bridge (because NATNet can be awkward for clients):
	1. Change Motive's local interface to loopback (127.0.0.1) so the bridge subscribes locally.
	2. Run the `SelectPacketClient` helper (it listens on host port 44400; used in our workflow).
	3. Run the bridge executable (compiled from the C++ source). The bridge listens (default) on TCP port 5400 and publishes compact ASCII robot records to connected clients.

Note: If you change rigid bodies (add/remove) or change labeling in Motive, the bridge can crash or stop publishing. Check the bridge terminal to confirm it's publishing the expected number of active tracked objects; if not, restart it.

Communication choice: NATNet vs VRPN (and NATNet->TCP bridge)

NATNet:
- Pros: native OptiTrack protocol, efficient UDP-based streaming, many client SDKs (C#, C++, MATLAB, Python wrappers).
- Cons: uses UDP and multicast in some modes which can be blocked on larger networks; more complex for firewall/NAT traversal.

VRPN:
- Pros: standardized robotics protocol; works well with many robotics frameworks and has a stable client/server model.
- Cons: extra layer between Motive and client; may require additional configuration.

NATNet->TCP bridge (used in this project):
- Rationale: some robot platforms (especially microcontrollers or restricted boards) are easiest to integrate with a simple TCP socket client instead of implementing NATNet/VRPN.
- Implementation notes: the bridge subscribes to NATNet locally on the host, converts relevant rigid-body data into a compact ASCII TCP format (e.g., `id,x,y,z,rot;...`) and serves it on a simple TCP port (example C++ server: `OptiTrack_serverTCP.cpp` — attached in your original project). The Python client `client_rasp_opti.py` consumes this format.

Client side: receive robot data with sockets and Python

- A ready-to-run client example is included: `client_rasp_opti.py`. It connects to a TCP server, reads ASCII robot frames, parses the `id,x,y,z,rot;...` format, performs basic validation and prints nicely-formatted output.
- Detailed notes (from your field observations):
  - VRPN: easier on ROS/Linux because VRPN maps well to ROS networking and there are existing ROS packages for VRPN (ROS and ROS2). On Windows using VRPN can be more work — you may need to rebuild VRPN libs on Windows or build Python bindings (older bindings target Python 3.4, which is dated). If you plan to pursue VRPN on Windows/Python, be prepared to rebuild or rebind; consider asking Edwin from MoreLab for guidance.
  - NATNet native: closed-source-ish SDK with C APIs; building native NATNet clients on robot boards can be difficult which motivated our bridge approach.
  - NATNet + bridge (our usual method): the project used this approach circa 2021. The original bridge code was not thread-friendly; the attached C++ was modified to reduce noisy logging and improve thread-safety — see `OptiTrack_serverTCP.cpp` (I can copy that file into this repo if you place it in the workspace or paste it here).

Ordering & reconnect caveats:

- The bridge publishes rigid-body entries sorted alphabetically by rigid-body name — clients should rely on the `id` field rather than array position to map robots.
- The bridge currently does not support auto-reconnect. In field tests the lab router sometimes disconnects laptops; Raspberry Pis are more resilient. When the router drops a client, restart the client; improving reconnect behavior is future work.
- Router/Network note: the lab router sometimes requires a password reset or admin steps (192.168.0.1). Ask Tin for admin credentials; some folks suggested removing the router password for the demo network (ask Duy/Tin for permission before doing that).

Files and layout (updated)

- `client_rasp_opti.py` — TCP client for the NATNet->TCP bridge (included here).
- `natnet_tcp_bridge.md` — short notes on the NATNet->TCP bridge and suggested server behavior.
- `diagrams/optitrack_pipeline.svg` — small pipeline diagram.
- `examples/` — (optional) place small example consumers here when available.

Troubleshooting and tips

- If you see fewer rigid bodies than expected: check marker IDs, ensure labels in Motive are correct, and confirm that all markers on a robot are visible to multiple cameras.
- For network issues: test with a local TCP client (telnet/netcat) to confirm the bridge port is open and forwarding data.

References

- OptiTrack Motive and NATNet SDK documentation.
- See `natnet_tcp_bridge.md` for bridge-specific details and a pointer to the attached C++ server that was used during development.

If you'd like, I can:
- copy the `OptiTrack_serverTCP.cpp` into this repo under `OptiTrack/bridge/` (it is Apache 2.0 licensed in the attached file),
- add a small systemd / Windows service wrapper for the bridge,
- or add a minimal unit test for the Python client to validate parsing.

--
Last updated: 2025-10-27
