# JSDoc and documentation

- Document an exported API with JSDoc only when its contract is not clear from names, types, tests, or generated API metadata.
- Prefer supported tags such as `@param`, `@returns`, `@type`, `@typedef`, `@callback`, `@import`, `@deprecated`, `@see`, and `@link`. [J20]
- Use `@import` for type-only references. It does not create a runtime import. [J20]
- Enable `// @ts-check` or project-wide `checkJs` when the repository accepts TypeScript's JavaScript checking and the signal is useful. [J20]
- Keep JSDoc types accurate and narrow. JSDoc does not validate JSON, HTTP, DOM, environment, or plugin data at runtime.
- Document side effects, ownership, sync versus async behavior, cancellation, thrown errors, and version constraints when they are not obvious.
- Do not add implementation comments or prose that merely restates executable code. Keep a source note only when a non-obvious constraint cannot be expressed through code, types, tests, or API documentation.
