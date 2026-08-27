# Reliability And Change

Read this reference only when architecture decisions involve remote dependencies, service objectives, overload, scale, caching, redundancy, migration, rollout, or recovery.

## Failure And Reliability

For every remote or asynchronous dependency, identify omission, timeout, partial failure, overload, duplication, reordering, stale data, and recovery behavior. Add a deadline, bounded retry budget, exponential backoff with jitter, idempotency, circuit breaking, concurrency limit, bulkhead, or graceful degradation only when it addresses a demonstrated failure mode.

Retries consume capacity and can amplify outages. Never create unbounded retries, queues, fan-out, concurrency, or memory buffers. Reject or shed excess work before overload becomes a cascade.

Define reliability from critical user journeys and measurable service objectives. Use latency percentiles, throughput, freshness, correctness, durability, recovery time, and recovery point only where they matter. Do not promise 100 percent availability or calculate impressive totals from component SLAs while ignoring shared dependencies, control planes, and failure domains.

Choose redundancy and geographic distribution from explicit SLOs, failure domains, RTO, RPO, data residency, latency, and cost. Prove recovery with restore tests, failover exercises, load tests, and controlled failure tests.

## Scale And Cache

Scale the observed bottleneck. Prefer simple capacity increases and stateless replication before partitioning. Partition only with a known key, access pattern, hotspot strategy, rebalancing plan, and failure behavior.

Add caching only after measuring a bottleneck. Define the source of truth, staleness tolerance, invalidation, TTL, eviction, stampede protection, warm-up, and failure fallback. A cache required for correctness or baseline capacity is a critical dependency and must be designed and tested as one.

## Migration And Evolution

Prefer small reversible slices over a big-bang replacement. Apply a strangler migration only through a stable routing seam and move one measurable capability at a time. For incompatible interfaces or schemas, use parallel change: expand compatibility, migrate producers and consumers with reconciliation, then remove the old path.

Keep schema and data migrations versioned with the application. Define ordering, backward compatibility, backfill, validation, reconciliation, backup, restore, rollback or roll-forward, and the point after which reversal is unsafe.

Temporary dual reads or writes require one authoritative source, discrepancy monitoring, an owner, a removal condition, and a bounded transition period. Do not extract code, data, ownership, and traffic simultaneously unless intermediate states are demonstrably safer than separate stages.

After every slice, the system must remain deployable and observable. Verify compatibility, migration restartability, data reconciliation, rollback or roll-forward, capacity, user-visible behavior, and removal of the obsolete path.
