---
name: adding-observability
description: Adds and reviews logs, metrics, traces, and health endpoints with OpenTelemetry. Use when code logs, measures, traces, or reports errors, or changes logging setup, audit logs, or health checks.
---

# Adding observability

The project's logger, telemetry setup, and field names win over this skill.

## Traces

- Use an existing agent or instrumentation library first, and write manual spans only for what it cannot see.
- Set up the SDK once in the composition root with `OTEL_*` variables, always with `OTEL_SERVICE_NAME`.
- Use stable semantic convention names from the language's semconv package, confirmed on opentelemetry.io. Custom attributes go under the company's reverse domain, as in `com.acme.order.tier`, never under an OpenTelemetry namespace or `otel.`.
- Span names use the route template or the operation and target, as in `GET /orders/{orderId}` and `SELECT orders`.
- Move to stable HTTP or database names with `OTEL_SEMCONV_STABILITY_OPT_IN=http` or `database`, or the `/dup` values to emit both, and update dashboards and alerts in the same change.
- The `gen_ai.*` conventions are in Development, so pin the instrumentation version and keep message content capture off unless the user asks.
- On failure set status Error and `error.type` to the exception class, and record the exception once. Leave the status unset on success and on server spans for 4xx.

## Logs

- Bridge the project's logger with its OpenTelemetry appender or handler. The Logs Bridge API is for appender authors, not application code.
- Write a constant message with named fields, carrying trace ID, span ID, and the correlation ID.
- Write to stdout and leave storage and rotation to the platform.
- Log an error once, at the boundary that handles it. Code that adds context rethrows without logging.

## Data

- Secrets, tokens, session IDs, auth headers, cookies, connection strings, keys, card data, source code, and personal data stay out of logs, spans, baggage, metric attributes, and exception messages. Bodies, header maps, and query values are not logged. Redaction is only a safety net.
- Generalize instead of hashing, because hashes of small inputs reverse. Keep the email domain, drop the last IPv4 octet or last 80 IPv6 bits, keep a date's year or month.
- Untrusted values go through a structured encoder. In plain text replace CR, LF, and delimiters first.
- Metric attributes stay bounded, because each stream caps at 2000 combinations and the overflow breaks queries. Per-user questions go to traces and logs. Units are seconds and bytes.

## Security events, health, checks

Log the OWASP Logging Cheat Sheet events this application can detect, each with when, where, who, and what. A health response carries only the status, and the failure reason goes to a log.

Run with a console exporter and read the real output. Test that CR and LF in logged input stay in one record and that secrets are absent from the output.

## Reference files

- [reference/opentelemetry.md](reference/opentelemetry.md), read when setting up telemetry or writing spans or metrics in a given language.
- [reference/security-logging.md](reference/security-logging.md), read when a change logs input, authentication, authorization, or admin actions.
- [examples.md](examples.md), read before writing a manual span or a security event.
