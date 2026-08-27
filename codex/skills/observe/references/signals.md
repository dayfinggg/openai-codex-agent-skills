# Signal Design

Read only the sections that match the signal being changed.

## Metrics

- Define the question, aggregation, unit, population, and required resolution before choosing an instrument.
- Use a counter for cumulative occurrences or amounts, a gauge for current state that can rise or fall, and a histogram for a distribution whose thresholds or quantiles matter. Prefer histograms over averages for latency and size tails.
- Give one metric one meaning and one base unit. Follow the naming convention of the installed telemetry and backend stack instead of translating conventions from another system mechanically.
- Use dimensions only when an operator will filter, group, aggregate, route, or own the resulting series. Prefer route templates, operation categories, status classes, regions, and bounded outcome types.
- Estimate series as the cross-product of possible label values across instances and lifetimes. Include ephemeral workloads, histogram buckets, recording rules, and deployment churn in the estimate.
- Configure cardinality limits or views when supported. Treat overflow as lost resolution that must be observable, not as permission to emit unbounded labels.
- Align collection resolution with detection and diagnostic needs. Higher frequency, more buckets, and longer retention require a concrete benefit.

## Logs And Events

- Use a stable schema with an event name, occurrence timestamp, severity, outcome, service or resource identity, safe correlation fields, and the minimum attributes needed for the intended query.
- JSON is not structured logging by itself. Field names, types, semantics, and event identity must remain stable enough for downstream queries and tests.
- Use an event for a meaningful checkpoint, state transition, lifecycle occurrence, or outcome. Use a span for an operation with duration, a span attribute for a property of the whole operation, and an ordinary log for diagnostic text that is not a named event.
- Keep event names low-cardinality and free of identifiers. Put bounded variable details in attributes.
- Record an error at the boundary that knows whether the operation failed and can classify it. Preserve the exception type or stable error category; collect messages or stack traces only when necessary and after privacy review.
- Avoid routine success logs for every request or item when a metric or trace already provides coverage. Prefer one contextual failure record over repeated logs at each call layer.
- Treat log contents from users, dependencies, and other trust zones as untrusted. Prevent log injection and separate occurrence time from collection or observation time.

## Traces

- Create spans for meaningful service, queue, datastore, protocol, or internal operation boundaries. Names describe operations and must not contain raw paths, identifiers, or payload values.
- Preserve parent-child causality and use links when work has causal relationships that are not a single parent chain, such as batches, fan-in, fan-out, retries, or asynchronous handoff.
- Set status from the operation's defined outcome, not merely from the presence of an exception. Record retries, cancellations, timeouts, and partial failures so the trace explains the user-visible result.
- Keep attributes needed for filtering or sampling on spans. Put repeated point-in-time occurrences on events. Do not attach large payloads or duplicate every log field.
- Propagate W3C Trace Context across supported boundaries. Validate injection and extraction in both directions, including queues and background work.

## Profiles

- Use a profile only after metrics or traces identify a material CPU, allocation, heap, lock, scheduler, or I/O question.
- Choose the profile type that observes the suspected resource. On-CPU, off-CPU, heap, and allocation profiles answer different questions.
- Correlate profiles with the same resource identity and, when supported, trace or span context. A profile without workload, time, and deployment context can misattribute cost.
- Verify runtime support, overhead, sampling frequency, retention, symbol handling, and privacy. Treat OpenTelemetry profiles as alpha until the project's actual implementation states otherwise.

## Correlation And Semantic Conventions

- Use the semantic-convention version supported by the installed instrumentation. Record migrations explicitly when stable and experimental schemas coexist.
- Apply consistent resource identity across signals, including service, version, environment or deployment, and instance identity when it is operationally useful.
- Add trace and span identifiers to logs through the established bridge or context mechanism. Use exemplars to connect an aggregate metric observation to representative traces when supported.
- Add deployment, configuration, feature-flag, and incident annotations as events or metadata rather than guessing changes from timestamps.
- Do not use trace identifiers, span identifiers, instance IDs, request IDs, or user IDs as metric labels.

## Sampling, Volume, And Cost

- Choose sampling from the diagnostic question, signal volume, storage budget, and acceptable loss. Record the policy and effective rate with the evidence.
- Parent-based head sampling preserves trace consistency but cannot select on later outcomes. Tail sampling can retain rare errors or slow traces but adds buffering, delay, and collector state. Choose from measured needs, not preference.
- Account for sampling when estimating rates or drawing frequency conclusions. A sampled trace set is not automatically representative of all traffic.
- Prefer aggregation, filtering, lower collection frequency, bounded attributes, and shorter retention over collecting everything and hoping the backend absorbs it.
- Expose dropped records, queue saturation, exporter errors, retry pressure, and effective sampling so telemetry loss is distinguishable from healthy silence.

## Privacy And Failure Isolation

- Inventory attributes emitted by manual and automatic instrumentation. Collect only what is necessary for the operational purpose.
- Never collect passwords, access or session tokens, encryption keys, connection strings, payment data, or raw secrets. Avoid personal information, request and response bodies, headers, query strings, database statements, and exception messages unless explicitly required and safely transformed.
- Redact or drop sensitive attributes before export when collection cannot be prevented. Hashing predictable identifiers may remain reversible and does not automatically anonymize data.
- Restrict access, transport, retention, and deletion according to the sensitivity of the telemetry. Treat the observability backend as a sensitive production system.
- Bound buffers, retries, memory, disk, and network use. Telemetry export failure must not produce recursive log storms or take down the observed application.
