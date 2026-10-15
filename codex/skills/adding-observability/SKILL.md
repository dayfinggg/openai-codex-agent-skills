---
name: adding-observability
description: Adds and reviews logs, metrics, traces, error reporting, and health endpoints with OpenTelemetry and structured logging. Use when code logs, measures, traces, or reports errors, or when changing logging setup, audit logs, or health checks.
---

# Adding observability

Telemetry lets people answer questions about a running system without shipping new code, and every log line, span, and metric is also a place where secrets and personal data leak. Use OpenTelemetry instrumentation and its stable names, keep telemetry structured and correlated, and collect only what serves an operational or security purpose. The writing-clean-code skill covers error handling in general, the writing-secure-code skill covers secrets, authentication, and access control, the building-resilient-services skill covers timeouts, retries, configuration, shutdown, and the design of health checks, and the securing-llm-features skill covers what to record about model and tool calls. When the project already has a logging library, a telemetry setup, or a field naming scheme, follow it over this skill.

## Instrumentation

- **Prefer existing instrumentation.** Before writing a span by hand, look in the project and the OpenTelemetry registry for an agent or instrumentation library that already covers the web framework, HTTP client, database driver, or message broker. Write manual spans only for business operations no library can see.
- **Know what a library emits.** Before adding or upgrading an instrumentation library, read which spans, metrics, and attributes it produces, because the output depends on its configuration and on what the application does. A missing optional attribute is not a defect.
- **Set up the SDK once.** Initialize OpenTelemetry in the composition root at startup, configure it through the standard `OTEL_*` environment variables such as `OTEL_SERVICE_NAME`, and flush and shut down the providers on exit.
- **Propagate context.** Keep the default W3C Trace Context propagation (`traceparent`) across every outgoing call and message, so one trace spans all services.

## Names and attributes

- **Use stable semantic conventions.** For HTTP, databases, and errors use the stable names, such as `http.request.method`, `http.response.status_code`, `http.route`, `url.full`, `url.path`, `server.address`, `db.system.name`, `db.operation.name`, `db.collection.name`, and `error.type`. Confirm every name in the semantic conventions on opentelemetry.io before using it, prefer the constants from the language's semantic conventions package, and never invent a name for something the conventions already define.
- **Name custom attributes in your own namespace.** Prefix them with the company's reverse domain name, as in `com.acme.order.tier`, in lowercase with dots between namespaces and snake_case inside them. Never reuse an OpenTelemetry namespace for a custom attribute, and never start a name with `otel.`.
- **Keep span names low in cardinality.** Name server spans after the route template, as in `GET /orders/{orderId}`, and database spans after the operation and target, as in `SELECT orders`. Never put raw paths or identifiers in a span name.
- **Switch convention versions on purpose.** Instrumentations that still emit the old HTTP or database names move to the stable ones with `OTEL_SEMCONV_STABILITY_OPT_IN` set to `http` or `database`, or to `http/dup` or `database/dup` to emit both during a rollout. Dashboards and alerts query by attribute name, so update them in the same change.
- **Treat `gen_ai.*` as in development.** The GenAI conventions have Development stability and live in their own repository, so names can change between versions. Pin the exact version of any GenAI instrumentation package, note which convention version it emits, and keep message content capture off unless the user asks, because it is likely to contain personal data.
- **Record errors once and plainly.** On failure set the span status to Error and `error.type` to a low cardinality error class such as the exception type, and record the exception once. Leave the status unset on success and, on server spans, for 4xx responses.

## Logs

- **Keep the application's logging library.** Log through the logger the project already uses, such as SLF4J with Logback or Log4j, Python `logging`, `slog`, `ILogger`, pino, or winston, and bridge it into OpenTelemetry with the appender, handler, or instrumentation for that library. Never call the OpenTelemetry Logs Bridge API from application code, because it exists for appender authors.
- **Log structured events.** Write a constant message plus named fields, never a string built by concatenation or interpolation, so fields stay searchable and values cannot rewrite the message.
- **Correlate every line.** Each log line written inside a request carries the trace ID and span ID, which the bridge or log correlation adds, and the correlation ID the service already uses.
- **Write to stdout as an event stream.** Following Twelve-Factor, each process writes its log events unbuffered to stdout and never routes, stores, or rotates log files itself. The platform or an OpenTelemetry pipeline collects them.
- **Choose levels by who must act.** Error marks a failed operation that someone must look at, Warning an unexpected condition the code handled, Information a significant business or lifecycle event, and Debug or Trace diagnostic detail that stays off in production unless someone is investigating. Use the project's level names.
- **Log an error once.** Either handle an error and log it, or add context and rethrow it, never both. The boundary that finally handles it, such as the request handler, job runner, or global handler, logs it once with the stack trace.
- **Keep logging failures harmless.** A failure to write or export telemetry never stops the application and never leaks information.

## Security events

Log the events the OWASP Logging Cheat Sheet lists, chosen by what this application can actually detect rather than as a blind checklist. These include input validation failures, authentication successes and failures, authorization failures, session management failures, user and privilege administration, use of admin rights, sensitive data access, key use and rotation, data import and export, file uploads, deserialization failures, backend TLS and certificate failures, and configuration changes. Each event records when (an international timestamp and the correlation ID), where (application, version, host, service, URL or code location), who (source address and user or machine identity), and what (event type, severity, a security flag, and the result). The full list is in the security logging reference.

