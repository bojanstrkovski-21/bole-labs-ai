---
name: reference_qml_layout_hidden_item_measures_zero
description: "A QML Layout skips invisible children, so an item's size measured inside a hidden Loader/slot is 0: never derive the slot's own visibility from that size (it can never come back, and shows as a binding loop)"
metadata:
  type: reference
---

When a Loader (or any wrapper) sits in a layout and its `visible` is bound to something measured from the loaded item (`item.visible`, `implicitWidth > 0`, a Layout.preferredWidth that depends on child visibility), you get a circle: hidden slot -> the item's effective `visible` is false and a RowLayout/Row inside it ignores invisible children -> measured width 0 -> slot stays hidden. Qt reports it as "Binding loop detected for property ...".

**Why:** found building the panel's movable modules (Session 52): a `RowLayout`-rooted module (status text, tray) with a size-based `shown` rule logged the loop and could never reappear.

**How to apply:** let the loaded module declare its own wish (`readonly property bool wanted: <condition not involving layout>`) and bind the slot's `visible` to that only; use the measured size only for `Layout.preferredWidth`, never for visibility. Also: `String.fromCodePoint(0xF0054)` for icon-font glyphs instead of typing them (see [[reference_unicode_pua_glyph_tool_calls]]).
