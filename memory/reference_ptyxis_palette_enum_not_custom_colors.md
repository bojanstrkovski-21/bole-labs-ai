---
name: reference-ptyxis-palette-enum-not-custom-colors
description: "Ptyxis's GSettings palette key only selects a built-in named preset (confirmed via strings on the real binary, ~200 presets) — never arbitrary custom hex colors"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-11T21:25:02.858Z
---

GNOME/libadwaita Ptyxis stores its per-profile color scheme at
`org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/<uuid>/ palette`,
a plain string type. It looks settable to any value, but it's actually
constrained to one of Ptyxis's own ~200 built-in named presets
(confirmed live by running `strings /usr/bin/ptyxis | grep -E
'^\(uuay\)'` and finding real names like Everforest, Dracula, Nord,
Gruvbox, Solarized, the full Catppuccin/Monokai/Tokyo-Night families,
plus many Gogh-derived themes) — not a free-form custom-hex-color
mechanism at all. There is no separate schema exposing individual
background/foreground/ANSI-color keys the way kitty/alacritty/ghostty/
wezterm/xfce4-terminal all do.

**How to apply**: if a theming tool needs to push an arbitrary custom
palette to every installed terminal and reaches Ptyxis, don't attempt
a fuzzy name-match against its built-in presets as a substitute — it's
a confirmed platform limitation, not a solvable gap. Skip Ptyxis's
color theming explicitly (its font-setting via `gsettings set
org.gnome.Ptyxis font-name` is unaffected, that's a real settable
key) rather than guessing an approximate preset name.
