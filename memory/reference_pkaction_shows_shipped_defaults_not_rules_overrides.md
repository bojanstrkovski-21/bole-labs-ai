---
name: reference_pkaction_shows_shipped_defaults_not_rules_overrides
description: "pkaction --verbose only shows a polkit action's shipped .policy defaults (e.g. \"implicit active: yes\") -- it can't see a local .rules.d/ script override that tightens the real, live-enforced policy"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-09-26T18:30:22.317Z
---

`pkaction --action-id <id> --verbose` prints the *compiled-in* `.policy`
file's declared `implicit any/inactive/active` values -- the vendor
default. It does not evaluate `/etc/polkit-1/rules.d/*.rules` (JavaScript
policy scripts), which can override that default per-machine. If
`/etc/polkit-1/rules.d/` is unreadable to the current user ("Permission
denied" on `ls`), that's itself a signal a local override may exist and
can't be inspected -- don't trust `pkaction`'s "implicit active: yes" as
proof an action will actually run without a password prompt for the real
active session.

**How to apply:** when an action reportedly requires no auth per
`pkaction` but a real invocation still fails with "Not authorized" (or
silently triggers a polkit agent dialog) even from a genuinely active local
session (confirmed via `loginctl show-session <id> -p Active -p Type`),
trust the empirical result, not the static policy listing. Caught on
[[project_dwm_quickshell_wifi_radio_manual_only]]'s test VM: both
`org.freedesktop.NetworkManager.wifi.scan` and
`org.freedesktop.NetworkManager.enable-disable-wifi` report
`implicit active: yes`, but both actually require a password on that
machine -- a deliberate lab-VM restriction, not the real Arch/
NetworkManager default.
