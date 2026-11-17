# pytest and newer Python features

This reference covers pytest 9.2, pytest-asyncio 1.5, and Python 3.12 to 3.15. Read the lockfile first and apply a detail only when that installed version supports it. Check the [pytest changelog](https://docs.pytest.org/en/stable/changelog.html), [pytest release notes](https://docs.pytest.org/en/stable/announce/index.html), and the relevant [Python What's New guide](https://docs.python.org/3/whatsnew/).

## pytest 9

- pytest 9 supports native TOML configuration through `[tool.pytest]` in `pyproject.toml` or `[pytest]` in `pytest.toml`. A single configuration file cannot define both `[tool.pytest]` and `[tool.pytest.ini_options]`.
- `strict = true` enables strict configuration, markers, parametrization IDs, and expected-failure handling. Use it only after checking existing project markers and fixtures.
- pytest 9.2 makes `indirect`, `ids`, and `scope` arguments to parametrization keyword-only. It also rejects unsupported `pytest.toml` top-level keys instead of silently ignoring them.
- pytest 9.1 deprecates non-collection iterables as parametrized values and class-scoped fixture instance methods. pytest 9.2 extends the fixture change to module, package, and session scopes. Define such fixtures at module level or as class methods.
- pytest 9.2 schedules `yield_fixture` for removal. Use `@pytest.fixture` with `yield`.

## pytest-asyncio

- pytest-asyncio 1.0 removed the `event_loop` fixture. Declare loop scope on `@pytest.mark.asyncio` or `@pytest_asyncio.fixture` instead.
- Set `asyncio_default_fixture_loop_scope` to make the intended lifecycle explicit. The `fixture-scope` value is version-specific, so check the installed pytest-asyncio docs first.
- The plugin deprecates overriding `event_loop_policy`; use its documented loop-factory hook when the installed release provides it.

## Python syntax by floor

Only use syntax supported by the project's `requires-python` minimum.

- Python 3.12 adds generic type parameter syntax, the `type` statement, and `typing.override`.
- Python 3.13 adds type parameter defaults, `typing.TypeIs`, `typing.ReadOnly`, and `warnings.deprecated`.
- Python 3.14 evaluates annotations lazily and adds template strings. Review the porting guide before relying on annotation evaluation or changing `__future__` imports.
- Python 3.15 adds lazy imports, `frozendict`, `sentinel`, unpacking in comprehensions, and additional typing forms. The official [Python 3.15 release guide](https://docs.python.org/3.15/whatsnew/3.15.html) lists the changes and porting notes.
