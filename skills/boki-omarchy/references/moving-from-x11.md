# Planning a move from dwm/X11 to Omarchy (Hyprland/Wayland)

A planning checklist, not a procedure. Omarchy facts are v4.5.0 and from the
guides we read (omacom/omarchy, MIT). Statements marked **(verify)** are general
knowledge and must be checked on the target machine. Nothing here has been run.

## What Omarchy gives you

- Omarchy ships its own Quickshell shell as one managed process: bar,
  notifications, menus, panels, OSD, driven by `~/.config/omarchy/shell.json`.
  Panels, widgets, and overlays are plugins with a `manifest.json` (`schemaVersion`,
  `id`, `name`, `version`, `kinds`, `entryPoints`) whose entry points are `Item`s;
  panels expose `open(payloadJson)` and `close()`.
- Hyprland is configured in Lua; themes come from `colors.toml` plus templates;
  hooks, a single `omarchy` CLI, and package helpers are built in.
- It follows a disposable-VM acceptance test model for UI changes.

## What probably carries over from dwm-quickshell

- QML component design and models (panels, dock, control center), once adapted to
  Omarchy's plugin contract and its `Style`/`Color` singletons and motion tokens.
- Theme work: your theme generator could emit `colors.toml` so Omarchy renders the
  app files; keep your palette credit and licence checks.
- The Omarchy dock plugin clone already tracked as reference in the
  `whatifs/bole-labs.dock/` folder of the dwm-quickshell project.
- Your project rules about deploy-and-verify, `Configuration Loaded`, and
  single-instance shells apply unchanged in spirit (Omarchy has the same rule).

## What likely does not carry over (verify each)

| dwm/X11 piece | Why it needs rethinking |
| --- | --- |
| dwm.c patches, `config.h`, the EWMH state bridge, the `altbarclass` strut patch | Hyprland replaces dwm; bar space comes from the compositor's layer-shell support, not window-class tricks **(verify)** |
| `xdotool`, `xprop`, `xwd`/`import`, `xrandr`, `picom` | X11 tools do not drive native Wayland windows. Omarchy's guides use `hyprctl`, `wtype`, `omarchy capture`, and `monitors.lua` instead **(verify)** |
| Xvfb-based tests and `xrandr --setmonitor` fake monitors | Different harness; Omarchy runs graphical acceptance tests in a disposable VM |
| Struts, input masks, `_NET_WM_WINDOW_TYPE` handling for the dock | X11 window-manager behaviours; re-test against layer-shell surfaces **(verify)** |
| `hotkeys.conf` and `dwm-hotkeyd` | Replaced by Hyprland bindings in `bindings.lua` (`o.bind`, `o.rebind`) |
| LightDM / X session scripts | Different login and session setup on Omarchy |
| Your one-time `~/.config/chadboki-qswm` deploy rules | Replace with Omarchy's overlay and `omarchy refresh` model (never edit `/usr/share/omarchy`) |

Memory notes that are X11-specific and need a re-check before reuse: the
`reference_x11_*`, `reference_xdotool_*`, `reference_xprop_*`,
`reference_picom_*`, `reference_dwm_*`, and `reference_lightdm_*` files in
`~/.agents/memory/`.

## Suggested order of work

1. Try Omarchy in a VM first; record the exact version (`omarchy version`) and read
   the installed official `omarchy` skill and `docs/` there.
2. Inventory your shell: list each panel, widget, script, and the X11 assumption
   behind it.
3. Port one self-contained piece (the dock is the natural first test) as an
   Omarchy plugin, with its own manifest, `Style.duration` motion, and lazy panel
   content.
4. Move theming to `colors.toml` and templates before porting more UI.
5. Re-run `$find-skills` for current Hyprland, Omarchy-plugin, and Qt/QML guidance
   (the Hyprland wiki changes quickly), and study Omarchy's own shell source with
   `$boki-code-scout` once that skill is tested.
6. Keep dwm-quickshell as the X11 reference until the Omarchy version is stable.
