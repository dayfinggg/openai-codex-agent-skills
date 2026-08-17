# Observability Practices

Metrics summarize trends, logs preserve discrete context, and traces connect work across boundaries. Use each for a decision. Instrument semantic outcomes close to the source and propagate context through asynchronous paths.

High-cardinality values such as user, request, or order identifiers belong in logs or traces, not unrestricted metric labels. Alerts should describe meaningful impact, have an owner and response, and avoid paging on conditions that require no action.

Primary sources:

- [OpenTelemetry observability primer](https://opentelemetry.io/docs/concepts/observability-primer/)
- [Google SRE service-level objectives](https://sre.google/sre-book/service-level-objectives/)
- [Google SRE alerting on SLOs](https://sre.google/workbook/alerting-on-slos/)
- [Prometheus metric and label naming](https://prometheus.io/docs/practices/naming/)
