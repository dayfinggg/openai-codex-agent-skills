---
name: structured-logging
description: "Implement or repair structured application logging with event fields, correlation, redaction, and delivery verification. Use for logging changes, missing error context, or malformed log events."
---

Produce useful diagnostic events without changing unrelated logging behavior.

1. Read the current logger, processors, sinks, formatting, retention, and request or worker context. Establish the symptom or investigation the changed event must support.
2. Choose a stable event meaning and fields from the actual operation. Record outcome, error identity, and relevant bounded context. Preserve existing field contracts used by queries and alerts.
3. Propagate the existing request or trace identity across the changed boundary. Distinguish event time from observation time where collection delay matters. Do not invent trace IDs that cannot join the tracing system.
4. Exclude credentials, session secrets, authorization headers, connection strings, and sensitive bodies. Inspect implicit serialization and exception context as well as explicit message text.
5. Encode structured data through the logger rather than string-concatenating untrusted content. Verify newline and delimiter handling. Avoid logging the same exception at every layer without an operational reason.
6. Check whether logging failure blocks the application or silently drops critical evidence. Reuse configured buffering and backpressure behavior rather than adding an unbounded in-memory queue.
7. Emit representative success and error events through the real configured path. Verify schema, levels, redaction, correlation, sink delivery, and the query that needs the event.

Do not enable production debug output or collect payloads outside the task's authorization. Do not install a new logging platform merely to add an event.

Read [OpenTelemetry Logs](https://opentelemetry.io/docs/specs/otel/logs/data-model/) and [OWASP Logging](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html) for the changed semantics.

