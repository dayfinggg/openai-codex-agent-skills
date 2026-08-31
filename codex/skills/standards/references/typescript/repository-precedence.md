# Repository precedence

- Treat package scripts, CI checks, and documented project conventions as the local contract.
- Follow the nearest `tsconfig.json` used by the project or package being changed.
- A child config overrides inherited `extends` options, and its `files`, `include`, and `exclude` replace the inherited values. [S7]
- An explicit `tsc --project` selects the config; passing input files directly makes `tsconfig.json` irrelevant for that invocation. [S8]
- Match the TypeScript version and resolved compiler options used by `tsc`, the editor, and typed linting. [S15]
- When this guide conflicts with a checked-in config or CI rule, the checked-in rule wins.
- Record deliberate exceptions in the narrowest configuration or tool-supported source directive. Prefer a machine-readable reason or a test; do not add a prose comment when the exception can be expressed mechanically.
