---
name: reference_qml_repeater_integer_model_count_change_rebuilds_delegates
description: "A QML Repeater with an integer model rebuilds ALL delegates when the count changes, and an equal array handed to a Repeater rebuilds too; use fixed slots and assign rows only when a key changes"
metadata:
  type: reference
---

In QML a `Repeater { model: someInt }` does not add or remove delegates when the integer changes: it rebuilds every one, so a delegate holding state (a Flickable's scroll position) loses it. Handing a Repeater an array that is equal to the old one (a binding re-evaluated, same list) also rebuilds its rows, which collapses a Flickable's contentHeight and clamps contentY to 0. dwm-quickshell Session 51: a cascading menu panel jumped back to the top every time a submenu opened.

Fix: a FIXED number of slots (`model: 8`) shown or hidden with `visible`, and set each slot's list imperatively only when a small string key says it shows something else (`onListKeyChanged: rows = ...`). Comparing arrays with `===` inside a handler did not work as a guard (identity changed through the property), so use a key.
