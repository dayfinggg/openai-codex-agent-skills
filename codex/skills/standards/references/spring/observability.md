# Observability
- Treat logs, metrics, and traces as one request narrative with stable operation names and correlation context.
- Use Actuator with Micrometer Observation for standard metrics and traces.
- Use `ObservationRegistry` for custom observations instead of coupling business code to a vendor API.
- Use low-cardinality metric tags and keep user identifiers in traces or structured logs only when safe.
- Enable context propagation for asynchronous executors and reactive pipelines when trace context crosses threads.
- Redact credentials, tokens, personal data, and full request bodies by default.
- Keep health and readiness checks aligned with whether the service can receive work.
