---
name: reference-forked-child-env-export-never-reaches-parent
description: "A script forked AS A CHILD of a long-running process (e.g. a WM's own autostart hook) can never propagate an exported env var back to that parent — fix at the pre-exec wrapper, not the child"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-11T21:25:19.579Z
---

If process P forks/execs a script S (S is P's child), anything S
`export`s only ever reaches S's own descendants — it can never
propagate back up into P's own environment, regardless of login-shell
timing or how early S runs after P starts. This is basic process
semantics (child environments are copies, writes don't flow upward),
but easy to miss when S is something like a WM's own "autostart.sh"
hook that *feels* like it runs "at session start" and should therefore
be able to configure the session.

Confirmed live (dwm-quickshell project, 2026-10-11): a window manager's
`autostart.sh` (forked as the WM's own child via a `runautostart()`-
style C call) sourced a conf file and exported `DWM_TERMINAL=kitty`,
written there by a settings UI specifically so the WM's own compiled
keybind (`spawn(SHCMD("dwm-terminal"))`, forked directly from the WM
itself) would pick it up. It never did — `/proc/<wm-pid>/environ`
confirmed the var was simply absent from the WM's own process, no
matter how early autostart.sh ran relative to login.

**How to apply**: when a long-running process P execs its real binary
via some wrapper/session script (a `.desktop` `Exec=` target, a login
shell profile, a `chadboki-qswm-session`-style pre-exec wrapper), any
env var that needs to be visible to everything P itself later spawns
has to be set in that pre-exec step, before P execs — never in a script
P itself later forks as a child. If the env var's value can change
*during* the session too (not just at login), prefer having the
actually-spawned command read the source-of-truth file directly at
invocation time instead of trusting any inherited env var at all —
this also sidesteps a second problem the pre-exec fix alone doesn't
solve: a later in-session change to the conf file can never
retroactively update an already-running process's environment either
way. See also [[reference_wezterm_split_config_reload_watches_entrypoint_only]]
for a related but distinct "edit isn't being watched/applied" failure
mode, and reference_lightdm_xsession_login_shell_env_scoping.md for a
different mechanism (login-shell source timing, not child-vs-ancestor
process topology) that looks similar on the surface.
