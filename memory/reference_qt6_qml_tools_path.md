---
name: reference_qt6_qml_tools_path
description: "The real Qt6 QML tools (qmllint etc.) live at /usr/lib/qt6/bin/, not on PATH — /usr/bin/qmllint is Qt5's and silently fails on this project's QML"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-15T09:50:16.544Z
---

On this machine, plain `qmllint` (resolved via PATH to `/usr/bin/qmllint`)
is owned by the `qt5-declarative` package (`qmllint 1.0`) — it silently
fails (exit 255, no stdout/stderr at all) on any of this project's actual
QML files, including dwm-titus's own untouched upstream files, because
they use modern QML/Quickshell syntax Qt5's linter can't parse. This looks
exactly like a real syntax error in freshly-edited QML but isn't one —
confirmed by running it against an untouched reference file and getting
the identical silent failure.

The real, usable Qt6 tools for this project (`qs.core`/Quickshell QML)
live at `/usr/lib/qt6/bin/` instead, installed by the `qt6-declarative`
package:
```
/usr/lib/qt6/bin/qml
/usr/lib/qt6/bin/qmlcontextpropertydump
/usr/lib/qt6/bin/qmldom
/usr/lib/qt6/bin/qmleasing
/usr/lib/qt6/bin/qmlformat
/usr/lib/qt6/bin/qmllint
/usr/lib/qt6/bin/qmlls
/usr/lib/qt6/bin/qmlplugindump
/usr/lib/qt6/bin/qmlpreview
/usr/lib/qt6/bin/qmlprofiler
/usr/lib/qt6/bin/qmlscene
/usr/lib/qt6/bin/qmltc
/usr/lib/qt6/bin/qmltestrunner
/usr/lib/qt6/bin/qmltime
/usr/lib/qt6/bin/svgtoqml
```

`/usr/lib/qt6/bin/qmllint <file>.qml` (version 6.11.1, confirmed working)
runs cleanly and exits 0 on valid QML, just emitting `[import]` warnings
for `Quickshell`/`qs.core`/local component types since `QML_IMPORT_PATH`
isn't configured for this project's module layout — those import warnings
are expected noise, not real errors; a genuine syntax problem shows up as
an actual parse error instead.

**How to apply:** in [[project_dwm-quickshell]] (and any other project
using Quickshell/qs.core QML on this machine), always invoke
`/usr/lib/qt6/bin/qmllint` by full path, never bare `qmllint` — the PATH
one is the wrong major version and its silent failure gives false
confidence that a syntax check was actually performed.
