# OpenTelemetry instrumentation and Collector

Technical reference snapshot dated 2026-11-17, originally aligned with semantic conventions 1.45.0 and Collector 0.165.0. Check the installed SDK and Collector versions, current semantic conventions, and current Collector release notes before relying on field stability or deprecation status.

## Semantic conventions

- Stable areas: HTTP, RPC spans and call duration metrics including gRPC (1.45), database client spans and `db.client.operation.duration`, the resource attributes `service.name`, `service.version`, `service.namespace` and `service.instance.id`, `deployment.environment.name` (1.41), and a core set of `k8s.*` resource attributes (1.42). Messaging is still in development.
- Use the stable attribute names: `http.request.method`, `http.response.status_code`, `db.system.name`, `db.namespace`, `db.operation.name`, `db.collection.name`, `db.query.text`. `http.method`, `http.status_code`, `db.system`, `db.name`, `db.operation`, `db.sql.table` and `db.statement` are deprecated.
- 1.45 replaces `rpc.request.metadata.<key>` and `rpc.response.metadata.<key>` with `rpc.request.header.<key>`, `rpc.response.header.<key>` and `rpc.response.trailer.<key>`.
- Set `deployment.environment.name`, not the deprecated `deployment.environment`, and use the well-known values `production`, `staging`, `test` or `development` whenever one applies.
- GenAI conventions moved to the `open-telemetry/semantic-conventions-genai` repository in 1.42 and have no tagged release yet. Pin a commit and treat them as unstable.
- Instrumentations that emitted pre-stable HTTP, database or RPC conventions keep emitting them in their current major version. Set `OTEL_SEMCONV_STABILITY_OPT_IN=http,database,rpc` to switch, or use `http/dup`, `database/dup` or `rpc/dup` to emit both while dashboards migrate.

## SDK configuration

- Spec defaults: `OTEL_TRACES_SAMPLER=parentbased_always_on`, `OTEL_PROPAGATORS=tracecontext,baggage`, the `otlp` exporter for traces, metrics and logs, and a 60000 ms metric export interval. `OTEL_SERVICE_NAME` wins over `service.name` inside `OTEL_RESOURCE_ATTRIBUTES`.
- OTLP uses port 4317 for gRPC and 4318 for HTTP. The spec default protocol is `http/protobuf`, but SDKs that shipped gRPC first may keep it, so set `OTEL_EXPORTER_OTLP_PROTOCOL` and the port together.
- For file-based SDK setup, point `OTEL_CONFIG_FILE` at a YAML file (configuration schema 1.0.0 since 2026-02, 1.2.0 since 2026-09). `OTEL_EXPERIMENTAL_CONFIG_FILE` is deprecated.
- Emit new events and exceptions as log records through the Logs API, correlated with the active span. The Span Event API (`AddEvent`, `RecordException`) is being deprecated since 2026-03 (OTEP 4430).
- Export over OTLP. The Zipkin exporter spec is deprecated, and Jaeger exporters were deprecated earlier.
- Logs are stable in Java, .NET, C++, PHP and Rust, and in JavaScript since SDK 3.0 (2026-11-05, requires Node.js 22.15+). Go logs are a release candidate, Python and Ruby logs are in development, and Rust traces are beta.

## Collector

- Run the `otelcol-k8s` or `otelcol-contrib` distribution, or a custom OCB build, when you need `k8sattributes` or `tail_sampling`. The core `otelcol` image lacks both.
- Batch in the exporter instead of the `batch` processor, which was deprecated on 2026-11-11. Exporter batching becomes the default in v0.171.0 (planned for 2027-02), the processor is removed in v0.177.0 (planned for 2027-05), and v0.165.0 warns at startup when a pipeline uses both. Use the `queue_batch` processor if batching must stay in a processor.

```yaml
exporters:
  otlp:
    sending_queue:
      enabled: true
      batch:
        enabled: true
```

- Put `memory_limiter` first in every pipeline and set `GOMEMLIMIT` to about 80% of the Collector's hard memory limit.

## Gotchas

- Since Collector v0.104.0 the OTLP receiver listens on `localhost:4317` and `localhost:4318` by default, so other containers and pods cannot reach it. Set `endpoint: 0.0.0.0:4317` or `endpoint: ${env:MY_POD_IP}:4317`.
- Write environment variables in Collector config as `${env:VAR}`, with a default as `${env:VAR:-value}`. Bare `$VAR` has not been expanded since v0.104.0, and `$$` writes a literal `$`.
- The Collector `logging` exporter was removed. Use the `debug` exporter.
- When `OTEL_CONFIG_FILE` is set, the SDK ignores every other `OTEL_*` variable unless the file references it through `${VAR}` substitution. Start from `otel-sdk-migration-config.yaml` in the `opentelemetry-configuration` repository to keep env-driven settings working.
- With the default ParentBased sampler, a public-facing service obeys the sampled flag in callers' `traceparent` headers, so external clients decide whether it records traces. Set `OTEL_TRACES_SAMPLER=always_on` at the edge and sample in the Collector.
