# JavaScript standards

These standards target maintained modern JavaScript source files, including JavaScript that lives inside a mixed TypeScript package.
They favor explicit runtime contracts, predictable asynchronous behavior, small public surfaces, and code that is easy to test.
Treat every rule as a default that yields to the repository contract, compatibility needs, measured evidence, and security requirements.

## Repository and runtime precedence

- Treat user requirements and repository instructions as the highest authority.
- Inspect the nearest `package.json`, lockfile, runtime declaration, build scripts, and CI checks before changing JavaScript.
- Follow the repository's module format, supported runtime versions, import aliases, test runner, linter, and formatter.
- Treat package scripts as the supported way to run checks rather than inventing replacement commands.
- Use the TypeScript reference for `.ts` and `.tsx` files or when shared compiler and type contracts are part of the change. Keep this JavaScript reference for maintained `.js`, `.mjs`, and `.cjs` sources in mixed packages. Do not edit generated JavaScript emitted from TypeScript.
- Use only ECMAScript and host APIs supported by the declared runtime and browser matrix.
- Do not adopt a proposal, transpiler convention, or tool default merely because it is available in another project.
- Keep generated, vendored, and bundled files under their owning workflow.

## Modules and package boundaries

- Use ECMAScript modules with `import` and `export` for new code when the runtime and toolchain support them. [J1][J2]
- Mark Node packages explicitly with `"type": "module"` or `"type": "commonjs"`; use `.mjs` and `.cjs` for file-level exceptions. [J3][J4]
- Use complete file extensions for relative and absolute ESM specifiers, including directory indexes. [J4]
- Keep ordinary imports and exports static so the dependency graph is visible to readers and tools.
- Use dynamic `import()` only for a real lazy, optional, or runtime-selected dependency, and handle its rejection.
- Prefer named exports for public APIs unless an established project convention or one conceptual default clearly justifies a default export. [J5]
- Treat imported bindings as read-only views, and do not expose mutable module state without an explicit ownership contract. [J2][J5]
- Keep import-time work minimal. Put network, filesystem, DOM, timers, and registration behind explicit functions when possible.
- Avoid cyclic imports. Merge the concepts, move shared code to a lower-level module, or introduce a deliberate inversion at the boundary. [J2][J5]
- Define a package's public entry points with `exports` and export every supported subpath explicitly. [J3]
- Do not make consumers deep-import private files that are absent from `exports`.
- Choose either extensioned or extensionless package subpaths and use one spelling consistently. [J3]
- For dual ESM and CommonJS packages, use conditional exports, test both loaders, and provide a `default` branch when possible. [J3]
- Import Node built-ins with the `node:` scheme in Node-specific modules. [J4]
- The maintained `p-map` package demonstrates explicit `type`, `exports`, `engines`, `sideEffects`, and test metadata in `package.json`. [J16][J29]
- The MDN `js-examples` repository provides executable module examples for named exports, aggregation, dynamic imports, and top-level `await`. [J6]

## Language semantics

- Declare locals with `const` by default and use `let` only when the binding is reassigned. Do not use `var` in new code. [J5][J7]
- Initialize variables close to first use and keep their scope no wider than necessary. [J5]
- Remember that modules are strict mode code. Do not rely on sloppy-mode coercion, silent assignment failure, or accidental globals. [J1][J2]
- Compare with `===` by default. Use `Object.is` when `NaN` or signed zero semantics matter, and use `== null` only when deliberately matching both `null` and `undefined`. [J8]
- Do not use truthiness when `0`, `false`, or an empty string is valid domain data.
- Make coercion explicit at boundaries with validation and parsing rather than relying on implicit conversions.
- Use `??` when only nullish values should default, and use `||` only when every falsy value should default.
- Keep optional chaining local to a known optional boundary. Do not let `?.` hide a broken required invariant.
- Prefer primitive values over boxed `String`, `Number`, and `Boolean` objects. Never modify built-in constructors or prototypes. [J5]
- Make a function's `this` contract explicit. Use an arrow function for lexical `this` and a method or bound function when a receiver is intentional.
- Prefer direct control flow, descriptive names, and ordinary data over clever coercion, metaprogramming, or hidden global state.
- Use standardized ECMAScript and host features only. Record a compatibility decision when a polyfill or transpilation step is required. [J5]

## Data and mutation

- Decide who owns each object, array, stream, timer, and resource before deciding whether to mutate it.
- Mutate data owned by the current operation when that keeps the algorithm clear. Do not mutate caller-owned inputs unless the API documents it.
- Return a new array or object when callers may retain the previous value or when change detection depends on identity.
- Remember that object and array spreads make shallow copies. Nested objects and functions remain shared references.
- `Object.freeze` freezes the object passed to it, returns that same object, and is shallow. It is not a deep-clone or a general immutability policy. [J9]
- Use `structuredClone` only when a genuine deep copy is required and its supported value types and cost are acceptable. [J10]
- Do not deep-clone every state update. Prefer a targeted copy-on-write update or an owned mutable accumulator.
- Use `Map` and `Set` when key identity or membership is the domain operation. Avoid unbounded property bags for untrusted keys.
- Keep `null`, `undefined`, omission, and an empty value distinct when the public contract distinguishes them.
- Normalize external data once at the boundary, then keep internal representations stable.
- Avoid retaining large request bodies, closures, listeners, or caches longer than their ownership and lifetime require.

