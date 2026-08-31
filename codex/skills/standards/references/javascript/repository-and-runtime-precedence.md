# Repository and runtime precedence

- Treat user requirements and repository instructions as the highest authority.
- Inspect the nearest `package.json`, lockfile, runtime declaration, build scripts, and CI checks before changing JavaScript.
- Follow the repository's module format, supported runtime versions, import aliases, test runner, linter, and formatter.
- Treat package scripts as the supported way to run checks rather than inventing replacement commands.
- Use the TypeScript reference for `.ts` and `.tsx` files or when shared compiler and type contracts are part of the change. Keep this JavaScript reference for maintained `.js`, `.mjs`, and `.cjs` sources in mixed packages. Do not edit generated JavaScript emitted from TypeScript.
- Use only ECMAScript and host APIs supported by the declared runtime and browser matrix.
- Do not adopt a proposal, transpiler convention, or tool default merely because it is available in another project.
- Keep generated, vendored, and bundled files under their owning workflow.
