# OpenTelemetry setup and names

Project conventions, the versions pinned in the project, and the OpenTelemetry documentation on opentelemetry.io win over this file. Check the page for the language at hand before changing a setup, because package names and defaults move between releases.

## Contents

- Maturity by language
- Shared environment variables
- Python
- JavaScript and TypeScript
- Java
- Go
- .NET
- Stable attribute names
- Stable metrics
- Areas still in development

## Maturity by language

| Language | Traces | Metrics | Logs |
|---|---|---|---|
| Python | Stable | Stable | Development |
| JavaScript | Stable | Stable | Development |
| Java | Stable | Stable | Stable |
| Go | Stable | Stable | Release candidate |
| .NET | Stable | Stable | Stable |

In the specification, the Logs Bridge API is stable and exists to write appenders that bridge existing logging frameworks. It is not meant to be called directly by end users.

## Shared environment variables

| Variable | Purpose | Default |
|---|---|---|
| `OTEL_SERVICE_NAME` | Sets the `service.name` resource attribute | `unknown_service` |
| `OTEL_RESOURCE_ATTRIBUTES` | Extra resource attributes as key-value pairs | empty |
| `OTEL_TRACES_EXPORTER`, `OTEL_METRICS_EXPORTER`, `OTEL_LOGS_EXPORTER` | Exporter per signal | `otlp` |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | Collector or backend address | depends on the SDK |
| `OTEL_PROPAGATORS` | Context propagators | `tracecontext,baggage` |
| `OTEL_TRACES_SAMPLER` | Sampler | `parentbased_always_on` |
| `OTEL_SEMCONV_STABILITY_OPT_IN` | Moves instrumentations to stable HTTP or database names (`http`, `database`) or emits both old and new (`http/dup`, `database/dup`) | old names stay |

Always set `OTEL_SERVICE_NAME`, because `unknown_service` makes telemetry from different services impossible to tell apart.

## Python

- Install the distro and exporter with `pip install opentelemetry-distro opentelemetry-exporter-otlp`, then run `opentelemetry-bootstrap -a install` to add instrumentation libraries for the packages already installed.
- Start the application with `opentelemetry-instrument python app.py` and configure it through the shared variables or flags such as `--service_name` and `--logs_exporter`.
- Keep the standard `logging` module. Records reach OpenTelemetry through the SDK's `LoggingHandler` on that module, and `OTEL_PYTHON_LOG_CORRELATION=true` injects the trace context into log records. Before OpenTelemetry Python 1.40.0, logs auto instrumentation was off by default and needed `OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED=true`.
- Exclude noisy instrumentations with `OTEL_PYTHON_DISABLED_INSTRUMENTATIONS`, as in `redis,kafka`.
- For manual spans get a tracer with `trace.get_tracer(__name__)` and use `with tracer.start_as_current_span(name) as span`. By default the context manager records an escaping exception and sets the status to Error.
- Import stable names from `opentelemetry.semconv.attributes`, as in `from opentelemetry.semconv.attributes.http_attributes import HTTP_REQUEST_METHOD`. The older `SpanAttributes` class holds pre-stable names such as `http.method`.

## JavaScript and TypeScript

- Install `@opentelemetry/api` and `@opentelemetry/auto-instrumentations-node`, then start Node with `--require @opentelemetry/auto-instrumentations-node/register`, directly or through `NODE_OPTIONS`.
- The bundle enables every instrumentation except `fs` and `host-metrics`. Narrow it with `OTEL_NODE_ENABLED_INSTRUMENTATIONS` or `OTEL_NODE_DISABLED_INSTRUMENTATIONS`.
- Keep pino or winston. Their instrumentations, both in the bundle, add `trace_id`, `span_id`, and `trace_flags` to records written inside a span and can send records to the Logs SDK. Pino sends logs from version 7, and winston needs `@opentelemetry/winston-transport` to send them. Do not combine the winston transport with the instrumentation's log sending, because that duplicates every record.
- For manual spans call `trace.getTracer(name)` where needed and wrap the work in `tracer.startActiveSpan(name, span => ...)`, ending the span in `finally`. On failure call `span.recordException(error)` together with `span.setStatus({ code: SpanStatusCode.ERROR })`.
- Import stable names from `@opentelemetry/semantic-conventions`, as in `ATTR_HTTP_ROUTE` or `ATTR_URL_FULL`. The `/incubating` entry point holds unstable names and is not bound by semantic versioning, so the package README advises copying the few unstable definitions you need into your own code instead of importing it.

## Java

