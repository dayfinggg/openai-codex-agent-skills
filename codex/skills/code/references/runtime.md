# Runtime and delivery decisions

Apply these rules only when the changed code creates the corresponding runtime risk. Prefer the language and framework's documented mechanisms over cross-language habits. The `security` and `performance` skills own detailed threat analysis and measured optimization; this reference keeps only the runtime contracts ordinary implementation must preserve.

## Errors, effects, and resources

1. Distinguish invalid input, expected domain outcomes, transient infrastructure failure, permanent external failure, cancellation, and programmer defects. Give each category a deliberate contract.
2. Validate at trust or representation boundaries and avoid repeating the same validation throughout trusted internal code.
3. Preserve the original cause, useful context, and machine-readable error identity while adding information. Do not swallow errors, expose secrets, or log and continue without a defined recovery contract.
4. Recover only where the caller can take a meaningful action. Otherwise propagate or terminate through the platform's normal mechanism.
5. Release files, locks, transactions, subscriptions, memory, processes, and network resources on every path using structured cleanup.
6. Make partial success explicit. Define atomicity, compensation, idempotency, and recovery before performing several externally visible writes.
7. Bound timeouts, retries, and cancellation. Retry only failures classified as transient when the operation is idempotent or protected against duplicate effects, and prevent retry multiplication across layers.

## Concurrency and asynchronous work

1. Add concurrency only for a demonstrated latency, throughput, responsiveness, or isolation need.
2. Define ownership, synchronization, ordering, lifetime, cancellation, and failure propagation before sharing work or state.
3. Minimize shared mutable state. Prefer immutable messages, task ownership, structured concurrency, and established high-level primitives over manual threads, lock-free code, or custom schedulers.
4. Bound queues, fan-out, task creation, memory, and retries. Apply backpressure instead of converting load into resource exhaustion.
5. Keep locks scoped and ordered, avoid blocking while holding them, and use only synchronization guarantees established by the language and runtime specification.
6. Exercise realistic interleavings, cancellation, shutdown, and failure propagation with the project's race detector, sanitizer, scheduler controls, or concurrency test facilities when available.

## Caching and repeated work

1. Add or change a cache only when repeated work is material and the allowed staleness is explicit. A cache is not authoritative storage.
2. Define every behavior-changing input in the key, including tenant and authorization context where applicable. Bound value size and total storage.
3. Define freshness, invalidation, write consistency, eviction, negative entries, failure fallback, warm-up, and stampede behavior in proportion to the risk.
4. Use the `performance` skill when the purpose is to meet a measured latency, throughput, resource, or cost target. Do not infer an optimization from code appearance.

## Dependencies

1. Prefer the standard library or an existing project dependency. Add a package only for a demonstrated capability gap and verify compatibility with the project's exact versions.
2. Evaluate maintenance, release history, license, transitive graph, platform support, package and runtime cost, and removal path. Use the `security` skill for provenance, vulnerability, secret, build, or supply-chain risk.
3. Update manifests and lockfiles together according to repository policy, inspect the resolved graph, and avoid opportunistic upgrades unrelated to the requested change.

## Compatibility and releases

1. Identify affected observable contracts, including source and binary APIs, CLI behavior, configuration, environment variables, data schemas, serialized forms, protocols, events, timing, ordering, errors, and supported platforms.
2. Preserve contracts by default. When a break is required, make it explicit, version it according to project policy, provide migration steps, and test supported old-to-new paths.
3. Treat semantic versioning as a communication contract, not proof of compatibility. Verify release notes, resolved versions, supported runtimes, and actual behavior.
4. Avoid language or library features newer than the pinned environment. Preserve declared minimum toolchain and platform versions.
5. Add deprecation or compatibility shims only for real consumers and a defined removal plan. Do not create permanent dual paths for hypothetical callers.
