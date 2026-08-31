# Observability and operations

- Use `ILogger<T>` with structured message templates and fields rather than interpolated log strings.
- Record useful request, dependency, outcome, and duration information without logging secrets or unnecessary personal data.
- Treat logs, metrics, and distributed traces as complementary signals rather than substitutes for one another.
- Use `ActivitySource`, `Meter`, and OpenTelemetry instrumentation for ASP.NET Core, outbound HTTP, and database dependencies where a trace backend is available.
- Propagate trace context across service calls and include the trace identifier in safe error responses when it helps support.
- Add health checks with separate liveness and readiness intent, and avoid exposing dependency details on an unauthenticated public endpoint.
- Measure hot paths and query behavior with production-like load before adopting pooling, compiled queries, caching, or other complexity.
