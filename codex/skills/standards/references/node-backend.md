# Framework-neutral Node.js backend standards

Use these rules for HTTP services built directly on Node.js or behind a thin adapter.
Keep transport concerns at the edge and keep application behavior independent of the adapter.
Choose the smallest complete design that makes ownership, failure, and operations obvious.

## Request boundary

Model each request as receive, parse, authenticate, authorize, validate, execute, serialize, and finish.
Keep sockets, headers, cookies, status codes, and request streams in the transport layer.
Pass a typed command and explicit request context into application code.
Give every method and path one clear owner.
Make middleware or adapter setup order visible in one composition root.
Install request metadata and security controls before routes that depend on them.
Terminate a request exactly once.
Return immediately after sending a response.
Treat client disconnects as lifecycle events. Cancel only safely cancellable work, and give committed side effects a durable owner.
Set explicit limits for body bytes, header bytes, parameters, query fields, and upload parts.
Use streams for large bodies and responses instead of unbounded buffers.
Preserve backpressure across every stream boundary.
Set and enforce a supported `Content-Type`.
Parse URLs explicitly and normalize only what the contract permits.
Never infer authorization from a client-controlled value.
Create or validate a request identifier and carry it through downstream calls.

Node's HTTP API parses message framing but leaves header and body interpretation to the application. [N1]

## Validation and representation

Validate path, query, header, cookie, and body data before application work.
Validate types, ranges, lengths, formats, relationships, and allowed values.
Reject unknown fields when the endpoint contract is closed.
Do not confuse compile-time types with runtime validation.
Keep one authoritative schema or validator for each external contract.
Validate output shape when the response is a public or versioned contract.
Serialize an allowlisted response object rather than spreading internal entities.
Do not perform expensive or stateful checks before cheap shape validation.
Return a stable error shape with a request identifier and application code.
Keep detailed validation data in logs only when it is safe to retain.

## Error policy

Throw `Error` instances with a stable application code and, where useful, a `cause`.
Use Node error codes rather than matching mutable error messages. [N2]
Separate expected client errors, domain conflicts, dependency failures, and programmer defects.
Map known failures to deliberate HTTP statuses at one transport boundary.
Do not expose stack traces, SQL, file paths, tokens, or upstream credentials.
Log unexpected failures with the original error, route, request identifier, and safe context.
Do not catch an error merely to log it and continue in an invalid state.
Treat unhandled rejections as ownership defects, not as a background retry mechanism.
Use `uncaughtException` only for last-resort synchronous cleanup before process exit. [N3]
If response bytes have started, finish or abort the stream and never send a second response.

## Async lifecycle

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

## Dependency boundaries

Use constructor or factory injection so dependencies are explicit, replaceable, and testable.
Prefer stateless singleton clients and immutable configuration.
Use request-scoped objects only when request identity or isolation requires them.
Keep composition in a bootstrap function or root module rather than hiding construction in handlers.
Avoid mutable module-level singletons that hide test state and shutdown ordering.
Keep transport objects out of domain and persistence interfaces.
Give each module one cohesive capability and a narrow public interface.
Do not add a container, registry, or plugin layer without a current problem it solves.

## Context and observability

Emit structured logs with level, timestamp, service, environment, route, status, duration, and error code.
Log a matched route template instead of a high-cardinality raw URL when possible.
Redact authorization headers, cookies, passwords, tokens, and personal data before serialization.
Do not log full request bodies by default.
Use one completion log per request and additional logs for meaningful state changes or failures.
Use `AsyncLocalStorage` when request context must cross promise and callback boundaries. [N6]
Prefer `AsyncLocalStorage.run()` over `enterWith()` to isolate one request context. [N6]
Record request count, status classes, duration, saturation, dependency latency, and queue depth.
Trace outbound calls with the same request or trace identifier.
Expose readiness and liveness separately from business endpoints.

## Security and performance

Run a maintained Node.js LTS release and keep it current.
Pin and review dependencies, audit vulnerabilities, and remove unused packages.
Use TLS at the application or trusted proxy boundary and configure proxy trust deliberately.
Keep secrets in a protected environment or secret manager, never in source or logs.
Prevent path traversal, command injection, SSRF, open redirects, brute force, and resource amplification.
Apply authentication before authorization and check authorization at each protected capability.
The Node Permission Model reduces accidental resource access but is not a malicious-code sandbox. [N7]
Keep every event-loop callback and worker-pool task small and bounded. [N8]
Do not use synchronous filesystem, compression, crypto, or child-process APIs on request paths. [N8]
Bound input before expensive JSON, regular-expression, decompression, or cryptographic work.
Review regular expressions for catastrophic backtracking and prefer linear-time alternatives. [N8]
Offload CPU-heavy work to workers or a queue, or partition it so the event loop yields.
Set connection, header, request, upstream, handler, and queue timeouts with an owner for each.
Use Node's header and request timeout controls to protect slow clients when the proxy does not. [N1]
Benchmark the complete service under representative load instead of trusting synthetic framework rankings.
Use event-loop delay, memory, file descriptors, pool saturation, and error rate as capacity signals.

## Testing

Test application services with fake ports and deterministic clocks before testing the HTTP adapter.
Test malformed input, unknown fields, missing auth, wrong auth, and oversized payloads.
Test success, client errors, dependency failures, cancellation, timeout, and duplicate-send paths.
Test response shape and redaction, not only status codes.
Use an ephemeral port or in-process injection so tests can run in parallel.
Close servers, pools, timers, and consumers in teardown.
Use the stable `node:test` runner when another runner is not required. [N9]
Keep a small set of real integration tests for databases, queues, TLS, proxies, and serialization.
Run security, load, and shutdown tests in CI or an environment suited to their cost.

## Design checkpoint

Start with direct functions and one composition root.
Add a module boundary when ownership, lifecycle, or testing becomes clearer through separation.
Add an abstraction only after real callers reveal stable variation.
Keep duplicate test setup when sharing it would hide the behavior under test.
Measure before optimizing unless a hard safety or capacity limit already proves the constraint.
Use Matteo Collina's event-loop resource guidance to measure saturation and queueing, not only throughput. [T1]

## Sources

### Official Node.js documentation

- [N1: Node.js HTTP API](https://nodejs.org/api/http.html)
- [N2: Node.js Errors](https://nodejs.org/api/errors.html)
- [N3: Node.js Process API](https://nodejs.org/api/process.html)
- [N4: Node.js Global AbortController and AbortSignal](https://nodejs.org/api/globals.html)
- [N5: Node.js Streams](https://nodejs.org/api/stream.html)
- [N6: Node.js AsyncLocalStorage](https://nodejs.org/api/async_context.html)
- [N7: Node.js Permission Model](https://nodejs.org/api/permissions.html)
- [N8: Node.js guidance on not blocking the Event Loop](https://nodejs.org/learn/asynchronous-work/dont-block-the-event-loop)
- [N9: Node.js Test Runner](https://nodejs.org/api/test.html)

### Practitioner talk

- [T1: Matteo Collina, “Do Not Thrash the Node.js Event Loop,” USENIX SREcon23 EMEA](https://www.usenix.org/conference/srecon23emea/presentation/collina)
