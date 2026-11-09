<overview>
This file lists the compiler changes from TypeScript 5.9 to 7.1 beta that matter for real projects. Check the installed version first, because each fact applies only from the version it names. TypeScript 6.0 changed the defaults and deprecated old options. TypeScript 7.0 is the Go-based native compiler, and it turns every 6.0 deprecation into a hard error. The TypeScript team recommends a move to 6.0 before 7.0.
</overview>
<contents>
This file has these sections, in order.
- changed defaults
- removed options
- syntax changes
- module settings
- new config
- named files
- standard library
- inference changes
- native compiler
- compiler api
- javascript checking
</contents>


<changed_defaults>
TypeScript 6.0 changed seven defaults, and 7.0 keeps them. A project that relied on an old default must now set the option explicitly.

| Option | Default in 6.0 and 7.0 | Action when the project needs the old behavior |
|---|---|---|
| `strict` | `true` | Fix the new errors, or set `"strict": false` |
| `module` | `esnext` | Set the module mode the runtime needs |
| `target` | The newest stable ECMAScript version before `esnext`, now `es2025` | Pin a target when output must stay the same |
| `types` | `[]` | List global packages, as in `"types": ["node", "jest"]` |
| `rootDir` | The directory that holds `tsconfig.json` | Set it, as in `"rootDir": "./src"` |
| `noUncheckedSideEffectImports` | `true` | Add declarations for intended side-effect imports |
| `libReplacement` | `false` | Set `true` when the project uses replacement lib packages |

An empty `types` list affects only global declarations. Types that code reaches through an import still load. The value `["*"]` restores the old scan of every `@types` package, and the team recommends an explicit list instead.

The new `rootDir` default changes where `tsc` writes output under `outDir`. The compiler still infers `rootDir` only when it runs without a `tsconfig.json`. This config keeps the common layout of `src` into `dist`.

```json
{
  "compilerOptions": {
    "rootDir": "./src",
    "outDir": "./dist"
  },
  "include": ["./src"]
}
```

In TypeScript 7.0, `stableTypeOrdering` is always on and cannot be turned off.
</changed_defaults>

<removed_options>
TypeScript 6.0 removed some options outright and deprecated others. TypeScript 7.0 rejects all of them.

| Option or form | TypeScript 6.0 | TypeScript 7.0 | Replacement |
|---|---|---|---|
| `target` `es5` | Deprecated | Removed | `es2015` or later |
| `downlevelIteration` | Deprecated when set at all | Removed | Remove the option and test the output |
| `moduleResolution` `node` or `node10` | Deprecated | Removed | `nodenext` or `bundler` |
| `moduleResolution` `classic` | Removed | Removed | `nodenext` or `bundler` |
| `module` `amd`, `umd`, `systemjs`, or `none` | Removed | Removed | An ESM or CommonJS mode |
| `outFile` | Removed | Removed | An external bundler |
| `baseUrl` | Deprecated | Removed | Prefixes in `paths` relative to the config |
| `esModuleInterop` or `allowSyntheticDefaultImports` set to `false` | Not allowed | Not allowed | Remove the setting |
| `alwaysStrict` set to `false` | Deprecated | Not allowed | Remove the setting |

The setting `"ignoreDeprecations": "6.0"` hides the deprecation errors in 6.0 only. TypeScript 7.0 supports none of the deprecated options, so treat the setting as a short bridge and not a fix. The `amd-module` directive no longer has any effect.

Without `baseUrl`, a `paths` entry is resolved relative to the config file. This config replaces a `baseUrl` of `.` for one alias.

```json
{
  "compilerOptions": {
    "paths": {
      "@app/*": ["./src/app/*"]
    }
  }
}
```

The old `baseUrl` also let any bare import resolve from the root. Add a `"*"` entry to `paths` only when the code relied on that on purpose. Such an entry can hide a missing dependency.
</removed_options>

<syntax_changes>
TypeScript 6.0 turned three old syntax forms into errors.

- The `module Foo {}` form of a namespace is an error. Write `namespace Foo {}`. An ambient `declare module "name" {}` still works.
- Import assertions with `assert` are an error. Write import attributes with `with`, in static and dynamic imports.
- The `/// <reference no-default-lib="true"/>` directive is no longer supported. Use the `noLib` or `libReplacement` option instead.

These forms are correct in 6.0 and 7.0.

```ts
namespace Utilities {
  export const ready = true;
}

import data from "./data.json" with { type: "json" };
const lazyData = import("./data.json", { with: { type: "json" } });
```
</syntax_changes>

<module_settings>
Choose the module mode by the runtime that executes the output.

| Project | Settings |
|---|---|
| Node.js that tracks current Node.js behavior | `module` `nodenext`, which implies the floating `esnext` target |
| Node.js with fixed Node.js 20 behavior | `module` `node20` from TypeScript 5.9, which implies `target` `es2023` |
| Code that a bundler processes | `module` `preserve` with `moduleResolution` `bundler` |
| CommonJS output during a move off `node10` resolution | `module` `commonjs` with `moduleResolution` `bundler`, allowed from 6.0 |

From 6.0, `nodenext` and `bundler` resolution support package `imports` keys that start with `#/`. Node.js supports them in newer Node.js 20 releases. This `package.json` entry maps `#/utils.js` to `./dist/utils.js`.

```json
{
  "imports": { "#/*": "./dist/*" }
}
```

TypeScript 5.9 supports `import defer`, which loads a module but runs it only when code first reads one of its exports. It allows only a namespace import, as in `import defer * as feature from "./feature.js"`. TypeScript does not transform it, so it works only with `module` `preserve` or `esnext`. The runtime or bundler must support the syntax too.
</module_settings>

