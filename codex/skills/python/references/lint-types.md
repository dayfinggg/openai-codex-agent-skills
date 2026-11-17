# Ruff, ty, and mypy

This reference records Ruff 0.17, ty 0.0.105, and mypy 2.4 guidance. Read each installed tool version from the project's lockfile or environment and confirm configuration keys and rules in the [Ruff docs](https://docs.astral.sh/ruff/), [ty docs](https://docs.astral.sh/ty/), or [mypy docs](https://mypy.readthedocs.io/).

## Ruff

- Ruff 0.15 changed the formatter's style. Check a formatting diff before a repository-wide upgrade, and keep an upgrade diff separate from behavior changes.
- Ruff 0.16 removed some opinionated `E` and `F` rules from the default set. Ruff 0.17 removed `DTZ` rules from the defaults. Add explicit selections only when the repository intends to enforce those checks.
- Ruff supports rule-specific inline suppressions and region disable directives. Prefer a narrow rule-specific suppression with an explanation over a broad ignore.
- `ANN` rules report missing annotations. Neither the default Ruff rules nor ty necessarily enforce the project's annotation policy, so configure the intended checker explicitly.
- Set `requires-python` or Ruff's target version to match the project's supported floor before enabling upgrade rules.
- If a project has `[tool.ruff]`, `ruff.toml`, or `.ruff.toml`, use the pinned Ruff version and scope fixes to changed files.

## ty

- ty reads `[tool.ty]` from `pyproject.toml` or `ty.toml`. If both are present, the standalone `ty.toml` configuration takes precedence.
- Configure the Python version and rule levels from the project's actual supported range. ty uses the `requires-python` floor when no Python version is set.
- The rule formerly named `unresolved-import` is now `import-not-found`. Verify rule names against the installed release.
- Use a rule-specific `# ty: ignore[rule]` suppression only when the diagnostic is a proven false positive. A bare `# type: ignore` can silence unrelated diagnostics.
- Baseline formats and rule names can change while ty remains pre-1.0. Review baseline updates instead of accepting them as a routine fix.

## mypy

- Run mypy inside the project's environment so it can resolve the same installed packages and stubs as the application.
- mypy 2.0 changed `--allow-redefinition` behavior. Use `--allow-redefinition-old` only when a project intentionally depends on the earlier semantics.
- `--ignore-missing-imports` suppresses missing stubs for all packages. Prefer installing the required stubs or configuring a narrow module override when the project depends on typed imports.
