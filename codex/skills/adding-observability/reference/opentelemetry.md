# OpenTelemetry setup and names

Versions pinned in the project win over this file. Check the opentelemetry.io page for the language before changing a setup, because package names and defaults move between releases.

## Contents

- Maturity by language
- Environment variables
- Python
- JavaScript and TypeScript
- Java
- Go
- .NET
- Stable attribute names

## Maturity by language

| Language | Traces | Metrics | Logs |
|---|---|---|---|
| Python | Stable | Stable | Development |
| JavaScript | Stable | Stable | Development |
| Java | Stable | Stable | Stable |
| Go | Stable | Stable | Release candidate |
| .NET | Stable | Stable | Stable |

## Environment variables

| Variable | Purpose | Default |
|---|---|---|
| `OTEL_SERVICE_NAME` | Sets `service.name` | `unknown_service` |
| `OTEL_RESOURCE_ATTRIBUTES` | Extra resource attributes as key-value pairs | empty |
| `OTEL_TRACES_EXPORTER`, `OTEL_METRICS_EXPORTER`, `OTEL_LOGS_EXPORTER` | Exporter per signal | `otlp` |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | Collector or backend address | depends on the SDK |
| `OTEL_PROPAGATORS` | Context propagators | `tracecontext,baggage` |
| `OTEL_TRACES_SAMPLER` | Sampler | `parentbased_always_on` |
| `OTEL_SEMCONV_STABILITY_OPT_IN` | `http`, `database`, `http/dup`, `database/dup` | old names stay |

## Python

- Install with `pip install opentelemetry-distro opentelemetry-exporter-otlp`, then run `opentelemetry-bootstrap -a install` to add instrumentations for the installed packages.
- Start with `opentelemetry-instrument python app.py`, configured by the variables above or flags such as `--service_name`.
- Keep `logging`. Records reach OpenTelemetry through the SDK's `LoggingHandler`, and `OTEL_PYTHON_LOG_CORRELATION=true` adds the trace context to them.
- Exclude noisy instrumentations with `OTEL_PYTHON_DISABLED_INSTRUMENTATIONS`, as in `redis,kafka`.
- `with tracer.start_as_current_span(name) as span` records an escaping exception and sets status Error by default.
- Import stable names from `opentelemetry.semconv.attributes`, as in `from opentelemetry.semconv.attributes.http_attributes import HTTP_REQUEST_METHOD`. The older `SpanAttributes` class holds pre-stable names such as `http.method`.

## JavaScript and TypeScript

- Install `@opentelemetry/api` and `@opentelemetry/auto-instrumentations-node`, then start Node with `--require @opentelemetry/auto-instrumentations-node/register`, directly or through `NODE_OPTIONS`.
- The bundle enables every instrumentation except `fs` and `host-metrics`. Narrow it with `OTEL_NODE_ENABLED_INSTRUMENTATIONS` or `OTEL_NODE_DISABLED_INSTRUMENTATIONS`.
- Keep pino or winston. Their instrumentations add `trace_id`, `span_id`, and `trace_flags` and can send records to the Logs SDK. Pino sends logs from version 7. Winston needs `@opentelemetry/winston-transport`, and combining that transport with the instrumentation's log sending duplicates every record.
- Wrap manual work in `tracer.startActiveSpan(name, span => ...)` and end the span in `finally`. On failure call `span.recordException(error)` and `span.setStatus({ code: SpanStatusCode.ERROR })`.
- Import stable names from `@opentelemetry/semantic-conventions`, as in `ATTR_HTTP_ROUTE`. The `/incubating` entry point is not bound by semantic versioning, so copy the few unstable definitions you need instead of importing it, as the package README advises.

## Java

