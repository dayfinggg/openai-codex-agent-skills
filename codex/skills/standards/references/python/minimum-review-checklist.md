# Minimum review checklist

- Confirm the code follows the repository's Python version, formatter, linter, and type-checker configuration.
- Run `ruff format --check` or `black --check`, then run the configured lint command.
- Run the type checker and inspect every new suppression.
- Run unit and integration tests, including expected failures and async paths.
- Build and install the package when packaging or import behavior changed.
- Review imports, resource ownership, cancellation, exception context, and public API changes.
