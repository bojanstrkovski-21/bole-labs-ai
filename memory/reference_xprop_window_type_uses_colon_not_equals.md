---
name: reference_xprop_window_type_uses_colon_not_equals
description: "xprop formats a CARDINAL/STRING property as \"PROP(TYPE) = value\" but a WINDOW-typed property (e.g. _NET_ACTIVE_WINDOW, _NET_CLIENT_LIST) as \"PROP(WINDOW): value\" — a colon, not an equals sign — a parser that only handles \"=\" silently returns nothing for any WINDOW property"
metadata: 
  node_type: memory
  type: reference
  originSessionId: f1b950f0-c1d0-4466-923f-bc56f9964782
  modified: 2026-09-01T21:50:52.255Z
---

Confirmed directly against a real X server, not assumed from docs:

```
$ xprop -root _NET_CURRENT_DESKTOP
_NET_CURRENT_DESKTOP(CARDINAL) = 1
$ xprop -root _NET_CLIENT_LIST
_NET_CLIENT_LIST(WINDOW): window id # 0x3400161, 0x2200004, 0x1000007
```

A CARDINAL/STRING/UTF8_STRING property uses `PROP(TYPE) = value`; a
WINDOW property (single or array — `_NET_ACTIVE_WINDOW`,
`_NET_CLIENT_LIST`, any client-list/active-window EWMH property) uses
`PROP(WINDOW): value` instead, with a colon and no `=` anywhere on the
line, plus a `window id # ` prefix before the actual hex value(s). A
shell parser written as `sed -n 's/^[^=]*= //p'` (or any variant assuming
`=` is the separator) silently produces empty output for every WINDOW
property — no error, just nothing, which a caller can easily read as
"property not set" instead of "my parser is wrong."

Fix: broaden the separator match to accept either character —
`sed -n 's/^[^=:]*[=:][[:space:]]*//p'` — which still needs a caller to
separately strip the WINDOW type's own `window id # ` value prefix (e.g.
`sed -n 's/^window id # //p'` on top, or `awk '{ print $NF }'` per
comma-split entry for a multi-window list) since that prefix isn't part
of the type/value separator at all.

Found in [[project_dwm-quickshell]]: `dwm-quickshell-state`'s
`root_property_value()` had exactly this `=`-only bug, meaning
`occupied_workspaces()` (built on `_NET_CLIENT_LIST`, always WINDOW-typed)
and `active_window_id()`'s `_NET_ACTIVE_WINDOW` xprop fallback (used
whenever `xdotool` isn't available) had been silently returning empty on
every real call, confirmed live before being caught by a test written
against realistic (not guessed) xprop output.
