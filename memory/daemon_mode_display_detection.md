---
name: daemon_mode_display_detection
description: "packages that auto-detect graphical/display capability at load time get it wrong under emacs --daemon, since no frame exists yet when they load — check for an explicit \"server mode\" override before assuming a display-related bug is something else"
metadata: 
  node_type: memory
  type: project
  originSessionId: a3266242-e383-49f4-b52f-ee9bbd08f3a0
---

Under `emacs --daemon`, package init code runs before any frame exists
(frames only get created later, when `emacsclient -c` connects). Any
package that auto-detects "do I have graphics/icon/font support?" at
package-*load* time — rather than at frame-*creation* time — can silently
decide "no" even though a real GUI frame shows up moments later. This is
a distinct failure mode from actual runtime errors: no error, no warning,
just a feature quietly not working.

**Why**: hit this as the 4th distinct instance of a related-but-different
"ran too early in daemon mode" bug class in
`archboki-doom-emacs-project/emacs/` this session (the others: elpaca
async timing — see [[elpaca_async_gotcha]] — and the native-comp
warning-volume hang — see [[native_comp_warning_hang]]). This time:
`doom-modeline-icon` (controls whether the modeline shows icons at all)
defaults to `t`, but its own docstring explicitly warns "While using the
server mode in GUI, should set the value explicitly" — it auto-detects
icon/graphics support at load time and gets it wrong for daemon mode.
Fixed with `(doom-modeline-icon t)` forced explicitly in `modules/ui.el`.

**How to apply**: when something display/graphics/icon-related "just
doesn't work" in this config's daemon-based testing setup (see
`TESTING.md` for the `--init-directory` + named-daemon workflow), before
assuming it's a real config bug: (1) check the offending package's own
docstrings/README for daemon/server-mode caveats — many packages that
touch fonts, icons, or terminal-vs-GUI detection document this exact
gotcha explicitly, as `doom-modeline` did; (2) if undocumented, test
whether explicitly forcing the relevant "yes, graphics are available"
variable/option fixes it. This is a *different* root cause from actual
missing fonts (confirm via `fc-list` first) or from a genuine timing race
needing `elpaca-after-init-hook` — three distinct failure modes that can
all present as "some floating/icon/theme thing isn't showing right,"
worth telling apart before picking a fix.
