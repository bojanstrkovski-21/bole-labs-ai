---
name: native_comp_warning_hang
description: "emacsclient -c hanging forever (\"Server not responding\") can be caused by native-comp's warning-reporting path bogging down under a large volume of harmless compiler warnings, not an actual infinite loop in your config"
metadata: 
  node_type: memory
  type: project
  originSessionId: a3266242-e383-49f4-b52f-ee9bbd08f3a0
---

If `emacsclient -c`/`-t` hangs indefinitely ("Waiting for Emacs..." ->
"Server not responding; use Ctrl+C to break") against a daemon whose own
startup log looked completely clean, don't assume it's a logic bug in init
code. Reproduce it live and get a real backtrace before guessing:

```
emacs --daemon=NAME            # in one terminal
sudo gdb -p $(pgrep -f daemon=NAME)   # attach (pauses it)
(gdb) continue                 # resume
# in another terminal: emacsclient -s NAME -c   (triggers the hang)
# back in the gdb terminal: Ctrl+C, then:
(gdb) bt
```

On Arch, get real function names instead of all `??` frames with:
`DEBUGINFOD_URLS="https://debuginfod.archlinux.org" sudo -E gdb ...`
(plain `sudo gdb` does NOT inherit your shell env, hence `-E`).

**Why**: hit this in `archboki-doom-emacs-project/emacs/`. Two backtrace
samples, taken seconds apart, showed the identical stack both times:
`server-process-filter` -> `server-return-error` ->
`server--message-sit-for` -> `sit-for` ->
`comp--accept-and-process-async-output` (with `re_search_2`, Emacs's C
regex engine, directly beneath it). That function parses warnings/errors
out of native-comp subprocess output via regex. This config installs
~40 packages via elpaca, several of which (general.el, evil-mc,
persp-mode, centaur-tabs) throw a lot of harmless "not known to be
defined" forward-reference warnings during native compilation. With that
much warning volume, the reporting path got invoked while the server was
separately trying to report an unrelated error back to a connecting
client, and it bogged down badly enough to look like an infinite hang —
first repro (fresh install, packages compiling for the first time) hit
28.9GB RSS / 88% of system RAM before being killed, genuinely close to a
full OOM. A second run with everything already elpaca-cached still hung,
just at far lower memory (1.3GB) — proving it wasn't purely "fresh-install
compile storm," there's a real, repeatable mechanism tied to warning
volume specifically.

**Fix applied**: `(setq native-comp-async-report-warnings-errors 'silent)`
in `early-init.el`, set early (before any package loads/compiles). Errors
still surface; only the noisy "not known to be defined" warnings are
silenced. Confirmed immediately after: `emacsclient -c` opened a real
frame cleanly on the first try.

**How to apply**: if this recurs (e.g. after adding more packages to
`archboki-doom-emacs-project/emacs/`), check `native-comp-async-report-
warnings-errors` is still set to `'silent` before chasing it as a new bug.
More generally: an `emacsclient` hang with a clean daemon startup log is a
different class of bug from an init-time error — go straight to a live gdb
backtrace (per the recipe above) rather than guessing at config logic,
since the actual cause may be in Emacs's own C/native-comp internals
reacting badly to something in the config, not a straightforward Lisp bug
you can find by reading files.
