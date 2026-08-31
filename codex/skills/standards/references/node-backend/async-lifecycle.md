# Async lifecycle

Return or await every promise owned by a request, startup hook, shutdown hook, or background task.
Give intentionally detached work an explicit error owner and shutdown policy.
Propagate a request deadline and `AbortSignal` to supported fetch, timer, stream, and database operations.
Use `AbortSignal.timeout()` for bounded operations and compose it with client cancellation. [N4]
Register abort listeners with `{ once: true }` and remove them in `finally` when successful completion can occur before abort. [N4]
Use `stream.pipeline()` so completion, backpressure, and abort failures share one promise. [N5]
Create pools and clients during startup rather than lazily in every handler.
Report readiness only after required dependencies are usable.
On shutdown, stop accepting traffic, drain in-flight work, close the server, and release clients.
`server.close()` stops new connections and waits for active work; forceful closure is a separate decision. [N1]
Handle `SIGTERM` and `SIGINT` once, make shutdown idempotent, and bound the drain window. [N3]
Do not schedule asynchronous work from a `process.on('exit')` handler. [N3]
