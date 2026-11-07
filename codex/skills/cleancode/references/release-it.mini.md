These rules come from Release It by Michael T. Nygard. They make code survive production failures, overload, latency, bad data, hostile traffic, and operational mistakes.

<when_to_use>
Use them for services, APIs, jobs, queues, deployment paths, and control tooling. Also use them for critical flows that must survive production failures.
</when_to_use>

<primary_bias>
A passing happy path does not make code ready for production. Design the failure semantics, demand limits, isolation, recovery path, and diagnostics before production defines them.
</primary_bias>

<decision_rules>
- Assume that every dependency, queue, cache, timeout, and caller retry can fail. Failures are often slow, partial, or prolonged, and code must expect them.
- Prefer designs that fail visibly, limit the blast radius, and shed load. Keep the core service running, and make diagnosis possible. That matters more than ideal-path elegance.
- Deployment, operations, security, observability, rollback, and configuration validation are part of the system. They are not chores for after the release.
- Give every outbound call and wait an explicit, intentional time limit. Do not rely on library defaults or allow infinite waits.
- Retry only when the operation is safe for both caller and provider. Bound the count and the total time, and use backoff with jitter. Never retry validation errors or permanent failures.
- Isolate failures of dependencies and workloads. Use circuit breakers, fast failure, bulkheads, separate resource pools, and isolation of slow work. One outage must not consume all threads, connections, or workers.
- Design overload behavior explicitly. Use back pressure, finite queues, and demand limits, and reserve capacity for critical traffic. Shed lower-value work before core functions collapse.
- Choose stability patterns by failure mode. Use the steady state pattern for routine cleanup and bounded growth. Fail fast when continuing would hide unrecoverable trouble or hold scarce resources. Let a component crash only under supervision and isolation. Use handshaking for readiness, monitored middleware for decoupling, and governors for expensive actions.
- Make runtime state, external responses, automation progress, and migrations visible. Validate them before you trust them. Keep a rollback or roll-forward path for partial operational changes.
- Budget scarce resources explicitly, and release them deterministically. Do not hold locks or expensive connections across slow remote calls. Stream or paginate large payloads instead of loading huge batches into memory.
- Treat external input and external responses as untrusted. Check syntax, shape, status, content type, semantics, and business plausibility. Keep malformed data out of caches, queues, and downstream systems.
- Build observability into boundaries and failure points. Log with structured context and correlation IDs, and keep secrets out of logs. Avoid log spam during retry storms. Track latency, throughput, errors, saturation, queue depth, retries, breaker state, dependencies, version, configuration, and health.
- Startup, health checks, migrations, one-time jobs, admin controls, and delivery tooling must fail safely. They must also be authorized, auditable, observable, stoppable, and recoverable.
- Make interconnects, routing, API contracts, caches, and background work production-aware. Avoid concentrated demand, hidden single points of failure, uncontrolled fan-out, and fragile chatty calls. Also avoid cache dogpiles, stale-data surprises, and synchronized job retries.
- Include security and hostile traffic in production readiness. Run production tests, capacity tests, game days, or chaos experiments only with a limited blast radius. They also need observability, stop conditions, and a path back into the design.
</decision_rules>

<trigger_rules>
- When you add an outbound call, resource checkout, queue consumer, or thread wait, define its timeout and retry rules. Also define the bounds, the fallback or degraded mode, the validation, and how the caller survives a failure.
- When you add a queue, buffer, pool, cache, log stream, job, or collection-returning API, define its capacity and full behavior. Also define cleanup, cache miss, stampede, and staleness behavior, pacing, pagination or streaming, and saturation monitoring.
- When a change touches deployment, configuration, startup, migrations, one-time jobs, or scripts, make it idempotent or restartable where practical. Give it durable state, an audit trail, verification, and a rollback or roll-forward path.
- When you add health checks, load balancing, service discovery, or routing, send traffic only to ready components. Health signals must reflect the real ability to serve.
- When you design an API or integration contract, make its material failure modes explicit. Distinguish retryable from non-retryable outcomes, and prefer coarse-grained interactions. State the timeout, retry, version, and compatibility expectations in the contract.
- When you review an incident or a capacity issue, trace the failure chain and the missing defenses. Check detection gaps, demand, saturation, latency distribution, queue age, dependency behavior, and traffic concentration. Then name the design changes.
- When you add admin controls, control planes, delivery tooling, or chaos work, require authorization, auditability, and safe defaults. They also need clear stop mechanisms, a bounded blast radius, and recovery paths.
</trigger_rules>

<final_checklist>
- Does every wait have an explicit timeout?
- Are retries safe, bounded, backed off with jitter, and not duplicated across layers?
- Are queues, buffers, pools, caches, logs, payloads, jobs, and result sets bounded?
- Is failure isolated with breakers, bulkheads, fast failure, degradation, or load shedding?
- Are external input and dependency responses validated before they affect state or downstream systems?
- Do diagnostics cover logs, metrics, health, correlation, version, configuration, dependencies, saturation, queue depth, retries, and breaker state?
- Are startup, deployment, migration, and operational controls restartable, observable, authorized, auditable, and recoverable where practical?
</final_checklist>
