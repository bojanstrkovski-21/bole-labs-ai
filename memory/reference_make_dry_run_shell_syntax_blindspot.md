---
name: reference_make_dry_run_shell_syntax_blindspot
description: "make -n (dry-run) only prints recipe lines, it never executes them — a shell-syntax bug in a recipe (e.g. unescaped parens in an @echo) is invisible to -n and only surfaces on a real run"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-22T14:27:22.534Z
---

`make -n`/`--dry-run` prints what each recipe line *would* run without
actually invoking a shell on it — so it verifies variable expansion and
target ordering, but gives zero coverage for whether the resulting line is
even valid shell syntax. A concrete example that actually happened: an
`@echo installing foo (bar)` line (unescaped parentheses — `(`/`)` are
subshell metacharacters to `/bin/sh` outside quotes) dry-ran cleanly every
time but broke `make install` with `Error 2` on every real invocation,
undetected across multiple successful-looking dry-run verifications in
[[project_dwm-quickshell]]. To actually validate a recipe line's shell
syntax, either run the real target (even partially, e.g. against a scratch
`DESTDIR`) or extract the exact line and feed it to `/bin/sh -c` directly
as its own check — dry-run alone is not sufficient evidence a recipe will
actually execute.
