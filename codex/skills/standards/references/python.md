# Python quality reference

Use this as a default for new Python code, then follow the repository's own guide.
Treat rules as aids to readability, correctness, and safe change, not as ceremony.

## Authority and configuration precedence

- PEP 8 is active guidance for the standard library; a project's local guide wins.
- Use PEP 20 as the design test: explicit, simple, readable, practical, and unsurprising.
- Declare the minimum supported Python in `[project].requires-python`.
- Keep build requirements in `[build-system]` and package metadata in `[project]`.
- Put linter, formatter, test, and type-checker settings in their documented `[tool.*]` tables.
- Do not assume that `pyproject.toml` gives different tools one shared precedence model.
- Ruff uses the closest `pyproject.toml`, `ruff.toml`, or `.ruff.toml` for each file.
- Ruff does not merge parent configurations; use its `extend` setting deliberately.
- In one directory, `.ruff.toml` takes precedence over `ruff.toml`, which takes precedence over `pyproject.toml`.
- Ruff command-line settings override discovered configuration; an explicit `--config` controls the run.
- Black reads one discovered `pyproject.toml` containing `[tool.black]`.
- Black command-line options override both its defaults and file configuration.
- Choose either `ruff format` or Black as the formatter for a project, not both in sequence.
- Keep the formatter's line length aligned with Ruff lint settings when using both.
- Ruff's formatter aims for near-Black-compatible output; verify a migration on the repository.
- Run lint, type checking, and tests against the same supported Python versions.

## PEP 8 and PEP 20

- Use four spaces for indentation and never mix tabs and spaces.
- Prefer implicit continuation inside parentheses, brackets, and braces over backslashes.
- Use 79 columns for conservative library code, or a documented project limit up to 99.
- Wrap comments and docstrings at 72 columns when the project follows PEP 8's conservative limit.
- Put two blank lines around top-level classes and functions, and one inside classes.
- Use one statement per line unless a tiny, unambiguous conditional expression is clearer.
- Surround operators with the spacing PEP 8 specifies, and avoid trailing whitespace.
- Use `lower_snake_case` for functions, methods, variables, modules, and packages.
- Use `CapWords` for classes and exception types.
- Use `UPPER_SNAKE_CASE` for constants and a single leading underscore for internal names.
- Choose descriptive names; scope may justify a short loop variable but not a vague public name.
- Keep public and internal interfaces visibly distinct and document the public contract.
- Prefer a short explanatory comment for a non-obvious constraint, not a narration of the code.
- Use docstrings for public modules, classes, functions, and methods when their contract needs explanation.
- Favor simple control flow over clever expressions, implicit mutation, or metaprogramming.
- Break a style rule only for a documented compatibility, readability, or local-consistency reason.

## Imports, modules, and names

- Put imports after the module docstring and future imports, before executable module code.
- Group imports as standard library, third party, and local application code.
- Put a blank line between import groups and keep imports sorted by the project's tool.
- Prefer absolute imports; use explicit relative imports when they make a package layout clearer.
- Avoid wildcard imports because they hide the module's namespace and defeat static tools.
- Import modules when a qualified name improves provenance or avoids a local name collision.
- Keep module import time cheap and deterministic; do not perform network, file, or registration work implicitly.
- Put executable behavior in `main()` behind `if __name__ == "__main__":`.
- Keep each module centered on one concept, layer, or cohesive group of related operations.
- Treat circular imports as a design signal; fix dependency direction instead of adding import tricks.
- Keep `__init__.py` small and intentional; re-export only stable public names.
- Use `__all__` when a module deliberately defines a public export surface.
- Use namespace packages only when multiple distributions intentionally contribute to one namespace.

## Type annotations

- Remember that Python does not enforce annotations at runtime; a checker and tests provide enforcement.
- Annotate public functions, methods, class attributes, and module boundaries first.
- Annotate inputs with the widest type the implementation accepts, such as `Iterable[str]` or `Mapping[str, object]`.
- Return a concrete type when the implementation promises a concrete result, such as `list[int]`.
- Prefer built-in generic syntax such as `list[str]`, `dict[str, int]`, and `tuple[int, ...]` where supported.
- Prefer `collections.abc` interfaces for protocols such as `Iterable`, `Sequence`, and `Mapping`.
- Use project-supported nullable syntax, preferring `X | None` on Python 3.10+ targets.
- Parameterize generic types; an unparameterized generic usually leaks `Any` into the program.
- Use `object` when a value of any type is accepted but no operations beyond `object` are assumed.
- Use `Any` only when the type is genuinely unknown or cannot be expressed economically.
- Narrow `Any` at external boundaries and avoid spreading it through core logic.
- Use `Protocol` for a small structural interface when callers need behavior rather than inheritance.
- Use `NewType` for domain identifiers that must not be confused with their underlying type.
- Use an explicit `TypeAlias` or the `type` statement when a complex alias could be mistaken for a value.
- Mark constants with `Final` when reassignment would violate the design.
- Use `TYPE_CHECKING` imports only for types that must not be imported at runtime.
- Prefer refactoring over suppressing a checker; every ignore should name a reason and narrow a scope.
- Libraries that promise typed APIs should ship `py.typed` or a separately maintained stub package.
- Keep decorators from changing call signatures unless their typing contract is explicit and tested.
- Run the selected type checker in CI with a documented configuration and supported-version matrix.

