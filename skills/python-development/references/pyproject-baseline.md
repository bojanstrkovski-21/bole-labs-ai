# pyproject.toml baseline

Verified 2026-11-07: this configuration parsed and ran cleanly with uv 0.13.5, ruff 0.17.4,
pytest 9.2.0, and pyright 1.1.414 in a throwaway `uv init --package` project, and ruff
flagged all four problems planted in a test file (unused import, mutable default argument,
`subprocess` with `shell=True`, `open()` instead of `Path.open()`). Adapt it; an existing
project's own configuration wins.

```toml
[dependency-groups]
dev = ["ruff", "pytest", "pyright"]        # uv add --dev ruff pytest pyright

[tool.ruff]
line-length = 100
src = ["src", "tests"]

[tool.ruff.lint]
select = ["E", "F", "I", "B", "UP", "N", "SIM", "PTH", "ARG", "C4", "RUF", "S"]

[tool.ruff.lint.per-file-ignores]
"tests/**" = ["S101", "ARG"]               # asserts and fixture arguments are normal in tests

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-ra --strict-markers --strict-config"

[tool.pyright]
include = ["src", "tests"]
typeCheckingMode = "standard"              # "strict" for a new library
```

What the rule families catch:

| Code | Family | Catches |
| --- | --- | --- |
| E, F | pycodestyle, pyflakes | style errors, unused imports and names |
| I | isort | import order |
| B | bugbear | likely bugs such as mutable default arguments |
| UP | pyupgrade | outdated syntax |
| N | pep8-naming | naming conventions |
| SIM | simplify | needlessly complex code |
| PTH | pathlib | `os.path` and `open()` where `pathlib` fits |
| ARG | unused arguments | arguments that are never used |
| C4 | comprehensions | clumsy comprehensions |
| RUF | ruff-specific | ruff's own checks |
| S | bandit | security issues such as `shell=True` |

Adopting this on an existing codebase: enable one family at a time and fix or baseline it,
so one change does not touch every file.
