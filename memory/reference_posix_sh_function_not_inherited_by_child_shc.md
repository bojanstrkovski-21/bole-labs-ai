---
name: reference_posix_sh_function_not_inherited_by_child_shc
description: "a shell function defined in a POSIX sh script is not available inside a detached `sh -c \"...\"` child it spawns — dash has no export -f, so the child can't see it even though the parent script \"already knows\" it"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-22T15:26:33.478Z
---

Defining a function earlier in a `/bin/sh` (dash/POSIX) script does not
make it callable from a *new* shell process the script spawns via
`sh -c "some_function_call"` (or `setsid sh -c "..."`, `nohup sh -c "..."`,
etc.) — that's a separate process with its own fresh environment, and
POSIX sh has no `export -f` (a bashism) to carry function definitions
across the fork/exec boundary the way exported variables cross it. The
mistake is easy because the *parent* script "obviously" has the function
in scope, making it feel like it should just work when referenced by name
in a string handed to a child shell — it silently fails instead (usually
"command not found" from the child, since the function name isn't a real
executable). Fix: either inline the actual logic as a literal string
(loses readability/reuse), or — cleaner when the function already lives
in the calling script itself — have the detached child re-invoke that
same script file with an internal-only subcommand that dispatches to the
function, rather than trying to hand the function itself across the
boundary. Hit in [[project_dwm-quickshell]]'s `dwm-quickshell-power`: a
`schedule()` helper backgrounds real teardown work via
`setsid sh -c "sleep 2; $1"`, so the scheduled string couldn't call
`end_all_sessions` directly — fixed by scheduling
`'dwm-quickshell-power end-all-sessions'` instead, letting the child
re-invocation load the function definitions fresh from the script file.
