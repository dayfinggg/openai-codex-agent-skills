# TypeScript, JavaScript and Node.js

## Defaults for every file

- TypeScript for new code. ES modules (`"type": "module"`, `import`/`export`), never CommonJS in new packages.
- `const` by default, `let` only when reassigned. `unknown` instead of `any`, narrowed before use.
- Named exports. Union types or `as const` objects instead of `enum`. No `namespace` and no constructor parameter properties, so the code stays runnable by Node's type stripping.
- Native platform APIs before dependencies: `fetch`, `structuredClone`, `AbortController`, `URL`, `Intl`, `crypto.randomUUID()`.

## tsconfig for new projects

`strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitOverride`, `verbatimModuleSyntax`, `erasableSyntaxOnly`, and `module: nodenext` for Node or `module: bundler` for bundled apps. Do not use `baseUrl`, `moduleResolution: node`, `target: es5` or `outFile`, which are deprecated or removed.

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
- Await or explicitly handle every promise. Enable the typescript-eslint rule `no-floating-promises`.
- Start independent async work together with `Promise.all` or `Promise.allSettled` instead of awaiting one after another.
- Give every `fetch` a timeout: `fetch(url, { signal: AbortSignal.timeout(5000) })`.
- Never use `readFileSync` or other synchronous I/O in request handlers on Node.js.

## Size and complexity limits

Apply these through ESLint in `eslint.config.js` when the project has no limits of its own: `max-lines` 300, `max-lines-per-function` 50, `max-depth` 4, `max-params` 3 with an options object beyond that, and `complexity` 10. Formatter line width stays at Prettier's default of 80.

## Outdated patterns

Do not write `var`, `.eslintrc*` files, `ts-node` for scripts, `dotenv`, `nodemon`, `axios` or `node-fetch` where `fetch` fits, the `glob` package, `moment`, Jest or Mocha in new projects, or `require` in ES modules.

## Fallback commands

- Types: `npx tsc --noEmit`.
- Lint: ESLint with a flat config `eslint.config.js` using `typescript-eslint` recommended configs, or `npx biome check --write` if the project uses Biome.
- Format: `npx prettier --write .` or Biome.
- Tests: `npx vitest run`, or `node --test` in projects without Vitest.
- Package manager: the one whose lockfile exists (`pnpm-lock.yaml`, `package-lock.json`, `yarn.lock`, `bun.lock`).
