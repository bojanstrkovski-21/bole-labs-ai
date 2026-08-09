---
name: project-archboki-themes
description: "archboki-emacs-themes repo architecture, theme list, and current session state"
metadata: 
  node_type: memory
  type: project
  originSessionId: 00d4e5d4-4210-415c-ae00-f8b9baac1f08
---

`~/Projects/archboki-emacs-themes` is bojanstrkovski-21's personal
Emacs theme collection (GitHub: bojanstrkovski-21/archboki-emacs-themes),
ported from their `archboki_nvim` Neovim colorscheme. One shared face
engine (`archboki-themes.el`) turns a per-theme palette alist into
every face mapping; each `archboki-<name>-theme.el` file only supplies
colors. As of 2026-07-05 there are 16 themes: `archboki-dark`,
`archboki-light`, `archboki-light-2`, 6x `archboki-everforest-*`
(sainnhe/everforest port), 5x `archboki-evergarden-*`
(codeberg.org/evergarden/nvim port), and 2x `archboki-dracula-pro*`
(Caio Vellani's free "Dracula Pro Version" VS Code theme port, not
the paid Dracula Pro product).

The repo now has its own `memory/overview.md` and
`memory/session-log.md` (in-repo, versioned) plus `/start-session`
and `/end-session` custom commands (`.claude/commands/`) — read those
first for full context instead of re-deriving from scratch.

**Why this matters:** in-repo memory only helps if the repo is open;
this entry exists so a future session even without this repo in
context still recalls the project exists, its shape, and that
detailed history lives in `memory/session-log.md`.

**How to apply:** if asked to add/modify a theme, check
`memory/overview.md`'s "Gotchas" section first — several
non-obvious Emacs face-priority behaviors were discovered the hard
way this session. See [[feedback-credit-palette-sources]].

As of 2026-07-05: all of that session's changes (engine fixes,
`archboki-theme.el`→`archboki-dark-theme.el` rename,
`archboki-light-theme-2.el`→`archboki-light-2-theme.el` rename, 13
new theme ports) are **uncommitted** in the local working tree —
nothing committed or pushed. This will go stale; check `git log`/
`git status` before trusting it.
