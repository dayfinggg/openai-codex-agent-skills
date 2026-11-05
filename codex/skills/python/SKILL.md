---
name: python
description: Implements and tests Python changes with interpreter, typing, packaging, and asyncio checks. Use when editing or creating .py files, Python scripts or packages, pytest or unittest tests, pyproject.toml, or when the user mentions Python, Django, FastAPI, mypy, or a Python environment mismatch.
---

1. Before editing, run `python --version` through the project's environment runner and `python -c "import sys; print(sys.executable); print(sys.prefix)"`. Read `pyproject.toml`, existing requirements or lockfiles, `.python-version`, test settings, and CI. Establish the minimum supported Python, build backend, dependency groups, and installed framework versions. `requires-python` constrains installation, classifiers do not. Read version-matched documentation for changed Django, FastAPI, SQLAlchemy, or stdlib APIs.

2. For implementation or dependency work, read [the shared procedure](references/common.md). For a version-only question, inspect the environment without installing or updating packages. Use `python -m pip show PACKAGE` in pip environments, or the existing manager's installed-package inspection. A lockfile records resolution, not proof of what the active interpreter imports.

3. Preserve exception types, result shapes, missing-value semantics, and external serialization. Distinguish `None` from false or empty values. Avoid mutable defaults, shared class-level mutable data, and generators consumed twice. Follow existing annotations and narrow types from actual checks. Do not silence mismatches with `Any`, casts, or ignores. Syntax and typing APIs must work at the supported minimum, not just locally.

4. For async changes, identify who owns, cancels, and awaits every task. Use context managers or `try/finally` for files, sessions, and connections. Propagate `asyncio.CancelledError` after cleanup. Keep blocking clients off the event loop using the established mechanism. A thread offload does not make the operation cancellable. Check ORM-session scope and sharing across tasks. Exercise cancellation, failure cleanup, and task termination on the changed path.

5. Preserve the existing manager. With uv, restore using `uv sync --locked` and run checks with `uv run --locked` so a check cannot silently rewrite `uv.lock`. Exact sync removes unselected packages, so use the project environment and required groups. With pip, use the selected interpreter's `python -m pip install -r requirements.txt` only when that is the project's declared dependency source. Requirements with ranges are not a reproducible lock. For authorized updates, use the existing resolver and review manifest, lock, markers, extras, and transitive changes together. Keep system packages separate.

6. Before reporting a code change, run the repository's affected test command. For a pytest project, use `python -m pytest PATH` with the real affected test path. Run configured typing, lint, and formatting checks too. Where already configured, use `python -m mypy PATH`, `ruff check PATH`, and `ruff format --check PATH` through the same environment. Retain Black, Pyright, or other existing tools instead of adding replacements. Do not impose a stricter configuration. For packages, test supported Python versions when API availability or packaging changes.

Consult [asyncio cancellation](https://docs.python.org/3/library/asyncio-task.html), [pyproject metadata](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/), and [uv locking](https://docs.astral.sh/uv/concepts/projects/sync/) when those boundaries change.
