---
name: reference_qml_child_id_not_root_property
description: "In QML, a child item's id is not a property of its parent/root — root.childId resolves to undefined, a TypeError that silently hides the item with no other symptom"
metadata: 
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-09-21T18:00:41.154Z
---

In QML, giving a child component an `id:` does not make it accessible as
`root.thatId` — the id is scoped to the containing file/component, not
exposed as a property on any ancestor. Writing `root.batteryStatus.available`
when `batteryStatus` is the `id` of a `BatteryStatus {}` child (not a
`property var batteryStatus` on the root) silently evaluates to `undefined`,
throwing `TypeError: Cannot read property 'available' of undefined` — visible
in the Quickshell/QML log, but with no compile-time error and no other
symptom in the UI besides the bound element just not showing.

**Why:** ids create local named references within the same QML document,
not properties on the object tree — the two namespaces look similar
(`thing.property` either way) but are unrelated.

**How to apply:** to reference a sibling/child by its id from elsewhere in
the same file, use the id directly (`someId.x`), not `root.someId.x`. If a
value genuinely needs to be reachable from outside the file, expose it
explicitly as a `property var` or `alias` on the component, don't rely on
the id leaking through. When a bound UI element mysteriously never shows
and the surrounding logic looks right, check the actual runtime log for a
`TypeError: Cannot read property ... of undefined` before assuming a data-
flow bug elsewhere — an `id`-instead-of-`property` mixup is a common,
easy-to-miss cause, especially since a change often lands and works during
development on a machine where the wrong path doesn't actually get
exercised (project note: an X11/dwm-quickshell panel's battery pill bug
that shipped and lay unnoticed for weeks — the test VM had no battery,
so the code path was never even run there).
