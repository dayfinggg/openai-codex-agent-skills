# Package layout and packaging

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
