# TypeScript

Check the TypeScript version and the compiler options first, in `package.json` and `tsconfig.json`. Keep `strict` on. Do not loosen an option to make an error go away.

## Pitfalls

Use `unknown` for a value whose type you do not know, and narrow it before use. `any` switches the type checker off for everything the value touches.

Use the primitive types `string`, `number`, `boolean` and `symbol`, and the non-primitive type `object`. `String`, `Number`, `Boolean` and `Object` are the wrapper objects.

Model a value that has several shapes as a discriminated union with a literal `kind` or `type` field. In the `switch` over that field, assign the value to a variable of type `never` in the `default` branch. The compiler then reports every place that misses a new shape.

A non-null assertion `!` and a cast with `as` both overrule the compiler. Narrow with a check. Reserve `as const` and `satisfies` for literals, where they add information.

Every promise is awaited, returned or given a handler. A promise that is dropped fails silently. Do not pass an `async` function where a callback that returns `void` is expected, as in `forEach`.

Data from outside the program has no type until it is checked. Parse a response, a file or an environment variable at the boundary, with a schema library the project already has or with a type guard, and pass typed values inward.

Type the return of a callback you ignore as `void`. Do not mark a callback parameter optional only because a caller may ignore it.

Use `import type` for imports that are only types. Mark what must not change as `readonly`.

Index access can miss. With `noUncheckedIndexedAccess` on, the compiler makes you handle `undefined`. Handle it the same way when the option is off.

## Tools

Run `tsc --noEmit` for types. When the project defines no linter, use `eslint` with the `recommended-type-checked` configuration of `typescript-eslint`, which needs type information and includes `no-explicit-any`, `no-floating-promises` and `no-misused-promises`. Format with the formatter the project has, which is usually `prettier` or `biome`.