## Functions and errors

- Give each function one coherent operation with explicit inputs, outputs, mutation, side effects, and failure behavior.
- Keep pure computation separate from I/O, DOM, process, and persistence bindings when that makes the core reusable and testable. [J2]
- Throw `Error` instances or meaningful subclasses, not strings or ad hoc primitives. [J11][J13]
- Add context while preserving the original failure with `new Error(message, { cause })`. [J12][J13]
- Catch only failures the current layer can recover from, translate, or enrich. Re-throw unexpected failures.
- Do not assume a caught value or `error.cause` is an `Error`; inspect or normalize it before reading properties. [J12]
- Keep error messages actionable but free of secrets, tokens, and untrusted markup.
- Document error categories, retryability, cancellation, and cleanup for exported operations whose behavior is not obvious.
- In Node, attach an `'error'` listener to every `EventEmitter` whose errors are not otherwise consumed. An unhandled event can crash the process. [J13]
- Use `finally` for cleanup that must happen on success, failure, and cancellation.

## Asynchronous behavior and the event loop

- Mark asynchronous APIs clearly and return the promise they create. An async function's caller must be able to await or handle its result.
- Await dependent operations in sequence. Start independent operations together and await them with `Promise.all`. [J14]
- Pass promises to `Promise.all`, not function values. Remember that it rejects when any member rejects and preserves input order on fulfillment. [J14]
- Bound concurrency for large or externally limited work. The `p-map` implementation is a verified example of a concurrency limit, backpressure, and `AbortSignal` support. [J16]
- Do not use `array.forEach(async () => ...)` when completion matters. Use `for...of` for sequence or `map` plus `Promise.all` for intentional concurrency.
- Do not leave floating promises. A deliberately detached operation needs local rejection handling, lifecycle ownership, and a reason that is visible to reviewers.
- Accept and forward an `AbortSignal` for cancellable I/O, and distinguish an expected abort from an operational failure. [J15]
- Abort controllers communicate cancellation. The underlying API must honor the signal for work to stop. [J15]
- Remove listeners, close streams, and release resources in a `finally` block or an equivalent lifecycle hook.
- Remember that Node `EventEmitter` listeners run synchronously and their return values are ignored. Keep listeners short and handle async failures explicitly. [J18]
- Keep each browser task, callback, and microtask small enough to preserve input and rendering responsiveness. Jake Archibald's event-loop talk explains the task and microtask distinction. [J28]
- Keep Node event-loop callbacks short. Avoid synchronous filesystem, crypto, compression, and child-process calls in server request paths. [J17][J27]
- Bound input before expensive regular expressions, `JSON.parse`, `JSON.stringify`, sorting, or recursive traversal. Large or adversarial input can cause denial of service. [J17]

## Browser and Node portability

- Separate portable core logic from browser and Node bindings. Keep DOM, `window`, `document`, `process`, filesystem, and native module access at the edge. [J2]
- Do not read a host global at module initialization unless the module explicitly targets that host.
- Use capability detection such as `typeof window` or `typeof process` only when the branches provide equivalent behavior. Prefer separate bindings when they do not. [J2]
- Use `globalThis` only for an intentional cross-runtime global contract. Do not create implicit globals. [J2]
- Treat Node's browser-compatible `fetch` as a runtime capability governed by the package's supported Node versions, not as proof that all browser APIs exist. [J19]
- Declare runtime support in `engines` or the repository's equivalent and test the oldest supported runtime.
- Keep Node built-ins out of portable modules. Inject a binding or expose separate entry points for host-specific behavior.
- Test browser code through a server and test Node code in Node. Do not infer portability from one successful bundler build.

## JSDoc and documentation

- Use JSDoc for exported functions, classes, callbacks, data shapes, and non-obvious invariants.
- Prefer supported tags such as `@param`, `@returns`, `@type`, `@typedef`, `@callback`, `@import`, `@deprecated`, `@see`, and `@link`. [J20]
- Use `@import` for type-only references. It does not create a runtime import. [J20]
- Enable `// @ts-check` or project-wide `checkJs` when the repository accepts TypeScript's JavaScript checking and the signal is useful. [J20]
- Keep JSDoc types accurate and narrow. JSDoc does not validate JSON, HTTP, DOM, environment, or plugin data at runtime.
- Document side effects, ownership, sync versus async behavior, cancellation, thrown errors, and version constraints when they are not obvious.
- Use ordinary `//` comments for implementation notes. Explain constraints and reasons rather than restating syntax. [J5]

## Tooling and testing

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

## Security

