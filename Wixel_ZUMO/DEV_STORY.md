# Wixel + ZUMO — Development Story

Author: (project team) — contributions by the OpenHouse students

Short history
-------------
This Wixel + Zumo stack was created to provide a lightweight, portable demo platform for OpenHouse. The idea was to use inexpensive Wixel radio modules and Pololu Zumo motor boards to build many small robots that are easy to transport and quick to assemble.

Design choices
--------------
- Use the same Wixel hardware for master and slave roles to simplify spare parts and flashing workflows.
- Favor peer-to-peer (Pololu recommended) RF mode for reliability and simplicity during demos.
- Keep the robot firmware simple (state machine: IDLE / GO_TO / TRACK_PATH) so it’s easy to reason about and debug in a live event.

What worked well
----------------
- Fast, lightweight robots suitable for crowded demo tables.
- RF peer-mode proved stable for one-to-many broadcasts in our tests.
- The alpha testing apps (hot-upload friendly) made rapid iterations possible during development.

Pain points and lessons
----------------------
- Fixed addresses in C code made changing robot IDs cumbersome — moving addresses into a small configuration location would have saved time.
- Hot-upload timing tricks are convenient but fragile. When apps grew in complexity the uploader timing could interfere with runtime serial behaviour.
- Trust the OptiTrack data format; ad-hoc transforms (e.g., reversing Y) can silently break orientation calculations.

Recommended next steps for students
----------------------------------
1. Move addresses to a runtime-configurable area so re-flashing is not required for ID changes.
2. Add a small `flash_wixel.ps1` helper to standardize uploads on Windows.
3. Extract packet schema definitions into a single shared file and add unit tests for host↔firmware framing.

Closing
-------
This stack was designed to be pragmatic for demo use. The codebase contains useful calibration, analysis and simulation components (see `host/` and `digitalTwin*` files). If you continue the project, keep the tooling simple and document every change to the packet schema — it is the backbone of the demo.
