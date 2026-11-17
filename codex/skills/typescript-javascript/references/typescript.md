# TypeScript configuration and type models

Compiler defaults and release behavior are version-specific. Read the installed compiler version, official migration notes, and all inherited configuration before relying on any example.

## Compiler and module model

- Read every `extends` link and identify which config applies to the changed files. A setting in an unused config does not affect the build.
- Match `module` and module resolution to the runtime or bundler. A Node.js service, an app bundler, and a published library have different resolution and output needs.
- Confirm the installed compiler and dependent tooling support the same TypeScript API. Some language servers and lint parsers can lag the main compiler.
- TypeScript `target` and `lib` declarations provide type or syntax targets. They do not polyfill runtime APIs.
- Avoid broad path aliases or compiler flags that conceal a runtime resolution mismatch. Test the emitted or bundled program in its real runtime.

## Type models

- Accept untrusted input as `unknown` and parse it at the system boundary. A type assertion does not validate external data.
- Prefer `satisfies` when validating a value's shape without widening its inferred literals.
- Represent mutually exclusive states as discriminated unions. Make exhaustive branches visible so a new state forces a compiler error.
- Await or return asynchronous work, and handle rejections intentionally. Choose sequential or bounded parallel execution based on dependencies and limits.
- Treat caught values as unknown until narrowed. Preserve the original cause when wrapping an error.
- Keep untrusted object keys out of prototypes and unsafe recursive merges. Use a schema, explicit allowlist, `Map`, or null-prototype object where appropriate.

## Upgrade failures

When an upgrade fails, reproduce the exact compiler and command. Check whether the failure comes from new defaults, module resolution, missing ambient types, changed inference, an unsupported legacy flag, or a dependent tool that expects another compiler API. Apply the migration guide for the installed version and verify the whole project, not just one source file.
