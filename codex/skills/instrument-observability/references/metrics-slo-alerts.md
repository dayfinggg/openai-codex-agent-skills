# Metrics, SLOs, dashboards, and alerts

**Reviewed:** 2026-08-11
**Scope:** Prometheus naming and instrumentation guidance plus Google SRE SLO and alerting guidance. Adapt query language to the deployed backend.

## Metrics

- Name one quantity with a base unit and type-consistent suffix. Preserve established names as compatibility contracts unless a migration is planned.
- Keep label sets bounded. Estimate active series from real dimensions and rollout scale before deployment.
- Instrument requests, errors, duration, saturation, queue depth, resource capacity, and domain outcomes only when they answer an owned question.
- Use histograms with boundaries aligned to user or service objectives. Do not derive quantiles across incompatible summary streams.

## SLOs and dashboards

- Define an SLI from a user-observable good-event or good-time ratio, scope, measurement point, exclusions, and data-quality behavior.
- Set the SLO and window from product reliability requirements, not current performance alone. Track error-budget consumption.
- Build dashboards from user outcome to service and dependency diagnosis. State units, aggregation, filters, freshness, and missing-data meaning.

## Alerts

- Alert on actionable impact or impending capacity failure. Multi-window burn-rate approaches can detect fast and slow SLO consumption.
- Define evaluation and pending windows, no-data behavior, deduplication, severity, owner, routing, escalation, runbook, and recovery condition.
- Test alert queries with synthetic or historical data. Confirm a firing notification reaches only an authorized test route before production enablement.

## Official sources

- [Prometheus metric and label naming](https://prometheus.io/docs/practices/naming/)
- [Prometheus instrumentation](https://prometheus.io/docs/practices/instrumentation/)
- [Google SRE service level objectives](https://sre.google/sre-book/service-level-objectives/)
- [Google SRE alerting on SLOs](https://sre.google/workbook/alerting-on-slos/)
- [Google SRE monitoring distributed systems](https://sre.google/sre-book/monitoring-distributed-systems/)
