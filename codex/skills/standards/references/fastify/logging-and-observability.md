# Logging and observability

Enable Fastify logging at instance creation and configure it by environment. [F7]
Use the built-in Pino logger for structured JSON in production. [F7]
Use `request.log` in handlers and `fastify.log` for application lifecycle events. [F7]
Keep pretty transports in development or test, not in production. [F7]
Include request ID, route template, method, status, duration, error code, and dependency identifiers.
Redact authorization headers, cookies, passwords, tokens, and personal data before serialization.
Do not log full request bodies by default.
Record request rate, status classes, latency percentiles, event-loop delay, pool saturation, and queue depth.
Use `onResponse` for completion metrics and avoid delaying the response for telemetry.
