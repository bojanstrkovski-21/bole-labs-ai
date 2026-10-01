---
name: reference_pacman_partial_upgrade_conflict
description: "A targeted pacman/paru -S can refuse to install if an ABI-bumping package (e.g. ffmpeg) and a dependent needing its old soname (e.g. a vlc plugin) are out of sync locally -- a partial-upgrade trap, not a real breakage"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-01T21:19:42.816Z
---

Running `pacman -S`/`paru -S` against a specific package list (not a
full `-Syu`) can hit a dependency conflict like "installing X breaks
dependency Y required by Z" when the repos have published a newer,
ABI-bumping core package (e.g. `ffmpeg` with a new `libavformat.so=`
soname) alongside an already-rebuilt dependent (e.g. `vlc-plugin-
ffmpeg`), but the locally-installed version of that dependent predates
the bump and still wants the old soname. pacman correctly refuses the
whole transaction rather than leave a broken package — this is pacman
protecting the system, not a sign anything is actually broken yet.
Confirmed via `pacman -Si`/`-Qi` on a real hit: the repo's own copy of
the dependent was already fixed, only the local install was stale.

**How to apply:** the clean fix is a full `sudo pacman -Syu` first so
the dependent upgrades in the same transaction as the ABI-bumping
package, then retry the targeted install. For a script that installs a
fixed package list and shouldn't hard-fail over one conflicting
package, install one package per `pacman -S`/`paru -S` call instead of
batching the whole list into one transaction — a single conflict then
only skips that package (catch and log the failure) instead of
aborting every other install in the same run.
