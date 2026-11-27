# TypeScript

Read the TypeScript version and the compiler options from `package.json` and `tsconfig.json`. Keep `strict` on, and fix the code when an option reports an error.

## Pitfalls

- `any` switches the type checker off for everything the value touches. Use `unknown` and narrow it before use.
- Write the types `string`, `number`, `boolean`, `symbol` and `object`. `String`, `Number`, `Boolean` and `Object` are the wrapper objects.
- Model a value with several shapes as a discriminated union on a literal `kind` or `type` field. In the `default` branch of the `switch` over that field, assign the value to a variable of type `never`, so the compiler reports every place that misses a new shape.
- A non-null assertion `!` and a cast with `as` overrule the compiler. Narrow with a check, and keep `as const` and `satisfies` for literals, where they add information.
- A dropped promise fails silently. Await it, return it or give it a handler. Where a `void` callback is expected, as in `forEach`, use `for...of` with `await` or `Promise.all` in place of an `async` callback.
- Data from outside the program has no type until it is checked. Parse a response, a file or an environment variable at the boundary with the project's schema library or a type guard, and pass typed values inward.
- Type the return of a callback you ignore as `void`, and keep a callback parameter required even when a caller may ignore it.
- Use `import type` for imports that are only types, and `readonly` for what must not change.
- Index access can miss. Handle `undefined` as `noUncheckedIndexedAccess` would require, also when the option is off.

## Tools

Run `tsc --noEmit` for types. When the project defines no linter, use `eslint` with the `recommended-type-checked` configuration of `typescript-eslint`, which needs type information and includes `no-explicit-any`, `no-floating-promises` and `no-misused-promises`. Format with the formatter the project has, usually `prettier` or `biome`.
