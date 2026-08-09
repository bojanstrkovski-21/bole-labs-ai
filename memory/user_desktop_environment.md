---
name: user-desktop-environment
description: "User's Linux desktop setup: Arch, X11, custom WM, no full DE, GTK theming toolchain"
metadata: 
  node_type: memory
  type: user
  originSessionId: 7c2f9ced-6117-47e1-9428-1c59460af66c
  modified: 2026-07-21T19:11:00.021Z
---

Runs Arch Linux, **X11** session (`$XDG_SESSION_TYPE=x11`), window manager is a personal dwm/suckless-style fork called **`chadwm-boki`** — no full desktop environment (no GNOME/KDE/XFCE session), consistent with other projects like `archboki-bash-improved` and general Linux-ricing hobbyist activity (~3.5 years per [[project-celestial-theme-builder]]).

**GTK theming toolchain**: uses **nwg-look** (a wlroots/Wayland-oriented GTK config tool, works fine on X11 too) as the sole theme-switcher. Previously also had `lxappearance` installed — **uninstalled it 2026-07-21** after we found both tools write overlapping-but-not-identical config files (`~/.gtkrc-2.0`, `gtk-3.0/settings.ini`) causing inconsistent/stuck-looking theme switches. Recommendation given: stick to nwg-look only, don't reintroduce a second GTK theme-switcher.

**Not installed**: `xsettingsd` (no XSETTINGS daemon running — GTK apps fall back to reading config files directly at startup, which is fine for this setup) and `colorreload-gtk-module` (GTK3 module that enables live CSS hot-reload without app restart — its absence means nwg-look's in-app theme preview doesn't refresh per-click, and GTK apps generally need a full restart, not just re-selecting a theme, to show a change). Both referenced in this user's `~/.gtkrc-2.0` as if present (leftover dotfile convention), neither actually installed as of 2026-07-21.

**How to apply/verify a GTK theme change on this system** (learned while debugging [[project-celestial-theme-builder]]'s generated theme): check these surfaces, they can disagree independently — `~/.gtkrc-2.0`, `~/.config/gtk-3.0/settings.ini`, `~/.config/gtk-4.0/settings.ini`, `~/.config/gtk-4.0/{gtk.css,gtk-dark.css,assets}` (symlinks to a theme's own gtk-4.0 folder — GTK4 doesn't use a theme-name setting at all), and `gsettings get org.gnome.desktop.interface gtk-theme`. Always close and reopen an app to see a change; already-running windows never hot-reload.
