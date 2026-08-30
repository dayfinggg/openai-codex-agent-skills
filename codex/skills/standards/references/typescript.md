# TypeScript standards

These standards target maintained TypeScript applications, libraries, and tooling.
They favor explicit boundaries, useful compiler feedback, predictable runtime behavior, and code that remains easy to change.
They are defaults, not a replacement for the repository's own engineering decisions.

## Repository precedence

- Treat package scripts, CI checks, and documented project conventions as the local contract.
- Follow the nearest `tsconfig.json` used by the project or package being changed.
- A child config overrides inherited `extends` options, and its `files`, `include`, and `exclude` replace the inherited values. [S7]
- An explicit `tsc --project` selects the config; passing input files directly makes `tsconfig.json` irrelevant for that invocation. [S8]
- Match the TypeScript version and resolved compiler options used by `tsc`, the editor, and typed linting. [S15]
- When this guide conflicts with a checked-in config or CI rule, the checked-in rule wins.
- Record deliberate exceptions in the narrowest config or source location and explain their reason.

## Quality baseline

- Keep formatting, type checking, linting, tests, and the production build independently runnable.
- Run the repository's prescribed checks before merging, rather than substituting a favorite command.
- Prefer code whose runtime behavior is obvious from ordinary JavaScript control flow. Static types do not validate runtime data.
- Make side effects visible at the edge of a module and keep core logic deterministic where practical.
- Use comments to explain constraints, invariants, or non-obvious choices, not to narrate syntax.
- Keep generated files, declaration output, and vendored code under their declared ownership.
- Do not hide a failing check with a broad compiler, linter, or test suppression.

## Strictness and compiler options

- Enable `strict` for new projects; it enables the strict family and may gain stricter checks in future TypeScript versions. [S1]
- Treat `strictNullChecks` as foundational because it keeps `null` and `undefined` distinct from concrete values. [S2]
- Enable `noImplicitAny` so missing inference does not silently create unchecked `any` values. [S3]
- Consider `noUncheckedIndexedAccess` when indexed lookups can miss, especially for maps, environment objects, and user input. [S4]
- Consider `exactOptionalPropertyTypes` when omission and an explicit `undefined` have different semantics. [S5]
- Keep `useUnknownInCatchVariables` enabled so caught values must be narrowed before use. [S6]
- Use `noImplicitOverride` in class hierarchies so an override states that it is intentional.
- Use `noImplicitReturns` and `noFallthroughCasesInSwitch` when total control flow is part of correctness.
- Stage strictness changes in a migration, but do not weaken new code to preserve an avoidable legacy error.
- Do not use `skipLibCheck`, broad `@ts-ignore`, or ambient declarations as a routine way to make a broken contract compile.
- Set `target`, `lib`, `module`, and `moduleResolution` to the actual runtime or bundler, not to a copied starter config. [S11]

## Type design

- Let the compiler infer trivially initialized locals and add annotations where they clarify intent or protect a boundary. [S8]
- Give exported functions, classes, and public methods explicit input and output types when inference would hide the contract. [S18]
- Keep internal annotations selective; redundant types create noise and can become stale.
- Prefer domain types that describe valid states instead of bags of optional fields.
- Use discriminated unions for finite alternatives and make impossible branches fail loudly.
- Narrow unions with ordinary runtime checks, type predicates, and exhaustive handling. [S9][S22]
- Use `unknown` for data whose shape is not established and narrow it before reading or calling it. [S12][S17]
- Reserve `any` for a bounded, documented interoperability or migration escape hatch.
- Do not replace `any` with a chain of unchecked assertions; fix the boundary or model the data. [S17]
- Remember that assertions are erased and perform no runtime validation. [S8]
- Treat non-null assertions and double assertions as proof obligations that need a local invariant.
- Prefer `satisfies` when a value must meet a contract while retaining its precise inferred shape. [S31]
- Use `readonly` for values and parameters that the function does not mutate.
- Prefer primitive types such as `string`, `number`, and `boolean` over boxed `String`, `Number`, and `Boolean`. [S12]
- Do not introduce a generic parameter that does not affect a member or result.
- Constrain generics to the operations the implementation actually requires.
- Use `interface` for extensible object contracts when the repository has no stronger convention.
- Use `type` for unions, tuples, mapped types, conditional types, and aliases that need those operators.
- Choose the simplest type expression that communicates the rule; repetition is cheaper than opaque type machinery. [S23]
- Avoid deeply nested conditional or mapped types unless they provide a tested, reusable contract.
- Keep serialization types distinct from domain types when parsing or normalization changes meaning.

