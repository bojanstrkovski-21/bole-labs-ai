---
name: reference_bluetoothctl_hangs_without_service
description: "bluetoothctl blocks indefinitely (not a quick error) when bluetooth.service is inactive/absent -- its own --timeout flag doesn't help since that only bounds the scan itself, not the initial D-Bus handshake"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-09-26T20:53:25.544Z
---

Any `bluetoothctl` invocation (`show`, `devices`, `info`, `power`, `pair`,
`connect`, even `scan on --timeout N`) hangs forever, not fails fast, when
`bluetooth.service` isn't running or no Bluetooth adapter exists (e.g. a VM
with no Bluetooth hardware). Confirmed live: `timeout 5 bluetoothctl show`
produced zero output and had to be killed by the external timeout: 124.
`bluetoothctl --timeout N scan on` does **not** protect against this —
that flag only bounds the scan duration once connected, not the initial
D-Bus setup, so it hangs identically.

**How to apply:** any script driving `bluetoothctl` non-interactively
(status polling, a UI backend, a health check) needs its own external
`timeout` wrapper around every call site, not just the ones that already
look "long-running." Pick a short bound (~5s) for status/read calls and a
longer one for an intentional scan (bound > the scan's own `--timeout`,
e.g. `timeout 10 bluetoothctl --timeout 8 scan on`, so the outer guard
doesn't cut off a legitimately-running scan). Caught in dwm-quickshell:
every `bluetoothctl` call in `dwm-quickshell-controls` was unguarded,
leaking orphan processes and hanging the Bluetooth panel section
indefinitely on a VM with no Bluetooth hardware.
