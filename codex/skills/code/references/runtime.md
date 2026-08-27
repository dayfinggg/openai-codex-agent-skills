# Runtime and delivery decisions

Apply these rules in proportion to the changed risk. Prefer the language and framework's documented mechanisms over cross-language habits.

## Errors and resources

1. Distinguish invalid input, expected domain outcomes, transient infrastructure failure, permanent external failure, and programmer defects. Give each category a deliberate contract.
2. Validate at trust and representation boundaries. Avoid scattering the same validation through trusted internal code.
3. Preserve the original cause, useful context, and machine-readable error identity while adding information. Do not swallow errors, log and continue without a contract, or expose secrets and internal details to users.
4. Recover only where the caller can take a meaningful action. Otherwise propagate or terminate through the platform's normal mechanism.
5. Release files, locks, transactions, subscriptions, memory, and network resources on every path using the language's structured cleanup facilities.
6. Make partial success explicit. Define transaction, compensation, idempotency, and retry behavior before performing several externally visible writes.
7. Retry only transient idempotent operations, with bounded attempts, backoff, jitter, timeout, and cancellation. Respect server retry guidance and avoid multiplying retries across layers.

## Concurrency and asynchronous work

1. Add concurrency only for a demonstrated latency, throughput, responsiveness, or isolation need. Sequential code is often easier to verify and fast enough.
2. Define ownership, synchronization, ordering, lifetime, cancellation, and failure propagation before sharing work or state.
3. Minimize shared mutable state. Prefer immutable messages, task ownership, structured concurrency, and established high-level primitives over manual threads, lock-free code, or custom schedulers.
4. Bound queues, fan-out, task creation, memory, and retries. Apply backpressure instead of allowing load to become resource exhaustion.
5. Keep locks scoped and ordered, avoid blocking while holding them, and never assume `volatile` or ordinary reads provide synchronization unless the language specification says so.
6. Test realistic interleavings and cancellation. Use the project's race detector, thread sanitizer, deadlock checks, or concurrency test tools when available.

## Performance and caching

1. Preserve clarity until a requirement, profile, trace, benchmark, or production metric identifies a meaningful bottleneck. Do not infer performance from code appearance.
2. Measure representative inputs and user-visible metrics before and after a change. Track distributions and tail latency where averages hide failures.
3. Improve algorithms, data structures, data movement, allocation, batching, and I/O before low-level micro-optimizations. Recheck complexity under expected scale.
4. Keep performance changes isolated and benchmarkable. Record the workload and metric so later runtime, compiler, or dependency changes can be retested.
5. Add caching only when repeated work is measured, hits are likely, and some staleness is acceptable. A cache is not the authoritative data store.
6. Define the cache key, tenant boundary, value size, TTL, invalidation path, write consistency, eviction, negative caching, failure fallback, warmup, and stampede protection.
7. Do not cache secrets or authorization decisions without an explicit security and revocation model. Include all inputs that affect a result in the key.

## Security and dependencies

1. Identify trust boundaries and abuse cases affected by the change. Use secure defaults, least privilege, deny by default, and defense in depth where the consequence justifies it.
2. Validate structured input, encode output for its destination, use parameterized queries, enforce authorization on each protected action, and use maintained cryptographic libraries instead of custom cryptography.
3. Keep secrets out of source, generated artifacts, URLs, client bundles, logs, errors, tests, and telemetry. Redact sensitive values and minimize retained data.
4. Avoid unsafe deserialization, dynamic evaluation, shell interpolation, path traversal, unbounded parsing, and attacker-controlled resource use. Use platform-safe APIs and explicit limits.
5. Prefer the standard library or an existing dependency. For a new dependency, verify provenance, maintenance, release cadence, known vulnerabilities, license, transitive graph, platform support, package size, and removal cost.
6. Pin and lock dependencies according to the ecosystem and repository policy. Update manifests and lockfiles together, inspect the resolved graph, and run vulnerability and provenance checks available to the project.
7. Do not upgrade unrelated dependencies opportunistically. Treat automated security scores and scanners as evidence to investigate, not proof that a package is safe or unsafe.

## Compatibility and releases

1. Identify every observable contract: source and binary API, CLI, configuration, environment variables, data schema, serialized form, protocol, events, timing, ordering, errors, and supported platforms.
2. Preserve contracts by default. When a break is required, make it explicit, version it according to project policy, supply migration steps, and test old-to-new behavior.
3. Treat semantic versioning as a communication contract, not proof of compatibility. Verify actual release notes, resolved versions, supported runtimes, and behavior.
4. Document and test minimum supported toolchain and platform versions when the project has those commitments. Avoid language or library features newer than the pinned environment.
5. Use deprecation and compatibility shims only for real consumers and a defined removal plan. Do not add permanent dual paths for hypothetical callers.
