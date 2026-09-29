# Python

## Defaults for every file

- Full type hints with builtin generics and unions: `list[int]`, `dict[str, User]`, `X | None`, `collections.abc.Callable`.
- `pathlib.Path` for file paths, f-strings for formatting, `dataclasses` or the project's model library for records.
- `asyncio.TaskGroup` and `asyncio.timeout()` for concurrent work instead of bare `gather`.
- Project metadata and tool config in `pyproject.toml`. Dev dependencies in `[dependency-groups]`.
- Change dependencies with `uv add` and `uv remove`, not by editing `pyproject.toml` by hand or with `uv pip install`. Run everything through `uv run` instead of activating the virtual environment.
- A standalone script with dependencies declares them inline with PEP 723: `uv add --script tool.py httpx` writes the `# /// script` block, and `uv run tool.py` runs it without a project.

## Features by version

Use what the project's `requires-python` allows.

| Version | Use |
|---|---|
| 3.11+ | `Self`, `TaskGroup`, `asyncio.timeout`, `tomllib`, exception groups |
| 3.12+ | Type parameter syntax `def first[T](items: list[T]) -> T`, `class Box[T]`, `type Alias = ...`, `@override` |
| 3.14+ | Deferred annotations, so forward references need no quotes and no `from __future__ import annotations`, `except A, B:` without parentheses, t-strings |

## Errors and resources

- Raise specific exceptions and chain them with `raise NewError(...) from err`. Never write a bare `except:` or `except Exception: pass`.
- Manage files, locks and connections with `with` or `async with`.
- Pass an explicit `timeout` to every `httpx` or `requests` call, because `requests` never times out by default.
- Log with the `logging` module, not `print`.
- In async code never call blocking functions directly. Move them to a thread with `asyncio.to_thread`.

## Size and complexity limits

Enable Ruff's `C901`, `PLR0911`, `PLR0912`, `PLR0913` and `PLR0915` when the project has no limits of its own. Their defaults are complexity 10, 6 return statements, 12 branches, 5 arguments and 50 statements. Line length stays at Ruff's default of 88. Keep modules under about 300 lines.

## Outdated patterns

Do not write `typing.List`, `Dict`, `Optional`, `Union`, `TypeAlias`, standalone `TypeVar` boilerplate on 3.12+, `setup.py` for new projects, `python setup.py install`, a Black, isort and Flake8 stack, or `os.path` string juggling where `pathlib` fits.

## Fallback commands

- Environment and dependencies: `uv sync`, `uv add pkg`, `uv add --dev pkg`, `uv run ...`. Commit `uv.lock`.
- Lint and format: `uv run ruff check --fix` then `uv run ruff format`. Select at least `E`, `F`, `UP`, `B`, `SIM`, `I`.
- Types: `uv run mypy --strict .` or `uv run pyright`, whichever the project configures. Use `ty` only where the project already does, because it has not reached a stable release.
- Tests: `uv run pytest`.
- Known vulnerabilities in dependencies: `uv run --with pip-audit pip-audit`, which audits the project's environment.
