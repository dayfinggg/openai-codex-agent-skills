---
name: design-observability
description: Design production telemetry, SLOs, dashboards, and alerts tied to user-visible failures. Use for observability plans, instrumentation, and signal audits; exclude performance profiling and incident debugging.
---

# Design Observability

Build observability around decisions and failure detection, not around a preferred vendor or the amount of telemetry collected.

## Establish the operating model

1. Inspect the system, existing instrumentation, deployment topology, and telemetry pipeline before proposing changes.
2. Identify critical user journeys, service boundaries, asynchronous work, dependencies, owners, and credible failure modes.
3. State which operational decisions each proposed signal must support. Reject signals with no clear consumer or action.
4. Distinguish configured, emitted, collected, queryable, alerted, and failure-tested telemetry. Never infer one state from another.

## Define service objectives

1. Express reliability at a boundary users experience, such as successful request completion, job freshness, or durable processing.
2. Specify each service-level indicator with its valid event population, good-event rule, units, window, exclusions, data source, and owner.
3. Derive objectives from product requirements, historical performance, and operational constraints. Do not choose targets solely because they are conventional.
4. Connect objectives to an error-budget policy. Use multi-window burn-rate alerts when an SLO and sufficient traffic make them appropriate.

## Design the telemetry

Read [references/signal-design.md](references/signal-design.md) when selecting signal types, defining schemas and dimensions, or writing SLO and alert specifications.

1. Capture user-impact symptoms first, then add causal signals for dependencies and constrained resources.
2. Use stable structured log events, bounded metric dimensions, and traces across meaningful distributed boundaries.
3. Correlate signals with trace and span identifiers, exemplars, stable operation names, release identifiers, and other bounded context supported by the stack.
4. Define liveness, readiness, startup, and background-work health independently. Make each check answer one operational question without turning it into a broad dependency probe.
5. Preserve established semantic conventions and repository patterns unless evidence justifies a migration.

## Control risk and cost

1. Exclude credentials, access tokens, session material, payment data, raw request bodies, and unnecessary personal data. Apply redaction before export and test it.
2. Reject unbounded metric labels and baggage, including user IDs, request IDs, raw URLs, arbitrary exception messages, and unconstrained tenant values.
3. Estimate event volume, series cardinality, sampling effects, retention, ingestion cost, and query cost before broad rollout.
4. Prefer the smallest set of complementary signals that answers the operational questions. Remove duplicate telemetry and vanity dashboards.
5. Confirm authorization before changing live alert routes, retention, sampling, dashboards, or SLO policy.

## Make operational views actionable

1. Organize dashboards around user outcomes, service objectives, dependencies, saturation, and recent changes. Give every panel a decision it supports.
2. Alert only when a condition has material impact or requires timely human action. Assign an owner, severity, response expectation, routing policy, and concise runbook for every page.
3. Define grouping, deduplication, inhibition, maintenance behavior, missing-data behavior, and recovery conditions.
4. Prefer symptoms for paging and causal signals for diagnosis. Avoid alerts that merely restate dashboard values.

## Validate the design

1. Test instrumentation schemas and redaction at the source.
2. Exercise success, partial failure, timeout, retry, cancellation, saturation, and dependency-failure paths appropriate to the system.
3. Verify end to end that expected telemetry reaches the backend, correlates across signal types, renders correctly, and survives the failure it must diagnose.
4. Test alert firing, grouping, routing, acknowledgment, and resolution without affecting production unless explicitly authorized.
5. Record observed evidence and remaining blind spots. Do not claim coverage for an untested failure path.

Use `$optimize-performance` for profiling, benchmarking, and performance causality. Use `$debug-systematically` for reproducing and diagnosing a specific incident or defect; use this skill to improve the durable telemetry revealed as necessary.
