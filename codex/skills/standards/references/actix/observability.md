# Observability

- Initialize the logging or tracing subscriber before starting the server, and configure filters from deployment settings [T8].
- Use Actix `Logger` for access records and a tracing middleware when spans, metrics, or distributed context are required [B3] [B12].
- Record method, route template, status, latency, request ID, and failure category without placing user IDs in metric label values.
- Keep request IDs and trace context available to downstream services, and redact cookies, authorization headers, and bodies.
- Measure request count, in-flight requests, latency distributions, status classes, payload rejections, and dependency outcomes.
- Measure database pool wait separately from query execution so pool saturation is visible.
- Use the maintained telemetry workshop example as a reference for request spans, concurrency gauges, duration histograms, and success labels [B12].
