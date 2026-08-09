---
name: project-archknife-changes-session1
description: All changes made to archknife in the first working session (2026-06-14)
metadata: 
  node_type: memory
  type: project
  originSessionId: e1c68563-531d-4bc3-bb2c-af7415b80308
---

## Chaotic-AUR chroot setup (installer.py)
`_setup_chaotic_aur_chroot()` rewritten to follow the official procedure inside the chroot: recv-key, lsign-key, `pacman -U` from CDN URLs for keyring and mirrorlist, then conditional append of `[chaotic-aur]` to pacman.conf only if not already present.

**Why:** `chaotic-mirrorlist` file was not persisting on installed system — the old function only ran `pacman-key --populate chaotic` and relied on pacstrap downloading the package, which failed silently when CDN was unreliable.

## Repos UI screen (screens.py)
Fixed three bugs in `repos()`:
1. Removed destructive reset loop that set all non-multilib attrs to False on every redraw
2. Added focus preservation in `_toggle_repo` (same pattern as desktop chooser)
3. Removed dead options (`enable_multilib_testing`, `enable_core_testing`, `enable_extra_testing`) — not in Config, not wired in installer
4. Multilib shown as read-only always-enabled row (it's unconditionally enabled in `_write_pacman_conf_chroot`)
5. Space key added to `Selectable.keypress` alongside Enter

## Extra repos defaults (config.py)
All three extra repos now default to True: `enable_chaotic=True`, `enable_nemesis=True`, `enable_boki=True`.

## Timezone screen (screens.py + utils.py)
- `detect_timezone()` now tries three services in order: KDE GeoIP (`geoip.kde.org/v1/calamares`, JSON), `ipapi.co/timezone`, `ip-api.com/line/?fields=timezone`
- Timezone screen: search field pre-filled with detected timezone, uses `SubmitEdit` so Enter on the field confirms directly
- Region browser moved below the search field/results box
- Results box shared between search and region browser
- Label updated to say "— edit or press Enter to confirm" when detected

## Package list cleanup (installer.py)
- `nemo-file-roller` → `nemo-fileroller`, `nemo-preview` removed from cinnamon
- `iso-flag-png` and `mintlocale` removed from cinnamon (Mint-isms, not needed on Arch)
- Full PipeWire stack in BASE_PACKAGES: pipewire, pipewire-audio, pipewire-alsa, pipewire-pulse, pipewire-jack, pipewire-zeroconf, pipewire-docs, wireplumber + full ALSA + pavucontrol, volumeicon, playerctl
- Full multimedia codec set added to BASE_PACKAGES: gstreamer stack, ffmpeg, x264/x265, etc. (`gstreamer-vaapi` dropped — no longer in Arch repos)
- New packages in BASE_PACKAGES: ripgrep-all, expac, inetutils, inxi, lsb-release, cmake, cmake-extras, extra-cmake-modules, devtools, intltool, xdg-desktop-portal, xdg-desktop-portal-gtk, xdg-user-dirs, xdg-user-dirs-gtk, yad, zenity, archlinux-appstream-data, archlinux-wallpaper
- `sublime-text-4` added to the chaotic-aur conditional block in `install_base()`
- `accountsservice` and `dbus` still in BASE_PACKAGES (user kept them)
- `nfs-utils` added to XDG/portals section by user

## Mount race condition fix (installer.py)
Added `udevadm settle` in `partition_disk()` after `os.makedirs(MNT)` and before any mount calls. Fixes "Can't find ext4 filesystem / SQUASHFS superblock" error on mount after formatting.

**Why:** Race condition between mkfs completing and udev registering the new filesystem — kernel hadn't finished processing device events before mount was attempted.

## OS branding (airootfs/etc/os-release)
Created `airootfs/etc/os-release` with `PRETTY_NAME="Arch-Boki Archknife Linux Live ISO"`. Systemd reads this during boot and prints `Welcome to <PRETTY_NAME>!`. `NAME` kept as `Arch Linux` for tool compatibility.

## Packages known to need non-default repos
- `rofi-categories`, `arch-boki-rofi-git` — boki repos only (awesome WM list)
- `sublime-text-4` — chaotic-aur only (chaotic block in install_base)
- `thunar-shares-plugin`, `xfce4-docklike-plugin` — also in extra (fine)
