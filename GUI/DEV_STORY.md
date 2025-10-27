# GUI — Development story & lessons

This file records the development history, the team contributions, the high-level choices we made, and the lessons learned while building the multi-robot GUI for the Open House demo.

Authors and roles
- Minh — original GUI author (Legacy), integrated client work and separate serial bridge approach
- Binh — integrated camera + OptiTrack client into the GUI ("with cam n opti")
- Soroush — implemented waypoint reduction/optimization features and integrated serial comms into an independent GUI

High-level timeline

1. Legacy_version (Minh)
   - Minimal GUI: drawing canvas, basic path functionality, and UI scaffolding.
   - Purpose: rapid prototype and user-facing controls.

2. BINH_Version_with_cam_n_opti (Binh) — Savepoint v1.0
   - Integrated overhead camera and OptiTrack client into the GUI.
   - Added calibration helpers and a serial integration prototype (master Wixel communication).
   - This was the most feature-rich version but proved difficult to extend further.

3. Feature split and experimentation
   - Two parallel efforts: waypoint simplification (reduce to max 20 waypoints, curvature-aware) and robust GUI-Serial integration.
   - Soroush implemented the waypoint simplifier (independent) while Minh focused on serial integration.

4. Backup / Merge attempts
   - Attempts to merge Soroush’s 20-waypoint optimizer into Binh’s v1.0 failed; integration conflicts and timing issues during serial send caused instability.

5. Soroush version with integrated serial
   - Soroush created an independent, working GUI that integrated serial communication directly (missing some camera/leaderboard features but stable for core functionality).

6. Minh version with separate GUI and serial (bridge)
   - Minh created a modular version where GUI and serial bridge were separated (keyboard/manual send available). It’s modular and easier to reason about.

Why multiple versions exist
- Parallel development allowed rapid exploration of ideas (camera integration, waypoint optimization, serial reliability) without blocking the demo schedule.
- We preserved each version to keep the history and to allow rollbacks to stable savepoints.

Current status (as of 2025-10-27)
- Soroush’s integrated version is the most stable for running the core demo (path drawing, optimizing, serial sending). It is the recommended branch for the Open House demonstration with caveats about occasional OptiTrack -> GUI -> serial value send bugs.
- Minh’s separate GUI+serial bridge is a robust fallback for manual control and modular testing.

LESSONS I LEARNED

- Keep the demo simple: For a short deadline event (Open House) the most robust demonstration is often the simplest one. Overengineering (GUI + Pi + camera + Wixels) introduced fragility.
- Keep remote access keys documented: Missing SSH credentials forced ad-hoc, insecure workarounds (HTTP upload). Always keep a documented recovery/SSH key process.
- Separate concerns early: Splitting upstream (OptiTrack) -> GUI -> serial bridge earlier would have reduced integration friction.
- Prioritize deterministic communication: For demos, deterministic, simple comms (serial via a wired connection or a well-tested master Wixel protocol) are better than many layers of translation.
- Preserve stories and rationale: We kept legacy code and savepoints for a reason — it helped debugging and allowed quick fallbacks.

If you'd like, I can:
- Generate a short one-page handout for the demo operator summarizing which folder to run and which script to start (Soroush's recommended path).
- Produce a minimal `RUN_DEMO.md` with copy-paste commands for the demo operator.

Last updated: 2025-10-27
