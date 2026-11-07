---
name: reference_lightdm_slick_greeter_setup
description: "Arch login screen: switch to LightDM, slick-greeter background and session badge, AccountsService avatar, and how to diagnose login hangs"
metadata:
  type: reference
---

Login screen on Arch with slick-greeter / LightDM / AccountsService (from dwm-quickshell Session 28).

- **Switch display manager** (no install needed if `lightdm` + `lightdm-slick-greeter` are present): under `[Seat:*]` in `/etc/lightdm/lightdm.conf` set `greeter-session=lightdm-slick-greeter`, then `sudo systemctl disable sddm && sudo systemctl enable -f lightdm`, reboot (never `systemctl start lightdm` from inside the session). Rollback from a TTY: disable lightdm, `enable -f sddm`.
- **Config:** `/etc/lightdm/slick-greeter.conf`, `[Greeter]` section, e.g. `background=/usr/share/backgrounds/<file>.jpg`. The image must be world-readable and outside `~` (the greeter runs as the `lightdm` user).
- **Session-picker badge:** slick-greeter looks only in `/usr/share/slick-greeter/badges/<session-name>.png|svg` (session name = the `/usr/share/xsessions/*.desktop` filename); it ignores `Icon=` in the desktop file. `sudo install -m 644 <img> /usr/share/slick-greeter/badges/<session>.png`.
- **User avatar:** `~/.face` does not work if the home directory is not readable by `lightdm` (for example `o::---`). Use AccountsService: `sudo install -Dm 644 <img> /var/lib/AccountsService/icons/<user>` and set `Icon=/var/lib/AccountsService/icons/<user>` under `[User]` in `/var/lib/AccountsService/users/<user>` (root-only file: create or patch with sudo).
- **Diagnosing hangs:** `journalctl -b -1` needs `Storage=persistent`; if a `Storage=volatile` drop-in exists, override it with a later-sorting `zz-*.conf` for one test, then remove it. `/var/log/Xorg.0.log.old` timestamps (device removal to server terminated) are a cheap fallback clue.

The chadboki-qswm `make install` already installs the badge, avatar and greeter config from the repo (backing up differing live copies).
