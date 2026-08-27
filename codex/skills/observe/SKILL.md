---
name: observe
description: Design, implement, and review production observability and diagnose operational symptoms using logs, metrics, traces, profiles, events, SLOs, alerts, dashboards, and runbooks. Use for instrumentation, telemetry pipelines, correlation, alerting, and evidence-based production debugging; do not use for business analytics, audit-policy work alone, or local debugging with no operational telemetry question.
---

# Observe

Add only telemetry that answers a named operational question or supports a defined response. Start from the user-visible symptom and the decision an operator must make, not from available collectors, dashboard panels, or fashionable signals.

## Establish The Operational Contract

1. Identify the observed user flow, service, job, dependency, or resource, its owner, supported environments, symptom, affected population, and expected response.
2. Separate urgent user impact from diagnostic context, then define the question, decision, required detection speed, and operational action.
3. Inspect the installed runtime, instrumentation and semantic-convention versions, collectors, backends, queries, alerts, dashboards, retention, sampling, cost controls, and privacy requirements.
4. Trace the path from emission through propagation, processing, export, storage, query, notification, and response. Define correctness, coverage, latency, overhead, cardinality, privacy, and failure budgets.

Do not introduce a vendor migration, new telemetry stack, blanket auto-instrumentation, or broad logging expansion to solve a narrow observability gap.

## Start With Symptoms

For reliability work, define a service-level indicator from a user or consumer outcome and record its measurement boundary and blind spots. Use golden signals, RED, or USE only where the service or resource fits them; they are coverage prompts, not mandatory dashboard templates.

Page primarily on active or imminent user-visible symptoms. Keep resource, dependency, deployment, and runtime causes for diagnosis. Do not page on an isolated log, exception, restart, host failure, or unusual value unless it reliably represents urgent impact and requires immediate human judgment.

## Choose The Smallest Useful Signal

Use metrics for bounded aggregate behavior, trends, objectives, and alert evaluation. Use structured logs for discrete events that need detailed context. Use traces for causal request paths and cross-boundary latency. Use profiles after evidence points to code-level CPU, allocation, memory, lock, or I/O consumption. Use named events for meaningful checkpoints, state changes, and outcomes that need their own timestamp but not a duration.

Do not copy the same payload into every signal. Correlate complementary signals with stable resource identity, trace and span context, exemplars, deployment markers, and domain identifiers that are safe and bounded. A trace identifier belongs in a log or exemplar, not as a metric label.

Read [signal design](references/signals.md) only when selecting or changing logs, metrics, traces, profiles, events, semantic conventions, propagation, sampling, cardinality, retention, or privacy controls.

## Instrument Deliberately

Follow the semantic conventions supported by the project version. Prefer stable operation names, error categories, resource identity, units, and typed fields over free-form or backend-specific conventions.

Create spans around meaningful operations and boundaries, not every function. Put whole-operation properties on attributes and point-in-time occurrences on events. Record errors once where useful context or the outcome is known.

Design every metric label from an explicit aggregation or drill-down need and estimate the cross-product before shipping. Never use unbounded identifiers, raw URLs, query strings, personal data, timestamps, stack traces, messages, or trace identifiers as labels.

Keep logs structured, schema-stable, severity-consistent, and proportional. Avoid per-item success logs, loop logging, duplicates, and debug detail by default. Telemetry must not change results or fail the application when export is unavailable.

Treat incoming trace context as untrusted. Keep baggage minimal and never place credentials, tokens, secrets, personal information, full request or response bodies, or other sensitive values in telemetry. Prefer not collecting sensitive data over masking it later.

## Diagnose With Evidence

1. Pin the symptom to a time range, population, operation, environment, and deployment or configuration state.
2. Start with the relevant SLI or user-facing signal and compare it with a known-good period or unaffected population.
3. Narrow the path with correlated traces and resource identity. Use logs or events for occurrences, metrics for constraints, and profiles only for an evidenced resource question.
4. Build a timeline that accounts for occurrence and observation time, clock skew, retries, queues, missing data, ingestion delay, aggregation, and sampling.
5. Test a falsifiable hypothesis and preserve the queries, samples, identifiers, configuration, sampling policy, and revisions needed to reproduce the conclusion.

Do not manufacture certainty from absent, sampled, delayed, or aggregated data. State the evidence limit when the telemetry cannot distinguish competing explanations.

## Make Operations Actionable

An alert must have a symptom, impact, owner, urgency, evidence, scope, safe first checks, runbook or investigation link, and recovery condition. Use error-budget burn only for an agreed SLO; do not invent an objective to justify an alert.

A dashboard must answer a specific operational question. Prefer a service landing view with user outcomes and change markers plus directed drill-downs over panel grids, copies, decorative charts, and every available metric.

Read [operational use](references/operations.md) only when defining SLIs or SLOs, alerts, dashboards, runbooks, incident evidence, error-budget behavior, or telemetry tests.

## Prove The Telemetry Path

Validate emission on representative success and failure paths. Check names, types, units, timestamps, resource identity, correlation, outcomes, bounded labels, sampling, redaction, and absence of forbidden fields.

Test processing and export, representative queries, dashboards, rule evaluation, notification routing, no-data behavior, recovery, deduplication, exporter failure, queue pressure, and drops. Measure overhead and volume against the declared budgets.

## Final Audit

Reject the change if any applicable answer is no:

1. Does every signal answer a named question or support a named action?
2. Is paging tied to urgent or imminent impact and human judgment?
3. Can an operator move from symptom to cause evidence without guessing across tools?
4. Are identity, names, units, and fields consistent with installed conventions?
5. Are cardinality, volume, sampling bias, retention, query cost, and privacy bounded?
6. Does telemetry failure reduce visibility without changing the application outcome?
7. Were the signal, pipeline, query, alert, routing, recovery, privacy, and overhead tested?
8. Do dashboards reduce time to answer, and are evidence limits reported honestly?
