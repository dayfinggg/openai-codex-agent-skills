# Signal Design Reference

Use this reference to choose complementary signals and make their contracts explicit. Adapt the vocabulary to the project's telemetry stack and semantic conventions.

## Signal selection

| Operational question | Primary signal | Supporting evidence | Common failure |
| --- | --- | --- | --- |
| Are users completing an operation successfully? | Bounded success and failure counters plus a latency histogram | Exemplars and request traces | Counting transport success instead of user-visible success |
| Is asynchronous work timely and complete? | Queue age, completion age, throughput, and terminal outcomes | Correlated job events and producer-to-consumer traces | Reporting queue depth without freshness or completion |
| Is a dependency harming the service? | Client latency, error, timeout, and saturation metrics by bounded dependency and operation | Client spans and categorized failure logs | Labeling by raw URL, host instance, or exception text |
| Is a constrained resource approaching failure? | Utilization, saturation, rejection, and wait-time measures | Resource events and relevant spans | Alerting on utilization alone without impact or saturation |
| Did a release or configuration change behavior? | Bounded version and environment dimensions plus deployment events | Traces and logs carrying the same release identifier | High-cardinality commit or feature values on every metric |
| Can operators locate one failed execution? | Structured terminal event with trace and span identifiers | Distributed trace and bounded domain identifiers | Logging complete payloads or secrets for correlation |

## Signal contracts

For each log event, define a stable event name, severity semantics, timestamp source, service and release identity, operation, outcome, failure category, correlation fields, retention class, and privacy classification. Keep variable details in structured fields rather than interpolated message templates.

For each metric, define its type, unit, monotonicity, aggregation, collection interval, allowed dimensions, expected cardinality, reset behavior, and query semantics. Use counters for accumulated events, histograms for distributions, and gauges only for meaningful current state.

For each span, define the operation boundary, parent relationship, propagation rules, status mapping, safe attributes, event usage, and sampling implications. Preserve error traces and rare critical workflows when choosing head, tail, or adaptive sampling.

For each health signal, define the consumer and consequence. Liveness should indicate whether restart can help; readiness should indicate whether traffic can be served; startup should cover initialization; background-worker health should reflect progress rather than process existence alone.

## SLO specification

Record the user journey, indicator formula, valid-event population, good-event rule, measurement point, window, objective, exclusions, minimum-traffic behavior, source query, owner, error-budget policy, and known blind spots. Validate numerator and denominator against representative raw events before relying on the ratio.

## Alert specification

Record the condition, rationale, severity, evaluation window, pending duration, missing-data behavior, grouping keys, deduplication behavior, owner, route, response expectation, runbook, dashboard link, and recovery rule. For SLO alerts, document the burn-rate and exhaustion horizon. For causal alerts, state the user-impact condition that makes paging appropriate.

## Validation evidence

Collect evidence from source-level schema tests, redaction tests, a successful execution, representative failures, telemetry pipeline delivery, backend queries, cross-signal correlation, dashboard rendering, alert firing and recovery, and cardinality or cost estimates. Treat missing or sampled data as an explicit limitation rather than silently extrapolating coverage.
