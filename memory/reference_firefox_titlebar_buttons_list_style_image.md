---
name: reference-firefox-titlebar-buttons-list-style-image
description: "Firefox's Linux window-control (min/max/close) titlebar icons are swapped in via list-style-image, not recolored via fill/color like other userChrome.css elements"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-08T19:57:00.043Z
---

When customizing Firefox's chrome via `userChrome.css`, most icons (tab
close buttons, toolbar buttons) are real SVGs using
`-moz-context-properties: fill; fill: currentColor;`, so a plain
`color`/`fill` CSS rule recolors them correctly.

The window-control buttons specifically (`#minimize-button`,
`#maximize-button`/`#restore-button`, `#close-button` -- also seen under
`#titlebar-min`/`#titlebar-max`/`#titlebar-close` naming on some
versions) are a real, documented exception on Linux: their icon is
swapped in wholesale via `list-style-image` on the `.toolbarbutton-icon`
child, completely ignoring `fill`/`color`/`currentColor`. Confirmed via a
real Firefox-96 regression report and a Mozilla support thread — this
isn't a version fluke, it's structural.

The actual fix is to replace the icon entirely:

```css
#minimize-button > .toolbarbutton-icon,
#titlebar-min > .toolbarbutton-icon {
  list-style-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Crect x='4' y='11' width='8' height='1.4' fill='%23RRGGBB'/%3E%3C/svg%3E") !important;
}
```

Note `#` is a reserved URI character and must become `%23` inside the
data URI, or the SVG truncates at the fragment identifier. Include both
ID naming schemes (`#minimize-button`/`#titlebar-min` etc.) since the
one actually present varies by Firefox version/build.
