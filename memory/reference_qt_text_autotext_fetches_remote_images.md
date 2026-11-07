---
name: reference_qt_text_autotext_fetches_remote_images
description: "Qt Text in AutoText, StyledText and RichText fetches an <img src=http://...> from the network; only PlainText does not. Set textFormat: PlainText on any Text showing external strings"
metadata:
  type: reference
---

Verified 2026-11-07 on Qt 6.12.0 with a loopback HTTP server and `qml6` (offscreen): a `Text` showing `<img src="http://127.0.0.1:PORT/x.png">` made one HTTP request in the default `AutoText`, in `StyledText` and in `RichText`, and none in `PlainText` (a plain `Image` pointing at the same server was the positive control).

**Why it matters:** a shell that shows notification summary/body/app name, Wi-Fi SSIDs, media titles or window titles in plain `Text {}` will fetch URLs an attacker puts in those strings (tracking pixel, IP leak, requests to the local network). Omarchy's plugin guide warns about the same sink.

**How to apply:** set `textFormat: Text.PlainText` on every element bound to external text unless markup is genuinely wanted. Applied in chadboki-qswm to 7 elements (SSID, notification app name, summary, body in the card and the history window); its notification server already declares `bodyMarkupSupported: false`, so a plain body matches. `StyledText` does not help. Test method: loopback `python3 http.server` that logs requests plus `qml6` with `QT_QPA_PLATFORM=offscreen`; `/usr/bin/qml` may be the Qt 5 runner and prints only `Did not load any objects` (see [[reference_qt6_qml_tools_path]]).
