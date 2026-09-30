# TypeScript, JavaScript and Node.js

## Runtime and conventions

- Preserve the project's JavaScript or TypeScript choice, module system and runtime. Prefer TypeScript and ES modules for new projects when they fit the requested stack, not as a reason to migrate a small script.
- `const` by default, `let` only when reassigned. `unknown` instead of `any`, narrowed before use.
- Prefer named exports and simple union types where consistent with the project. Node type stripping has syntax limits and does not perform type checking.
- Native platform APIs before dependencies: `fetch`, `structuredClone`, `AbortController`, `URL`, `Intl`, `crypto.randomUUID()`.
- Validate external data at runtime with the existing validator or a focused guard. Type assertions and non-null assertions do not validate values. Use `??` rather than `||` when zero, false or an empty string is valid.

## tsconfig for new projects

Use the framework's generated configuration and supported TypeScript version. Prefer `strict` and consider indexed access and optional property checks. Node projects can use matching `module` and `moduleResolution: nodenext`. Bundled apps use `moduleResolution: bundler` with a compatible `module` setting, not `module: bundler`. Do not change existing compiler options just to match a reference.

## Node.js

Use what the project's Node version supports, and prefer the built-in over a dependency:

| Need | Built-in |
|---|---|
| Run a `.ts` file | `node file.ts` (type stripping, no type checking) |
| Environment files | `node --env-file=.env` |
| Restart on change | `node --watch` |
| Tests without a framework | `node --test` with `node:test` and `node:assert` |
| Glob | `fs.glob` from `node:fs/promises` |
| HTTP client | global `fetch` |

Import built-ins with the `node:` prefix.

## Errors, resources and async

- Throw `Error` subclasses and keep the original with `new Error("message", { cause: err })`.
- Await or explicitly handle every promise. Use existing `no-floating-promises` checks when configured.
- Choose `Promise.all` or `Promise.allSettled` by the required failure behavior. Bound concurrency for growing inputs instead of starting one promise per item without a limit.
- Give `fetch` a timeout and propagate caller cancellation when supported. Check the expected response status: HTTP errors do not reject the promise, and parsing the body can fail separately.
- Never use `readFileSync` or other synchronous I/O in request handlers on Node.js.

## Checks and tooling

Use the package manager identified by the lockfile and existing scripts for types, lint, formatting and tests. Run installed tools rather than allowing `npx` to download a missing package silently. For a dependency-free Node module, `node --test` may suffice. Do not add linter limits, replace the test runner or reformat unrelated files for a small change.
