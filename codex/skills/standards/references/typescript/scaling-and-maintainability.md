# Scaling and maintainability

- Measure type-check, editor, lint, and build performance before changing architecture.
- Use project references when independent packages or domains have real dependency boundaries and a large project has become a measured bottleneck. [S13][S24]
- Pair references with `composite`, declarations, and `tsc --build` as required by the build graph. [S13]
- Keep project boundaries aligned with ownership and dependency direction, and keep tests from becoming production dependencies. [S24]
- Use typescript-eslint's Project Service so typed linting can follow the same project model as editors, especially in large repositories. [S16]
- Keep TypeScript, editor, linter, formatter, test runner, and bundler versions compatible and pinned by the repository.
- Simplify expensive type expressions before adding compiler memory or timeout workarounds.
- Prefer local, stable abstractions over a shared type utility that imports half the repository.
- Study mature repositories, maintainer examples, and traceable conference talks for trade-offs; do not paste snippets without understanding their runtime assumptions. [S26][S27]
