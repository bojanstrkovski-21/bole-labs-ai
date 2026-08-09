---
name: project-archboki
description: "archboki-bash-improved — improving boki's bash config by comparing with erik and chris reference configs, goal is multi-distro portability"
metadata: 
  node_type: memory
  type: project
  originSessionId: 9eca6ad6-95e8-43c4-8445-7802794d7494
---

Goal: Improve boki's bash/alias config by cherry-picking the best from erik's and chris's configs. End result should work on Arch, Debian, Fedora, openSUSE, Void.

**Why:** Boki's config was scattered and lacked many useful functions. Erik and chris use a zachbrowne.me template with good portable functions.

**How to apply:** When suggesting changes, keep the multi-distro alias file structure intact. General stuff goes in `.bashrc`, distro-specific aliases go in `.config/bash_aliases/<distro>-aliases`.

---

## File Structure

```
boki/
  .bashrc                          — main config (restructured with section headers)
  .bash_profile                    — sources .bashrc + cargo env
  .profile                         — cargo env only
  .config/bash_aliases/
    common-aliases                 — general aliases for all distros
    arch-aliases                   — arch/arcolinux specific only
    debian-aliases
    fedora-aliases
    opensuse-aliases
    void-aliases
    xmonad-aliases
chris/bashrc.txt                   — reference config (zachbrowne.me template)
erik/bashrc-latest.txt             — reference config (same template, slightly different)
```

## .bashrc Section Headers (in order)

1. `### ENVIRONMENT` — exports, PATH, /etc/bashrc source, XDG, HIST vars
2. interactive guard `[[ $- != *i* ]] && return`
3. `### SHELL OPTIONS` — shopt (checkwinsize, histappend, autocd, cdspell, cmdhist, dotglob, expand_aliases), PROMPT_COMMAND, starship/zoxide/fzf, Tilix/VTE
4. `### COMPLETION` — bind commands, bash-completion, carapace
5. `### MANPAGE COLORS` — LESS_TERMCAP vars
6. `### ALIASES` — sources alias files only (no inline aliases here)
7. `### FUNCTIONS` — all functions
8. `### TOOLS` — NVM, Python paths, cargo env
9. `### PROMPT` — `__setprompt` block commented out (starship is primary prompt)

## What was done in session 2026-06-07

- Compared boki vs erik: tables of same/different
- Compared boki vs chris: same/different tables
- Added to .bashrc: section headers, `/etc/bashrc` source, XDG vars, HIST vars, `checkwinsize`, `PROMPT_COMMAND`, LESS_TERMCAP colors, `vi/eb/mkdir/ping/less/home/topcpu/checkcommand/openports/kssh/sha1/countfiles/h/p/f/diskspace/folders/folderssort/tree/treed/mountedinfo/logs/rmd` aliases, chmod aliases (mx,000,644,666,755,777), nav aliases (..,  ..., etc), archive creation aliases, `cp/mv/rm` safe ops, `ftext/cpg/mvg/mkdirg/up/trim/cpp/distribution/ver/install_bashrc_support/path_add_first` functions, updated `my_ip` with internal+external, `bell-style none` bind, Ctrl-F→zi bind
- Removed from .bashrc: `export PATH=$PATH:~/.cargo/bin/` (duplicate), duplicate NVM completion source, QT_QPA_PLATFORMTHEME (commented out), `pamac-unlock` alias (moved to arch-aliases only)
- Added to arch-aliases: eza ls aliases (replacing broken ls block), `gcom()`/`lazyg()` git functions, `###btrfs/snapper/leftwm###` section headers
- Removed from arch-aliases: rmlogoutlock, iso/isoo, rvariety/rkmix/rconky, downgrada, arcolinux app aliases (adt/abl/agm etc), personal

## Duplicate cleanup done 2026-06-07 (session 2)

Duplicates found and resolved:
- arch-aliases: removed second `ff="fastfetch"` (kept line 19, removed line 175 block)
- arch-aliases: removed first `rg` + `jctl` block (kept the second occurrence lower in file)
- arch-aliases: removed entire edu-fix-... aliases block (keyfix/key-fix/keys-fix/fixkey/fixkeys/fix-key/fix-keys/fix-pacman-conf/fix-pacman-keyserver) — kept arcolinux-fix-... versions
- cross-file: `pamac-unlock` removed from .bashrc, kept in arch-aliases only

## Resolved in session 2026-06-08

- `__setprompt` block fully commented out by user — starship is the prompt, this is dead code
- `alias cpu` in .bashrc renamed to `alias cpuzz` (proc/stat CPU usage %) — no conflict with arch-aliases `cpu` (cpuid microarch)
- `PROMPT_COMMAND='history -a'` confirmed working — starship preserves it via `STARSHIP_PROMPT_COMMAND` and calls it inside `starship_precmd`

## Done in session 2026-06-08 (session 3)

- Created `common-aliases` — all general aliases that work on any distro (179 lines)
- Rewrote `arch-aliases` — stripped to Arch/boki-specific only (230 lines)
- Moved `shopt` block (autocd, cdspell, cmdhist, dotglob, expand_aliases) from arch-aliases → .bashrc SHELL OPTIONS
- Removed all inline aliases from .bashrc ALIASES section — now only source lines remain
- Added `common-aliases` source line to .bashrc (loaded before distro-specific files)
- `cpuzz` alias added to .bashrc for proc/stat CPU usage percentage

## Done in session 2026-06-08 (session 4)

- Ported all missing bash aliases/functions from common-aliases → boki-fish/fish/config.fish:
  - nvim: `nv`, `snv`, `vi`; shell: `x`; date: `da`
  - navigation: `..`, `...`, `....`, `.....`, `home`
  - safe file ops: `cp`, `mv`, `rm`, `rmd`, `mkdir`
  - chmod: `mx`, `chmo`, `000`, `644`, `666`, `755`, `777`
  - eza block expanded from 3 → 17 aliases (added `lx`, `lk`, `lc`, `lu`, `lr`, `lt`, `lm`, `lw`, `labc`, `lf`, `ldir`; improved existing `ls`/`la`/`ll`/`l`/`l.`/`listdir` with eza flags)
  - `ping`, `openports`, `kssh`
  - `topcpu`, `checkcommand` (mapped to `type`), `p`, `h`, `f`, `sha1`
  - `diskspace`, `folders`, `folderssort`, `mountedinfo`, `tree`, `treed`, `multitail`
  - archive: `mktar`, `mkbz2`, `mkgz`, `untar`, `unbz2`, `ungz`
  - git: `gc`, `gf`, `ga`, `gm`, `gp`
  - functions: `gcom`, `lazyg`, `countfiles` (fish syntax with `$argv[1]`, `string sub`)
- Fixed starship in fish: uncommented `starship init fish | source` in both project and live config
- Fixed `logs` alias: converted from alias to `function logs` — fish expands `$` inside double-quoted alias strings even with inner single quotes
- All fixes applied to both project file AND live `~/.config/fish/config.fish`

## Key fish gotcha (save for future)

`alias foo="... | grep '[0-9]$' ..."` — fish expands `$` inside double quotes even when surrounded by inner single quotes. Fix: convert to `function`.

## Open / unresolved items

- `alias vim='nvim'` — not yet added (user has `vi` but not `vim`)
- `yayf` fzf yay browser — not discussed yet
- `bd='cd "$OLDPWD"'` — not added yet
- docker-clean — not added, user aware it has no confirmation
- `svi`, `vis`, `spico`, `snano` — not decided
- Other distro alias files (debian, fedora, opensuse, void) — not started
