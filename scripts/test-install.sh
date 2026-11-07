#!/usr/bin/env bash
# Exercises install.sh in an isolated temporary HOME: dry-run safety, correct
# links, backups, and idempotence. Never touches the real HOME.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_home="$(mktemp -d)"
trap 'rm -rf "$tmp_home"' EXIT
errors=0

fail() {
  printf 'error: %s\n' "$1" >&2
  errors=$((errors + 1))
}

run_install() { HOME="$tmp_home" "$repo_root/install.sh" "$@"; }

# 1. Dry run changes nothing.
run_install --dry-run >/dev/null
if [[ -n "$(find "$tmp_home" -mindepth 1 -print -quit)" ]]; then
  fail "dry run created files under the temporary HOME"
fi

# 2. Real install links CLAUDE.md and every skill.
run_install >/dev/null
[[ "$(readlink -f "$tmp_home/.claude/CLAUDE.md")" == "$repo_root/claude/CLAUDE.md" ]] ||
  fail "CLAUDE.md is not linked to the repository copy"
for skill_dir in "$repo_root"/skills/*/; do
  name="$(basename "$skill_dir")"
  [[ "$(readlink -f "$tmp_home/.claude/skills/$name")" == "${skill_dir%/}" ]] ||
    fail "skill not linked: $name"
done

# 3. Second run is idempotent: nothing replaced, nothing backed up.
second="$(run_install)"
grep -q '^backed up:' <<<"$second" && fail "second install backed up an already-correct link"
grep -q '^linked:' <<<"$second" && fail "second install relinked an already-correct link"

# 4. An existing real file is backed up, not lost.
rm "$tmp_home/.claude/CLAUDE.md"
printf 'local\n' >"$tmp_home/.claude/CLAUDE.md"
run_install >/dev/null
backup="$(find "$tmp_home/.claude/backups" -name CLAUDE.md -print -quit 2>/dev/null || true)"
[[ -n "$backup" && "$(cat "$backup")" == "local" ]] || fail "existing CLAUDE.md was not backed up"

# 5. Skills-only targets and Codex config are handled only when their dirs exist.
mkdir -p "$tmp_home/.grok" "$tmp_home/.codex"
printf 'model = "local"\n' >"$tmp_home/.codex/config.toml"
run_install >/dev/null
for skill_dir in "$repo_root"/skills/*/; do
  name="$(basename "$skill_dir")"
  [[ "$(readlink -f "$tmp_home/.grok/skills/$name")" == "${skill_dir%/}" ]] ||
    fail "Grok skill not linked: $name"
done
[[ ! -e "$tmp_home/.gemini" ]] || fail "Gemini directory was created although absent"
[[ "$(cat "$tmp_home/.codex/config.toml")" == 'model = "local"' && ! -L "$tmp_home/.codex/config.toml" ]] ||
  fail "existing Codex config.toml was modified or linked"
rm "$tmp_home/.codex/config.toml"
run_install >/dev/null
[[ -f "$tmp_home/.codex/config.toml" && ! -L "$tmp_home/.codex/config.toml" ]] ||
  fail "Codex config.toml was not seeded as a regular file"

# 6. --create-missing: dry run creates nothing; a real run creates the skills-only
#    tools' dirs and links, including Codex.
fresh="$(mktemp -d)"
trap 'rm -rf "$tmp_home" "$fresh"' EXIT
mkdir -p "$fresh/.claude"
HOME="$fresh" "$repo_root/install.sh" >/dev/null
[[ ! -e "$fresh/.grok" && ! -e "$fresh/.gemini" && ! -e "$fresh/.copilot" ]] ||
  fail "skills-only tool dirs were created without --create-missing"
HOME="$fresh" "$repo_root/install.sh" --dry-run --create-missing >/dev/null
[[ ! -e "$fresh/.grok" ]] || fail "dry run with --create-missing created files"
HOME="$fresh" "$repo_root/install.sh" --create-missing >/dev/null
for tool in .grok .gemini .copilot; do
  for skill_dir in "$repo_root"/skills/*/; do
    name="$(basename "$skill_dir")"
    [[ "$(readlink -f "$fresh/$tool/skills/$name")" == "${skill_dir%/}" ]] ||
      fail "$tool skill not linked with --create-missing: $name"
  done
done
[[ -f "$fresh/.codex/config.toml" && ! -L "$fresh/.codex/config.toml" ]] ||
  fail "--create-missing did not seed Codex config.toml"
[[ "$(readlink -f "$fresh/.codex/AGENTS.md")" == "$repo_root/codex/AGENTS.md" ]] ||
  fail "Codex AGENTS.md not linked with --create-missing"
[[ "$(readlink -f "$fresh/.codex/rules")" == "$repo_root/codex/rules" ]] ||
  fail "Codex rules not linked with --create-missing"
HOME="$fresh" "$repo_root/install.sh" new-project >/dev/null 2>&1 && fail "new-project without a name should fail"
HOME="$fresh" "$repo_root/install.sh" --bogus >/dev/null 2>&1 && fail "unknown flag should fail"

if [[ $errors -gt 0 ]]; then
  printf 'install test failed with %d error(s)\n' "$errors" >&2
  exit 1
fi
printf 'install test passed\n'
