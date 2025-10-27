# BINH — Camera + OptiTrack Integration (snapshot)

Overview
--------
This folder contains a snapshot by Binh that focuses on integrating camera feeds and OptiTrack coordinate transforms with the demo GUI. It is not a complete, production-ready GUI, but it contains useful utilities and transformation code used when merging camera observations and motion-capture positions.

Contents
--------
- `coordinate_transformer.py` — helper utilities for transforming coordinates between camera frame and field coordinates (used to align camera detections with OptiTrack positions).
- `backup_Oct24.txt` — notes / savepoint from a development session.

Quickstart
----------
1. Install dependencies (if there is a `requirements.txt` in this folder, otherwise use the repo-wide requirements):

   python -m venv .venv; .\.venv\Scripts\Activate.ps1; pip install -r requirements.txt

2. Run the transformer or experiments directly:

   python coordinate_transformer.py

Notes and expectations
----------------------
- The Binh snapshot assumes a camera feed (OpenCV-compatible device or video file). If you plan to use an IP camera or RTSP stream, adapt the capture source in `coordinate_transformer.py`.
- This version is a useful resource for reprojection code and small utilities; it does not include the full GUI window seen in other folders.

How it fits
-----------
- Use the transformation utilities here to convert pixel coordinates (camera) into field coordinates used by the GUI and path planner.
- For a full demo that integrates camera + GUI + serial, prefer combining these utilities with `Minh` or `Soroush` versions which include complete runtime wiring.

Known issues & next steps
------------------------
- This folder is a development snapshot — add tests and example recordings to make it reproducible.
- Add a short example script showing a mapping from example image -> field coordinates and unit tests covering the math.

DEV_STORY
---------
See `DEV_STORY.md` in this folder for the small narrative and author notes.
