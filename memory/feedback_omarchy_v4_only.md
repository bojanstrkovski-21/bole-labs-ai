---
name: feedback_omarchy_v4_only
description: "When researching basecamp/omarchy for portable ideas, only look at Omarchy 4 (\"Quattro\") and newer — ignore v3 and earlier"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-09-13T18:54:26.109Z
---

When investigating basecamp/omarchy (omacom/omarchy) for ideas to port into
[[project_dwm-quickshell]]/chadboki-qswm, only consider **Omarchy 4
("Quattro", v4.0.0, tagged 2026-08-14) and later** — never v3 or earlier.

**Why:** Omarchy 4 rewrote the entire desktop shell in Quickshell (bar,
launcher, menus, notifications, OSDs, control panels, lock screen, polkit
agent all now live in one Quickshell process with a plugin architecture),
replacing waybar/walker/mako/hyprlock/hypridle/swaybg/polkit-gnome. Pre-v4
Omarchy used waybar (a completely different Wayland-native status-bar
technology, config-file-driven, SIGUSR1-toggle-based) and other now-retired
tools — none of that maps onto chadboki-qswm's Quickshell+X11 architecture
the way v4's actual Quickshell QML does. A v3-era comparison (e.g. searching
"omarchy toggle bar" and landing on a waybar keybind) gives a wrong-
technology answer that looks superficially similar but isn't portable.

**How to apply:** When searching/fetching Omarchy source, docs, or DeepWiki
pages, check the branch/tag/date first (`quattro` branch, v4.x releases) and
disregard anything describing waybar, hyprlock, mako, walker, or swaybg —
those are pre-v4 and retired. Prefer their `quattro` branch source directly
over general web search results, which often surface older v3 docs first.