## Boundary validation

- Treat HTTP responses, JSON, files, environment variables, message queues, DOM data, and plugin values as untrusted.
- Read unknown external values as `unknown`, validate structure and semantics, then construct a domain value.
- Put validation in a named adapter or parser instead of scattering casts through business code.
- Check required keys, optional-key presence, primitive types, ranges, formats, and cross-field invariants.
- Return a typed validation failure or throw a documented error according to the module's API contract.
- Keep validation errors useful by naming the boundary, field, received kind, and safe remediation context.
- Revalidate data after deserialization, even when a producer publishes a matching TypeScript type.
- Do not claim runtime safety because a value was assigned a TypeScript type.
- Use `satisfies` for compile-time checking of authored constants, not for untrusted runtime data. [S31]
- Test malformed, missing, extra, and semantically invalid input at every important boundary.

## Modules and file organization

- Use ES module `import` and `export` syntax for new code unless an external runtime requires another form. [S11][S12]
- Make every source file's module status intentional; avoid relying on accidental script globals.
- Match module resolution to the runtime or bundler, including package `exports`, conditions, and file extensions. [S11]
- Do not assume that TypeScript `paths` aliases rewrite runtime imports; configure the runtime or bundler separately. [S11]
- Prefer relative imports for files in the same logical project when that is the repository convention. [S23]
- Limit long chains of parent imports because they obscure ownership and make moves expensive. [S23]
- Avoid namespaces, triple-slash references, and `import = require` in application code unless interoperability requires them. [S12]
- Organize files around a cohesive domain or feature, not a growing catch-all `utils` directory.
- Keep a file's imports, types, implementation, and tests easy to locate without artificial section ordering.
- Place a type beside its implementation until sharing or ownership gives it a clearer home.
- Use a small public entry module for a package and keep implementation modules private by default.
- Add an index or barrel only when it expresses a deliberate public boundary.
- Remove unused imports and avoid side-effect imports except for explicit initialization contracts.
- Use `.mts`, `.cts`, or repository-specific extensions only when the package's module semantics require them.

## Exports and public APIs

- Prefer named exports when no repository convention says otherwise because names remain canonical at import sites. [S23]
- Export only symbols needed by another module or by the supported package API.
- Keep the public surface small so consumers depend on stable concepts rather than implementation details. [S23]
- Avoid mutable exported bindings; expose commands or getter functions when external mutation is truly required. [S23]
- Use `import type` and `export type` where the dependency is type-only when the project enables or prefers that distinction. [S19]
- Avoid broad `export *` chains when they create name collisions, cycles, or accidental API expansion.
- Export every named type that appears in a published function, class, or value signature.
- Keep package `exports`, runtime files, and declaration files aligned for every supported subpath. [S11]
- Document exported behavior, invariants, thrown errors, cancellation, and version-sensitive constraints.
- Treat an export change as an API change and update consumers, tests, and release notes as required.

## Errors

- Throw `Error` instances or deliberate subclasses, not strings or arbitrary primitives.
- Catch as `unknown` and narrow with `instanceof`, a stable discriminator, or a validated predicate. [S6][S9]
- Identify Node.js failures by stable error codes where available, not by mutable human-readable messages. [S28]
- Preserve causal information when adding context, using `cause` or a typed equivalent. [S28]
- Handle an error at the layer that can recover, translate, retry, report, or terminate meaningfully.
- Do not catch an error only to rethrow it unchanged or to return a misleading success value.
- Never swallow an error without recording why it is safe and what signal replaces it.
- Distinguish expected validation or business failures from programmer defects and infrastructure failures.
- Keep error messages free of secrets, tokens, raw credentials, and unbounded external payloads.
- Test both the error value exposed to callers and the side effects of failure paths.

## Async code and concurrency

