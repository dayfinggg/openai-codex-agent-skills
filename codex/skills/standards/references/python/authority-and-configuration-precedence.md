# Authority and configuration precedence

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
