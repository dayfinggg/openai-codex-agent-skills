---
name: python
description: Gives current Python practice for uv, ruff, ty, and pytest, with Django and FastAPI references. Use it whenever you write, review, upgrade, or set up Python code, including dependencies, virtual environments, scripts, linting, formatting, type checking, and pytest tests. Use it for every Django or FastAPI change, because it routes to framework references.
license: MIT for SKILL.md (uv, ruff, and ty guidance from astral-sh/claude-code-plugins). Apache-2.0 for references/django-performance.md, adapted from getsentry/skills django-perf-review with headings and checklists converted to XML sections and prose, code comments moved to prose, the report template rewritten as prose, Sentry tooling references removed, one model example fixed, and a Django 6.1 fetch mode note added. See the distribution LICENSE.
---

<project_first>
The project's own Python version and tools come first, as `code_rules` requires. Read `requires-python` in `pyproject.toml`, `.python-version`, and the lockfile before you write code. The lockfile shows the package manager, such as `uv.lock`, `poetry.lock`, `pdm.lock`, `Pipfile.lock`, or plain `requirements*.txt`. The `pyproject.toml` tool tables and config files show the linter, formatter, type checker, and test runner. Use only syntax that the lowest allowed Python version supports. The modern defaults in this skill apply to new projects, or when the user asks for them.
</project_first>

<python_versions>
Python 3.15 is the current release. It came out on October 9, 2026, and 3.14 came out on October 7, 2025. A new project targets 3.14 or 3.15, as long as its main dependencies support that version.

