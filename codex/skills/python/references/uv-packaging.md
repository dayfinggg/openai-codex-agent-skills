# uv projects and packaging

This reference records uv behavior through 0.13. Check the repository's `uv.lock`, run `uv --version`, and verify the relevant [official uv documentation](https://docs.astral.sh/uv/) before using a version-specific option.

## Projects and groups

- Since uv 0.12, `uv init` creates a packaged project by default with a `src/` layout, `uv_build`, and a project command. Use `uv init --no-package` when an unpackaged script project is intended.
- uv resolves dependency groups together. Add development tools to `[dependency-groups]`, and use `uv sync --locked` in CI so a stale lockfile fails instead of changing silently.
- `uv sync --no-dev` excludes the `dev` group from a production environment. Use explicit group selection when a project defines separate test or lint groups.
- Since uv 0.12, `uv run path/to/script.py` discovers the project containing the script. Pass `--project .` when the current project must be used instead.
- Since uv 0.12, the resolver can select a pre-release when no stable version satisfies a requirement. Set an explicit pre-release policy when stable-only resolution is required.

## Scripts and publishing

- A PEP 723 inline-metadata script declares `dependencies`, even when the list is empty. Run it with `uv run script.py`; add script-scoped packages with `uv add --script script.py package`.
- Use `uv lock --script script.py` when the standalone script needs a reproducible `.py.lock` file.
- `uv_build` targets pure Python. Use a backend such as `maturin` or `scikit-build-core` when the project builds native extensions.
- Before publishing, run `uv build --no-sources`. This checks that package metadata does not rely on local paths, Git sources, or workspace-only configuration.
- Constrain build dependencies separately when reproducible build artifacts require them, because the project lockfile does not necessarily pin the dependencies of a source build.

## Resolution and interpreters

- `exclude-newer` accepts an RFC 3339 timestamp. Duration forms require a uv version that documents them.
- uv 0.13 uses Python 3.15 as its default stable interpreter and prefers native ARM64 Python on Windows ARM64. Pin the project's supported interpreter in `.python-version` or request it explicitly in a command when an implicit change would violate the project floor.
- Request `UV_PYTHON_ARCH=x86_64` only when a Windows ARM64 dependency does not provide a native wheel and the project supports emulation.
- Clearing an existing environment can discard local state. Inspect the exact target and uv help before using `--clear` or `--force`.
