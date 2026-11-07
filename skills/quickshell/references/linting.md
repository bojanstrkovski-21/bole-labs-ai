# Quickshell QML Linting

Use this reference for `qmllint`, `qmlls`, `qml-language-server`, and missing QML type declarations.

## Why Plain qmllint Fails

Stock `qmllint` often does not discover Quickshell modules automatically. It needs explicit QML import roots that contain Qt's modules, Quickshell's `qmldir` files, and generated `.qmltypes` files. Quickshell `qs.<path>` imports are rooted at the directory containing `shell.qml`; stock Qt tooling may also need a lint-only `qmldir` map for each local `qs.*` module.

Official docs for the current reference version:
- QML imports: https://quickshell.org/docs/v0.3.0/guide/qml-language/
- Installation and editor setup: https://quickshell.org/docs/v0.3.0/guide/install-setup/

Use the version-selection rules in `docs-map.md` for a project that targets a
different release.

## Preferred Command

Resolve this skill's absolute directory, keep the working directory at the
target project, then run the bundled helper against the nearest Quickshell
config root:

```sh
quickshell_skill_dir="/absolute/path/to/quickshell-skill"
"$quickshell_skill_dir/scripts/quickshell-qmllint"
```

When running elsewhere, pass an absolute root explicitly:

```sh
"$quickshell_skill_dir/scripts/quickshell-qmllint" \
  --root "/absolute/path/to/project/config/quickshell"
```

It:
- finds `qmllint-qt6`, `qmllint`, or `/usr/lib*/qt6/bin/qmllint`;
- adds common Qt/Quickshell QML roots such as `/usr/lib64/qt6/qml`, `/usr/lib/qt6/qml`, and `/usr/lib/qt6/qml`;
- discovers `qs.*` imports in the target files;
- creates temporary `qmldir` files and symlinks for local QML types;
- sets `QMLLS_BUILD_DIRS` and `QML_IMPORT_PATH` for the lint process.

## Qt's Rule Linter (Vendored)

`scripts/qt_qml_lint.py` is Qt's own deterministic QML linter (about 46 rules: imports,
bindings, layouts, loaders, delegates, states, images, performance, signals, JavaScript),
vendored unmodified from The Qt Company's `agent-skills` under BSD-3-Clause. Provenance, the
pinned commit, the sha256, and the audit notes are in `scripts/qt_qml_lint.PROVENANCE`; the
license is `scripts/QT-LICENSE.txt`. It uses only the standard library and never touches the
network or writes files. Always run it through the wrapper, with Python's isolated mode:

```sh
python3 -I "$quickshell_skill_dir/scripts/quickshell-qt-lint" path/to/File.qml ...
find config/quickshell -name '*.qml' | python3 -I "$quickshell_skill_dir/scripts/quickshell-qt-lint" --files-from=-
python3 -I "$quickshell_skill_dir/scripts/quickshell-qt-lint" --diff=HEAD~1..HEAD
```

`--files-from` accepts only `-` (standard input); `--files-from=path` is silently treated as a
file name and lints nothing. The wrapper exits 1 when findings remain and hides rules that are
noise for a shell: `ORD-1` (attribute order), `BND-1` (`property var`), `STY-3` (dot-notation
grouping), `PRF-3` (`clip: true`) and `BND-2` on `...Process.command/running` (the normal
Quickshell `Process` idiom). On a 114-file shell that hid 1,214 of 1,247 findings and left 33
real ones. Pass `--all` for everything. Its rules complement, and do not replace, `qmllint`
with the Quickshell import roots (which finds missing properties and types).

To update the vendored copy: fetch the new file, repeat the audit in the provenance file,
replace it, and update the commit and sha256 there (`scripts/validate.sh` fails otherwise).

## An Empty Result Is Not A Pass

On Arch (and any distro where the Qt 5 package owns `/usr/bin/qmllint`) the bare
`qmllint` reports `qmllint 1.x` and exits 255 with **no output** on Qt 6 /
Quickshell QML, which looks identical to a clean lint. The helper now prefers
`qmllint-qt6`, `qmllint6`, and the `/usr/lib*/qt6/bin/qmllint` paths, and skips
any candidate that reports itself as 1.x. Even so, prove the tool works before
trusting silence: run it once on a file you know is broken (for example a
missing `}` or an assignment to a property the base type lacks) and confirm it
reports it.

## Pre-Deploy Check For A Live Config

Before copying QML into a running shell, build the tree that will exist after the
deploy (the live config plus every file you are about to copy) and lint every
changed file against it:

```sh
"$quickshell_skill_dir/scripts/quickshell-qmllint" --root /path/to/post-deploy-tree \
  drawer/DrawerWindow.qml core/ClickAwayPopup.qml
```

Treat `[missing-property]` and `[unresolved-type]` as blockers. On 2026-11-07 the
helper reported `Could not find property "anchorX"/"anchorY"/"screenWidth"
[missing-property]` for a drawer file deployed without its newer base component,
the exact mismatch that made a live reload fail and leave the old config running.
It is silent on a consistent tree. After deploying, read the log by instance or
pid (`quickshell log -i <id>`), because the plain form matches the display string
literally.

## Manual Pattern

Use this if the helper needs adaptation:

```sh
QMLLS_BUILD_DIRS="/usr/lib64/qt6/qml:/usr/lib/qt6/qml" \
QML_IMPORT_PATH="$PWD/config/quickshell" \
qmllint-qt6 \
  -I /usr/lib64/qt6/qml \
  -I /usr/lib/qt6/qml \
  -I "$tmp_module_root" \
  -I config/quickshell \
  config/quickshell/shell.qml
```

For Nix, use the store paths for `qtdeclarative` and `quickshell`:

```sh
export QMLLS_BUILD_DIRS="${qtdeclarative}/lib/qt-6/qml:${quickshell}/lib/qt-6/qml"
export QML_IMPORT_PATH="$PWD"
```

## Local qs.* Module Maps

For a file that imports `qs.core`, create a temporary tree like:

```text
$tmp/qs/core/qmldir
$tmp/qs/core/Theme.qml -> $project/core/Theme.qml
$tmp/qs/core/ShellButton.qml -> $project/core/ShellButton.qml
```

The `qmldir` entries should mark files with `pragma Singleton` as singletons:

```text
module qs.core
singleton Theme 1.0 Theme.qml
ShellButton 1.0 ShellButton.qml
```

Do not commit this lint-only tree unless the project intentionally wants persistent Qt module metadata.

## LSP Notes

Official Quickshell docs recommend `qmlls`, but note it has caveats and cannot
provide all Quickshell type documentation. Prefer `qml-language-server` from
`cushycush/qml-language-server` when the repository
already standardizes on it, and still keep `QMLLS_BUILD_DIRS` and
`QML_IMPORT_PATH` aligned with the lint import roots.
