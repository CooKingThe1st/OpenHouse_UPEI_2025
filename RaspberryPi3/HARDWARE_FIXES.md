# RaspberryPi3 — Hardware fixes & critical notes

This document lists actionable hardware fixes, parts needed, testing procedures, and a frank account of the design problems and operational complaints observed while testing the Pi-powered robot. These notes are intentionally direct and specific — they are intended to guide a rapid repair sweep and to record the known failure modes for future maintainers.

Status: draft — follow the checklist below and mark items done as you complete them.

---

## Safety first

- Work on electronics only with power removed unless you need to perform a live test. Disconnect LiPo and motor battery packs before soldering.
- LiPo safety: handle the 2S LiPo carefully. If swelling, damage or questionable wiring is present, DO NOT USE. Dispose/replace per safe LiPo procedures.
- Use eye protection and a temperature-controlled soldering iron.

## Summary of critical issues (high priority)

1. Pulled positive solder lead for the orange LiPo regulator on Robot1 and Robot2 — these must be re-soldered before reliable Pi power is restored.
2. Missing OptiTrack marker head: one marker head is missing (only 3 out of expected 4 found) — robot may not register as a rigid body until replaced.
3. SSH credentials are unknown/missing — remote administration is hindered. The HTTP upload workaround is useful but insecure and incomplete.
4. Robot is heavy (~2.2 kg) and Zumo v1.2 motor driver is underpowered — steering is poor; motors slip and traction is insufficient.

Each item below includes steps, parts, tests and severity.

---

## Actionable checklist: repairs and verification

- [ ] 1) Repair pulled LiPo positive wire (Robot1 & Robot2)
  - Severity: critical
  - Parts/tools: soldering iron (25–35 W), rosin-core solder (60/40 or lead-free SAC305), flux (liquid or pen), 22–26 AWG stranded silicone-insulated wire (spare), heat-shrink tubing, helping hands or PCB clamp.
  - Steps:
    1. Power down and disconnect ALL batteries (LiPo and NiMH packs).
    2. Inspect the regulator PCB and the pulled trace — determine if the pad or wire was lifted.
    3. If pad lifted: carefully scrape soldermask to expose copper or use a small stranded wire to bridge to a nearby ground or VCC pad following the regulator layout. If the connector itself pulled from the cable, strip ~5 mm of insulation and tin the conductor.
    4. Apply a small amount of flux; reflow with iron and solder the joint. Use a fresh solder tip and minimal heat exposure to avoid lifting more pads.
    5. Reinforce with a small dab of epoxy or hot glue (after cooling) to relieve mechanical stress.
    6. Fit heat-shrink over the joint and shrink with heat gun.
  - Tests:
    - Reconnect motor batteries only if regulator is not connected to motors; connect only the LiPo and check the internal white LED and camera power. Confirm Pi boots or at least shows activity (LEDs blink) after connecting regulator output.
    - Measure 5V output with a multimeter before connecting Pi (confirm polarity and voltage ~5.0 V).

- [ ] 2) Replace or reattach missing OptiTrack marker head
  - Severity: blocking for tracking if robot uses that head
  - Parts/tools: replacement OptiTrack reflective head (small ball markers) or a 3D-printed mount + reflective tape; double-sided adhesive or screw mount depending on design.
  - Steps:
    1. Locate an appropriate spare marker head (big ball preferred for reliability per OptiTrack notes).
    2. Mount on the robot’s head mount in the same pose used during registration.
    3. Re-register the rigid body in Motive if the marker configuration changed.
  - Tests:
    - Confirm the rigid body appears in Motive with stable positions and that the bridge publishes its `id`.

- [ ] 3) Inspect and reflow connectors on Zumo/Arduino interface
  - Severity: high
  - Parts/tools: multimeter, soldering iron, spare header pins (if required), hot glue.
  - Steps:
    1. Check TX/RX serial connections between Arduino and Pi; reflow any suspicious joints.
    2. Inspect power headers on Zumo board for cold joints.
    3. Ensure the Zumo on/off switch is functional and not intermittent.
  - Tests:
    - With motor pack installed and Zumo switch ON, run `test_motor.py` and confirm motor direction and speed control.