- Annotate exported asynchronous contracts as `Promise<T>` when the result is not obvious. [S10][S18]
- Every promise must be intentionally awaited, returned, caught, or explicitly discarded with a documented reason. [S20]
- Enable typed linting for promise misuse when its performance cost is acceptable for the repository. [S14][S15]
- Avoid passing an async callback to a void-only callback API unless a wrapper handles its rejection. [S21]
- Use `for...of` for ordered asynchronous work and `Promise.all` for independent work that must all succeed. [S20][S29]
- Use `Promise.allSettled` when every outcome matters and partial failure is part of the contract. [S29][S30]
- Preserve required sequencing; do not turn dependent operations into concurrent tasks for cosmetic speed.
- Bound concurrency for untrusted or large collections and make backpressure explicit.
- Propagate cancellation with `AbortSignal` when the underlying API supports it.
- Avoid `Array.prototype.forEach` with async callbacks because it does not await them.
- Remove `async` from functions that do not await or intentionally normalize a promise.
- Attach error handling to event emitters and streams according to the runtime API, not only with a surrounding `try` block. [S28]
- Test rejection, timeout, cancellation, retry, ordering, and partial-success behavior.

## Naming and style

- Name values, types, functions, and modules for the domain concept they represent.
- Do not encode type information in names such as `userString` or `itemsArray`. [S23]
- Use `lowerCamelCase` for values and functions, `UpperCamelCase` for types and classes, and the repository's constant convention for constants. [S23]
- Avoid unexplained abbreviations, Hungarian prefixes, and meaningless one-letter names outside tiny local scopes. [S23]
- Do not add `I` prefixes to interfaces unless the surrounding ecosystem requires them. [S23]
- Name predicates with forms such as `isReady`, `hasAccess`, or `canRetry` when they return booleans.
- Name conversion, parsing, and validation functions so callers can see whether they can fail or throw.
- Prefer object parameters when several arguments would otherwise be positional and easy to swap.
- Keep function names stable during refactoring; move or rename separately from behavior edits when possible. [S32]
- Use the formatter and lint rules already selected by the repository.

## Testing

- Test observable behavior, contracts, and failure modes rather than implementation trivia.
- Add focused runtime tests for parsers, adapters, state transitions, and error translation.
- Add integration tests at module, package, and transport boundaries where wiring can fail.
- Add type-level tests for public generics, overloads, conditional types, and intentional compiler errors.
- Use `@ts-expect-error` only when the error is the behavior under test, and state what must remain rejected.
- Include malformed external values, absent optionals, unknown discriminants, and unexpected extra fields.
- Verify promise rejection and ensure tests never leave background work or floating promises.
- Control clocks, randomness, network calls, filesystem state, and environment variables in unit tests.
- Prefer deterministic fixtures that show the smallest input needed to prove the behavior.
- Keep test names descriptive enough to serve as executable documentation. [S23][S32]
- Run the same type checker and compiler options in CI that developers use locally.
- Use the TypeScript repository's focused cases and baselines as examples of narrow compiler-regression tests, not as application test templates. [S25]

## Scaling and maintainability

- Measure type-check, editor, lint, and build performance before changing architecture.
- Use project references when independent packages or domains have real dependency boundaries and a large project has become a measured bottleneck. [S13][S24]
- Pair references with `composite`, declarations, and `tsc --build` as required by the build graph. [S13]
- Keep project boundaries aligned with ownership and dependency direction, and keep tests from becoming production dependencies. [S24]
- Use typescript-eslint's Project Service so typed linting can follow the same project model as editors, especially in large repositories. [S16]
- Keep TypeScript, editor, linter, formatter, test runner, and bundler versions compatible and pinned by the repository.
- Simplify expensive type expressions before adding compiler memory or timeout workarounds.
- Prefer local, stable abstractions over a shared type utility that imports half the repository.
- Study mature repositories, maintainer examples, and traceable conference talks for trade-offs; do not paste snippets without understanding their runtime assumptions. [S26][S27]

## File and function size heuristics

