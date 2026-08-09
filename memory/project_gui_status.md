---
name: project-gui-status
description: "Current development state of the arch-boki-post-install GUI tool — what's done, what's pending"
metadata: 
  node_type: memory
  type: project
  originSessionId: c8fe6678-7b2d-41fb-bce5-c45821d8bb7e
---

The main GUI is in `python-gui/arch-boki-post-install-gui.py` (Dear PyGui, Everforest theme). A companion `python-gui/actions.py` holds package sets and maintenance bash command strings.

**Why:** Building an Arch Linux post-install tool distributed as a pacman package (like Erik Dubois's archlinux-tweak-tool), run via pkexec for one-time root elevation at launch.

**Done:**
- Four tabs: Welcome, System Maintenance, Core & Drivers, Install Apps + Search tab
- pkexec privilege escalation at launch; polkit policy auto-installed on first run
- External terminal launcher (default Alacritty, user-selectable dropdown saved to settings.json)
- Package manager dropdown on Welcome tab (yay/paru/pacman) — all install commands use selected manager at call time via `_mgr_install_cmd()`
- pacman.conf editor: ParallelDownloads input + 5 boolean toggles
- Nerd Fonts (65 fonts, GitHub releases), General Fonts (3-col grid), Emoji Fonts (3rd subtab) — all with ✓ installed indicator
- Installed cache: saved to `~/.cache/arch-boki-post-install-gui/installed.json`, refreshed from `pacman -Q` on every run
- Missing packages report: `missing_pkgs.md` in cache dir, generated at startup with per-section missing pkg lists + install commands
- ✓/! markers on all install buttons (checkboxes show ✓, command-section buttons show ✓ or !)
- Audio: PipeWire/PulseAudio smart detection — only checks the active stack, shows "X is the active stack" for the inactive one
- Search tab: online search via selected AUR helper (yay/paru) or pacman -Ss, debounced as-you-type (600ms), mutex-locked DPG thread updates, shows pkg/version/repo/installed/description
- All `_CORE_UTILS_SECTIONS` and `_PRINTER_SECTIONS` cmds are callables (lambdas) using `_mgr_install_cmd()` — no more hardcoded pacman/yay
- CUPS auto-installs before any printer driver section via `_cups_ensure()`
- `_REAL_USER` bash snippet used everywhere AUR helper needs real user context

**Pending:**
- PKGBUILD, .desktop file, /usr/bin/ launcher script
- End-to-end testing after reboot (GLX error appeared mid-session during system update — expected to resolve after reboot)

**How to apply:** User rebooting tonight, resuming tomorrow. First task: confirm GLX error is gone after reboot. If still present, add XDG_SESSION_TYPE + MESA_GL_VERSION_OVERRIDE to pkexec env vars in `_ensure_root()`.
