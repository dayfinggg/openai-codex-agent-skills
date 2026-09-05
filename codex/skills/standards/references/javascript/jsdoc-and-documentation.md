# JSDoc and documentation

- Do not add prose JSDoc or implementation comments unless documentation is explicitly requested. Preserve or update type annotations required by an existing JavaScript type-checking workflow.
- Prefer supported tags such as `@param`, `@returns`, `@type`, `@typedef`, `@callback`, `@import`, `@deprecated`, `@see`, and `@link`. [J20]
- Use `@import` for type-only references. It does not create a runtime import. [J20]
- Enable `// @ts-check` or project-wide `checkJs` when the repository accepts TypeScript's JavaScript checking and the signal is useful. [J20]
- Keep JSDoc types accurate and narrow. JSDoc does not validate JSON, HTTP, DOM, environment, or plugin data at runtime.
- Express side effects, ownership, cancellation, and errors through names, signatures, types, and behavior. Document remaining contract details only when explicitly requested. Do not use a non-obvious constraint as an exception to the user's ban on source commentary.
