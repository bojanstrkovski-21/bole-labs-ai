---
name: reference_qt6_qml_tools_path
description: "The real Qt6 QML tools (qmllint etc.) live at /usr/lib/qt6/bin/, not on PATH — /usr/bin/qmllint is Qt5's and silently fails on this project's QML"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-09-12T11:27:49.984Z
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

**Confirmed again (2026-09-12) with the actual fix**: the project's own
`quickshell` skill ships `scripts/quickshell-qmllint`, a helper that
builds proper lint-only `qmldir` maps for `qs.*` imports (a real fix,
not just suppressing warnings — took a ~150-warning file down to 1
genuine edge case). That helper's own `find_qmllint()` picks a bare
`qmllint` off PATH by default, so on this machine it silently hits the
same wrong Qt5 binary and fails with exit 255 and zero output — always
pass `--qmllint /usr/lib/qt6/bin/qmllint` explicitly when invoking it
here. Separately, for the IDE's own automatic per-edit lint noise (not
a deliberate deep pass), a project-level `.qmllint.ini` with
`ImportFailure=disable`/`UnqualifiedAccess=disable` fixes it with zero
code changes — confirmed `qmllint` auto-discovers that file from any
subdirectory under the project root, not just when invoked from the
exact directory it lives in.
