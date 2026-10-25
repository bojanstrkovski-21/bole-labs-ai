---
name: reference_restore_state_before_anything_rewrites_it
description: "Restore-from-saved-property code must run before any earlier step that rewrites that property — dwm manage() read _NET_CLIENT_INFO after updatewmhints() had already overwritten it"
metadata:
  node_type: memory
  type: reference
---

When state is persisted in a property/file and "restored" on startup, the restore must run BEFORE any other step that writes the same property. In dwm's `manage()`, `updatewmhints()` called `setclienttagprop()` (rewrites `_NET_CLIENT_INFO` with freshly computed tags) before the restore block read it, so the saved value was always gone and the restore silently never worked. It stayed hidden because the only code path that exercises it (an in-place restart) was unbound.

How to apply: an untested restore path is not working until a real restart test proves it; reading back the property after the restore point tells you nothing if a writer ran first. Test on a throwaway X display (Xvfb, isolated HOME/XDG_DATA_HOME) with `xprop -spy` timestamps to see who rewrites it.

Found in dwm-quickshell Session 44 (2026-10-19).
