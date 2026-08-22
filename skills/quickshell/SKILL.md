---
name: quickshell
description: Build, lint, validate, and troubleshoot Quickshell desktop shell projects and QML configurations. Use when working with Quickshell `shell.qml`, `qs.*` imports, Quickshell QML modules, `qmllint`/`qmlls` import failures, Quickshell source builds, packaged Quickshell configs, or version-matched docs/API questions.
---

# Quickshell

## Core Workflow

1. Locate the project shape:
   - Config project: has `shell.qml` and QML files.
   - Source checkout: has Quickshell CMake files and usually `BUILD.md`.
   - Packaged config: has a named config intended for `$XDG_CONFIG_HOME/quickshell/<name>` or `$XDG_CONFIG_DIRS/quickshell/<name>`.
2. Read local project instructions first (`AGENTS.md`, `README`, docs, package metadata).
3. For QML edits, resolve this skill's absolute directory, keep the working
   directory at the target project, and run its `scripts/quickshell-qmllint`
   helper before treating `qmllint` import errors as real.
4. For runtime validation, load the managed config with `quickshell --path <dir-or-shell.qml>` or `quickshell --config <name>` in a real or nested compositor/session.
   A clean launch is not proof a visual change is correct: capture a
   compositor screenshot for layout/static changes, a short screen recording
   for animations or transitions, and simulated input (e.g. `wtype`) for
   interaction changes, then inspect the capture. Capture reference (before)
   and candidate (after) screenshots when comparing a change rather than
   relying on memory. Track the PID of anything launched for testing and stop
   only that process; never kill Quickshell broadly.
5. For documentation or API work, detect the project's target version from its
   package metadata, lock files, source checkout, or `quickshell --version`.
   Use the matching official versioned docs. If the project has no version
   signal, use the latest stable release and state the version selected.
6. For source builds, use CMake/Ninja and disable optional features whose dependencies are absent.

## Resources

- Read `references/linting.md` when linting QML, configuring `qmllint`/`qmlls`, or diagnosing missing `Quickshell` or `qs.*` type declarations.
- Read `references/build-and-run.md` when installing Quickshell, running a config, packaging a config, or building Quickshell from source.
- Read `references/docs-map.md` when selecting version-matched official docs pages or type references.
- Before telling the user a topic isn't covered, grep `references/` for the keyword — a single plain-word grep can surface a match the routing above missed. Only report no coverage after that search comes up empty.

## Fast Commands

From the target project root, set the resolved absolute skill directory and lint
all QML under the nearest `shell.qml` root:

```sh
quickshell_skill_dir="/absolute/path/to/quickshell-skill"
"$quickshell_skill_dir/scripts/quickshell-qmllint"
```

Lint a specific config root:

```sh
"$quickshell_skill_dir/scripts/quickshell-qmllint" --root "$PWD/config/quickshell"
```

Run a config for validation:

```sh
quickshell --path config/quickshell --no-duplicate
```

Build Quickshell source:

```sh
cmake -GNinja -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
cmake --install build
```

## Guardrails

- Prefer official docs matching the project's Quickshell version. Do not apply
  current APIs to an older pinned configuration without checking compatibility.
- Do not replace runtime `qs.*` imports with relative imports only to satisfy stock `qmllint`; create lint-only module maps instead.
- Treat plain `qmllint` failures about `Quickshell` or `qs.*` imports as setup failures until explicit import roots have been supplied.
- Validate UI/runtime behavior in an actual compositor/X11/Wayland session when windows, panels, focus, IPC, or services are involved.
- A launch or automated check alone does not verify a visual change; inspect a captured screenshot or recording before reporting it works.
- Never type a Nerd Font / private-use-area icon codepoint (e.g. `U+F4BC`) as literal text in a file-editing tool call — it can silently come out as an empty string with no error. Write it via a small script that computes the character from its codepoint (`chr(0xXXXX)` in Python), patch the file directly, then re-read the file's actual bytes to confirm the codepoint landed before trusting it.