- Download `opentelemetry-javaagent.jar` from the opentelemetry-java-instrumentation releases and start the application with `-javaagent:path/to/opentelemetry-javaagent.jar`, or set it in `JAVA_TOOL_OPTIONS`, plus `OTEL_SERVICE_NAME`.
- Keep SLF4J with Logback or Log4j. The appenders `opentelemetry-logback-appender-1.0` and `opentelemetry-log4j-appender-2.17` bridge records into OpenTelemetry, and the context shims, such as `logback-mdc` for Logback, add the trace context to log records.
- The Java `LoggerProvider` and `Logger` APIs exist to write appenders and are not a replacement for SLF4J, Logback, or Log4j in application code.
- For structured fields use the SLF4J 2 fluent API, as in `logger.atInfo().setMessage("Order placed").addKeyValue("orderId", id).log()`.
- For manual spans use `tracer.spanBuilder(name).startSpan()`, make it current in try-with-resources with `span.makeCurrent()`, call `span.recordException(e)` and `span.setStatus(StatusCode.ERROR)` on failure, and end it in `finally`.
- Import stable names from `io.opentelemetry.semconv`, as in `HttpAttributes.HTTP_REQUEST_METHOD`.

## Go

- Go uses instrumentation libraries from `go.opentelemetry.io/contrib`, such as `otelhttp`. Wrap the server handler with `otelhttp.NewHandler(mux, "/")`.
- Build the tracer, meter, and logger providers once at startup, register them with `otel.SetTracerProvider`, `otel.SetMeterProvider`, and `global.SetLoggerProvider`, set the propagator with `otel.SetTextMapPropagator`, and call every provider's `Shutdown` on exit.
- Go has no user-facing OpenTelemetry logs API. Keep `slog`, zap, logrus, or logr and use the matching bridge, such as `otelslog.NewLogger(name)` from `go.opentelemetry.io/contrib/bridges/otelslog`, and log with the context methods such as `logger.InfoContext(ctx, msg, "key", value)`.
- For manual spans call `ctx, span := tracer.Start(ctx, name)` with `defer span.End()`. `span.RecordError(err)` does not set the status, so also call `span.SetStatus(codes.Error, msg)`.
- Create metrics from `otel.Meter(name)` with `meter.Int64Counter` or `meter.Float64Histogram` and `metric.WithUnit`, and pass attributes with `metric.WithAttributes`.

## .NET

- Add `OpenTelemetry.Extensions.Hosting`, the instrumentation packages such as `OpenTelemetry.Instrumentation.AspNetCore`, and `OpenTelemetry.Exporter.OpenTelemetryProtocol`.
- Configure tracing and metrics with `builder.Services.AddOpenTelemetry().ConfigureResource(r => r.AddService(serviceName)).WithTracing(...).WithMetrics(...)`, each with `.AddOtlpExporter()`. The OTLP exporter sends over gRPC to `http://localhost:4317` unless configured otherwise.
- Keep `ILogger` and add `builder.Logging.AddOpenTelemetry(logging => logging.AddOtlpExporter())`.
- Log with message templates and named placeholders, as in `logger.LogInformation("Order {OrderId} placed", orderId)`, or with `[LoggerMessage]` source generated methods, which Microsoft calls usually the better alternative for performance and typing. String interpolation in a log call breaks structured fields and is flagged by analyzer rule CA2254.
- Tracing uses `System.Diagnostics`. Create spans with an `ActivitySource` and `StartActivity(name)` inside `using`, set attributes with `activity?.SetTag(...)`, and on failure call `activity?.AddException(ex)` and `activity?.SetStatus(ActivityStatusCode.Error)`.

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

Collect `db.query.text` only when literals are sanitized or the query is parameterized, and never capture `db.query.parameter.<key>` values by default, because they may hold personal data.

`error.type` describes the class of error, such as the exception type, stays predictable and low in cardinality, and falls back to `_OTHER`. Leave span status unset on success. Server spans also leave it unset for 4xx responses, while client spans set Error.

## Stable metrics

| Metric | Instrument | Unit |
|---|---|---|
| `http.server.request.duration` | Histogram | `s` |
| `http.client.request.duration` | Histogram | `s` |
| `db.client.operation.duration` | Histogram | `s` |

The metrics SDK keeps separate state for every attribute combination and caps each metric stream at 2000 combinations by default. Further combinations fold into one data point marked `otel.metric.overflow=true`, which silently breaks queries on the other attributes.

## Areas still in development

- All `gen_ai.*` attributes, spans, metrics, and events. They moved to the repository open-telemetry/semantic-conventions-genai, and message content attributes such as `gen_ai.output.messages` are opt-in because they are likely to contain personal data.
- The `user.*` attributes such as `user.id`, which are also examples of data the sensitive data guidance asks to remove or generalize.
- The general guidance on recording errors as log records, which already advises against recording the same exception more than once.
