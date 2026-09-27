---
name: reference_qml_content_embedding_loses_implicit_load_trigger
description: "extracting a popup's content into a reusable *Content.qml so it can be embedded elsewhere silently drops whatever implicit data-load trigger the original popup's open()/visible binding used to provide -- the new embedding needs its own explicit trigger"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-09-26T20:53:38.619Z
---

A common QML popup pattern bundles two things into one `open()` call:
`visible = true` and a data refresh. When that same content later gets
extracted into a plain `Item`-rooted `*Content.qml` for reuse (e.g.
embedding it in a second window/dashboard alongside the original popup),
the new embedding usually just instantiates the content directly and
binds a model in — it never calls the old `open()`, so the implicit
refresh that used to ride along with it silently never happens. The
model's data stays at whatever default/empty state it was constructed
with, and nothing in the UI signals why.

**How to apply:** when extracting a `*Content.qml` from a `*Window.qml`
popup, check whether the paired `*Model.qml` has its own
`Component.onCompleted` self-load. If it doesn't — if it only ever
populated data through the old popup's `open()` — add
`Component.onCompleted: root.refresh()` (or equivalent) directly to the
model, not the content or the new embedding site. That keeps the fix in
one place regardless of how many different surfaces end up embedding the
same content later, and matches how sibling models in the same codebase
that already have this self-load stay correct automatically. Caught in
dwm-quickshell: two of ~13 embedded Control Center section models
(Displays, Bluetooth) were missing this after a Control Center redesign
started embedding their content directly — one showed "No displays
detected" despite a real connected monitor, the other silently never
performed a live status check at all, showing only its property's
compile-time default text.
