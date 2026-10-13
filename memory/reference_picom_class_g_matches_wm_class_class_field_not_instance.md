---
name: reference-picom-class-g-matches-wm-class-class-field-not-instance
description: "picom's class_g condition matches WM_CLASS's CLASS field (2nd string), not the instance field some window managers' own rules may match against instead"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-12T19:27:12.308Z
---

`WM_CLASS` is two strings: instance (resource name) then class
(resource class). Some window managers (dwm among them) match their own
per-app rules against the instance field, or against whichever field
happens to contain the simpler name — so a rule using a short name like
`"ghostty"` can work fine at the WM level while picom's own `class_g`
condition, which only ever checks the CLASS field, silently never
matches the same window at all if its real class string is something
longer/different (e.g. Ghostty's real `WM_CLASS` is `"ghostty",
"com.mitchellh.ghostty"` — the WM-level short name is the instance,
not the class).

Confirmed live (dwm-quickshell project, 2026-10-12): a terminal's own
`background-opacity` config was correctly set and loaded, but rendered
fully opaque regardless. Root cause: every other terminal that *did*
show real transparency relied on an explicit picom `opacity=` rule
keyed on `class_g`, not on the app's own internal alpha blending alone
— and no rule had ever been added for this one, since a naive rule
using the app's short/common name would have silently never matched.

**How to apply**: when adding a picom (or any X11 tool using WM_CLASS
condition matching) rule for an app, verify the real class string
directly via `xprop WM_CLASS` on a live window of that app — never
assume the short/common app name is the class field just because
another tool (a WM's own app rules, a taskbar, etc.) matches on it
successfully. Also: `_NET_WM_CM_S0`-style compositor-registration
checks are X *selections*, not window properties — `xprop -root
<name>` always reports "not found" for these regardless of real
ownership; query selection ownership directly (e.g. via Xlib's
`get_selection_owner`) instead.
