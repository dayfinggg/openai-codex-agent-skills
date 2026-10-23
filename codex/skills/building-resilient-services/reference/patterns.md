# Resilience patterns

Rules beyond SKILL.md, from the Azure Architecture Center Cloud Design Patterns, its transient fault guide, and Twelve-Factor. None of these sources gives universal numbers.

## Contents

- Idempotent consumer
- Compensating transaction and jobs
- Bulkhead, rate limiting, load leveling
- Health endpoints
- Process rules
- Sources

## Idempotent consumer

- When several consumers share one dedup store, key the record by consumer and message.
- For a third-party call that cannot join the transaction, record the key as in progress, make the call with the idempotency key passed along, then mark the record completed with its outcome.
- Keep dedup records longer than the broker can redeliver, counting messages operators resubmit from the dead-letter queue.
- Broker duplicate detection reduces duplicates but never replaces an idempotent handler. A check-then-set in a cache races, so use the uniqueness constraint.
- Skip deduplication when the effects are already idempotent, or occasional duplicates are harmless and cost less than the store.

## Compensating transaction and jobs

- When an operation spans several services without one atomic transaction and a later step fails for good, undo the completed steps with a compensating transaction. Retry first, and compensate only when forward progress is impossible.
- Record each completed step and how to undo it, make every compensation step idempotent, record its progress so it can resume, put irreversible steps after all critical validations, and alert with details when a person must intervene.
- A job can be killed at any moment, so wrap its results in a transaction or make it idempotent, and release its locks when it stops.

## Bulkhead, rate limiting, load leveling

- Give each dependency its own connection pool, concurrency limit, or queue, using the library's bulkhead or the platform's limits rather than application code. Use separate breakers for independent resources such as shards or hosts.
- For a dependency that throttles, pace calls below its documented limit, send every workstream that uses it through the same limiter, coordinate retries with that pace, and send bursts through a durable queue drained at the allowed rate.
- When spikes overwhelm a dependency and callers need no synchronous answer, put a durable queue in front, bound the consumers' total downstream rate, watch the queue depth, and assume no ordering unless the broker provides it.

## Health endpoints

- Keep checks read-only and cheap, cache expensive results with a short time to live, and allow for startup time.
- Let each readiness check respect the dependency's circuit breaker.
- Report not ready until startup work is done, and move slow warm-up behind the readiness signal.
- What the endpoints expose and how they are watched belongs to the adding-observability skill.

## Process rules

- Everything that varies between deploys, such as URLs, credentials, timeouts, and retry settings, comes from environment variables, read once at startup into a typed settings object in the composition root. Validate it and refuse to start when a required value is missing. Do not bundle settings into named environments in code.
- Keep nothing in memory or on local disk between requests except a brief single-request cache, store durable state in a backing service, and never rely on sticky sessions.
- A web process on SIGTERM closes its pools after draining. Both web and worker processes exit before the platform's kill deadline and survive sudden death because work is reentrant.

## Sources

- [Recommendations for handling transient faults](https://learn.microsoft.com/en-us/azure/well-architected/design-guides/handle-transient-faults)
- [Retry](https://learn.microsoft.com/en-us/azure/architecture/patterns/retry), [Circuit Breaker](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker), [Bulkhead](https://learn.microsoft.com/en-us/azure/architecture/patterns/bulkhead)
- [Idempotent Consumer](https://learn.microsoft.com/en-us/azure/architecture/patterns/idempotent-consumer), [Compensating Transaction](https://learn.microsoft.com/en-us/azure/architecture/patterns/compensating-transaction)
- [Rate Limiting](https://learn.microsoft.com/en-us/azure/architecture/patterns/rate-limiting-pattern), [Queue-Based Load Leveling](https://learn.microsoft.com/en-us/azure/architecture/patterns/queue-based-load-leveling), [Health Endpoint Monitoring](https://learn.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring)
