# Tooling and testing

- Follow the nearest checked-in ESLint, formatter, test, build, and runtime configuration before applying generic style preferences.
- ESLint's current flat configuration belongs at the project root and must match the package's module format. [J21]
- Use ESLint for correctness and policy rules. Do not hide violations with broad disables or file-wide suppression.
- Let the repository's formatter own whitespace and layout. Prettier resolves configuration from the formatted file upward and intentionally has no global configuration. [J22]
- Do not fight formatter output with manual alignment or unrelated restyling.
- Keep lint, format, test, and build commands independently runnable through package scripts or documented tools.
- Test behavior at module and package boundaries, including malformed input, errors, cancellation, cleanup, and concurrency limits.
- Test both success and failure paths for every exported asynchronous operation.
- The stable Node `node:test` runner treats thrown synchronous tests and rejected returned promises as failures. [J23]
- Return or await asynchronous test promises. Never let a test finish before the work under test settles. [J23]
- Test published entry points through the same import forms and runtime versions that consumers use.
- Run the formatter, linter, focused tests, broader tests, and production build required by the repository, then inspect the final diff.