- Do not enforce a universal line count or function-length limit; no number is a quality target.
- Split a unit when it has multiple reasons to change, hides sequencing, needs explanatory scaffolding, or is hard to test in isolation.
- Keep a cohesive algorithm together when splitting would obscure its invariants or create needless indirection.
- Treat nesting, branching, parameter count, fan-out, churn, review friction, and test setup as signals rather than verdicts.
- Let measured repository data and repeated maintenance pain set any local thresholds.
- Keep generated code, schemas, fixtures, and large lookup tables together when their size reflects their purpose.
- Refactor in small behavior-preserving steps, compiling and running tests after each meaningful step. [S32]
- Prefer a boundary that reduces cognitive load and coupling over a boundary that merely shortens a file.

## Sources

### Official TypeScript and tool documentation

- [S1. TypeScript TSConfig: `strict`](https://www.typescriptlang.org/tsconfig/strict.html)
- [S2. TypeScript TSConfig: `strictNullChecks`](https://www.typescriptlang.org/tsconfig/strictNullChecks.html)
- [S3. TypeScript TSConfig: `noImplicitAny`](https://www.typescriptlang.org/tsconfig/noImplicitAny.html)
- [S4. TypeScript TSConfig: `noUncheckedIndexedAccess`](https://www.typescriptlang.org/tsconfig/noUncheckedIndexedAccess.html)
- [S5. TypeScript TSConfig: `exactOptionalPropertyTypes`](https://www.typescriptlang.org/tsconfig/exactOptionalPropertyTypes.html)
- [S6. TypeScript TSConfig: `useUnknownInCatchVariables`](https://www.typescriptlang.org/tsconfig/useUnknownInCatchVariables.html)
- [S7. TypeScript TSConfig: `extends`](https://www.typescriptlang.org/tsconfig/extends.html)
- S8. [TypeScript Handbook: `tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html) and [Everyday Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html)
- [S9. TypeScript Handbook: Narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html)
- [S10. TypeScript Handbook: More on Functions](https://www.typescriptlang.org/docs/handbook/2/functions.html)
- [S11. TypeScript Handbook: Modules Reference](https://www.typescriptlang.org/docs/handbook/modules/reference.html)
- [S12. TypeScript Handbook: Declaration-file Do's and Don'ts](https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html)
- [S13. TypeScript Handbook: Project References](https://www.typescriptlang.org/docs/handbook/project-references.html)
- [S14. typescript-eslint: Shared Configs](https://typescript-eslint.io/users/configs/)
- [S15. typescript-eslint: Linting with Type Information](https://typescript-eslint.io/getting-started/typed-linting/)
- [S16. Josh Goldberg, typescript-eslint maintainer: Typed Linting with Project Service](https://typescript-eslint.io/blog/project-service/)
- [S17. typescript-eslint: `no-explicit-any`](https://typescript-eslint.io/rules/no-explicit-any/)
- [S18. typescript-eslint: `explicit-module-boundary-types`](https://typescript-eslint.io/rules/explicit-module-boundary-types/)
- [S19. typescript-eslint: `consistent-type-imports`](https://typescript-eslint.io/rules/consistent-type-imports/)
- [S20. typescript-eslint: `no-floating-promises`](https://typescript-eslint.io/rules/no-floating-promises/)
- [S21. typescript-eslint: `no-misused-promises`](https://typescript-eslint.io/rules/no-misused-promises/)
- [S22. typescript-eslint: `switch-exhaustiveness-check`](https://typescript-eslint.io/rules/switch-exhaustiveness-check/)
- [S28. Node.js Documentation: Errors](https://nodejs.org/api/errors.html)
- [S29. MDN: `Promise.all()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all)
- [S30. MDN: `Promise.allSettled()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/allSettled)
- [S31. TypeScript 4.9 Release Notes: `satisfies`](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-9.html)

### Team guidance and maintainer examples

- [S23. Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)
- [S24. TypeScript Wiki: Performance](https://github.com/microsoft/TypeScript/wiki/Performance)
- [S25. TypeScript GitHub: focused compiler test cases](https://github.com/microsoft/TypeScript/tree/main/tests/cases)

### Practitioner material

- [S26. Dan Vanderkam: Effective TypeScript code samples](https://github.com/danvk/effective-typescript)
- [S27. TSConf 2018 video archive](https://archive.tsconf.io/2018/videos.php)
- [S32. Clare Sudbery and Martin Fowler: Refactoring, This class is too large](https://martinfowler.com/articles/class-too-large.html)
