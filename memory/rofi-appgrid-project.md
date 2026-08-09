---
name: rofi-appgrid-project
description: Status/pointer for the rofi-appgrid theme project — a rofi theme for a personal drun-categories fork
metadata: 
  node_type: memory
  type: project
  originSessionId: 640e7924-3700-4c41-a794-559533277f4b
  modified: 2026-08-07T16:03:30.407Z
---

Building rofi themes (3 `.rasi` variants now) at `~/Projects/rofi-appgrid`
(git repo), styled as an AppGrid-like launcher: search bar, centered
category tabs via `mode-switcher`, icon grid (5×4). Built for a personal
**drun-categories fork of rofi** — categories are separate `Mode` structs
(`MODE_TYPE_SWITCHER`), not something stock rofi has.

Full up-to-date status, decisions, and TODOs live in the repo itself under
`memory/` (`STATUS.md`, `DECISIONS.md`, `TODO.md`, `SESSIONS.md`) — read
those for details instead of duplicating here; this entry is a pointer, kept
short on purpose.

As of 2026-08-07 (session 5, end of session): 3 variants exist —
`appgrid.rasi` (default, colors sampled from the real
plasma6-applet-appgrid screenshots), `appgrid-evergarden.rasi` (fall
palette from `everviolet/nvim`), `appgrid-everforest-medium-dark.rasi`
(palette from `sainnhe/everforest`) — all real sourced palettes, never
guessed from a name. All verified live by rendering with the actual fork
binary (`~/DATA/rofi/build/rofi`) and screenshotting. Nothing committed
yet (all staged). Open: typography has drifted between appgrid.rasi and
the two later variants and needs a conscious decision, not just more
drift; also a proper README screenshot (compositor running), light
variant, license, first commit.

**Why this matters:** the project spans multiple sessions, and the
drun-categories fork's category-as-Mode-struct mechanism is easy to
misremember as "just a custom widget" — worth getting right each time.
See the repo's `memory/DECISIONS.md` for the full reasoning.
