---
name: node
description: Gives current Node.js runtime practice. Use it whenever you write, review, or debug Node.js servers, CLIs, workers, or scripts. Use it for streams, errors, logging, caching, environment config, and graceful shutdown. Use it for node:test mechanics, test runs that never exit, profiling, and running TypeScript directly in Node. Use it when choosing Node APIs for the installed version or upgrading Node.
---

<project_first>
Follow the project's existing tools and versions before any advice here, as `code_rules` requires. Read these files first.

- The `engines` field in `package.json`, and `.nvmrc` or `.node-version`
- The lockfile, which names the package manager (`package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, or `bun.lock`)
- The `type` field, which decides between ESM and CommonJS
- The test runner, framework, logger, and validation library already in `package.json`

Use an API only when the project's Node.js version has it. A library that a reference file recommends, such as pino or close-with-grace, is a default for new code. A new dependency still needs the user's request or the repository's practice for this kind of change, as `code_rules` says.
</project_first>

<references>
Each reference file holds the rules for one topic, which this file does not repeat. Read the whole file as soon as the work reaches its topic, also later in the task, and apply every rule in it that fits the case.

- Before you rely on a Node.js API that depends on the version, choose between ESM and CommonJS, use `require(esm)`, load env files, or upgrade Node.js, read [node-lts.md](references/node-lts.md). It lists the supported lines and what each one added or removed.
- Before you run TypeScript in Node.js, write its tsconfig, or publish a TypeScript package, read [typescript.md](references/typescript.md). Node.js runs `.ts` files directly through type stripping on every supported line, so new code needs no loader such as tsx or ts-node.
- Before you write or change tests with `node:test`, mocks, or snapshots, read [testing.md](references/testing.md).
- When a process or test run never exits, read [stuck-processes-and-tests.md](references/stuck-processes-and-tests.md).
- Before you handle signals, shut a server down, or add a health check, read [graceful-shutdown.md](references/graceful-shutdown.md).
- Before you define error types, classify errors, or handle process-level errors, read [error-handling.md](references/error-handling.md).
- Before you build a pipeline or a transform over a large input, or handle backpressure, read [streams.md](references/streams.md).
- Before you add a cache or change how one is invalidated, read [caching.md](references/caching.md).
- Before you profile, benchmark, or take a diagnostic report, read [profiling.md](references/profiling.md).
- Before you add or change logging or redaction, read [logging.md](references/logging.md).
- Before you validate config from the environment or branch on `NODE_ENV`, read [environment.md](references/environment.md).
</references>

<scope>
This skill covers the Node.js runtime, its built-in servers and APIs, and running TypeScript in Node.js. Web frameworks are out of scope, so follow the framework's own docs for the installed version. Type-level work and tsconfig design belong to the `typescript` skill. Language features, browser code, and React belong to the `javascript` skill. Test strategy and flaky tests belong to the `testing` skill, and this skill covers the `node:test` mechanics.
</scope>