Python 3.15 adds these features, as [What's New in 3.15](https://docs.python.org/3/whatsnew/3.15.html) lists.
- `lazy import json` and `lazy from pathlib import Path` defer the import until first use (PEP 810). They work only at module scope.
- UTF-8 is the default encoding when no `encoding` argument is given (PEP 686). `PYTHONUTF8=0` or `-X utf8=0` restores the locale encoding.
- `frozendict` is a built-in immutable mapping (PEP 814), and `sentinel` creates unique sentinel values (PEP 661).
- Comprehensions accept unpacking, as in `[*xs for xs in lists]` (PEP 798).
- The `profiling` package adds the `profiling.sampling` profiler and `profiling.tracing`, which replaces `cProfile` (PEP 799).
- Typing adds `TypedDict` with `extra_items` and `closed` (PEP 728), `TypeForm` (PEP 747), and disjoint bases (PEP 800).

Python 3.14 adds these features, as [What's New in 3.14](https://docs.python.org/3/whatsnew/3.14.html) lists.
- Annotations are evaluated lazily (PEP 649 and 749), so forward references need no quotes and no `from __future__ import annotations`. Read them with `annotationlib.get_annotations()`.
- Template strings such as `t"Hello {name}"` produce a `string.templatelib.Template` instead of a `str` (PEP 750). They let a library escape values safely, as for SQL or HTML.
- The free-threaded build without the GIL is officially supported (PEP 779).
- `compression.zstd` adds Zstandard compression (PEP 784), and `concurrent.interpreters` with `InterpreterPoolExecutor` adds subinterpreters (PEP 734).
- `except A, B:` works without parentheses when there is no `as` clause (PEP 758).
- A `return`, `break`, or `continue` that leaves a `finally` block emits a `SyntaxWarning` (PEP 765).
- On Unix other than macOS, the default `multiprocessing` start method is `forkserver`.
</python_versions>

<modern_code>
Modern Python code uses these defaults where the project has no other convention.
- Use built-in generics and union syntax, such as `list[int]`, `dict[str, Any]`, and `int | None`.
- Use type parameter syntax from Python 3.12, such as `def first[T](items: list[T]) -> T` and `type Pair = tuple[int, int]`.
- Mark overriding methods with `typing.override`, and return `typing.Self` from methods that return their own instance.
- Use `dataclasses` with `frozen=True` and `slots=True` for plain value types, and Pydantic models where data crosses a boundary.
- Use `pathlib.Path` for file paths, f-strings for formatting, and `match` for structural branching.
- Pass `encoding` explicitly when a file must be portable to Python 3.14 or older.
</modern_code>

<uv>
uv is the package and project manager from Astral. It replaces pip, pip-tools, pipx, pyenv, virtualenv, and Poetry. The current release is 0.13. Use uv when the project has `uv.lock` or a `[tool.uv]` table. A uv header in `requirements*.txt` files also shows it. Do not use uv in a project that Poetry or PDM manages, which `poetry.lock` or `pdm.lock` shows. Use that tool instead.

A project has `pyproject.toml` or `uv.lock`, and these commands manage it.
- `uv init` creates a new project. By default it uses a `src` layout and the `uv_build` build backend.
- `uv add requests` adds a dependency, and `uv add --dev pytest` adds it to the `dev` group.
- `uv remove requests` removes a dependency.
- `uv sync` installs the environment from the lockfile. In CI, `uv sync --locked` fails if the lockfile is out of date.
- `uv lock --upgrade-package requests` upgrades one locked package.
- `uv run <command>` runs a command in the project environment, and `uv run python -c "..."` runs Python there.
- `uv run -p 3.14 <command>` runs a command with a specific Python version.

A standalone script uses inline metadata (PEP 723), and these commands manage it.
- `uv run script.py` runs the script.
- `uv run --with requests script.py` runs it with an extra package.
- `uv add --script script.py requests` writes the dependency into the script's metadata.

`uvx <tool>` runs a command-line tool from PyPI without installing it, and `uvx <tool>@<version>` runs a specific version. It installs packages by name, so run only well-known tools. Use `uv tool install` only when the user asks for it.

The pip interface serves projects that keep `requirements.txt` files and have no `uv.lock`. It uses `uv venv`, `uv pip install -r requirements.txt`, `uv pip compile requirements.in -o requirements.txt`, and `uv pip sync requirements.txt`. Add `--universal` to `uv pip compile` for a platform-independent result. Do not add new `requirements.txt` files to a uv project.

In a uv project, these replacements apply.

| Instead of | Use |
| --- | --- |
| `pip install requests` | `uv add requests` |
| `python script.py` | `uv run script.py` |
| `python -c "..."` | `uv run python -c "..."` |
| `python3.12 -c "..."` | `uvx python@3.12 -c "..."` |
| `python -m venv .venv` and `source .venv/bin/activate` | `uv run <command>` |

These commands replace the older tools when the user asks to migrate.

| Old command | uv command |
| --- | --- |
| `pyenv install 3.14` | `uv python install 3.14` |
| `pyenv versions` | `uv python list --only-installed` |
| `pyenv local 3.14` | `uv python pin 3.14` |
| `pyenv global 3.14` | `uv python install 3.14 --default` |
| `pipx run ruff` | `uvx ruff` |
| `pipx install ruff` | `uv tool install ruff` |
| `pipx upgrade ruff` | `uv tool upgrade ruff` |
| `pipx list` | `uv tool list` |
| `pip install -r req.txt` | `uv pip install -r req.txt` |
| `pip freeze` | `uv pip freeze` |
| `pip-compile req.in` | `uv pip compile req.in` |
| `pip-sync req.txt` | `uv pip sync req.txt` |
| `virtualenv .venv` | `uv venv` |

The [uv documentation index](https://docs.astral.sh/uv/llms.txt) links to a page for each workflow.
</uv>

<ruff>
Ruff is Astral's linter and formatter. It replaces Flake8, isort, Black, pyupgrade, and autoflake. The current release is 0.17. Use it when the project has a `[tool.ruff]` table, a `ruff.toml`, or a `.ruff.toml` file. Run `uv run ruff` when ruff is a project dependency, so that the pinned version runs. Run `uvx ruff` when it is not a dependency.

Keep ruff's changes inside the task. If `ruff format --diff` changes a whole file, the project does not format with ruff. Leave that file unformatted. `ruff check --diff` shows the fixes for the code you change. Apply fixes only to the files you modify, unless the user asks for more.

These commands cover daily use.
- `ruff check .` lints the directory, and `ruff check path/to/file.py` lints one file.
- `ruff check --fix .` applies the safe fixes.
- `ruff check --select E,F .` checks only some rules, and `--ignore E501` skips one.
- `ruff rule E501` explains a rule.
- `ruff format .` formats the code, `ruff format --check .` only checks it, and `ruff format --diff .` shows the diff.

Run `ruff check --fix` before `ruff format`, because a lint fix can change the structure that the formatter then cleans up. Some fixes are unsafe because they can change behavior. For example, removing an unused import breaks code that relies on its side effects. Ruff 0.17 shows unsafe fixes by default, but applies them only with `--unsafe-fixes`. Preview them with `ruff check --fix --unsafe-fixes --diff .`, and read `ruff rule <CODE>` before you apply them.

This configuration in `pyproject.toml` enables rule sets beyond the defaults and sets the first-party package for import sorting.

```toml
[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B"]
ignore = ["E501"]

[tool.ruff.lint.isort]
known-first-party = ["myproject"]
```

Without a configured Python version, ruff 0.17 assumes Python 3.11. Set `requires-python` in `pyproject.toml` or `target-version` in the ruff table, so that `UP` rules match the project. Ruff maps the older tools directly. `black .` becomes `ruff format .`, `flake8 .` becomes `ruff check .`, and `isort .` becomes `ruff check --select I --fix .`. The [ruff documentation](https://docs.astral.sh/ruff/) lists every rule and setting.
</ruff>

<type_checking>
Use the type checker that the project already runs, such as mypy, Pyright, basedpyright, or ty. Its config sits in `pyproject.toml` or in `mypy.ini`, `pyrightconfig.json`, or `ty.toml`. Run it through the project's environment, as in `uv run mypy .`. For a new project, ty is the fast default from Astral. It is still versioned 0.0.x and renames rules at times, so pin its version.

ty runs as `uv run ty check` when it is a project dependency, and as `uvx ty check` otherwise. `ty check src/` or `ty check path/to/file.py` checks a part of the project. These options control the run.
- `--python-version 3.14` and `--python-platform linux` set the target environment.
- `--error <rule>`, `--warn <rule>`, and `--ignore <rule>` change the level of one rule.
- `--output-format concise` prints one line per diagnostic.

ty reads its configuration from `[tool.ty]` tables in `pyproject.toml` or from `ty.toml`. This example sets the target version, the checked paths, and two rule levels.

```toml
[tool.ty.environment]
python-version = "3.14"

[tool.ty.src]
include = ["src", "tests"]
exclude = ["**/migrations/**"]

[tool.ty.rules]
possibly-unresolved-reference = "warn"
division-by-zero = "error"
```

ty fails on warnings by default, and `error-on-warning = false` under `[tool.ty.terminal]` turns that off. The rule `unresolved-import` is now named `import-not-found`, and the old name still works as an alias. Fix type errors instead of suppressing them, as the `verification` block of the coding instructions requires. If the user asks for a suppression, use a rule-specific comment such as `# ty: ignore[import-not-found]`, not a blanket `# type: ignore`. The [ty documentation](https://docs.astral.sh/ty/) lists the rules.
</type_checking>

<pytest>
pytest is the default test runner, and its current release is 9.2. It needs Python 3.10 or later. Run one test with `uv run pytest tests/test_users.py::test_create -q`. The `tdd` and `testing` skills cover test design.

pytest 9 changed these behaviors, as the [changelog](https://docs.pytest.org/en/stable/changelog.html) shows.
- Configuration can use native TOML in a `[tool.pytest]` table, or in a `[pytest]` table in `pytest.toml`. The older `[tool.pytest.ini_options]` table still works, but a project cannot use both.
- `strict = true` turns on `strict_config`, `strict_markers`, `strict_parametrization_ids`, and `strict_xfail`. A new project sets it.
- The `subtests` fixture is built in and still marked experimental.
- Code that raised `PytestRemovedIn9Warning` now fails.
- pytest 9.2 makes the `indirect`, `ids`, and `scope` arguments of `parametrize` keyword-only.

This configuration fits a new project.

```toml
[tool.pytest]
strict = true
testpaths = ["tests"]
addopts = ["-ra"]
```
</pytest>

<framework_references>
Read the framework reference before you change code in a framework project. The dependencies in `pyproject.toml` or the lockfile show the framework.
- A Django project starts with [references/django.md](references/django.md). It covers Django 5.2 LTS, 6.0, and 6.1 facts and access control for views, Django REST framework, and the admin.
- A Django performance review, or work on slow views and querysets, uses [references/django-performance.md](references/django-performance.md). It finds N+1 queries, unbounded querysets, and missing indexes, and it validates each finding before it reports.
- A FastAPI project reads [references/fastapi.md](references/fastapi.md). It covers the FastAPI releases up to 0.162, dependencies, lifespan, request and response models, streaming, security, and testing.
</framework_references>
