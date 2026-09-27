---
name: project_dwm_quickshell_wifi_radio_manual_only
description: "dwm-quickshell's Wi-Fi radio toggle is manual-switch-only, not auto-managed -- full auto (off unless no Ethernet) was built and reverted 2026-09-26 after the test VM's polkit policy proved every radio on/off needs an admin password"
metadata:
  node_type: memory
  type: project
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-09-26T18:30:33.803Z
---

In `dwm-quickshell` (`chadboki-qswm/quickshell-configs/network/`), the
Wi-Fi radio on/off switch is deliberately manual-only: `setWifiRadio()` is
called from exactly one place, the `PanelToggleSwitch` in
`network/NetworkContent.qml`. Nothing auto-toggles the radio.

**Why:** the user's original ask was "Wi-Fi off all times, unless I turn it
on or there's no Ethernet." That automatic version was fully built
(`ethernetPresent` + edge-triggered `maybeEvaluateWifiAutoManage()` in
`NetworkModel.qml`, driven by the model's existing always-on `nmcli
monitor` watcher) and confirmed logically correct via live `console.log`
tracing on the test VM (`archboki-vm`) -- but the actual `nmcli radio wifi
off/on` call failed there with "Not authorized to perform this operation"
even from the real active X11 session, despite `pkaction` claiming
`implicit active: yes` (see
[[reference_pkaction_shows_shipped_defaults_not_rules_overrides]]). An
unattended background toggle on that machine would mean a silent failure
or an unanswered polkit password dialog on every cable plug/unplug, so the
feature was reverted to manual-only per explicit user decision.

**How to apply:** full write-up, the exact code shape that was reverted,
and the steps to resurrect it (test the raw `nmcli radio wifi` command
directly on whichever machine you're targeting first) are in
`quickshell-scripts/whatifs/wifi-radio-auto-management.md` in the repo
root's `quickshell-scripts/` (not `chadboki-qswm/quickshell-scripts/` --
this project has two `whatifs/` folders; this doc lives in the repo-root
one, alongside the `control-center-old/` retirement folder from the same
session). This VM restriction looked like a deliberate lab lockdown (same
category as its separate "System policy prevents Wi-Fi scans" block, also
already known) -- worth re-testing on the real daily-driver laptop, which
may not have the same restriction.
