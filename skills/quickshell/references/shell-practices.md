# Shell development practices

Adapted in our own words from Omarchy's `agents/skills/shell-dev.md` and
`visual-verification.md` (omacom/omarchy v4.5.0, MIT). They describe a Wayland
shell; where a project targets X11 or another window manager, keep the
principle and replace the commands.

## One shell instance

A desktop shell runs as one long-lived process. Do not start extra standalone
instances for individual components or repo-local test paths: IPC targets the
managed instance, and the launcher may respawn the original. Restart the managed
shell after QML edits using the project's own restart command.

## Keep state current without polling

A widget is built once per monitor, so a `Timer` that starts a `Process` costs
that process times the monitor count on every tick, forever. Pick the first
option that fits:

1. A native Quickshell service that signals on change (UPower, PowerProfiles,
   Pipewire, Mpris, SystemTray, Notifications, the compositor's workspace data).
2. An event stream the shell already runs. Extend it instead of starting a
   second one.
3. A file watch (`FileView` with `watchChanges`) when the state lives in a file.
4. A push from the command that changes the state (the command pokes the shell
   over IPC after the change). For a change that happens later without a command
   running (an expiry), schedule the refresh with a transient user timer.
5. Polling, last resort, for state with no change signal. Gate the timer on the
   panel being open, use the longest tolerable interval, and put the poll in one
   shared service rather than a per-monitor widget. Never poll a privileged
   probe: each `sudo -n` can write to the auth log.

## Panels

- Build a panel's content on first open, not at startup on every monitor. Keep
  anything that must run while the panel is closed (timers, data, IPC) outside
  the lazily built content.
- Panel, overlay, and menu plugins need open and close lifecycle methods so IPC
  can summon and hide them.

## Palette singleton name

Reported in Omarchy's guide, not verified by us: Qt 6.12 adds a `Color` type to
`QtQuick` that can shadow an unqualified palette singleton named `Color`. If a
project's palette singleton is called `Color`, import it qualified
(`import qs.Commons as Commons`, then `Commons.Color`). Check the installed Qt
version before changing code.

## Untrusted text in QML

Adapted from Omarchy's plugin guide (omacom/omarchy v4.5.0, MIT). A shell runs
unsandboxed and long-lived, so treat text from network responses, files, IPC,
settings, environment variables, and command output as untrusted.

- QML `Text` defaults to `Text.AutoText`, so markup-shaped input such as
  `<img src="https://example.invalid/tracker">` can be interpreted as rich text
  and fetch a resource. For text the plugin owns, set `textFormat: Text.PlainText`.
- When passing dynamic text to a component whose internal `Text` format you
  cannot set (tooltips, notifications), neutralize markup in your own code first
  and add a regression test with markup-shaped input.
- Bound and validate downloaded data before showing or saving it: response and
  collection sizes, string lengths, identifiers, timestamps.
- Keep network access explicit: fixed HTTPS sources, timeouts, size limits, and
  validation. Disclose periodic background refreshes and let the user turn them
  off. Never execute downloaded content.

## Glyphs

Icon fonts put private-use codepoints in QML as raw characters, and editing
tools can strip them. Do not rewrite such files wholesale. Make a targeted edit
with context, or insert the character from its codepoint with a script
(`chr(0xXXXX)`), then re-read the file bytes to confirm.

## Verifying visual changes

- Capture a screenshot of the reference state and the candidate state as
  separate images and compare them, for layout and layer-surface changes.
- Record a short video for animations, transitions, and capture flows, and keep
  it focused on the changed behavior.
- Read motion frame by frame: find the moment with a coarse sheet
  (`ffmpeg ... -vf "fps=6,scale=...,tile=..."`), then tile every frame of that
  moment at the recording's full rate and check where it starts, whether
  anything doubles or blanks, and where it settles.
- Drive the UI without the mouse: the panel's own IPC target takes the same path
  as a click; simulated key input (for example `wtype`) exercises keyboard flow.
- From outside the session (an agent shell or SSH) the compositor environment
  variables are not inherited. Import them from the running session first, or
  capture tools exit silently with nothing saved.
- Before deploying part of a config, diff the whole config against the live one: a file can depend
  on newer siblings (a missing property fails the whole reload, and the old config silently keeps
  running until the next restart). Read the log by instance (`quickshell log -i <id>`) or `--pid`,
  since the plain form matches the display string literally.
- Take over the live desktop only after telling whoever is using it, and always
  restore their shell afterwards (a `trap` on exit does it even if a step fails).
