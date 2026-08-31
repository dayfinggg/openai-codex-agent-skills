# Concurrency and request cancellation
- Ktor route handlers are suspendable, but `suspend` does not make blocking code non-blocking.
- Keep blocking database, filesystem, and legacy-client calls off the engine's event-loop threads.
- Use a deliberately chosen IO dispatcher or a non-blocking driver at the adapter boundary.
- Bound fan-out, queues, connection pools, and external calls with timeouts and capacity limits.
- Use Ktor's module startup settings deliberately when concurrent module loading is safe for the dependency graph.
- Install `HttpRequestLifecycle` when a disconnected client should cancel long-running request work.
- Let request cancellation reach child work and rethrow `CancellationException` after cleanup.
- Consult the [Kotlin reference](../kotlin/index.md) for general structured-concurrency, dispatcher, shared-state, and coroutine-testing rules.
