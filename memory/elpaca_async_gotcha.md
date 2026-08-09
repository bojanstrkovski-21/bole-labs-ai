---
name: elpaca_async_gotcha
description: "elpaca (this project's package manager) installs/activates packages asynchronously — code right after a use-package block, or even inside another package's own :config, can run before dependencies are actually ready"
metadata: 
  node_type: memory
  type: project
  originSessionId: a3266242-e383-49f4-b52f-ee9bbd08f3a0
---

Elpaca queues package installation/activation and only processes the queue
via `after-init-hook`, i.e. *after* the entire init file (and everything it
`load`s) has finished being read synchronously. Plain top-level code placed
right after a `use-package ... :ensure (...)` block is **not** guaranteed
the package is installed yet.

Two levels of this, discovered in order while debugging the same bug:

1. Top-level code after a `use-package` block is not guaranteed the
   package is ready — only code inside that package's own `:init`/
   `:config` body, or code gated behind `elpaca-wait` / the recipe's
   `:wait t` keyword, can rely on it being present.
2. **A single package's own `:config` body is not enough if the
   dependent code needs *other*, unrelated packages queued in the same
   startup batch to also be ready.** `:config` only guarantees *that
   one* package finished building — it does not serialize against
   sibling packages declared elsewhere in the same init run.

**Why**: hit both as a real bug in `emacs/modules/theme.el`. First pass:
`load-theme` was called at top level right after the `archboki-themes`
`use-package` block, and failed with "Unable to find theme file" —
`custom-theme-load-path` (set in that package's `:config`) hadn't been
updated yet. Fixed by moving `load-theme` into that `:config` body.
Second pass, on real VM testing (`archboki`/`bole-labs`): the *exact same
error* still happened intermittently — but `emacsclient` confirmed live
that `custom-theme-load-path` was correct, the theme file existed at the
expected path, and `(load-theme 'archboki-dark t)` run manually via
`emacsclient` succeeded seconds after the init-time failure. Root cause:
five theme packages (`doom-themes`, `archboki-themes`, `base16-theme`,
`ef-themes`, `modus-themes`) were all queued in the same startup batch;
`archboki-themes`'s own `:config` finishing doesn't mean elpaca has
settled everything else. Confirmed against elpaca's own README: use
`elpaca-after-init-hook` for "code that depends on multiple packages
being fully activated" — it only fires once elpaca has activated *every*
queued package. Final fix: moved `load-theme` out of any package's
`:config` entirely, into `(add-hook 'elpaca-after-init-hook (lambda ()
(load-theme archboki-theme t)))`.

**How to apply**: in `archboki-doom-emacs-project/emacs/`, for code that
depends on exactly one just-declared package and needs it immediately,
(a) put it in that package's own `:init`/`:config` body, (b) add `:wait t`
to its `:ensure` recipe, or (c) call `(elpaca-wait)` first — the pattern
already used in `init.el` for `general`/`which-key` before
`modules/keybindings.el` loads. But if the code depends on **multiple**
packages queued in the same batch (as with theme-loading, which pulls in
several theme collections at once), none of those are sufficient —
use `(add-hook 'elpaca-after-init-hook ...)` instead. Watch for this
specifically in `modules/theme.el` and any future module that touches
more than one elpaca package's output at startup.
