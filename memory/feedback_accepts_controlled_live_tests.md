---
name: feedback_accepts_controlled_live_tests
description: "Bojan accepts a brief, controlled live disruption to get definitive proof ("risk it, we can restart after") when a recovery command is ready; he wants every test artifact cleaned up afterwards and claims backed by re-verified evidence"
metadata:
  type: feedback
---

When a claim can only be settled by a real end-to-end test that briefly disrupts the live desktop (for example killing Quickshell to free a D-Bus name), Bojan prefers doing it over leaving it unverified: "risk it, it's ok, we can reload quickshell after."

**How to apply:** state what will be disrupted and for how long, have the recovery command ready (for Quickshell `DISPLAY=:0 dwm-quickshell-controlcenter action restart-quickshell`), make the restart unconditional at the end of the script, then re-verify the live state (process, bus name owner, `Configuration Loaded`). Afterwards delete everything the work created (scratch clones, temp files, hand-picked deploy scripts, backups from the work) after listing the targets first; leave older or system-owned items and say so. When he asks "did you really do X", answer from freshly re-checked state, not memory. Keep the dev repo as the single deploy source and let him run the sudo, commit and push steps himself.
