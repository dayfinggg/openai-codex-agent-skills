# Verification Surfaces

Choose checks from the change's risks. Do not run every category mechanically.

## Code and behavior

Run formatter, static analysis, type checks, focused tests, broader relevant suites, and the build. Exercise public behavior, boundaries, errors, cancellation, retries, resource cleanup, concurrency, and compatibility. Inspect the final diff and generated artifacts.

## APIs and integrations

Validate request and response schemas, status and error behavior, authentication, object-level authorization, idempotency, pagination, retry, timeout, webhook verification, version compatibility, and real serialization. Use contract and integration checks across the actual boundary.

## Data and migrations

Validate constraints, representative queries, execution plans, transactions, locking, mixed application versions, expand and contract stages, idempotent backfills, reconciliation, rollback or forward repair, backup, and restore. Use representative volume and distributions.

## Security

Check trust boundaries, untrusted input, output encoding, query and command parameterization, authorization, least privilege, secrets, logs, dependency changes, failure defaults, and abuse paths. Include negative tests and report residual scope rather than claiming a complete audit.

## Performance

Define the metric and workload, establish a baseline, profile the bottleneck, then repeat the same representative measurement. Compare distributions and resources. A microbenchmark, isolated best run, or theoretical complexity claim does not prove end-to-end improvement.

## Web and design

Inspect the rendered interface in a real browser at narrow, medium, and wide sizes. Verify hierarchy, typography, contrast, font loading, image crop, overflow, keyboard order, visible focus, control targets, 200% zoom, reduced motion, loading, empty, error, success, and disabled states. Exercise important interactions and inspect console errors.

Compare against the user task and product context, not only a screenshot or snapshot. Confirm that mobile is recomposed rather than scaled, motion has a purpose, content is not fabricated as fact, and the design does not merely repeat a generic template.

## Operations and release

Check configuration, environment assumptions, observability, health and smoke behavior, migrations, staged rollout, abort signals, rollback, immutable artifacts, and ownership. Do not deploy, publish, or perform destructive validation without authorization.

Primary sources: [Google code review guidance](https://google.github.io/eng-practices/review/reviewer/looking-for.html), [NIST SSDF](https://csrc.nist.gov/pubs/sp/800/218/final), [WCAG 2.2](https://www.w3.org/TR/WCAG22/), [Google SRE testing for reliability](https://sre.google/sre-book/testing-reliability/).
