"""Offline check of codex/rules/*.rules.

Codex rules are Starlark, a Python subset. This runs a rules file with a stub
prefix_rule that mirrors Codex's documented semantics (exact-prefix match,
union lists per position, strictest decision wins) and verifies:
  - every rule's match/not_match examples behave as declared, and
  - the policy cases below resolve to the expected decision.
It complements, and does not replace, `codex execpolicy check` when Codex is
installed.
"""
import pathlib
import shlex
import sys

ORDER = {"allow": 0, "prompt": 1, "forbidden": 2}
rules = []
errors = []


def prefix_rule(pattern, decision="allow", justification=None, match=(), not_match=()):
    if decision not in ORDER:
        errors.append(f"invalid decision {decision!r} in rule {pattern!r}")
        return
    rules.append((pattern, decision, list(match), list(not_match)))


def matches(pattern, argv):
    if len(argv) < len(pattern):
        return False
    for want, got in zip(pattern, argv):
        options = want if isinstance(want, list) else [want]
        if got not in options:
            return False
    return True


def decide(command):
    argv = shlex.split(command)
    found = [d for p, d, _, _ in rules if matches(p, argv)]
    return max(found, key=ORDER.__getitem__) if found else None


def main(path):
    source = pathlib.Path(path).read_text()
    exec(compile(source, path, "exec"), {"prefix_rule": prefix_rule})
    if not rules:
        errors.append("no rules defined")
    for pattern, _, match, not_match in rules:
        for cmd in match:
            if not matches(pattern, shlex.split(cmd)):
                errors.append(f"match example does not match {pattern!r}: {cmd}")
        for cmd in not_match:
            if matches(pattern, shlex.split(cmd)):
                errors.append(f"not_match example matches {pattern!r}: {cmd}")

    expectations = {
        "rg --files": "allow",
        "git status": "allow",
        "git diff --check": "allow",
        "git commit -m x": "prompt",
        "git push origin main": "prompt",
        "git tag v1": "prompt",
        "git push --force": "forbidden",
        "git push -f origin main": "forbidden",
        "git reset --hard": "forbidden",
        "git clean -fd": "forbidden",
        "gh auth status": "forbidden",
        "git credential fill": "forbidden",
        "ssh-add -l": "forbidden",
        "gh repo delete o/r": "forbidden",
        "gh pr create": "prompt",
        "gh pr view 1": "prompt",
        "sudo ls": "prompt",
        "bash -lc 'git push'": None,
    }
    for cmd, want in expectations.items():
        got = decide(cmd)
        if got != want:
            errors.append(f"policy: {cmd!r} -> {got}, expected {want}")

    for message in errors:
        print(f"error: {message}", file=sys.stderr)
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1]))
