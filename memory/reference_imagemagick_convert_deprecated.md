---
name: reference_imagemagick_convert_deprecated
description: "ImageMagick v7 (on the dwm-quickshell test VM, and generally) deprecated the `convert` command in favor of `magick` — using `convert` still works but always prints a deprecation warning; use `magick file.in file.out` instead"
metadata: 
  node_type: memory
  type: reference
  originSessionId: f1b950f0-c1d0-4466-923f-bc56f9964782
  modified: 2026-08-29T15:57:41.600Z
---

`convert` (and other legacy per-verb binaries like `mogrify`/`composite`)
is ImageMagick v6's interface. ImageMagick v7 keeps `convert` as a
backward-compat shim that still works but prints
`WARNING: The convert command is deprecated in IMv7, use "magick" instead
of "convert" or "magick convert".` on every single invocation — noisy in
any output that gets shown to the user, and shows up repeatedly if the
same `xwd`-then-convert pattern gets reused across many calls in one
session (screenshot-based VM testing in [[project_dwm-quickshell]] hits
this constantly).

**How to apply:** always use `magick file.in file.out` (or `magick
file.in -crop ... file.out`, etc.) instead of `convert file.in file.out`
— same arguments otherwise, just swap the binary name. Never fall back to
`convert` out of habit after copy-pasting an earlier command in the same
session; the warning is a signal to fix the command itself, not just to
ignore for that one call. This was already noted once in
[[project_dwm-quickshell]]'s own narrative memory (Session 8) but wasn't
being consulted reliably mid-session — this standalone reference exists
so it actually surfaces next time.
