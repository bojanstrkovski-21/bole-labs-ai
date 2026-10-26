---
name: reference_xdg_current_desktop_hardcode_overrides_session_name
description: "fastfetch shows the wrong WM name when ~/.xprofile or environment.d hard-sets XDG_CURRENT_DESKTOP; make ~/.xprofile pick it from DESKTOP_SESSION"
metadata:
  type: reference
---

fastfetch's WM line on X11 falls back to `XDG_CURRENT_DESKTOP` when the window
manager publishes no `_NET_WM_NAME`. A hard-coded `export XDG_CURRENT_DESKTOP=...`
in `~/.xprofile` (sourced by `/etc/lightdm/Xsession`) or in
`~/.config/environment.d/*.conf` overrides the session file's `DesktopNames=`,
so a renamed session keeps showing the old name (dwm-quickshell: `chadwm-boki`
instead of `chadboki-qswm`, 2026-10-26).

Fix: in `~/.xprofile` use `case "$DESKTOP_SESSION" in a | b) export
XDG_CURRENT_DESKTOP=$DESKTOP_SESSION ;; esac` (LightDM exports DESKTOP_SESSION;
other sessions keep their own value) and drop the line from `environment.d`,
which cannot choose per session. Takes effect after the next login.
