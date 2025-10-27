# Legacy GUI — Short Development Story

Author: Unknown (early prototype)

Purpose
-------
This single-file GUI was the first playable demo used to validate the DotConnect concept with visitors. The goal was to be fast-to-run and simple to explain.

What we learned
---------------
- Single-file apps are great for rapid demos but quickly become hard to maintain as features (audio, saving, preview, execution) are added.
- Hard-coded passwords and demo-only shortcuts made demo operations fast but are insecure for any production environment.

Why it stayed
-----------
We keep this version as a reliable, minimal fallback. When more integrated versions fail, the Legacy GUI is the fastest route to a demo that 'just works'.
