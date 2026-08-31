# Context and observability

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
