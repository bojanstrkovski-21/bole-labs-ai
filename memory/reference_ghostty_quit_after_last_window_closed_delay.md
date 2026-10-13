---
name: reference-ghostty-quit-after-last-window-closed-delay
description: "Ghostty fully cold-exits the instant its last window closes unless quit-after-last-window-closed-delay is set, defeating --gtk-single-instance's warm-reuse benefit on repeat launches"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-12T19:27:20.875Z
---

Ghostty's `.desktop` file ships `Exec=/usr/bin/ghostty
--gtk-single-instance=true`, meant to let a new launch reuse an
already-warm process instantly instead of paying a full GTK4/
libadwaita cold-start every time. But `quit-after-last-window-closed`
defaults to `true` and `quit-after-last-window-closed-delay` defaults
to *unset* — meaning the process exits completely the instant its last
window closes, so in normal usage (open a terminal, close it, open
another a bit later) the single-instance flag almost never actually
gets the chance to help, since the process is nearly always already
dead by the next launch.

**How to apply**: set `quit-after-last-window-closed-delay = 5m` (or
similar; 1s minimum, Linux-only per `man ghostty`) in Ghostty's config
to keep the process resident for a grace period after the last window
closes. A launch within that window hits the fast warm-reuse path
instead of a cold start. Confirmed valid/loaded via `ghostty
+show-config` after setting it.
