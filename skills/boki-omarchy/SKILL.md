---
name: boki-omarchy
description: Omarchy-specific knowledge for Hyprland/Wayland on Arch: customizing an Omarchy install (Hyprland Lua config, keybindings, themes, hooks, capture), contributing to Omarchy, and planning a move from dwm/X11. Use when a task names Omarchy, omarchy-* commands, ~/.config/omarchy, or Hyprland config.
---

# Boki Omarchy

Notes on Omarchy (https://omarchy.org, repository `omacom/omarchy`), pinned to
**v4.5.0**. Adapted in our own words from Omarchy's agent guides (MIT; credit in
this repository's README). Omarchy changes quickly, so this skill is a map and a
snapshot, not the authority.

Omarchy installs its own official skill (named `omarchy`) and version-matched
guides on an Omarchy system. Use those first when they exist; this skill adds
our safety rules, the development conventions, and migration planning.

## Pick the situation

1. **On an Omarchy system** (`omarchy version` works, `/usr/share/omarchy`
   exists): read the installed official skill and the guide for the area you are
   touching, then use `references/customization.md` as a checklist. Facts here
   are v4.5.0 and may differ from the installed version; the installed docs win.
2. **Not on Omarchy yet** (for example still on dwm/X11): do not run `omarchy`
   commands or assume paths exist. Use the references to plan, label every fact
   "v4.5.0, unverified on this machine", and read `references/moving-from-x11.md`
   for the migration.
3. **Contributing to or developing Omarchy itself**: follow the repository's own
   `AGENTS.md` first, then `references/development.md`.

## Safety rules

- Never edit `/usr/share/omarchy/` (package-owned; overwritten on update).
  Reading it is safe and encouraged. Customize in `~/.config/`, custom themes in
  `~/.config/omarchy/themes/<name>/`, automation in `~/.config/omarchy/hooks/`.
- Back up a config file before changing it. `omarchy refresh <app>` resets to
  defaults (it backs up first) but needs the user's confirmation before running.
- Prefer stock `omarchy <group> <action>` commands over hand edits; discover them
  with `omarchy commands` or `omarchy <group> --help`, and read a command's
  source (`cat $(which omarchy-<name>)`) before relying on it.
- Run `omarchy debug --no-sudo --print`, never plain `omarchy debug` (the
  interactive sudo prompt hangs a non-interactive shell).
- Privilege: use `sudo` where a terminal can ask for a password; use `pkexec`
  only when the caller has no terminal (an agent or background process). Do not
  swap `sudo` for `pkexec` just because a command changes system state.
- Hyprland window-rule syntax changes between versions. Fetch the current
  Hyprland wiki page before writing any window rule; do not write it from memory.
- After any Hyprland Lua change, run `hyprctl reload` then `hyprctl configerrors`
  and fix errors until clean.
- When rebinding a key, list current bindings first (`omarchy menu keybindings
  --print`), use the rebind helper, and tell the user what the key did before.
- Our global rules still apply: confirm-first, no git or push without being
  asked, no credential or auth commands.

## Resources

- `references/customization.md`: config locations, Hyprland files, bindings,
  monitors, themes, hooks, screenshots and recordings, decision framework.
- `references/development.md`: reporting bugs and PRs, command metadata, tool
  declarations, install scripts, migrations, helper commands.
- `references/moving-from-x11.md`: planning a move from dwm/X11 to Omarchy.

## Validation

- Every command or path used was either checked on the machine or labelled as
  unverified v4.5.0 information.
- Nothing under `/usr/share/omarchy/` was edited; config changes were backed up
  and, for Hyprland, validated with `hyprctl configerrors`.
