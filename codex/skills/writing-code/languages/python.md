# Python

## Runtime and conventions

- Follow the project's Python version, type hints, environment and package manager. Prefer builtin generics, `pathlib`, f-strings and dataclasses where supported and useful. Do not convert unrelated code or introduce `uv` just for a fix.
- Do not share mutable defaults between calls or instances. Use `None` or a distinct sentinel for function defaults and `default_factory` for dataclass fields.
- Distinguish `None` from valid zero, false and empty collections. Preserve caller-owned mutation when it is part of the contract.

## Features by version

Use what the project's `requires-python` allows.

| Version | Use |
|---|---|
| 3.11+ | `Self`, `TaskGroup`, `asyncio.timeout`, `tomllib`, exception groups |
| 3.12+ | Type parameter syntax `def first[T](items: list[T]) -> T`, `class Box[T]`, `type Alias = ...`, `@override` |
| 3.14+ | Deferred annotations and t-strings, when the project's libraries and tools support them |

## Errors and resources

- Raise specific exceptions and chain them with `raise NewError(...) from err`. Never write a bare `except:` or `except Exception: pass`.
- Manage files, locks and connections with `with` or `async with`.
- Pass an explicit `timeout` to every `httpx` or `requests` call, because `requests` never times out by default.
- Use the project's logger for application diagnostics. `print` remains appropriate for intended CLI output.
- Move blocking I/O out of async code with `asyncio.to_thread` where suitable. Threads do not generally parallelize pure Python CPU work under the GIL. Choose CPU offloading from the actual runtime and workload.
- Clean up cancellation in `finally` and propagate `CancelledError`. Choose `TaskGroup` or `gather` according to required failure and cancellation behavior, not as interchangeable recipes.

## Checks and tooling

Use existing project commands for tests, formatting and type checks. Where already configured, examples include `uv run pytest`, `python -m unittest`, Ruff, mypy or pyright. Do not introduce linter limits, audit dependencies or reformat the whole project for an isolated change. For a new project, keep metadata in `pyproject.toml` and choose only the tooling the task needs.
