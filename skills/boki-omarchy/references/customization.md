# Customizing an Omarchy install (v4.5.0)

Adapted in our own words from Omarchy's `default/agents/skills/omarchy/` guides
(omacom/omarchy v4.5.0, MIT). Verify against the installed version.

## Decision framework

1. A stock command exists: use it (`omarchy commands`, `omarchy <group> --help`).
2. A config edit: edit under `~/.config/`, never `/usr/share/omarchy/`.
3. A theme change: create or overlay a theme directory (see Themes).
4. Automation on a system event: install a hook (see Hooks).
5. A package: `omarchy pkg add <pkgs...>` (`omarchy pkg aur add` for AUR-only).
6. Built-in shell or plugin code: clone it with `omarchy plugin clone`, edit the
   clone, never the packaged copy.

## Locations

| Area | Where |
| --- | --- |
| Hyprland (Lua) | `~/.config/hypr/` |
| Shell: bar, notifications, plugins, idle | `~/.config/omarchy/shell.json` (hot-reloads on save) |
| User shell plugins | `~/.config/omarchy/plugins/<id>/` |
| Menu and launcher extensions | `~/.config/omarchy/extensions/omarchy-menu.jsonc` (hot-reloads) |
| Themes | `~/.config/omarchy/themes/<name>/`; stock themes under `/usr/share/omarchy/themes/` |
| Hooks | `~/.config/omarchy/hooks/<event>.d/` |
| Terminals | `~/.config/{alacritty,foot,kitty,ghostty}/`; apply with `omarchy restart terminal` |

Defaults live in `$OMARCHY_PATH` (`/usr/share/omarchy`): read them to see what
you are overriding.

## Hyprland files

`hyprland.lua` loads Omarchy defaults, then your files: `bindings.lua`,
`monitors.lua`, `input.lua`, `looknfeel.lua` (gaps, borders, animations),
`autostart.lua`. `hyprsunset.conf` (night light) and `xdph.conf` (screen-share
portal) are read by separate processes, so `hyprctl` neither applies nor
validates them: restart with `omarchy restart hyprsunset`; the portal config
applies when the portal restarts (next login).

- Validate every Lua change: `hyprctl reload`, then `hyprctl configerrors`.
- Reset to defaults (confirm with the user first): `omarchy refresh hyprland`.
- Keybindings: `o.bind("SUPER + B", "Browser", { launch = "chromium" })`. Prefer
  `{ menu = "theme" }` and `{ panel = "omarchy.network" }` over running the menu
  or shell commands by hand. Replace an existing binding with `o.rebind(...)`;
  remove one with `hl.unbind(...)`.
- Monitors: `hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })`;
  list with `hyprctl monitors all`.
- Window rules: use Omarchy's `o.window(match, rules)` helper (examples in
  `$OMARCHY_PATH/default/hypr/windows.lua`) and fetch the current Hyprland wiki
  for syntax first.

## Themes

- `omarchy theme list | current | set <name> | install <url> | bg next`.
- A theme normally starts from `colors.toml`; Omarchy renders app files from
  `default/themed/*.tpl`. An existing file is never overwritten by a template, so
  a hand-written theme file wins.
- Make a new theme in `~/.config/omarchy/themes/<name>/` (copy a stock one as a
  model, add `backgrounds/`). Customize a stock theme with an **overlay**: a user
  directory with the same slug holding only the files you change.
- Override how an app is themed for every theme by writing a template at
  `~/.config/omarchy/themed/<config-name>.tpl`.
- A theme installed from git drops anything that can run code (`*.lua`, terminal
  configs, `vscode.json`) and symlinks; those are regenerated from templates.

## Hooks

`omarchy hook install <event> <script>` copies a script into
`~/.config/omarchy/hooks/<event>.d/`. Events include `theme-set` (theme slug in
`$1`), `font-set`, `post-boot`, `post-update`, `battery-low` (percentage in
`$1`), `pre-refresh-pacman`. Update hooks run as your user inside the update's
sudo authorization.

## Capture and sharing

- `omarchy screenshot` (interactive); `omarchy capture screenshot
  region|windows|fullscreen|scroll`; `... fullscreen save` writes straight to
  disk without opening the editor.
- `omarchy screenrecord --fullscreen`, then `omarchy screenrecord
  --stop-recording` (prints the saved path). If it fails to start, set
  `OMARCHY_SCREENRECORD_DEBUG=true` and read the log in `$XDG_RUNTIME_DIR`.
- `omarchy capture text` (OCR a region to the clipboard); `omarchy share
  file|folder|clipboard`; `omarchy transcode <input> [format] [resolution]`.

## Other commands worth knowing

`omarchy update`, `omarchy version`, `omarchy toggle nightlight`, `omarchy
restart shell`, `omarchy refresh shell`, `omarchy bar move <widget> --section
right`, `omarchy reminder <minutes> "<message>"`.
