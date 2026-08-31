# Observability

- Initialize one `tracing_subscriber` before serving requests and set filters from deployment configuration [T8].
- Use `TraceLayer` to record request start, matched route, status, latency, body-stream failures, and classified failures [H2].
- Prefer `MatchedPath` or another route template over raw URLs so IDs do not become high-cardinality metric labels [A9].
- Correlate logs and outbound work with request IDs and trace context, while redacting authorization, cookies, and personal data [H4] [H5].
- Measure request count, in-flight work, latency distributions, status classes, body-limit rejections, and dependency outcomes.
- Measure database pool wait separately from query execution so saturation has a visible signal.
- Use the maintained Axum tracing example as a reference for spans, rejection filters, response hooks, and stream hooks [A9].
