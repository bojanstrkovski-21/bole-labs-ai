---
name: general_el_keymap_shorthand
description: "general.el's `(COMMAND :wk \"desc\")` shorthand only works for commands — binding an existing keymap symbol as a prefix needs the explicit `:keymap` key instead"
metadata: 
  node_type: memory
  type: project
  originSessionId: a3266242-e383-49f4-b52f-ee9bbd08f3a0
---

general.el's extended-definition shorthand `"key" '(SOMETHING :wk "desc")`
only unwraps correctly when `SOMETHING` is an actual command. If
`SOMETHING` is a keymap variable (e.g. `help-map`, `evil-window-map`) meant
to act as a prefix, that shorthand does **not** bind it as a keymap —
Emacs ends up with a bogus non-keymap, non-command value under that key,
and any further binding underneath it (e.g. `"h t"` after `"h"`) fails
with `Key sequence ... starts with non-prefix key ...`.

**Why**: hit this as a real, deterministic bug (not a timing race — an
`elpaca-wait` added right before `keybindings.el` changed nothing, which
is what proved it wasn't async-related) in
`emacs/modules/keybindings.el`: `"w" '(evil-window-map :wk "window")` and
`"h" '(help-map :wk "help")` were both wrong. Confirmed against general.el's
own docs: attaching a which-key description to an existing keymap requires
the explicit `:keymap` key: `'(:keymap help-map :wk "help")`. This was
almost certainly a mistranslation of Doom's `map!` DSL (which has its own
sugar for "bind this key to this keymap") into raw general.el syntax during
an earlier porting pass — the two aren't 1:1.

**How to apply**: in `archboki-doom-emacs-project/emacs/modules/
keybindings.el` (or any new module adding leader bindings), whenever
binding a key directly to an existing keymap symbol (as opposed to
`:ignore t` for a plain prefix-only submenu, or an actual interactive
command), always use `'(:keymap SOME-MAP :wk "desc")`, never the bare
`'(SOME-MAP :wk "desc")` shorthand. When debugging a "starts with
non-prefix key" error in this config, check for this pattern *before*
suspecting elpaca's async package timing — that's a different, separate
class of bug (see [[elpaca_async_gotcha]]) and easy to conflate.
