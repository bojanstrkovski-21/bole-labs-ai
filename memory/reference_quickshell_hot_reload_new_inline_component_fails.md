---
name: reference_quickshell_hot_reload_new_inline_component_fails
description: "Quickshell hot reload fails with 'X is not a type' when a QML file gains NEW inline components; a fresh start is fine. Use standalone files, and check `quickshell log` after a live deploy"
metadata:
  node_type: memory
  type: reference
---

Quickshell reloads a changed config in place. If a QML file that was already loaded gains new `component Foo: ...` inline components (declared inside the file, used by name in the same file), the reload fails with `ERROR: Failed to load configuration ... caused by @file.qml[N:M]: Foo is not a type`, and every later reload of that file keeps failing until something changes it again (or Quickshell is restarted). A fresh start of the very same file loads fine, so a test that starts Quickshell from scratch will NOT catch it.

Fix/avoidance: put new reusable pieces in their own standalone `.qml` files (same directory, no qmldir needed) instead of adding inline components to a file that is already live. Reproduced and confirmed both ways in dwm-quickshell Session 44: old file -> new file with inline components = failure; new file using standalone components = "Configuration Loaded". The stuck instance recovers by itself on the next good deploy, no restart needed.

How to check after a live deploy: `quickshell log -t 30` (or read /run/user/$UID/quickshell/by-id/*/log.log) and look for "Configuration Loaded" vs "Failed to load configuration". A running instance that failed a reload keeps the OLD config silently, so "deployed" does not mean "live" until the log says loaded.
