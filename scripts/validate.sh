#!/usr/bin/env bash
# Validates repository structure, skills, configuration, and the installer.
# Adapted from ChrisTitusTech/titstack's validate.sh for this repository layout.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
errors=0

fail() {
  printf 'error: %s\n' "$1" >&2
  errors=$((errors + 1))
}

required_files=(
  "README.md"
  "AGENTS.md"
  "CLAUDE.md"
  "install.sh"
  "claude/CLAUDE.md"
  "codex/AGENTS.md"
  "codex/config.toml"
  "commands/start-session.md"
  "commands/end-session.md"
  "docs/SKILLS.md"
  "memory/MEMORY.md"
  "scripts/validate.sh"
  "scripts/test-install.sh"
  "scripts/check-rules.py"
  "codex/rules/default.rules"
)
for relative in "${required_files[@]}"; do
  [[ -f "$repo_root/$relative" ]] || fail "missing $relative"
done

# Skills: front matter, name matches directory, no placeholders, metadata file.
skill_count=0
actual_skills=""
for skill_dir in "$repo_root"/skills/*/; do
  skill_dir="${skill_dir%/}"
  name="$(basename "$skill_dir")"
  skill_file="$skill_dir/SKILL.md"
  skill_count=$((skill_count + 1))
  actual_skills+="$name"$'\n'
  rel="skills/$name"

  if [[ ! -f "$skill_file" ]]; then
    fail "missing $rel/SKILL.md"
    continue
  fi
  [[ "$(sed -n '1p' "$skill_file")" == "---" ]] || fail "$rel/SKILL.md has no YAML front matter"
  declared="$(sed -n '2,/^---$/s/^name: //p' "$skill_file" | sed -n '1p')"
  [[ "$declared" == "$name" ]] || fail "$rel/SKILL.md name '$declared' does not match its directory"
  sed -n '2,/^---$/p' "$skill_file" | grep -q '^description: .\+' || fail "$rel/SKILL.md has no description"
  ! grep -q '\[TODO:' "$skill_file" || fail "$rel/SKILL.md contains TODO placeholders"
  [[ -f "$skill_dir/agents/openai.yaml" ]] || fail "$rel has no agents/openai.yaml"
done
[[ $skill_count -gt 0 ]] || fail "no skills found under skills/"

# docs/SKILLS.md inventory must match the directories.
# shellcheck disable=SC2016
documented="$(sed -n '/^## Repository skills$/,/^## /p' "$repo_root/docs/SKILLS.md" |
  sed -n 's/^- `\([^`]*\)`$/\1/p' | sort)"
actual="$(printf '%s' "$actual_skills" | sort)"
[[ "$documented" == "$actual" ]] || fail "docs/SKILLS.md inventory does not match skills/"

# Codex TOML files must parse.
python_cmd=""
for candidate in python3 python; do
  if command -v "$candidate" >/dev/null 2>&1 &&
    "$candidate" -I -c 'import tomllib' >/dev/null 2>&1; then
    python_cmd="$candidate"
    break
  fi
done
if [[ -n "$python_cmd" ]]; then
  for toml in "$repo_root"/codex/*.toml; do
    "$python_cmd" -I -c 'import pathlib, sys, tomllib; tomllib.loads(pathlib.Path(sys.argv[1]).read_text())' "$toml" ||
      fail "invalid TOML in ${toml#"$repo_root"/}"
  done
  "$python_cmd" -I "$repo_root/scripts/check-rules.py" "$repo_root/codex/rules/default.rules" ||
    fail "codex/rules/default.rules failed the offline rules check"
else
  printf 'warning: Python 3.11+ not found; skipping TOML and rules checks\n' >&2
fi

# When Codex is installed, also use its own rules engine.
if command -v codex >/dev/null 2>&1 && codex --version >/dev/null 2>&1; then
  codex execpolicy check --rules "$repo_root/codex/rules/default.rules" git status >/dev/null ||
    fail "codex execpolicy rejected codex/rules/default.rules"
fi

# Shared policy must stay identical in intent across the Claude and Codex files.
if [[ -n "$python_cmd" ]]; then
  "$python_cmd" -I - "$repo_root/claude/CLAUDE.md" "$repo_root/codex/AGENTS.md" <<'PY' || fail "git/confirm-first policy differs between claude/CLAUDE.md and codex/AGENTS.md"
import pathlib, re, sys
required = [
    "State what you intend to change and why, then wait before touching any file",
    "Never run git commands (init, commit, push, branch, tag, remote) automatically",
    "anything that mutates history or a remote needs an explicit ask first",
    "Don't reach for `gh auth`, credential-helper, or SSH-agent commands",
    "Never force push. Never amend a published commit. Never create tags without being asked.",
]
bad = False
for path in sys.argv[1:]:
    text = re.sub(r"\s+", " ", pathlib.Path(path).read_text())
    for fragment in required:
        if fragment not in text:
            print(f"{path}: missing shared rule: {fragment}", file=sys.stderr)
            bad = True
sys.exit(1 if bad else 0)
PY
fi

# Runtime state and credentials must not be tracked.
if git -C "$repo_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git -C "$repo_root" ls-files | grep -Eq '(^|/)(auth\.json|history\.jsonl|installation_id|\.env|.*\.sqlite(-shm|-wal)?)$'; then
    fail "tracked runtime or credential files detected"
  fi
fi

# Shell scripts: syntax and ShellCheck.
scripts=("$repo_root/install.sh" "$repo_root/scripts/validate.sh" "$repo_root/scripts/test-install.sh")
bash -n "${scripts[@]}" || fail "Bash syntax validation failed"
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck "${scripts[@]}" || fail "ShellCheck failed"
else
  printf 'warning: shellcheck not found; skipping\n' >&2
fi

# Installer integration test (isolated temporary HOME).
bash "$repo_root/scripts/test-install.sh" || fail "installer integration test failed"

if [[ $errors -gt 0 ]]; then
  printf 'validation failed with %d error(s)\n' "$errors" >&2
  exit 1
fi
printf 'validation passed: %d skills checked\n' "$skill_count"
