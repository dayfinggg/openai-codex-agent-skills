<contents>
This file has these sections, in order.
- release lines
- typescript
- language and globals
- modules
- configuration
- permission model
- test runner
- sqlite
- network
- removed and deprecated
</contents>

<release_lines>
Three Node.js lines have support in November 2026. Use the version that the project pins in `engines`, `.nvmrc`, `.node-version`, or its CI and container images.

| Line | Codename | Status | End of life |
|---|---|---|---|
| 26 | Lithium | Active LTS since 2026-10-28 | 2029-04-30 |
| 24 | Krypton | Maintenance LTS since 2026-10-20 | 2028-04-30 |
| 22 | Jod | Maintenance LTS | 2027-04-30 |

Node.js 20, 23, and 25 are end-of-life. Node.js 27 is in Alpha since October 2026. Alpha builds are signed and tested, but their APIs and ABI may change. They are meant for library authors and CI only.

The release schedule changes with Node.js 27. One major line is branched each October and spends six months in Alpha. It becomes Current in April and moves to LTS in October for 30 months. Every line now reaches LTS, and odd numbers no longer mark short-lived lines. Node.js 26 is the last line under the old model. The [release schedule](https://github.com/nodejs/Release) has the dates.
</release_lines>

<typescript>
Type stripping runs `.ts` files without a flag since 23.6 and 22.18, and it is stable since 25.2 and 24.12. Node.js 26 removed `--experimental-transform-types`. On 22 and 24 that flag still runs enums, runtime namespaces, and parameter properties, and without it they fail on every line. [typescript.md](typescript.md) has the rules and the tsconfig.
</typescript>

<language_and_globals>
V8 brings new JavaScript features with each line. The `javascript` skill covers the language itself, and this list shows which Node.js line ships what.

- Node.js 24 ships V8 13.6, with `Float16Array`, explicit resource management (`using`), `RegExp.escape`, and `Error.isError`. `URLPattern` is a global.
- Node.js 25 enables Web Storage by default and makes `ErrorEvent` a global. In 26, `localStorage` is `undefined` unless `--localstorage-file` names a file.
- Node.js 26 ships V8 14.6 and enables `Temporal` by default. It adds `Map.prototype.getOrInsert()`, `getOrInsertComputed()`, and `Iterator.concat()`.
</language_and_globals>

<modules>
Use ES modules for a new project, and keep the module system an existing project already uses. These module facts matter for current code.

- Native ESM needs the file extension in every relative import, as in `./helper.js`, and a JSON import needs `with { type: 'json' }`. A path without an extension works only in a bundler.
- `require()` loads synchronous ES modules without a flag since 22.12, and the feature is stable since 25.4. A module with top-level `await` in its graph makes `require()` throw `ERR_REQUIRE_ASYNC_MODULE`, so load it with `import()`. `process.features.require_module` detects support, and `--no-require-module` turns it off.
- An ES module chooses what `require()` returns with `export { Point as 'module.exports' }`. CommonJS consumers then lose the other named exports.
- `import.meta.main` (24.2 and 22.18) is `true` in the entry module. It is still early development.
- `module.registerHooks()` installs synchronous, in-thread resolve and load hooks and is a release candidate. `module.register()` is runtime-deprecated in 26 (DEP0205), so move custom loaders to `registerHooks()`.
- `import.meta.dirname` and `import.meta.filename` are stable since 24 and 22.16. They replace `__dirname` and `__filename`, which ESM lacks.
</modules>

<configuration>
`--env-file` and `--env-file-if-exists` are stable since 24.10 and 22.21. With several files, later files override earlier ones, and `--env-file-if-exists` does not fail on a missing file. `process.loadEnvFile()` loads a file from code, and without an argument it reads `.env` in the current directory.

`--config-file` is stable since 26.12 and loads options from a JSON file. Without a path, it reads `node.config.json` in the working directory. The file has a `nodeOptions` object for flags allowed in `NODE_OPTIONS`, plus namespaces such as `test`, `watch`, and `permission`. Command-line flags and `NODE_OPTIONS` override the file. Node.js does not validate the file, so use only trusted config files. Before 26.12 the flag is named `--experimental-config-file`, which remains as an alias.

```json
{
  "$schema": "https://nodejs.org/dist/v26.13.0/docs/node-config-schema.json",
  "nodeOptions": {
    "watch-path": "src"
  },
  "test": {
    "test-isolation": "process"
  }
}
```

`node --build-sea config.json` (25.5) builds a single executable application in one step, without a separate blob and injection step. The feature is still experimental.
</configuration>

<permission_model>
The Permission Model is stable since 23.5 and 22.13, and Node.js 24 renamed its flag to `--permission`. With it, a process gets no file, child process, worker, addon, WASI, FFI, or inspector access unless a flag grants it. Since 25.0, network access also needs a grant. The entry point is readable without a grant since 24.2 and 22.17.

```bash
node --permission --allow-fs-read=./data --allow-fs-write=./tmp app.js
```

Other grants include `--allow-child-process`, `--allow-worker`, `--allow-addons`, `--allow-net`, `--allow-wasi`, `--allow-ffi`, and `--allow-inspector`, and `node --help` lists the ones the installed version has. Since 24.4 and 22.18, the flags pass on to child Node.js processes.
</permission_model>

<test_runner>
Recent `node:test` releases added these features. Check that the project's Node.js version has a feature before you use it.

| Feature | Since | Notes |
|---|---|---|
| `t.assert.fileSnapshot(value, path)` and `t.waitFor(fn, options)` | 23.7, 22.14 | Snapshot files update with `--test-update-snapshots` |
| `--test-global-setup` with `globalSetup` and `globalTeardown` exports | 24.0 | Early development |
| `t.mock.property(object, name, value)` | 24.3, 22.20 | Restored after the test |
| `--test-rerun-failures <file>` | 24.7 | Reruns only the tests that failed in the last run |
| `expectFailure` option and `it.expectFailure()` | 25.5, 24.14 | Passes only when the test throws |
| `tags` option with `--experimental-test-tag-filter` | 26.2, 24.19 | Early development |
| `--test-coverage-include-all` | 26.7 | Reports unloaded files with zero coverage |

`test()` returns a promise. Await subtests created with `t.test()`, or the parent can finish first and cancel them. `node:test` has no `retry` option. `t.mock.module()` still needs `--experimental-test-module-mocks` and takes one `exports` object. Its `defaultExport` and `namedExports` options are deprecated.
</test_runner>

<sqlite>
`node:sqlite` needs no flag since 23.4 and 22.13, and it is a release candidate since 25.7. Its whole API is synchronous. In 26.11 the classes became `Database` and `Statement`, and `DatabaseSync` and `StatementSync` remain as deprecated aliases (DEP0210, DEP0211). Use `DatabaseSync` on lines that lack the new names.

```javascript
import { DatabaseSync } from 'node:sqlite';

const db = new DatabaseSync('app.db', { timeout: 5000 });
const user = db.prepare('SELECT * FROM users WHERE id = ?').get(42);
```

The defaults are strict. Foreign key constraints and defensive mode are on. Double-quoted string literals are off, so write SQL strings in single quotes. Other options are `readOnly`, `timeout` for the busy timeout, `readBigInts`, and `allowExtension`.
</sqlite>

<network>
Node.js 26 ships Undici 8 as the engine of `fetch`. `NODE_USE_ENV_PROXY=1` or `--use-env-proxy` (24.5 and 22.21) routes `fetch` and `node:http` requests through `HTTP_PROXY`, `HTTPS_PROXY`, and `NO_PROXY`. The feature is still in active development. `--use-system-ca` trusts the certificate store of the operating system.
</network>

<removed_and_deprecated>
These APIs are gone or deprecated in current lines. The [deprecations page](https://nodejs.org/api/deprecations.html) lists codemods for several of them.

| API | Status | Replacement |
|---|---|---|
| `response.writeHeader()` | Removed in 26 | `response.writeHead()` |
| `node:_stream_*` modules | Removed in 26 | `node:stream` |
| Short GCM tags without `authTagLength` | Removed in 26 | Pass `authTagLength` to the decipher |
| `module.register()` | Runtime-deprecated in 26 | `module.registerHooks()` |
| `SlowBuffer` | Removed in 25 | `Buffer.allocUnsafeSlow()` |
| `fs.rmdir(path, { recursive: true })` | Removed in 25 | `fs.rm(path, { recursive: true, force: true })` |
| `fs.F_OK`, `fs.R_OK`, `fs.W_OK`, `fs.X_OK` | Removed in 25 | `fs.constants` |
| `assert.CallTracker` | Removed in 25 | `t.mock.fn()` call tracking |
| `worker.terminate()` with a callback | Removed in 25 | The returned promise |
| Closing a `FileHandle` on garbage collection | Removed in 25 | Close each handle explicitly |
| `url.parse()` | Deprecated for application code since 24 | `new URL()` |
| `util.isBoolean()` and the other `util.is*()` checks, except `util.isArray()`, which is only deprecated | Removed in 23 | `typeof` and native checks |
| `crypto.createCipher()` | Removed in 22 | `crypto.createCipheriv()` |

Corepack is no longer bundled since Node.js 25. Install it separately when the project uses it.
</removed_and_deprecated>
