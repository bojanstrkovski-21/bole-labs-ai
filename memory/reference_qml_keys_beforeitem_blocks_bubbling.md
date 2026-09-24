---
name: reference_qml_keys_beforeitem_blocks_bubbling
description: "Adding a second Keys.onPressed as an ancestor Item, assuming it only fires when a descendant doesn't consume the event, can silently break existing keyboard navigation if that descendant relies on Keys.priority Keys.BeforeItem rather than plain focus/bubbling"
metadata: 
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-09-21T21:21:38.512Z
---

The normal QML mental model — key events go to the focused item, and if
unaccepted bubble up through ancestor `Keys.onPressed` handlers — does NOT
reliably hold in every real project. Confirmed live in dwm-quickshell: a
component (`core/PanelKeyCatcher.qml`, ported from basecamp/omarchy) was
deliberately built with `focus: true` + `Keys.priority: Keys.BeforeItem`
specifically because that project had already found, independently, that
per-widget `activeFocus` was unreliable inside a certain popup type
(`ClickAwayPopup`) — lost within a few hundred ms of being gained, Tab never
reaching a specific item. `Keys.BeforeItem` makes that catcher's own handler
run before its own children even get a look, which is what actually made
navigation work there — not the normal bubble-up model.

Adding a *second*, independent `Keys.onPressed` on a new ancestor `Item`
(e.g. a `Flickable` wrapper introduced for scrolling), assuming it would
only catch keys the existing navigation didn't already consume, **broke
that navigation entirely** — a live-tested, confirmed regression, not a
theoretical concern. Bisecting (removing just the new handler) fixed it
immediately.

**Why:** once a project has already worked around unreliable focus/bubbling
with an explicit `Keys.priority` mechanism, a second independent key
handler is competing with a non-standard event-ownership scheme, not
falling back within the standard one. The two don't compose safely by
default.

**How to apply:** before adding any new `Keys.onPressed`/`Keys.forwardTo`
to a shared/ancestor component in an existing project, grep for
`Keys.priority` and any custom key-dispatcher component first. If one
exists, wire the new behavior *into* it (e.g. have the existing semantic
signal handlers — like a `moveRequested(dx, dy)` — additionally trigger
the new behavior) instead of adding a second, independent raw-key
interceptor at a different layer. Always live-test existing keyboard
navigation after touching anything in this area, not just the new feature
in isolation — a regression here can be silent (no error, just "the
cursor doesn't move") and easy to miss if you only screenshot the new
behavior.
