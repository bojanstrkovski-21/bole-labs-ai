---
name: reference_hover_handler_privileged_action
description: "A passive hover/preview handler that triggers a privileged or authenticated action (e.g. a forced network rescan) can silently pop a system auth dialog from mere navigation, not an explicit click"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-09-24T21:22:27.404Z
---

Found in dwm-quickshell (2026-09-24): a Control Center hover-preview
handler called `networkModel.refresh(true)` — `true` meaning "force an
active Wi-Fi rescan" — purely from the user's keyboard/mouse cursor
passing over the "Network" row while browsing an unrelated menu. On a
system where NetworkManager's wifi-rescan action is polkit-gated, this
silently triggered the real system polkit authentication agent ("System
policy prevents Wi-Fi scans") from nothing more than passive navigation.
The auth dialog also didn't auto-dismiss, so it lingered behind whatever
the user navigated to next — reported as "why does a wifi auth popup show
up when I change an unrelated setting," since the two events (hovering
Network, then later noticing the stuck dialog) were separated in time
and looked unrelated.

**Why:** hover/preview code paths are easy to treat as "just refreshing
the UI," but if the underlying call can request elevated privileges (a
forced rescan, a `sudo`/`pkexec` action, anything polkit/PAM-gated), it
crosses from passive display into an authenticated action — the same
class of side effect a click handler would need explicit justification
for, but without the user's deliberate intent behind it.

**How to apply:** when reviewing or writing a hover/preview handler
(ghost-preview panels, embedded content-on-hover, live status polling
that expands scope on focus), grep for what the underlying model/backend
call actually does before assuming "refresh" is free — a `rescan: true`,
`force: true`, or similar flag is the tell. Keep hover/preview refreshes
to "show current known state" (no forced/privileged action); reserve any
actual forced rescan or elevated action for an explicit click/keypress
the user chose (a visible "Scan" button, an Enter on a specific cursor
position) — never something the mere act of Down-arrowing or mousing
across a menu can trigger.
