<contents>
This file has these sections, in order.
- prefer esm
- file extensions
- barrel exports
- named exports
- dynamic imports
- esm paths
- require esm
</contents>

<prefer_esm>
Use ES Modules (ESM) for new projects. In an existing project, keep the module system it already uses. `"type": "module"` in `package.json` makes `.js` files ESM.

```json
{
  "type": "module"
}
```

Named exports and named imports are the default style.

```typescript
export function processData(data: Data): Result {
  return transform(data);
}

export const CONFIG = {
  timeout: 5000,
};
```

```typescript
import { processData, CONFIG } from './utils.js';
```
</prefer_esm>

<file_extensions>
Include the file extension in every relative ESM import. Native ESM does not resolve a path without an extension, and only bundlers accept it. A JSON import also needs the `type` import attribute.

```typescript
import { helper } from './helper.js';
import config from './config.json' with { type: 'json' };
```

This import works in a bundler but fails in Node.js.

```typescript
import { helper } from './helper';
```
</file_extensions>

<barrel_exports>
An index file can group the exports of a folder. This index re-exports three modules, and the consumer imports from it.

```typescript
export { formatDate, parseDate } from './date.js';
export { formatCurrency } from './currency.js';
export { validateEmail } from './validation.js';
```

```typescript
import { formatDate, formatCurrency } from './utils/index.js';
```

Large barrels slow startup and tests, because importing one name loads every module behind the barrel.
</barrel_exports>

<named_exports>
Prefer named exports, because they refactor and tree-shake better. These two functions use named exports.

```typescript
export function createServer(config: Config): Server {
  return new Server(config);
}

export function createClient(config: Config): Client {
  return new Client(config);
}
```

Avoid a default export such as this one.

```typescript
export default function createServer(config: Config): Server {
  return new Server(config);
}
```
</named_exports>

<dynamic_imports>
Dynamic `import()` loads code on demand or under a condition. This function loads only plugins in a fixed allowlist.

```typescript
const pluginLoaders = new Map([
  ['csv', () => import('./plugins/csv.js')],
  ['json', () => import('./plugins/json.js')],
]);

async function loadPlugin(name: string): Promise<Plugin> {
  const load = pluginLoaders.get(name);
  if (!load) throw new Error('Unknown plugin');
  const module = await load();
  return module.default;
}

const { default: heavy } = await import('./heavy-module.js');
```

Never build the import path from user input, because that loads arbitrary code.
</dynamic_imports>

<esm_paths>
ESM has no `__dirname` or `__filename`. Use `import.meta.dirname` and `import.meta.filename`, which are stable since Node.js 24 and 22.16.

```typescript
import { join } from 'node:path';

const configPath = join(import.meta.dirname, 'config.json');
const currentFile = import.meta.filename;
```

`import.meta.main` is `true` when the module is the process entry point. It exists since Node.js 24.2 and 22.18 and is still marked early development.

```typescript
if (import.meta.main) {
  main();
}
```
</esm_paths>

<require_esm>
`require()` can load ES modules without a flag since Node.js 22.12, and the feature is stable since 25.4. The module must have no top-level `await` in its graph, or `require()` throws `ERR_REQUIRE_ASYNC_MODULE`. Use `import()` for such modules. `process.features.require_module` detects support, and `--no-require-module` turns it off.

An ES module can choose what `require()` returns by exporting a value under the string name `"module.exports"`. CommonJS consumers then lose the other named exports.

```javascript
export default class Point {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
}

export { Point as 'module.exports' };
```

[node-lts.md](node-lts.md) lists more module changes in current Node.js lines.
</require_esm>
