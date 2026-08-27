# Operational Use

Read only the sections that match the operational artifact being changed.

## SLIs, SLOs, And Error Budgets

- Define the service-level indicator as a user or consumer outcome before defining its measurement. Then document the numerator, denominator, threshold, population, exclusions, window, data source, and known blind spots.
- Prefer an end-to-end measurement boundary. When an implementation misses traffic that never reaches the service, pair it with black-box or edge evidence and state the gap.
- Distinguish availability, latency, freshness, correctness, durability, and throughput. A successful protocol status does not prove a correct or timely result.
- Treat an SLO as an agreed product and operational objective. Confirm the target, window, ownership, and consequences with stakeholders rather than deriving a target from current performance.
- Compute the error budget from the agreed SLO and use it for prioritization only when an error-budget policy defines the response. Do not convert every internal metric threshold into an SLO.

## Alerts

- Page only when a condition is urgent, actionable, and actively or imminently user-visible, or when a hard resource limit creates a comparably imminent threat. Use tickets, dashboards, or review queues for non-urgent work.
- Prefer SLO burn-rate alerts when a stable SLI and agreed SLO exist. Use multiple windows when needed to detect both fast and slow budget consumption without reacting to isolated noise.
- Separate the alerting symptom from diagnostic cause signals. A process restart, host failure, dependency warning, or CPU spike usually belongs in investigation context unless it directly creates urgent impact.
- Define ownership, service scope, severity, routing, persistence window, no-data policy, recovery threshold, deduplication, inhibition, and escalation. Avoid dimensions that create one page per instance or endpoint without changing the response.
- Write for the first responder. Include what is wrong, why it matters, current and threshold values, affected scope, start time, query and dashboard links, recent changes, safe first checks, runbook, and recovery condition.
- Remove or demote alerts that are repeatedly ignored, have rote responses, lack an owner, cannot be acted on, or duplicate another page.

## Dashboards

- Give every dashboard a question, audience, owner, and expected entry path. If it has no decision or investigation role, do not create it.
- Put user outcomes, SLI or SLO state, traffic, errors, latency distribution, saturation, and recent changes on the service landing view only when they apply.
- Organize drill-downs from symptom to service, operation, dependency, resource, trace, log, and profile evidence. Link from alerts directly to the relevant filtered time range and scope.
- Show distributions and meaningful percentiles instead of averages that hide tails. Label units, aggregation, population, time window, and missing-data behavior.
- Compare like with like and expose a known-good period, unaffected region, version, or cohort when that comparison speeds diagnosis.
- Keep queries and refresh rates proportional to operational value. Version-control maintained dashboards, reuse variables instead of copying one dashboard per instance, and remove temporary or unused panels.

## Incident Evidence

- Begin with the reported symptom, affected users, detection source, and current operational state. Preserve facts separately from hypotheses and decisions.
- Build one UTC timeline with occurrence time, observation time, detection, alert, deployment and configuration changes, mitigation actions, recovery, and validation. Record clock uncertainty and ingestion delay when material.
- Save query links, trace identifiers, representative log or event records, profile references, alert payloads, deployment revisions, configuration, and sampling policy. Preserve enough raw evidence to reproduce derived charts.
- Compare before, during, and after the incident using equivalent windows and populations. Check whether retries, fallbacks, caches, aggregation, and sampling hide or amplify impact.
- Do not mutate production telemetry broadly during an incident without considering overhead, privacy, and rollback. Time-bound temporary diagnostic detail and remove it after the investigation.
- State unresolved competing explanations. A temporal association with a deploy, metric, or exception is not a root cause until evidence establishes the mechanism.

## Runbooks

- Scope a runbook to a concrete alert or symptom. Record owner, prerequisites, required access, last review, and last successful exercise.
- Include impact confirmation, safe read-only diagnostics, decision points, mitigations, rollback or stop conditions, escalation, recovery verification, cleanup, and evidence to preserve.
- Use commands and links that match the actual environment and versions. Do not embed credentials, destructive shortcuts, hidden assumptions, or instructions that require tribal knowledge.
- Separate mitigation from permanent repair. A runbook should help restore service safely without presenting a workaround as the root-cause fix.
- Retire or revise a runbook when incident use shows that steps are unsafe, stale, ambiguous, or routinely skipped.

## Telemetry Testing

1. Unit-test that instrumentation emits the expected signal and fields for representative success and failure conditions, and emits nothing forbidden.
2. Test schema names, types, units, bounded label sets, error classification, timestamps, resource identity, context propagation, and redaction.
3. Send representative telemetry through the configured processors and exporters. Verify transformations, filtering, sampling, retries, drops, and backend queries.
4. Test rules with fixed input series or events, including threshold boundaries, persistence, no data, delayed data, recovery, flapping, deduplication, and inhibition.
5. Exercise notification routing to a safe test destination and verify the payload, owner, links, runbook, escalation, and automatic resolution.
6. Simulate collector, exporter, network, storage, and backend failures. Confirm that loss is visible, bounded, and does not change application correctness.
7. Measure CPU, memory, allocation, latency, network, storage, and telemetry volume under a representative workload. Reject instrumentation that exceeds its declared budget without justified value.
8. Re-run the full path after changing semantic-convention versions, processors, sampling, label sets, alert queries, routing, or dashboards.
