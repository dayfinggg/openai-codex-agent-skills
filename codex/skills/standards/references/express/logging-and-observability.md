# Logging and observability

Use a trusted structured logger in request middleware and application services.
Include request ID, route template, method, status, duration, and stable error code.
Redact authorization headers, cookies, passwords, tokens, and personal data.
Do not log full request bodies by default.
Emit one completion record per request and additional records for meaningful state changes or failures.
Record request rate, status classes, latency percentiles, event-loop delay, dependency latency, and saturation.
Preserve the request ID across outbound calls and background jobs.
