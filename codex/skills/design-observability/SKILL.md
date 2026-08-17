---
name: design-observability
description: Design or improve production observability. Use for service-level objectives, metrics, structured logs, traces, correlation, dashboards, alerts, sampling, retention, incident signals, and operational runbooks.
---

# Design Observability

## Workflow

1. Start with user and business outcomes, failure modes, ownership, and decisions operators must make.
2. Define meaningful service-level indicators and objectives where reliability decisions require them.
3. Instrument metrics, structured logs, and traces deliberately. Propagate correlation context and record outcomes, latency, errors, and saturation without sensitive data.
4. Control metric dimensions, log volume, trace sampling, retention, and cost. Avoid unbounded identifiers as metric labels.
5. Build dashboards around diagnosis and objectives. Create actionable alerts with an owner, severity, evidence, and runbook; prefer sustained impact or error-budget burn over noisy thresholds.
6. Test telemetry during success, degradation, dependency failure, retry, and recovery. Confirm alerts reach the intended responder.
7. Review signals after incidents and remove unused or misleading telemetry.

Observability is not maximal logging. Read [observability practices](references/practices.md) for signal and SLO guidance.
