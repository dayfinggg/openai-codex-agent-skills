# Testing

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
- Test aggregate invariants through the aggregate root, and add contract tests for published integration messages and bounded-context translators when other systems depend on their meaning.