## Data that never enters telemetry

- **Never record secrets or personal data.** Passwords, access and refresh tokens, API keys, session IDs, authorization headers, cookies, connection strings, encryption keys, payment card data, source code, and personal data stay out of log messages, log fields, span attributes, span events, baggage, metric attributes, and exception messages. Hash a session ID only when sessions must be tracked.
- **Collect only what serves a purpose.** The best way to avoid collecting sensitive data is to not collect data that might be sensitive, so never log whole request or response bodies, header maps, or query parameter values.
- **Generalize instead of hashing.** Hashes of small or predictable inputs such as numeric user IDs can be reversed. Keep only the domain of an email address, drop the last octet of an IPv4 address or the last 80 bits of an IPv6 address, and keep only the year or year and month of a date.
- **Keep baggage clean.** Baggage travels in HTTP headers to downstream services, including third-party APIs, so it never carries sensitive values.
- **Redaction is a safety net.** Logger redaction rules and Collector processors catch mistakes, but the code itself must not emit the data.

## Log injection

Treat every value from outside the trust boundary as untrusted in logs too. Prefer a structured encoder such as JSON that escapes values for the output format. When the output is plain text, replace CR, LF, and the format's delimiter characters in untrusted values before logging. Logs written to a database follow the parameterization rules of the working-with-databases skill.

## Metrics

- **Start from the standard metrics.** HTTP and database instrumentation already emits stable histograms such as `http.server.request.duration`, `http.client.request.duration`, and `db.client.operation.duration` in seconds. Add custom metrics only for questions they cannot answer.
- **Keep attributes bounded.** Every unique combination of attribute values is a new time series. Never use user IDs, email addresses, raw URLs, request or session IDs, user input, or free-form error messages as metric attributes. Use route templates, status codes, methods, and bounded error categories, and answer per-user questions with traces and logs.
- **Use base units.** Measure time in seconds and sizes in bytes, use one unit per metric, and set the unit on the instrument.

## Health endpoints

The building-resilient-services skill covers how liveness and readiness checks are designed. This skill covers what they expose and how they are watched.

- **Expose the minimum.** A probe response carries the status only, never connection strings, versions of dependencies, hostnames, or exception text. Detailed diagnostics require authorization, and an obscure path or port is not access control.
- **Keep probes read-only and cheap.** A probe never changes data or starts workflows, and an expensive check runs periodically and serves the cached result.
- **Alert on flows, not single probes.** Combine probe results with metrics, logs, and traces, and alert on meaningful changes in the health of critical flows instead of on individual probe failures.
- **Health checks complement telemetry.** A health endpoint does not replace logging and auditing, and the reason a check failed belongs in a log event, not in the probe response.

## Workflow

1. Find the logging library, its configuration, the OpenTelemetry setup or agent, the exporter, the field naming scheme, and the correlation ID.
2. Name the question the new telemetry answers and pick the signal, a metric for rates and durations, a span for the path of a request, a log for a discrete event, and a security event for the OWASP list.
3. Look for an existing instrumentation library or agent, and add manual telemetry only for the gap.
4. Confirm every attribute and metric name in the semantic conventions on opentelemetry.io.
5. Write the change, then check every recorded value against the never-record list, the cardinality rules, and the log injection rules.
6. Run the code with a console exporter or local stdout and read the real output.
7. Add tests the writing-tests skill describes, including one that feeds CR and LF into logged input and one that asserts secrets are absent from output.
8. Review against the checklist.

## Checklist

- [ ] Existing instrumentation is used, and manual spans cover only what it cannot see
- [ ] Every attribute name is a stable semantic convention or sits in the company's own namespace
- [ ] `gen_ai.*` instrumentation is pinned and message content capture is off
- [ ] Logs go through the project's logger, are structured, and carry trace and correlation IDs
- [ ] Logs reach stdout or the OpenTelemetry pipeline, not files the application manages
- [ ] Each error is logged once, at the boundary that handles it
- [ ] Security events record when, where, who, and what
- [ ] No secret, token, session ID, connection string, key, card data, or personal data appears in logs, spans, baggage, metrics, or exception messages
- [ ] Untrusted values are encoded or have CR, LF, and delimiters neutralized
- [ ] Metric attributes are bounded and units are base units
- [ ] Health endpoints expose only status, and failure reasons go to logs

## Reference files

Read them before the first change, the language section of the OpenTelemetry file when setting up telemetry or writing spans or metrics, the security logging file when a change logs user input, authentication, authorization, or admin actions, and the examples file for every change.

- [references/opentelemetry.md](references/opentelemetry.md) has setup notes for Python, JavaScript and TypeScript, Java, Go, and .NET, the shared environment variables, and the stable HTTP, database, and error attribute names.
- [references/security-logging.md](references/security-logging.md) has the OWASP list of events to log, the event attributes, the never-record list, generalization rules, log injection defenses, and logging tests.
- [examples.md](examples.md) has before and after pairs for structured logs, a leaked token, invented span attributes, a user ID in a metric attribute, log forging, double logging, and health endpoints.
