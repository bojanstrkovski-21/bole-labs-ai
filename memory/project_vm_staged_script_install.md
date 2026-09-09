---
name: project_vm_staged_script_install
description: "Reusable VM deploy workflow for quickshell-scripts/*+quickshell-configs/* changes — THREE copies must stay in sync (live ~/.config/, root-owned /usr/local/bin via vm-install-staged.sh, and the checkout itself, which any dwm.c rebuild's make install reads from and will silently revert the other two if skipped)"
metadata: 
  node_type: memory
  type: project
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-09-08T15:46:00.249Z
---

[[project_dwm-quickshell]]'s test VM (`archboki-vm`, `bole-labs@192.168.122.81`)
installs `quickshell-scripts/*` backend commands into the root-owned
`/usr/local/bin`, and `bole-labs` has no passwordless sudo there — so a
plain `scp` of an updated backend script can't land directly in place.

**The reusable workflow** (built 2026-08-15, Session 12, after first doing
this ad hoc for the Network Wi-Fi security overhaul):
1. From the dev machine: `scp quickshell-scripts/<name> archboki-vm:~/<name>.new`
   (stages it in the user's home dir, no sudo needed for this step).
2. On the VM, run the already-deployed `~/vm-install-staged.sh` (source of
   truth tracked in the repo at `vm-install-staged.sh`, matching
   `dwm-titus-sync.sh`'s repo-root-utility-script precedent) — it sweeps
   every pending `*.new` file in `$HOME`, `sudo cp`s each to
   `/usr/local/bin/<name>`, `chmod 755`s it, and removes the staging copy.
   One sudo prompt per run (sudo caches it across a batch of several
   staged files).

**How to apply:** next time a `quickshell-scripts/*` backend script needs
a VM-side update, stage it with `scp ... archboki-vm:~/<name>.new` and
just tell the user to run `./vm-install-staged.sh` again — don't
regenerate one-off `sudo cp`/`rm` commands or recreate the script. If the
VM's copy of `vm-install-staged.sh` itself is ever missing or stale,
redeploy it from the repo's own `vm-install-staged.sh` (it's tracked
there, not VM-only).

**Second install location, found the hard way (Session 14, 2026-08-20):**
`/usr/local/bin` is not the *only* place a `quickshell-scripts/*` script
lives on the VM — the checkout's own `Makefile` (`~/.config/chadboki-qswm`
on the VM since Session 21's 2026-09-07 rename, was `~/.config/chadwm-boki`
before that) installs the same scripts from `~/.config/quickshell-scripts/`
(a separate, user-writable copy) every time `sudo make install` runs, which
every real `./rebuild` does. Patching
only `/usr/local/bin` via the workflow above looks like it worked (the fix
is live immediately) but silently reverts on the very next rebuild, since
that overwrites `/usr/local/bin` from the stale `~/.config/
quickshell-scripts/` copy. Cost a full round of wasted user testing before
being caught by directly `grep`-ing the reinstalled binary. **Fix any
`quickshell-scripts/*` script in both places**: `scp` it to
`~/.config/quickshell-scripts/<name>` directly (no sudo, user-owned) *and*
stage+install it to `/usr/local/bin` via the workflow above — checksum-diff
both against the repo afterward to confirm they agree.

**Third install location + correction, found the hard way again (Session
23, 2026-09-08):** the "Second install location" note above is now stale
about *which* directory the Makefile reads from — Session 22's repo
restructure moved `quickshell-scripts/`/`quickshell-configs/` in-tree
under the checkout itself, so `sudo make install` (run for *any* `dwm.c`
rebuild, not just a scripts/QML change) copies from
`~/.config/chadboki-qswm/quickshell-scripts/` (the checkout, tracked by
its own `Makefile`'s `QSSCRIPTS` var) — **not** a separately-standing
`~/.config/quickshell-scripts/`. That path (and `~/.config/
chadboki-qswm/quickshell-configs/` for QML, via `QSCONFIGS`) is the real
third copy. Confirmed to also apply to `quickshell-configs/*` (QML), not
just backend scripts — `make install` does `cp -rf quickshell-configs/.
~/.config/quickshell/`, so a QML-only fix deployed straight to
`~/.config/quickshell/` (the normal fast/no-sudo path for QML) gets
silently reverted the next time *any* `dwm.c` change gets rebuilt, even
though the QML fix itself has nothing to do with `dwm.c`. Full fix now
needs all three kept in sync: `~/.config/quickshell-scripts|quickshell`
(live, no sudo), `/usr/local/bin` (via `vm-install-staged.sh`), and
`~/.config/chadboki-qswm/quickshell-scripts|quickshell-configs` (the
checkout itself — a plain `scp`/`rsync`, user-owned, no sudo needed for
this one either). See [[project_dwm-quickshell]]'s own `CLAUDE.md` for
the full three-copy rule.
