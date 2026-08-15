---
name: reference_posix_sh_function_scope_collision
description: "POSIX shell functions don't have separate variable scopes by default — a loop variable in a helper function can silently clobber a same-named variable in the calling function"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-14T19:55:58.445Z
---

POSIX `sh` functions share the caller's variable namespace unless `local`
is used (and `local` itself isn't POSIX — it's a widely-supported but
non-standard extension). A loop variable, or any assignment that looks
local, inside a function called as a *plain function call* (not a
subshell via `$(...)` or `(...)`) will overwrite a same-named variable
in whatever function called it.

Hit for real in [[project_dwm-quickshell]]: `is_compatible()`'s
`for name in $COLOR_NAMES` loop clobbered `set_theme()`'s own `name`
variable (the actual theme argument being processed), because
`is_compatible()` was invoked as a direct function call from within
`set_theme()`. The bug was silent and specific: `set-theme nord` wrote
`theme = col_borderbar` (the last item `$COLOR_NAMES` iterated to)
into the output file instead of `theme = nord` — no error, just wrong
data. A `$(...)` command substitution call would *not* have this
problem (it forks a subshell, so its variable assignments never leak
back), only a plain function call does.

**How to apply:** when writing a POSIX shell helper function that's
called as a plain function call from another function, name its loop
variables and local-feeling assignments distinctly (e.g. suffix or
prefix them) from anything the caller might plausibly use — don't reuse
generic names like `name`, `i`, `line`, `value` across functions in the
same call chain without checking for collisions. Caught this one via
isolated scratch-directory testing (exercising the real script against
a throwaway copy of its target files) before it ever touched a real
deployment — worth doing that kind of test on any shell script whose
functions call each other directly.
