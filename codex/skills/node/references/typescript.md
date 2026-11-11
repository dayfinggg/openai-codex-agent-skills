<contents>
This file has these sections, in order.
- type stripping
- limits
- erasable syntax
- file extensions
- tsconfig development
- tsconfig build
- package json
- type checking
</contents>

<type_stripping>
Node.js runs TypeScript files directly by stripping the type annotations. It does no type checking and no transform. Stripping is on by default since Node.js 23.6 and 22.18, and it is stable since 25.2 and 24.12. So `node app.ts` works on every supported line without a flag. Node.js 26 removed `--experimental-transform-types`. On 22 and 24 that flag still runs enums and other transformed syntax, and without it they fail on every line.

```bash
node app.ts
```

Use type stripping instead of ts-node or tsx when the project has no build step yet. Keep the runner the project already uses, as `code_rules` requires. Type-level work and tsconfig design beyond this file belong to the `typescript` skill.
</type_stripping>

<limits>
Node.js ignores `tsconfig.json`, so options such as `paths` or a lower `target` have no effect at runtime. It refuses to strip files under `node_modules`, so packages must publish JavaScript. `.tsx` files are not supported. `.mts` files always run as ESM, and `.cts` files always run as CommonJS. A `.ts` file follows the `type` field of the nearest `package.json`, like a `.js` file.
</limits>

<erasable_syntax>
Only erasable syntax runs, which is type syntax that can be removed without new JavaScript. Syntax that needs a transform throws `ERR_UNSUPPORTED_TYPESCRIPT_SYNTAX`. Set `erasableSyntaxOnly` in `tsconfig.json`, so `tsc` reports such syntax before runtime.

<type_imports>
Mark type-only imports with `type`. Without it, Node.js treats the import as a value import, and the program fails at runtime. These two forms both work.

```typescript
import type { User, Config } from './types.ts';
import { createUser, type User } from './user.ts';
```

This form fails at runtime when `User` is only a type.

```typescript
import { User, createUser } from './user.ts';
```

`verbatimModuleSyntax` makes `tsc` enforce the `type` keyword.
</type_imports>

<no_enums>
Enums need a transform. This enum fails under type stripping.

```typescript
enum Status {
  Active = 'active',
  Inactive = 'inactive',
}
```

Use a const object and a derived union type instead.

```typescript
const Status = {
  Active: 'active',
  Inactive: 'inactive',
} as const;

type Status = (typeof Status)[keyof typeof Status];
```
</no_enums>

<no_runtime_namespaces>
A namespace with runtime code needs a transform. This namespace fails because it exports a function.

```typescript
namespace Utils {
  export function format(s: string): string {
    return s.trim();
  }
}
```

Use a module export instead. A namespace that holds only types still works.

```typescript
export function format(s: string): string {
  return s.trim();
}
```
</no_runtime_namespaces>

<no_parameter_properties>
Constructor parameter properties need a transform. This class fails.

```typescript
class User {
  constructor(public name: string, private age: number) {}
}
```

Declare the fields and assign them in the constructor instead.

```typescript
class User {
  name: string;
  private age: number;

  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }
}
```
</no_parameter_properties>

<no_decorators_or_import_aliases>
Node.js does not transform or polyfill decorators, so any decorator is a parse error. This affects frameworks such as NestJS, which need a compile step. Import aliases such as `import fs = require('fs')` also fail.
</no_decorators_or_import_aliases>
</erasable_syntax>

<file_extensions>
Relative imports need the real file extension, in `import`, `import()`, and `require()` alike. Write `.ts` in the specifier. `allowImportingTsExtensions` lets `tsc` accept it, and `rewriteRelativeImportExtensions` turns it into `.js` in emitted code.

```typescript
import { helper } from './helper.ts';
import type { Config } from './types.ts';
import config from './config.json' with { type: 'json' };
```
</file_extensions>

<tsconfig_development>
The Node.js docs recommend TypeScript 5.8 or later with these core options. `noEmit` fits code that only runs as `.ts`, such as scripts and apps.

```json
{
  "compilerOptions": {
    "target": "esnext",
    "module": "nodenext",
    "rewriteRelativeImportExtensions": true,
    "erasableSyntaxOnly": true,
    "verbatimModuleSyntax": true,
    "allowImportingTsExtensions": true,
    "noEmit": true,
    "strict": true,
    "skipLibCheck": true,
    "types": ["node"]
  },
  "include": ["src/**/*.ts", "test/**/*.ts"]
}
```

`types` must list `node`, because TypeScript 6 and later no longer load every `@types` package by default. The `typescript` skill covers other changed defaults.
</tsconfig_development>

<tsconfig_build>
A package that publishes JavaScript needs a separate build config. This one emits JavaScript, declarations, and source maps into `dist`.

```json
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "noEmit": false,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "rootDir": "src",
    "outDir": "dist"
  },
  "include": ["src/**/*.ts"]
}
```

`rewriteRelativeImportExtensions` from the base config rewrites `.ts` specifiers to `.js` in the output. `declaration` emits `.d.ts` files, and `declarationMap` maps them back to the source. Set `rootDir` explicitly, because TypeScript 6 and later default it to the folder of the tsconfig. Build with `tsc -p tsconfig.build.json`.
</tsconfig_build>

<package_json>
This `package.json` publishes the build output as ESM and runs the tests directly from TypeScript.

```json
{
  "type": "module",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "import": "./dist/index.js"
    }
  },
  "files": ["dist", "README.md", "LICENSE"],
  "scripts": {
    "build": "tsc -p tsconfig.build.json",
    "clean": "rm -rf dist",
    "prepublishOnly": "npm run clean && npm run build",
    "test": "node --test \"test/**/*.test.ts\"",
    "typecheck": "tsc --noEmit"
  },
  "engines": {
    "node": ">=22.18.0"
  }
}
```
</package_json>

<type_checking>
Type stripping does not check types, so run `tsc --noEmit` as a separate step. Run it before you report a TypeScript change as done, as the `verification` block requires.

```bash
tsc --noEmit
tsc --noEmit --watch
```
</type_checking>
