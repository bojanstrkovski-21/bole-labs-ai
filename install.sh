#!/usr/bin/env bash
# Fans ~/.agents out to each tool's expected location, and can bootstrap a
# new project with the shared project-doc + Copilot templates.
#
# Usage:
#   ./install.sh              install/link for Claude, and skills for the tools in
#                             SKILLS_ONLY_TOOLS whose config dir exists
#                             (+ Codex if ~/.codex exists)
#   ./install.sh --dry-run    preview only, no changes
#   ./install.sh --create-missing
#                             also create the config dir and skills links for
#                             SKILLS_ONLY_TOOLS and for Codex that are not installed
#                             yet (flags combine)
#   ./install.sh new-project <name> [--full-docs]   bootstrap a new project dir
set -euo pipefail

agents_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dry_run=false
create_missing=false

# Skills-only tools: "Name|config dir|skills dir". Add a line to support another.
SKILLS_ONLY_TOOLS=(
  "Grok|$HOME/.grok|$HOME/.grok/skills"
  "Gemini|$HOME/.gemini|$HOME/.gemini/skills"
  "Copilot|$HOME/.copilot|$HOME/.copilot/skills"
)
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

# Skills-only targets: link each skill into the tool's user skills directory.
# Skipped when the tool's config directory is absent, unless --create-missing.
install_skills_for() {
  local tool="$1" config_dir="$2" skills_dir="$3"
  if [[ ! -d "$config_dir" ]]; then
    if "$create_missing"; then
      printf 'creating %s: %s\n' "$tool" "$config_dir"
    else
      printf 'skipping %s: %s not found (use --create-missing)\n' "$tool" "$config_dir"
      return
    fi
  fi
  for skill_dir in "$agents_root"/skills/*/; do
    link_managed_path "${skill_dir%/}" "$skills_dir/$(basename "$skill_dir")"
  done
}

install_codex() {
  if [[ ! -d "$HOME/.codex" ]]; then
    if "$create_missing"; then
      printf 'creating Codex: %s\n' "$HOME/.codex"
    else
      printf 'skipping Codex: ~/.codex not found (use --create-missing)\n'
      return
    fi
  fi
  link_managed_path "$agents_root/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
  link_managed_path "$agents_root/codex/rules" "$HOME/.codex/rules"
  for profile in "$agents_root"/codex/*.config.toml; do
    [[ -f "$profile" ]] || continue
    link_managed_path "$profile" "$HOME/.codex/$(basename "$profile")"
  done
  # config.toml is seeded as a regular file only when none exists, so Codex's
  # own edits (model, MCP servers, project trust) never write through into this
  # repository and reinstalling never overwrites them.
  if [[ -e "$HOME/.codex/config.toml" || -L "$HOME/.codex/config.toml" ]]; then
    printf 'kept existing: %s\n' "$HOME/.codex/config.toml"
  else
    run cp "$agents_root/codex/config.toml" "$HOME/.codex/config.toml"
    printf 'seeded: %s\n' "$HOME/.codex/config.toml"
  fi
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
  run bash -c "sed 's/project=your-project-name/project=$name/' '$agents_root/copilot/set-git-cred.sh' > '$dir/set-git-cred.sh'"
  run cp "$agents_root/copilot/push.sh" "$dir/push.sh"
  run chmod +x "$dir/set-git-cred.sh" "$dir/push.sh"

  if [[ "$style" == "full" ]]; then
    run cp -r "$agents_root/docs/project-docs/." "$dir/"
  else
    run bash -c "sed 's/{{PROJECT_NAME}}/$name/g' '$agents_root/docs/PROJECT.template.md' > '$dir/PROJECT.md'"
  fi

  printf 'Created %s (docs: %s). This is a scaffold only — git init/set-git-cred.sh/push.sh are NOT run here, that stays yours to run; say "start session" inside it and confirm when asked.\n' "$dir" "$style"
}

install_all() {
  install_claude
  local entry name config_dir skills_dir
  for entry in "${SKILLS_ONLY_TOOLS[@]}"; do
    IFS='|' read -r name config_dir skills_dir <<<"$entry"
    install_skills_for "$name" "$config_dir" "$skills_dir"
  done
  install_codex
}

main() {
  local usage="usage: $0 [--dry-run] [--create-missing] | new-project <name> [--full-docs]"
  if [[ "${1:-}" == "new-project" ]]; then
    shift
    new_project "$@"
    return
  fi
  local arg
  for arg in "$@"; do
    case "$arg" in
      --dry-run) dry_run=true ;;
      --create-missing) create_missing=true ;;
      install) ;;
      *) printf '%s\n' "$usage" >&2; exit 2 ;;
    esac
  done
  install_all
}

main "$@"