## Dataclasses and data modeling

- Use `@dataclass` for records or value objects whose fields and equality semantics are part of the design.
- The decorator inspects annotated fields and can generate methods such as `__init__`, `__repr__`, and `__eq__`.
- Field order affects generated methods, so put required fields before defaulted fields and keep the order meaningful.
- Use `field(default_factory=...)` for a fresh mutable default per instance.
- Use `frozen=True` when immutability expresses the value object's contract, not merely to silence mutation.
- Consider `slots=True` for a deliberate memory or attribute-layout decision, and test inheritance behavior.
- Consider `kw_only=True` when positional arguments would be fragile or ambiguous.
- Validate cross-field invariants in `__post_init__` or a named constructor that raises a specific exception.
- Do not mistake a dataclass for runtime schema validation or a substitute for domain behavior.
- Keep methods on a dataclass cohesive with its invariants; move unrelated orchestration to a service function.

## Errors and exceptions

- Raise an exception for an exceptional condition that the caller can handle; do not return ambiguous sentinels.
- Choose the narrowest useful built-in exception, such as `ValueError`, `TypeError`, `KeyError`, or `OSError`.
- Define domain exceptions under `Exception` or an appropriate built-in subclass, with an `Error` suffix.
- Catch the narrowest exception that the code can recover from or translate.
- Keep `try` blocks small so unrelated programming errors are not accidentally hidden.
- Never use bare `except:` for ordinary application handling.
- Catch `Exception` only at an intentional boundary that records, translates, or re-raises the failure.
- Preserve the original cause with `raise NewError(...) from err` when translating an exception.
- Use `raise` without an argument when re-raising from an exception handler.
- Use `finally` or a context manager for cleanup regardless of success or failure.
- Do not use `assert` for user input, permissions, data validation, or required application behavior.
- Use `assert` for internal invariants that may safely disappear under optimized execution.
- Give errors enough operation and input context to diagnose them, but never include secrets.
- Log an error once at the boundary that can act on it; do not log and re-raise at every layer.

## Resource lifetime

- Make the owner of every file, socket, lock, process, database session, and temporary resource explicit.
- Prefer `with` and `async with` so cleanup runs when the block exits, including on exceptions.
- Use `contextlib` helpers or a custom context manager to centralize acquire and release logic.
- Use `ExitStack` or `AsyncExitStack` when the number of resources is dynamic.
- Close resources promptly; garbage collection is not a reliable resource-lifetime policy.
- Keep resource acquisition near the code that establishes ownership and release in the same abstraction.
- Avoid global mutable clients unless lifecycle and shutdown behavior are explicit.
- Make cleanup idempotent when callers may retry or cancellation may interrupt the operation.

## Package layout and packaging

- Prefer a `src/` layout for distributable packages so tests exercise the installed package, not a checkout shadow.
- Use a flat layout for a small script or application only when its import-path trade-offs are understood.
- A conventional package has `pyproject.toml`, `src/pkg_name/__init__.py`, implementation modules, and `tests/`.
- Keep test modules outside `src/` unless distributing tests with the package is an intentional choice.
- Match import package names to their directories and avoid dashes in Python module or package names.
- Use the build backend declared in `[build-system]`; do not assume setuptools-specific behavior for every backend.
- Declare dependencies and entry points in standardized `[project]` metadata when the backend supports them.
- Make dynamic metadata explicit and document which backend supplies it.
- Build and install a wheel or source distribution in CI to catch missing package files and metadata.
- Keep CLI adapters thin and call domain code through importable functions.

## Async and concurrency

- Use `asyncio` for concurrent I/O-bound work, not as a default replacement for synchronous code.
- Keep an async call chain async; do not block the event loop with synchronous network, disk, or CPU work.
- Use `asyncio.run()` once as the normal top-level entry point, or use `Runner` for one shared loop.
- Await every coroutine and retain every background task until its outcome is handled.
- On Python 3.11 and later, prefer `asyncio.TaskGroup` for related tasks because it waits for tasks and propagates failures together. On older supported versions, use a project-approved structured-concurrency library or explicitly own, await, cancel, and collect every task.
- Do not create fire-and-forget tasks without an owner, a strong reference, cancellation, and error handling.
- On Python 3.11 and later, use `asyncio.timeout()` around external operations. On older supported versions, use `asyncio.wait_for()` or the repository's established deadline helper.
- In cancellation cleanup, use `try/finally` and normally re-raise `CancelledError` after cleanup.
- Avoid swallowing cancellation because structured concurrency relies on it.
- Bound concurrency with queues or semaphores, and use task groups to own the bounded tasks.
- Use async context managers for async resources and keep their lifetime within the owning task.

## Testing