- Start with `-javaagent:path/to/opentelemetry-javaagent.jar`, or set it in `JAVA_TOOL_OPTIONS`, plus `OTEL_SERVICE_NAME`. The jar comes from the opentelemetry-java-instrumentation releases.
- Keep SLF4J with Logback or Log4j. Bridge with `opentelemetry-logback-appender-1.0` or `opentelemetry-log4j-appender-2.17`, and add the trace context with the context shims such as `logback-mdc`.
- Structured fields use the SLF4J 2 fluent API, as in `logger.atInfo().setMessage("Order placed").addKeyValue("orderId", id).log()`.
- Manual spans use `tracer.spanBuilder(name).startSpan()` and `span.makeCurrent()` in try-with-resources. On failure call `span.recordException(e)` and `span.setStatus(StatusCode.ERROR)`, and end the span in `finally`.
- Import stable names from `io.opentelemetry.semconv`, as in `HttpAttributes.HTTP_REQUEST_METHOD`.

## Go

- Use instrumentation libraries from `go.opentelemetry.io/contrib`, such as `otelhttp.NewHandler(mux, "/")`.
- Register providers once with `otel.SetTracerProvider`, `otel.SetMeterProvider`, and `global.SetLoggerProvider`, set `otel.SetTextMapPropagator`, and call every provider's `Shutdown` on exit.
- Go has no user-facing logs API. Keep `slog`, zap, logrus, or logr with the matching bridge, such as `otelslog.NewLogger(name)` from `go.opentelemetry.io/contrib/bridges/otelslog`, and log with context methods such as `logger.InfoContext(ctx, msg, "key", value)`.
- `span.RecordError(err)` does not set the status, so also call `span.SetStatus(codes.Error, msg)`.
- Create metrics with `meter.Int64Counter` or `meter.Float64Histogram` and `metric.WithUnit`, and pass attributes with `metric.WithAttributes`.

## .NET

- Add `OpenTelemetry.Extensions.Hosting`, instrumentation packages such as `OpenTelemetry.Instrumentation.AspNetCore`, and `OpenTelemetry.Exporter.OpenTelemetryProtocol`.
- Configure with `builder.Services.AddOpenTelemetry().ConfigureResource(r => r.AddService(serviceName)).WithTracing(...).WithMetrics(...)`, each with `.AddOtlpExporter()`. The OTLP exporter sends over gRPC to `http://localhost:4317` unless configured otherwise.
- Keep `ILogger` and add `builder.Logging.AddOpenTelemetry(logging => logging.AddOtlpExporter())`.
- Log with message templates, as in `logger.LogInformation("Order {OrderId} placed", orderId)`, or with `[LoggerMessage]` source generated methods, which Microsoft calls usually the better choice for performance and typing. Analyzer rule CA2254 flags string interpolation in a log call.
- Spans come from an `ActivitySource` with `StartActivity(name)` inside `using`. Set attributes with `activity?.SetTag(...)`, and on failure call `activity?.AddException(ex)` and `activity?.SetStatus(ActivityStatusCode.Error)`.

## Stable attribute names

HTTP server spans

| Attribute | Requirement |
|---|---|
| `http.request.method` | Required |
| `url.path`, `url.scheme` | Required |
| `url.query` | When present |
| `http.route` | When available, low cardinality template |
| `http.response.status_code` | When a response was sent |
| `error.type` | When the request ended in error |
| `server.address`, `client.address`, `user_agent.original` | Recommended |

HTTP client spans

| Attribute | Requirement |
|---|---|
| `http.request.method`, `url.full`, `server.address`, `server.port` | Required |
| `http.response.status_code` | When a response was received |
| `error.type` | When the request ended in error |
| `http.request.resend_count` | Recommended on retries |

Database client spans

| Attribute | Requirement |
|---|---|
| `db.system.name` | Required, such as `postgresql`, `mysql`, `microsoft.sql_server` |
| `db.namespace`, `db.collection.name`, `db.operation.name` | When available |
| `db.response.status_code`, `error.type` | When the operation failed |
| `db.query.text`, `db.query.summary`, `server.address` | Recommended |

Collect `db.query.text` only when the query is parameterized or its literals are sanitized, and leave `db.query.parameter.<key>` off by default, because the values may hold personal data. Client spans set status Error for 4xx, server spans do not. `error.type` falls back to `_OTHER`.

Stable metrics are the histograms `http.server.request.duration`, `http.client.request.duration`, and `db.client.operation.duration`, all in `s`.
