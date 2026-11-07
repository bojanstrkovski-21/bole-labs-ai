# QML performance triage

Adapted in our own words from the `qt-qml-profiler` skill's anti-patterns reference
(`theqtcompanyrnd/agent-skills`, The Qt Company Ltd., `LicenseRef-Qt-Commercial OR
BSD-3-Clause`, used under BSD-3-Clause; copyright (c) 2026 The Qt Company Ltd.).
Qt's profiler workflow runs `qmlprofiler` on a 2D Qt Quick application and reads the
trace. Whether it can launch a Quickshell config is **unverified**; the symptom
table below works with any profiler output or with plain observation (CPU in `top`,
dropped frames, slow first open).

Name the cause before changing code: a fix that cannot say which row it addresses is
a guess. Do not conclude "it is fine" from a fast machine.

| Symptom | Common causes | Fixes |
| --- | --- | --- |
| A binding re-evaluates constantly | Depends on a property that changes every frame (animation progress, scroll position); a heavy expression; one change cascading into many bindings | Cache the value in a `readonly property`; split a complex binding into intermediate properties; use `Behavior` or `SmoothedAnimation` instead of re-computing each frame |
| Expensive JavaScript, often with expensive signal handlers | Heavy work in `onCompleted` or `on<Property>Changed`; rebuilding a model; array and string work in hot paths; one handler setting many properties | Move heavy work to C++ or a helper process; batch updates into one state property that bindings read; use `WorkerScript` for async computation; cache results |
| `onWidthChanged` / `onHeightChanged` doing real work | Resize handlers run per pixel during a drag | Debounce with a short `Timer`; move logic out of the handler |
| Slow startup or slow first open of a view | Large trees created synchronously; many bindings evaluated at creation; heavy delegates; everything loaded up front | `Loader` with `asynchronous: true`; simplify delegates; load views on demand. Setting `visible: false` does **not** prevent creation: use a `Loader` |
| Slow QML compilation | Large QML files compiled on first use; no ahead-of-time compilation | Enable qmlcachegen/`qmlsc` in the build; split large files into components; preload critical components |
| Frame drops in rendering | Too many scene graph nodes; frequent clip changes; large images; stacked semi-transparent layers (over-draw); `Canvas` where a scene graph item would do | Reduce node count; set `sourceSize`; avoid `clip: true` on items that change often; replace `Canvas` with `Shape` or a custom item |
| High memory or pixmap cache misses | Full-resolution images where thumbnails suffice; many temporary objects; many unique images | Set `sourceSize` to the display size; `asynchronous: true` on `Image`; reuse delegates with `ListView.reuseItems` |
| Images missing or reloading | A changed `source` or a destroyed item cancels a load (not a bug); a wrong path or a file missing from the resources; an image provider returning an empty image; an unsupported format | Read the app's stderr (`QML Image:` lines name the reason; cancellations print nothing); verify the URL resolves; handle `Image.status === Image.Error` so failures show during development |

Hard rules from the same source: animate `transform` and `opacity` by default;
never claim a fix without naming which cause it addresses; say which findings you
verified from code and which need a recording on a real device.

See `qml-rules.md` for the matching coding rules, and `shell-practices.md` for
polling and per-monitor cost.
