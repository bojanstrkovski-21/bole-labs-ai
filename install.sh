#!/usr/bin/env bash
# Fans ~/.agents out to each tool's expected location, and can bootstrap a
# new project with the shared project-doc + Copilot templates.
#
# Usage:
#   ./install.sh              install/link for Claude (+ Codex if ~/.codex exists)
#   ./install.sh --dry-run    preview only, no changes
#   ./install.sh new-project <name> [--full-docs]   bootstrap a new project dir
set -euo pipefail

agents_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dry_run=false
backup_root="$HOME/.claude/backups/agents-install-$(date +%Y%m%d-%H%M%S)-$$"

run() {
  if "$dry_run"; then
    printf '+'; printf ' %q' "$@"; printf '\n'
  else
    "$@"
  fi
}

ensure_parent() { run mkdir -p "$(dirname "$1")"; }

# Same idempotent backup-then-symlink pattern as titus-ai's installer.
link_managed_path() {
  local source="$1" target="$2"
  [[ -e "$source" ]] || { printf 'error: missing source: %s\n' "$source" >&2; exit 1; }
  ensure_parent "$target"
  if [[ -L "$target" ]] && [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
    printf 'already linked: %s\n' "$target"; return
  fi
  if [[ -e "$target" || -L "$target" ]]; then
    local backup="$backup_root/${target#"$HOME"/}"
    ensure_parent "$backup"
    run mv "$target" "$backup"
    printf 'backed up: %s -> %s\n' "$target" "$backup"
  fi
  run ln -s "$source" "$target"
  printf 'linked: %s -> %s\n' "$target" "$source"
}

install_claude() {
  link_managed_path "$agents_root/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  for skill_dir in "$agents_root"/skills/*/; do
    name="$(basename "$skill_dir")"
    link_managed_path "${skill_dir%/}" "$HOME/.claude/skills/$name"
  done
}

install_codex() {
  # Dormant until Codex is actually installed/used again.
  [[ -d "$HOME/.codex" ]] || { printf 'skipping Codex: ~/.codex not found\n'; return; }
  link_managed_path "$agents_root/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
  link_managed_path "$agents_root/codex/rules" "$HOME/.codex/rules"
  for profile in "$agents_root"/codex/*.config.toml; do
    [[ -f "$profile" ]] || continue
    link_managed_path "$profile" "$HOME/.codex/$(basename "$profile")"
  done
  # config.toml is linked as-is here (unlike titus-ai's per-machine trust-entry
  # rendering) — rerun titus-ai's own installer separately if you need the
  # generated ~/github trust entries.
  link_managed_path "$agents_root/codex/config.toml" "$HOME/.codex/config.toml"
  # Codex already scans AGENTS_HOME/skills natively — with AGENTS_HOME
  # defaulting to ~/.agents, $agents_root/skills IS that path, so no linking
  # step is needed for skills when this repo lives at ~/.agents.
}

new_project() {
  local name="${1:?usage: install.sh new-project <name> [--full-docs]}"
  local style="single"
  [[ "${2:-}" == "--full-docs" ]] && style="full"
  local dir="$PWD/$name"
  [[ -e "$dir" ]] && { printf 'error: %s already exists\n' "$dir" >&2; exit 1; }

  run mkdir -p "$dir/.github/prompts"
  run cp -r "$agents_root/copilot/prompts/." "$dir/.github/prompts/"
  run cp "$agents_root/copilot/copilot-instructions.md" "$dir/.github/copilot-instructions.md"

  if [[ "$style" == "full" ]]; then
    run cp -r "$agents_root/docs/project-docs/." "$dir/"
  else
    run bash -c "sed 's/{{PROJECT_NAME}}/$name/g' '$agents_root/docs/PROJECT.template.md' > '$dir/PROJECT.md'"
  fi

  printf 'Created %s (docs: %s). This is a scaffold only — git init is NOT run here; say "start session" inside it and confirm when asked.\n' "$dir" "$style"
}

main() {
  local cmd="${1:-install}"
  case "$cmd" in
    --dry-run) dry_run=true; install_claude; install_codex ;;
    install) install_claude; install_codex ;;
    new-project) shift; new_project "$@" ;;
    *) printf 'usage: %s [--dry-run|install|new-project <name> [--full-docs]]\n' "$0" >&2; exit 2 ;;
  esac
}

main "$@"
