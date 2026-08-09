---
name: project-archknife
description: "What archknife is, its structure, and the work done on it"
metadata: 
  node_type: memory
  type: project
  originSessionId: e1c68563-531d-4bc3-bb2c-af7415b80308
---

Archknife is a custom Arch Linux live ISO installer built on top of the official archiso profile. It uses a Python + urwid TUI (no pip deps) inspired by butterknife (justaguylinux on Codeberg). The working directory is `/home/bojanstrko/DATA/butterknife/archknife-iso/iso/`.

**Why:** Personal custom ISO with pre-configured repos (Chaotic-AUR, Nemesis, Boki), full PipeWire stack, multimedia codecs, and multiple DE/WM choices baked in.

**Key files:**
- `airootfs/usr/local/lib/archknife/lib/installer.py` — all install logic, package lists, partitioning
- `airootfs/usr/local/lib/archknife/lib/screens.py` — all TUI screens
- `airootfs/usr/local/lib/archknife/lib/config.py` — Config dataclass with defaults
- `airootfs/usr/local/lib/archknife/lib/utils.py` — helpers, detect_timezone, get_partitions
- `airootfs/usr/local/lib/archknife/lib/widgets.py` — Selectable, SubmitEdit, MenuItem
- `airootfs/etc/pacman.conf` — live ISO pacman.conf (has all custom repos already)
- `airootfs/etc/os-release` — custom branding (PRETTY_NAME="Arch-Boki Archknife Linux Live ISO")
- `packages.x86_64` — packages baked into the live ISO

**How to apply:** See [[project-archknife-changes-session1]] for all changes made.
