# Logging and observability

Use Nest's `Logger` or a custom `LoggerService` through dependency injection.
Enable JSON logging for production aggregation and keep development formatting environment-specific. [Nst12]
Use a logger context named for the provider or feature.
Include request ID, route template, method, status, duration, error code, and dependency identifiers.
Redact authorization headers, cookies, passwords, tokens, and personal data.
Do not log full request bodies by default.
Emit one completion record per request and additional records for meaningful state changes or failures.
Record request rate, status classes, latency percentiles, event-loop delay, dependency latency, and pool saturation.
Propagate trace context through outbound clients and background jobs.
