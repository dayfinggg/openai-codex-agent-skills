---
name: node
description: Gives current Node.js runtime practice. Use it when writing, reviewing, or debugging Node.js servers, CLIs, workers, or scripts. Use it for streams, async code, errors, logging, caching, environment config, and graceful shutdown. Use it for flaky or hanging tests with node:test, for profiling, and for running TypeScript directly in Node. Use it when choosing Node APIs for the installed version or upgrading Node.
---

<project_first>
Follow the project's existing tools and versions before any advice here, as `code_rules` requires. Read these files first.

- The `engines` field in `package.json`, and `.nvmrc` or `.node-version`
- The lockfile, which names the package manager (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, or `bun.lock`)
- The `type` field, which decides between ESM and CommonJS
- The test runner, framework, logger, and validation library already in `package.json`

Use an API only when the project's Node.js version has it. [node-lts.md](references/node-lts.md) lists the supported lines and what each one added or removed. A library recommended here, such as pino or close-with-grace, is a default for new code. A new dependency still needs the user's request, as `code_rules` says.
</project_first>

<scope>
This skill covers the Node.js runtime, its built-in servers and APIs, and running TypeScript in Node.js. Web frameworks are out of scope, so follow the framework's own docs for the installed version. Type-level work and tsconfig design belong to the `typescript` skill. Language features, browser code, and React belong to the `javascript` skill. Test strategy in general belongs to the `testing` skill, and this skill covers the `node:test` mechanics.
</scope>

<typescript_in_node>
Node.js runs `.ts` files directly through type stripping on every supported line. Only erasable syntax works, so use `import type`, const objects instead of enums, and no runtime namespaces or parameter properties. Write `.ts` extensions in relative imports. Type stripping does not check types, so run `tsc --noEmit` as well. This file runs with `node greet.ts`.

```ts
import type { IncomingMessage } from 'node:http';

const greet = (name: string): string => `Hello, ${name}!`;
console.log(greet('world'));
```

[rules/typescript.md](references/typescript.md) has the full rules and the tsconfig.
</typescript_in_node>

<workflows>
Five workflows recur often. Each one links to its rule file.

- Graceful shutdown registers handlers for `SIGTERM` and `SIGINT` and stops accepting new work. It then drains in-flight requests, closes external connections such as the database and cache, and exits with the right code. See [rules/graceful-shutdown.md](references/graceful-shutdown.md).
- Error handling classifies errors by code and keeps the `cause` chain. It leaves process-level handlers to close-with-grace and logs context before it responds or crashes. See [rules/error-handling.md](references/error-handling.md).
- A flaky test needs its cause found. Isolate the test, check shared state and timer dependencies, and inspect the async teardown order. A retry or a longer timeout hides the fault, so fix the cause instead. See [rules/flaky-tests.md](references/flaky-tests.md).
- A stuck process or test run needs its open handles found. Isolate the file and test, run with an explicit timeout and reporter, and inspect the handles with `why-is-node-running`. Then fix the teardown where the resource is created and rerun until stable. See [rules/stuck-processes-and-tests.md](references/stuck-processes-and-tests.md).
- A slow path needs a profile. Reproduce it under realistic load and capture a CPU profile with flame or `--cpu-prof`. Find the hot functions, check for backpressure problems or needless serialization, and measure the fix with a benchmark. See [rules/profiling.md](references/profiling.md) and [rules/performance.md](references/performance.md).
</workflows>

<streams_and_caching>
Apply this checklist to CSV, ETL, ingestion pipelines, large files, and backpressure. It also applies to repeated lookups and duplicate concurrent async calls.

1. Use `await pipeline(...)` from `node:stream/promises` instead of chained `.pipe()`.
2. Use an `async function*` transform when the existing stream stages cannot express the required transformation simply.
3. Consider a cache when repeated work causes a measured problem and the freshness requirements allow reuse. `lru-cache` fits bounded in-memory reuse in one process. `async-cache-dedupe` fits async request deduplication and stale-while-revalidate. Follow `code_rules` before adding either dependency.
4. Show where backpressure is handled, through `pipeline()` or through an explicit `drain` wait.

For large CSV or ETL inputs, `createReadStream(input)` and `await pipeline(...)` keep memory bounded. Reuse the existing parser and add enrichment or caching only when the task needs them. [rules/streams.md](references/streams.md) and [rules/caching.md](references/caching.md) have the details.
</streams_and_caching>

<references>
Read a rule file when the task touches its topic.

- [rules/async-patterns.md](references/async-patterns.md) for async/await, parallel work, concurrency limits, and cancellation
- [rules/error-handling.md](references/error-handling.md) for error codes, causes, and async errors
- [rules/streams.md](references/streams.md) for pipelines, transforms, backpressure, and stream consumers
- [rules/modules.md](references/modules.md) for ESM, CommonJS, `require(esm)`, and import paths
- [rules/testing.md](references/testing.md) for `node:test`, mocks, snapshots, and hooks
- [rules/flaky-tests.md](references/flaky-tests.md) for tests that fail at random
- [rules/stuck-processes-and-tests.md](references/stuck-processes-and-tests.md) for processes and test runs that never exit
- [rules/node-modules-exploration.md](references/node-modules-exploration.md) for installed versions, dependency trees, and package internals
- [rules/performance.md](references/performance.md) for event loop blocking, worker threads, pools, and leaks
- [rules/caching.md](references/caching.md) for choosing and invalidating caches
- [rules/profiling.md](references/profiling.md) for flame graphs, benchmarks, and diagnostic reports
- [rules/logging.md](references/logging.md) for pino, redaction, and debug output
- [rules/environment.md](references/environment.md) for env files, config validation, and secrets
- [rules/graceful-shutdown.md](references/graceful-shutdown.md) for signals, server shutdown, and health checks
- [rules/typescript.md](references/typescript.md) for type stripping, its tsconfig, and publishing TypeScript packages
- [node-lts.md](references/node-lts.md) when the Node.js version matters, such as for an upgrade or a new API
</references>

<attribution>
Read [credits](references/credits.md) when checking source attribution or redistribution terms.
</attribution>
