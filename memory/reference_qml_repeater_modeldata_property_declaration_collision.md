---
name: reference_qml_repeater_modeldata_property_declaration_collision
description: "In a QML Repeater over a plain array-of-objects model (pragma ComponentBehavior: Bound), redeclaring `required property var modelData` at each delegate instantiation site collides with a same-named property already on a reusable component, self-binding to undefined"
metadata:
  type: reference
---

When a `Repeater`'s `model` is a plain JS array of objects (not a
`ListModel`/C++ model), Qt's Bound-mode auto-injection populates a
`required property var modelData` declared **on the delegate root
itself** with each array element, plus `required property int index`.
This works fine for an inline delegate. It breaks silently if the
delegate is a reusable named `component` that *also* declares its own
`property var modelData` (e.g. as part of its public API, meant to be
set like `MyCard { modelData: someValue }`) — redeclaring
`required property var modelData` again at the instantiation site inside
the `Repeater` collides with the component's own property of the same
name, and the `modelData: modelData` self-assignment binds to
`undefined` instead of receiving the Repeater's injected array element.
Every field access off it (`modelData.someField`) then throws
`TypeError: Cannot read property '...' of undefined` at runtime — Qt
only warns, it doesn't fail the config load, so this can go unnoticed
until the delegate is actually rendered.

Fix: declare `required property var modelData` (and `required property
int index` if needed) exactly once, **inside the reusable component's own
definition**, not re-declared at each `Repeater` usage site. Any derived
property (e.g. `isNow`/`isSelected`) should be computed from the required
`index` directly inside the component rather than passed in separately.
This lets the Repeater usage collapse to a bare `MyCard {}` with no body
at all. Found and fixed in the [[project_dwm-quickshell]] project's
Weather feature (`HourCard`/`DayCard` components in
`quickshell-configs/weather/WeatherWindow.qml`) — caught immediately by
a real Quickshell config load (qmllint did not catch it), which is the
project's standing rule for any QML change.
