---
name: python-development
description: Write, review, test, and package Python code: project layout, uv, ruff, pytest, type checking, error handling, safe subprocess and file use, dependencies, and CI commands. Use for Python scripts, tools, libraries, and pyproject.toml work; for LLM or agent applications use python-ai.
---

# Python Development

## Workflow

1. Read what exists first: `pyproject.toml`, the lock file (`uv.lock`, `poetry.lock`,
   `requirements*.txt`), `tox.ini` or `noxfile.py`, CI config, the README, and any
   `AGENTS.md`. The project's own tools win. Do not migrate an existing project to
   different tools (poetry to uv, mypy to pyright, requests to httpx) unless asked.
2. Name the commands you will run for lint, format check, types, tests, and the lock
   check, taken from the project's scripts or CI.
3. Make the smallest change in the existing style. Add or update tests for behavior
   you change; for a bug fix, see the test fail first.
4. Run the commands and fix causes. Do not silence rules or loosen types to pass.

## Defaults for a new project

Add only what the project actually needs.

| Task | Default | Notes |
| --- | --- | --- |
| Packages, venv, interpreter | uv | `uv init --package`, `uv add`, `uv run`; commit `uv.lock` |
| Lint and format | ruff | one tool for both |
| Tests | pytest | |
| Types | pyright, `standard` mode | `strict` for a new library; mypy if the team already uses it |
| Validate external data | pydantic v2 | only where data enters (files, HTTP, env); dataclasses or `TypedDict` inside |
| Settings from env | pydantic-settings | when pydantic is already in use |
| HTTP client | httpx | `httpx2` is on PyPI (github.com/pydantic/httpx2, "the next generation HTTP client"); use whichever the project already has and read its README before choosing for a new one |
| CLI | argparse, or typer for larger tools | |
| Logging | stdlib `logging`; structlog if structured logs are wanted | |
| Retries | tenacity | only when needed |

## Layout

`src/<package>/`, `tests/`, `pyproject.toml`, `uv.lock`. `uv init --package` creates the
`src` layout but not `tests/`.

## Commands

Verified 2026-11-07 in a throwaway project with uv 0.13.5, ruff 0.17.4, pytest 9.2.0,
pyright 1.1.414 (do not hard-code versions).

```sh
# local
uv run ruff check --fix . && uv run ruff format .
uv run pyright && uv run pytest

# CI: read-only, never --fix
uv sync --locked
uv lock --check
uv run --locked ruff check . && uv run --locked ruff format --check .
uv run --locked pyright && uv run --locked pytest
uv audit --locked        # experimental in uv 0.13: prints a preview warning
```

A working `pyproject.toml` baseline is in `references/pyproject-baseline.md`. Ruff's
auto-fix does not rewrap long lines; fix those by hand.

## Code rules

- Catch specific exceptions. No bare `except:`. Re-raise with `raise ... from err`.
  Never swallow an error to make a test pass.
- No mutable default arguments; use `None` and build the value inside.
- Use `pathlib` for paths and context managers for files, locks, and connections.
  Pass `encoding=` when opening text files.
- `subprocess`: pass a list, never `shell=True`, set a `timeout`, check the return
  code, and never build commands by concatenating user input.
- No `eval` or `exec`. Do not `pickle.load` untrusted data; use `yaml.safe_load`;
  validate member paths before extracting `tarfile` or `zipfile` archives.
- Give every network call a timeout, and validate and bound external data before use.
- Keep secrets in the environment or a secret store, never in source, logs, or
  defaults. Do not print environment dumps.
- Annotate public functions and anything that crosses a boundary. Prefer `X | None`
  and built-in generics.
- Keep modules free of import-time side effects and global mutable state; put
  entry points under `if __name__ == "__main__":`.
- Use `logging` in libraries and `print` only for CLI output.

## Working in a directory you did not write

Run Python that reads untrusted files with `python3 -I` (isolated mode: ignores the
script directory, `PYTHON*` variables, and the user site; confirmed
`sys.flags.isolated == 1`) and from a different directory than the files, because the
interpreter otherwise imports modules from the script or current directory. Do not
run a project's code, hooks, or install scripts just to inspect it.

## Dependencies

- Add with `uv add <pkg>` (`--dev` for tooling), keep ranges in `pyproject.toml`, exact
  versions in the lock file.
- Before adding a package, check the maintainer, the last release, and that the name
  is not a near-miss of a popular one.
- `uv audit --locked` reports known vulnerabilities.

## Testing

- Use plain pytest functions, `tmp_path`, `monkeypatch`, and `capsys`; parametrize
  instead of looping.
- Tests use no network and not the real home directory; patch time and randomness.
- Assert behavior, not implementation. A test that cannot fail proves nothing.

## Related skills

`$python-ai` for LLM and agent applications, `$bash-scripting` for shell, `$pr-readiness`
for merge gates.

## Validation

- Format check, lint, types, and tests pass with the project's own commands, or each
  skipped check is named.
- The lock file is consistent (`uv lock --check`).
- Report tool versions only if you ran them.
