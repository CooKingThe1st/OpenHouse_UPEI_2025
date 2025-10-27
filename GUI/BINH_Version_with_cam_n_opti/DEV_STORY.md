# BINH Version — Short Development Story

Author: Binh (snapshot)

What this is
------------
This folder captures a focused effort to add camera-based observations and transformation utilities to the project. The primary deliverable is coordinate transformation code to align pixel detections with the motion-capture / field coordinates.

Key choices
-----------
- Keep transformation logic isolated in `coordinate_transformer.py` so other GUI versions can reuse it.
- Prefer reproducible math with small helper functions rather than embedding the logic in a large GUI script.

Lessons & next steps
-------------------
- Add an example dataset (image + annotated ground-truth) and a small unit test suite to make this snapshot reusable.
- Integrate the transformer into a GUI demo (e.g., Minh or Soroush versions) and provide a runtime switch to enable camera-based corrections.