- Treat request data, URLs, DOM values, files, environment variables, messages, plugin output, and package metadata as untrusted until validated.
- Never pass untrusted strings to `eval`, `Function`, dynamic code loaders, or equivalent implicit evaluation. [J24][J5]
- Keep dynamic import specifiers on an allowlist. Do not turn user input into a module path.
- Render untrusted browser data as text with `textContent`, `value`, or other safe sinks. Avoid `innerHTML`, `document.write`, and event-handler attributes. [J25][J26]
- If user-authored HTML is required, sanitize it with a maintained, reviewed sanitizer and do not modify the sanitized result afterward. [J25]
- Parse and validate URLs, allow only intended protocols and hosts, and do not construct `javascript:` or executable URLs from input. [J25]
- Use `spawn` or `execFile` with an argument array for Node subprocesses. Do not interpolate untrusted input into shell commands or use synchronous child processes on request paths. [J27]
- Resolve file paths against an allowed root and reject traversal, unexpected schemes, and symlink escapes where the threat model requires it.
- Bound input size, regular-expression complexity, recursion depth, and concurrency to reduce denial-of-service risk. [J17]
- Keep secrets out of source, logs, errors, snapshots, and client bundles. Review dependency changes and lockfile diffs.

## Size and cohesion heuristics

- Keep a module centered on one domain concept, host binding, or change reason with a narrow public API.
- Split a file or function when it mixes independent lifecycles, unrelated dependencies, host concerns, or failure policies.
- Keep a larger cohesive algorithm together when extraction would create pass-through wrappers or scatter one invariant.
- Treat line count as a review signal, not a hard limit. Investigate nesting, branching, state, import count, and test setup before splitting.
- Keep package entry points shallow and implementation modules private behind `exports`.
- Prefer a small concrete abstraction over a generic utility with flags, unused options, or speculative extension points.
- Remove duplicated business rules while leaving harmless repeated test setup visible when it clarifies a scenario.
- Measure bundle size, startup, event-loop delay, and memory before adding complexity for performance.

## Verification

- Confirm the module format, runtime matrix, package exports, and host bindings from the final artifact.
- Run repository-prescribed formatting, linting, tests, type-aware JavaScript checks, and build commands.
- Exercise success, failure, abort, timeout, cleanup, and boundary-validation paths.
- Inspect the diff for accidental public API changes, hidden mutation, floating promises, deep imports, and unrelated churn.

## Sources

### Specifications and official documentation

- [J1] [ECMAScript 2026 specification: scripts and modules](https://tc39.es/ecma262/2026/multipage/ecmascript-language-scripts-and-modules.html)
- [J7] [ECMAScript 2026 specification: statements and declarations](https://tc39.es/ecma262/2026/multipage/ecmascript-language-statements-and-declarations.html)
- [J2] [MDN: JavaScript modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules)
- [J3] [Node.js: packages and module resolution](https://nodejs.org/api/packages.html)
- [J4] [Node.js: ECMAScript modules](https://nodejs.org/api/esm.html)
- [J8] [MDN: equality comparisons and sameness](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Equality_comparisons_and_sameness)
- [J9] [MDN: Object.freeze](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze)
- [J10] [MDN: structuredClone](https://developer.mozilla.org/en-US/docs/Web/API/Window/structuredClone)
- [J11] [MDN: Error](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error)
- [J12] [MDN: Error cause](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error/cause)
- [J13] [Node.js: errors](https://nodejs.org/api/errors.html)
- [J14] [MDN: Promise.all](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all)
- [J15] [MDN: AbortController](https://developer.mozilla.org/en-US/docs/Web/API/AbortController)
- [J17] [Node.js Learn: don't block the event loop](https://nodejs.org/learn/asynchronous-work/dont-block-the-event-loop)
- [J18] [Node.js: events](https://nodejs.org/api/events.html)
- [J19] [Node.js: global objects](https://nodejs.org/api/globals.html)
- [J20] [TypeScript: JSDoc reference for JavaScript](https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html)
- [J21] [ESLint: configuration files](https://eslint.org/docs/latest/use/configure/configuration-files)
- [J22] [Prettier: configuration](https://prettier.io/docs/configuration)
- [J23] [Node.js: test runner](https://nodejs.org/api/test.html)
- [J24] [MDN: eval](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/eval)
- [J27] [Node.js: child_process](https://nodejs.org/api/child_process.html)

### Google team guidance

- [J5] [Google JavaScript Style Guide](https://google.github.io/styleguide/jsguide.html)

### Maintainer examples and security guidance

- [J6] [MDN JavaScript examples on GitHub](https://github.com/mdn/js-examples)
- [J16] [Sindre Sorhus: p-map on GitHub](https://github.com/sindresorhus/p-map)
- [J25] [OWASP: Cross Site Scripting Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
- [J26] [OWASP: DOM based XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/DOM_based_XSS_Prevention_Cheat_Sheet.html)
- [J29] [Sindre Sorhus p-map package.json on GitHub](https://github.com/sindresorhus/p-map/blob/main/package.json)

### Practitioner talk

- [J28] [Bram.us: Jake Archibald's In The Loop talk](https://www.bram.us/2018/02/09/jake-archibald-in-the-loop-taking-a-close-look-into-the-browsers-event-loop/)
