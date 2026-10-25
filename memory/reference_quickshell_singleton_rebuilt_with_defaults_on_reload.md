---
name: reference_quickshell_singleton_rebuilt_with_defaults_on_reload
description: "A Quickshell hot reload rebuilds Singletons with their defaults, so a window sized from async-loaded settings is created at the wrong size then resized — gate it and carry state in PersistentProperties"
metadata:
  node_type: memory
  type: reference
---

On every Quickshell hot reload the `pragma Singleton` objects (e.g. a Theme) are re-created with their declared defaults, and saved settings arrive later through an async `FileView`. Anything sized from those settings (a panel `PanelWindow` whose `implicitHeight` depends on "floating / scale") is therefore created at the DEFAULT size for a moment and then resized. Measured with `xev -id <window> -event structure`: 36 px then 44 px on every reload; a tiling WM re-tiles around each size and sometimes the second resize is left half-applied (bar drawn 28 px inside a 44 px strut). A full restart hides it because it happens once, before anyone looks.

Fixes that work: (1) keep the window unmapped (`visible: ... && Theme.settingsReady`) until the loader has applied the settings, with a timer as a safety net; (2) carry the values across reloads in `PersistentProperties { reloadableId: "..." }` (they survive a reload in memory) and restore them in its `onLoaded`.

Dead ends: `FileView { blockLoading: true }` with a `JsonAdapter` is NOT populated by the time the first binding evaluates; Quickshell's `Singleton` type has no attached `Component`, so `Component.onCompleted` there makes the whole config fail to load (and `qmllint` does not catch it).

Found in dwm-quickshell Session 45 (2026-10-23).