<new_config>
From TypeScript 5.9, a plain `tsc --init` writes a short config with active settings. It sets `module` `nodenext`, `target` `esnext`, `types` `[]`, `strict`, and `verbatimModuleSyntax`. It also sets `isolatedModules`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `jsx` `react-jsx`, and `skipLibCheck`. Adjust each setting to the runtime and build tool before you keep it. For Node.js, the generated comments suggest `"types": ["node"]` with `@types/node` installed.
</new_config>

<named_files>
From TypeScript 6.0, `tsc file.ts` in a directory with a `tsconfig.json` fails with error TS5112. The error exists because named files skip the project config. Run the project build instead. When you want the named file with default options, run `tsc --ignoreConfig file.ts`.
</named_files>

<standard_library>
The bundled lib files gained these declarations.

- From 5.9, a typed array is generic over its buffer, and `ArrayBuffer` is no longer a supertype of typed arrays. A `Buffer` from Node.js is affected too. Update `@types/node` first, then write `Uint8Array<ArrayBuffer>` or pass `bytes.buffer` where an `ArrayBuffer` is required. Do not hide these errors with a cast.
- From 6.0, `target` and `lib` accept `es2025`. That lib adds `RegExp.escape` and moves `Promise.try`, the `Iterator` helper methods, and the new `Set` methods out of `esnext`.
- From 6.0, `Temporal` types load with `target` `esnext`, with `lib` `esnext`, or with the lib `esnext.temporal`.
- From 6.0, the `esnext` lib declares `Map` and `WeakMap` methods `getOrInsert` and `getOrInsertComputed`. The callback of `getOrInsertComputed` receives the key and runs only when the key is missing.
- From 6.0, `lib.dom.d.ts` includes the iterable and async iterable DOM types. A `lib` list needs only `dom`, without `dom.iterable` or `dom.asynciterable`.
- From 7.1 beta, `target` and `lib` accept `es2026`, with `Math.sumPrecise`, `Array.fromAsync`, and `Uint8Array.fromBase64`.
</standard_library>

<inference_changes>
Inference changed in small ways that can produce new errors. TypeScript 5.9 stops type variables from leaking out of their scope during inference. When an upgrade changes an inferred type, add explicit type arguments to the generic call. From 6.0, a method that never uses `this` no longer counts as context sensitive. So inference no longer depends on property order. In 7.1 beta, a type parameter inside a distributive conditional branch becomes a narrower type parameter, which can add errors.

In 6.0, the flag `--stableTypeOrdering` orders types the way 7.0 does. It helps compare output before a move to 7.0. It can slow type checking by up to 25 percent, so use it only to diagnose. When it shows an order-dependent inference, add an explicit annotation or type argument.
</inference_changes>

<native_compiler>
TypeScript 7.0 installs with `npm install -D typescript` and runs as `npx tsc`. Nightly builds use the `next` tag of the same package. The old `@typescript/native-preview` package with its `tsgo` command only shipped preview builds, so replace it with `typescript` 7.

The native compiler checks in parallel, and three flags control that.

- `--checkers` sets the number of type-checking workers. The default is 4, and `--checkers 1` is the lowest value. More workers use more memory.
- `--builders` sets how many project references build at the same time under `--build`. Its effect multiplies with `--checkers`, so balance the two against memory.
- `--singleThreaded` runs parsing, checking, and emit in one thread. Use it to debug, to compare results, or on a small machine.

TypeScript 7 rebuilt `--watch` on a Go port of the file watcher from the Parcel bundler.
</native_compiler>

<compiler_api>
TypeScript 7.0 ships without a programmatic API. TypeScript 7.1 adds a new API that differs from the old one, and 7.1 is in beta. Tools that import `typescript` as a library still need the 6.0 code. Examples are typescript-eslint and the tooling for Vue, Svelte, Astro, MDX, and Angular.

The package `@typescript/typescript6` provides the 6.0 API and a `tsc6` command. With npm aliases, tools import the 6.0 API under the name `typescript`, and the native compiler gets its own name. This `package.json` fragment is the pairing that the TypeScript team recommends.

```json
{
  "devDependencies": {
    "@typescript/native": "npm:typescript@^7.0.2",
    "typescript": "npm:@typescript/typescript6@^6.0.2"
  }
}
```

Check the project's linter and framework tooling before you replace `typescript` 6 with 7.
</compiler_api>

<javascript_checking>
TypeScript 7 checks JavaScript and JSDoc with the same rules as TypeScript. These changes matter for a project with `checkJs` or JSDoc types.

- An argument for a parameter typed `any`, `unknown`, or `undefined` can no longer be omitted. A `void` parameter can still be omitted.
- A value cannot stand where a type is expected. Write `typeof someValue` instead.
- The `@enum` tag has no special meaning. Use a `@typedef` instead.
- The `@class` and `@constructor` tags no longer turn a function into a constructor. Constructor functions that assign to `this` are not supported, so write a `class`.
- A JSDoc variadic type is only an array type. Write a real rest parameter, because `arguments` in the body no longer implies one.
- The compiler ignores `@overload` on arrow functions and function expressions. Use one `@type` with several call signatures instead.
- A standalone `?` is no longer a type, so write `any`. A postfix `!` is not supported, so write the plain type.
- Closure-style function types such as `function(string): void` are no longer supported.
- A CommonJS module cannot mix an assignment to `module.exports` with assignments to `module.exports.name`. Use one style per module.
- A fallback like `f.x = f.x || init` no longer declares an expando property. Write `if (!f.x) f.x = init` instead.

Declaration output for `.js` files was rewritten and does not match 6.0 exactly. Review the generated `.d.ts` files after the switch.
</javascript_checking>