- [ ] 4) Battery checks and connectors
  - Severity: high
  - Parts/tools: charger for NiMH pack, LiPo charger, spare battery connectors (JST or JST-PH), multimeter.
  - Steps:
    1. Charge NiMH motor pack to full and verify cell/battery voltage.
    2. Check LiPo voltage and battery health. Replace if below expected resting voltage or if cells are unbalanced.
    3. Replace any brittle or corroded connectors.
  - Tests:
    - Motor current draw test via bench supply with current meter (verify Zumo driver is not overheating and that motors draw reasonable current without overcurrent trips).

- [ ] 5) Create recovery access & SSH key plan
  - Severity: operational (medium-high)
  - Steps:
    1. If you regain physical access to the Pi, create a recovery SSH user and add your SSH public key to `/home/pi/.ssh/authorized_keys`.
    2. Add a local console password reset plan (boot with SD card on another machine and edit `/etc/shadow` or use `passwd` after mounting to reset `pi` password) — document steps.
    3. Replace the HTTP upload-only workflow with a secure mechanism: prefer SSH key-based access or a small HTTPS endpoint protected by a token.
  - Tests:
    - Verify you can SSH in with key and SFTP files.

---

## Potential upgrades (non-blocking but recommended)

- Replace Zumo v1.2 motor driver with a higher-current motor driver or motor controller that supports current limiting and more torque.
- Consider lighter chassis or reduce payload to bring total mass under ~1.2 kg for reliable differential drive with existing motors.
- Improve mechanical mounting so the weight is better distributed and traction increases (rubber tread, larger wheels, friction-reducing bearings).

---

## Potential bugs, complaints, and a candid rant (preserve for context)

These are verbatim-style notes and strong opinions intended to record the frustrations and the key reasons you dropped this robot for the Open House. Keep them — they explain the design risk and why we should pick alternatives for live demos.

- Missing SSH password: I couldn't SSH into the Pi because the SSH password is unknown. That made development difficult — having to rely on an HTTP upload work-around is insecure and clumsy. Fix: create documented recovery keys and a standard `MAINTAINERS.md` with guidance.

- Pulled solder and fragile power wiring: I accidentally pulled the positive (+) lead on Robot1 and Robot2 when moving them. That is a poor mechanical design — the regulator/wiring is exposed to mechanical stress and will fail in the field. This is critical; it caused time loss and is a safety hazard if LiPo wires are shorted.

- Missing OptiTrack head: only 3 heads were found; one missing means a robot may not be tracked reliably or will appear with missing markers. This is sloppy inventory management.

- Design is too heavy: the robot weighs ~2.2 kg but uses the Zumo v1.2 motor driver and small motors intended for much lighter robots. The motors struggle, steering is near impossible because traction is poor and the motor can't produce the torque for differential steering under load.

- Zumo + Arduino wiring is brittle: the stack wiring and harness make power and signal routing prone to intermittent contacts — a hard stop for reliable operation during an event.

- Outcome and decision: I tested the OptiTrack client and motors, but after hitting all of the above, I concluded the robot is not fit for a stable Open House demo. The HTTP remote control idea is neat, but it shouldn't be the fallback because it exposes a fragile, insecure workflow.

These are not minor nitpicks — they are show-stoppers for a public demo. I recommend we retire this robot for the event unless we (a) fix the wiring and resolder joints, (b) replace the motor driver or reduce weight, and (c) restore proper remote access (SSH keys).

---

## Recording changes & next actions (for PR checklist)

When you apply a fix, update this file and append the action, who did it, and the date. Example log entry:

- [2025-10-27] Reflowed LiPo regulator on Robot1; verified 5.02 V output; tested camera LED. — @yourname

---

Last updated: 2025-10-27