- Test observable behavior, contracts, failure modes, and important integration boundaries.
- Keep unit tests fast and deterministic; isolate clocks, randomness, filesystem, network, and environment state.
- Give each test one clear reason to fail and use names that state the behavior and condition.
- Use fixtures for shared setup and teardown, not hidden global state.
- Use parameterization for a compact matrix of equivalent examples.
- Test both successful and expected-exception paths, including exception type and useful details.
- Use `pytest` for readable function tests or `unittest` when its class-based API fits the codebase.
- Follow pytest discovery names such as `test_*.py`, `*_test.py`, and `test_*` functions.
- Keep tests in `tests/` and install the package, preferably editable during development.
- For new pytest projects, consider `--import-mode=importlib` to avoid test-import path surprises.
- Use temporary directories, monkeypatching, mocks, or fakes at explicit boundaries rather than broad mocks.
- Exercise async code with an async-aware test runner and assert cancellation and timeout behavior.
- Run tests against a built artifact or installed package before publishing.

## Size and cohesion heuristics

- There is no universal Python limit for function, class, module, or package size.
- Treat a long or deeply nested unit as a review trigger, not an automatic refactoring target.
- Split a function when it has multiple responsibilities, repeated phases, unrelated branches, or awkward tests.
- Split a module when it mixes layers, exposes an unclear public surface, or creates dependency cycles.
- Prefer one reason to change per module and one invariant-owning responsibility per class.
- Extract a helper when the extracted concept has a name, a contract, and independent tests.
- Do not extract trivial wrappers that obscure control flow or force readers across many files.
- Use parameter count, nesting depth, duplication, and change frequency as local review signals.
- Revisit a function that needs multiple screens, a long explanatory comment, or several mock layers to test.
- Keep public APIs small and stable; let private helpers absorb implementation detail.
- Prefer composition and plain functions until shared state or invariants justify a class.

## Minimum review checklist

- Confirm the code follows the repository's Python version, formatter, linter, and type-checker configuration.
- Run `ruff format --check` or `black --check`, then run the configured lint command.
- Run the type checker and inspect every new suppression.
- Run unit and integration tests, including expected failures and async paths.
- Build and install the package when packaging or import behavior changed.
- Review imports, resource ownership, cancellation, exception context, and public API changes.

## Sources

### Official specifications and documentation

- [PEP 8: Style Guide for Python Code](https://peps.python.org/pep-0008/)
- [PEP 20: The Zen of Python](https://peps.python.org/pep-0020/)
- [PEP 484: Type Hints](https://peps.python.org/pep-0484/)
- [PEP 585: Type Hinting Generics in Standard Collections](https://peps.python.org/pep-0585/)
- [Python `typing` documentation](https://docs.python.org/3/library/typing.html)
- [Typing specification: Best Practices](https://typing.python.org/en/latest/reference/best_practices.html)
- [Typing specification: Typing Python Libraries](https://typing.python.org/en/latest/guides/libraries.html)
- [Python `dataclasses` documentation](https://docs.python.org/3/library/dataclasses.html)
- [Python tutorial: Errors and Exceptions](https://docs.python.org/3/tutorial/errors.html)
- [Python `contextlib` documentation](https://docs.python.org/3/library/contextlib.html)
- [Python `asyncio` overview](https://docs.python.org/3/library/asyncio.html)
- [Python `asyncio` coroutines and tasks](https://docs.python.org/3/library/asyncio-task.html)
- [Python `asyncio` runners](https://docs.python.org/3/library/asyncio-runner.html)
- [Python tutorial: Modules](https://docs.python.org/3/tutorial/modules.html)
- [Python reference: The import system](https://docs.python.org/3/reference/import.html)
- [PyPA: Packaging Python Projects](https://packaging.python.org/en/latest/tutorials/packaging-projects/)
- [PyPA: `src` layout vs. flat layout](https://packaging.python.org/en/latest/discussions/src-layout-vs-flat-layout/)
- [PyPA: Writing `pyproject.toml`](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/)
- [PyPA: `pyproject.toml` specification](https://packaging.python.org/en/latest/specifications/pyproject-toml/)
- [Ruff: Configuration](https://docs.astral.sh/ruff/configuration/)
- [Ruff: Formatter](https://docs.astral.sh/ruff/formatter/)
- [Ruff: FAQ](https://docs.astral.sh/ruff/faq/)
- [Black: The basics and configuration](https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html)
- [pytest documentation](https://docs.pytest.org/en/stable/)
- [pytest: Good Integration Practices](https://docs.pytest.org/en/stable/explanation/goodpractices.html)
- [Python `unittest` documentation](https://docs.python.org/3/library/unittest.html)
- [mypy: Type hints cheat sheet](https://mypy.readthedocs.io/en/stable/cheat_sheet_py3.html)
- [mypy: Configuration file](https://mypy.readthedocs.io/en/stable/config_file.html)

### Team guidance

- [Google Python Style Guide on GitHub](https://github.com/google/styleguide/blob/gh-pages/pyguide.md)
