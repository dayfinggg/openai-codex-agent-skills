# OpenTelemetry instrumentation

**Reviewed:** 2026-08-11
**Scope:** OpenTelemetry specification and semantic conventions current at review time. Resolve SDK, instrumentation library, collector, exporter, and convention versions locally.

## Initialization and ownership

- Initialize providers once at the repository-defined process boundary and shut them down or flush according to runtime lifecycle.
- Set service name, namespace, instance, version, deployment environment, and cloud or container attributes through the existing resource policy.
- Avoid double instrumentation when auto and manual instrumentation overlap.

## Traces and context

- Use W3C Trace Context where the protocol and stack support it. Validate and bound inbound context rather than trusting arbitrary headers.
- Create spans around meaningful operations and remote boundaries. Set names and attributes with stable low-cardinality values.
- Record exception or error information once at the appropriate span and preserve status semantics. Exclude secrets and sensitive payloads.
- Propagate context across async tasks, queues, and process boundaries using supported libraries. Test loss and invalid-parent behavior.

## Metrics, logs, and exporters

- Follow stable semantic conventions for the installed instrumentation version. Do not mix incompatible convention versions silently.
- Configure temporality, aggregation, histogram boundaries, sampling, batching, timeouts, retries, queue sizes, memory limits, and export endpoints explicitly where material.
- Treat telemetry export as a remote dependency. Fail open or closed according to the application contract, with bounded resource use and diagnostics.

## Official sources

- [OpenTelemetry specifications](https://opentelemetry.io/docs/specs/otel/)
- [OpenTelemetry signals](https://opentelemetry.io/docs/concepts/signals/)
- [OpenTelemetry instrumentation](https://opentelemetry.io/docs/concepts/instrumentation/)
- [OpenTelemetry semantic conventions](https://opentelemetry.io/docs/specs/semconv/)
- [W3C Trace Context](https://www.w3.org/TR/trace-context/)
