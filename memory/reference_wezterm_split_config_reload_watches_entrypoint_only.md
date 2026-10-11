---
name: reference-wezterm-split-config-reload-watches-entrypoint-only
description: "wezterm configs split across wezterm.lua + a require()'d config.lua — automatically_reload_config only watches the directly-loaded file, never one reached only via require()"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-11T21:24:51.994Z
---

A wezterm setup can split its config across two files: `wezterm.lua`
(the real entrypoint wezterm actually loads) doing
`local config = require("config")` to pull in a secondary `config.lua`
module. `automatically_reload_config = true` only makes an
already-open window watch the file wezterm *directly* loaded
(`wezterm.lua`) — editing `config.lua` alone, even with content
confirmed correct, never triggers a live reload at all, because the
watcher never knew `config.lua` was a dependency.

Confirmed live (dwm-quickshell project, 2026-10-11): a script correctly
wrote new colors into `config.lua` every time, but an already-open
wezterm window and even a fresh relaunch both kept showing stale
colors. Root cause had two parts: (1) `wezterm.lua` also had its own
hardcoded theme override that unconditionally clobbered
`config.colors`/`config.color_scheme` after the `require("config")`
call, regardless of what `config.lua` set — found by just reading
`wezterm.lua` directly; (2) even after removing that override, nothing
changed on an already-open window until `wezterm.lua`'s own mtime was
bumped (content untouched), which forced the watcher to fire and
re-run the whole `require()` chain fresh.

**How to apply**: when a wezterm color/font script edits `config.lua`
(or any file reached only via `require()`) and live-reload isn't
taking effect, check whether a separate `wezterm.lua` entrypoint exists
and loads it that way. If so, also touch `wezterm.lua`'s mtime after
writing the real file — a plain `touch`, no content change needed.
Also check `wezterm.lua` itself for any hardcoded override that might
run after the `require()` and silently win.
