---
name: node
description: Change Node.js runtime behavior or diagnose streams, async work, process lifecycle, and node:test failures.
---

Establish the Node version, module system, and existing runner from the project.
Read only the reference for the operation.
- Async ordering and cancellation use [async-patterns.md](references/async-patterns.md).
- Error codes and causes use [error-handling.md](references/error-handling.md).
- Backpressure and pipelines use [streams.md](references/streams.md).
- Imports and ESM use [modules.md](references/modules.md).
- node:test uses [testing.md](references/testing.md).
- Intermittent tests use [flaky-tests.md](references/flaky-tests.md).
- Processes that never exit use [stuck-processes-and-tests.md](references/stuck-processes-and-tests.md).
- Package internals use [node-modules-exploration.md](references/node-modules-exploration.md).
- Event-loop delays and resource limits use [performance.md](references/performance.md).
- Cache lifetime and invalidation use [caching.md](references/caching.md).
- CPU or memory measurements use [profiling.md](references/profiling.md).
- Logging uses [logging.md](references/logging.md).
- Environment configuration uses [environment.md](references/environment.md).
- Signals and draining use [graceful-shutdown.md](references/graceful-shutdown.md).
- Direct TypeScript execution uses [typescript.md](references/typescript.md).
- Runtime upgrades use [node-lts.md](references/node-lts.md), checked against the current official support schedule.

Reference versions are snapshots, not authorization to upgrade. Type stripping does not replace type checking.
