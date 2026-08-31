# Strictness and compiler options

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
