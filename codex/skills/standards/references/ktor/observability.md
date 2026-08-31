# Observability
- Treat logs, metrics, and traces as one request narrative with stable operation names and correlation context.
- Use SLF4J with `CallLogging` or structured logging and configure the backend for production output.
- Use `MicrometerMetrics` for HTTP and JVM metrics and choose a registry such as Prometheus deliberately.
- Use low-cardinality metric tags and keep user identifiers in traces or structured logs only when safe.
- Use `KtorServerTelemetry` for incoming spans and configure a stable OpenTelemetry service name.
- Install telemetry before other logging or telemetry plugins when the Ktor integration requires that order.
- Redact credentials, tokens, personal data, and full request bodies by default.
- Add health and readiness signals that reflect whether the service can receive work.
