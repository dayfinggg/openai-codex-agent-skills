# Data operations

Treat concurrency, migration, and recovery behavior as part of the data contract.

## Transactions, consistency, and locking

1. Define the invariant and anomalies to prevent before selecting read committed, snapshot, repeatable read, serializable, or store-specific consistency modes.
2. Keep transactions short and free of user interaction, remote calls, unbounded loops, and long computation. Acquire required locks in a consistent order and understand their exact release point.
3. Prefer atomic statements, constraints, compare-and-set, and engine-supported locking reads over read-check-write sequences with a race window.
4. Handle deadlock and serialization aborts as expected control flow only when the complete transaction is idempotent and can be retried from the beginning with bounded backoff.
5. Document where eventual consistency is allowed, which representation is authoritative, maximum staleness, conflict resolution, repair, and what users observe during convergence.
6. Use operation identifiers or inbox, outbox, and uniqueness patterns where messages, jobs, or network retries can repeat a write. Exactly-once business effects require durable deduplication, not delivery assumptions.

## Migrations and zero-downtime changes

1. Separate schema expansion, application compatibility, data backfill, verification, constraint enforcement, reader switch, and old-schema removal when they cannot be safe in one deployment.
2. Make the application tolerate the previous and next schema while mixed versions may run. Add before use, stop use before remove, and delay destructive cleanup until rollback no longer needs the old representation.
3. Inspect the exact DDL lock and rewrite behavior for the database version. Set appropriate lock and statement timeouts; do not wait indefinitely behind production traffic.
4. Add constraints in stages when supported: create without validating old rows, backfill or repair, validate online, then enforce for all writes.
5. Use online or concurrent index operations where required. Detect and clean up invalid or partial artifacts after interruption.
6. Historical migrations must remain self-contained and deterministic. Avoid depending on application models, mutable business logic, wall-clock defaults, or external services that may change later.
7. Reversible means the previous schema and data semantics can actually be restored. When deletion, lossy conversion, or external side effects prevent that, mark the irreversible point and require a tested backup, copy, or roll-forward plan.

## Backfills and bulk changes

1. Iterate by stable key or cursor rather than repeatedly using a growing offset. Persist progress so work can resume without reprocessing unsafe effects.
2. Make every batch idempotent. Use bounded transactions, bounded rows and bytes, throttling, cancellation, retry limits, and observability for throughput, lag, failures, and remaining work.
3. Keep live writes compatible during the backfill through dual writes, triggers, derived-on-read behavior, or another explicit synchronization mechanism. Define how missed or conflicting writes are reconciled.
4. Validate counts, nulls, uniqueness, referential integrity, checksums, samples, and domain invariants before switching readers or deleting the old representation.
5. Estimate duration and database load with production-like data. Pause or reduce work when replication lag, lock waits, latency, or resource budgets exceed limits.

## Connections and resource limits

1. Treat connections as a bounded shared resource. Set a total budget across instances, workers, jobs, admin tools, replicas, failover capacity, and database limits.
2. Reuse the application's established pool. Configure pool size, overflow, checkout timeout, lifetime or recycle, health checks, transaction reset, and cancellation for the actual driver and server behavior.
3. Always commit or roll back before returning a connection. Detect leaks and long-held transactions. Do not share pooled connections across processes or concurrent units unless the driver explicitly supports it.
4. Use a pooler only when it solves measured connection setup or server concurrency pressure. Verify whether transaction, session, prepared statement, temporary table, advisory lock, and authentication features survive the selected pooling mode.

## Backup, recovery, and testing

1. Define recovery point and recovery time objectives. Replication improves availability but can replicate deletion or corruption; it does not replace independent backups.
2. Choose logical, physical, snapshot, continuous archive, and point-in-time recovery methods according to engine support, dataset size, version compatibility, and recovery needs.
3. Encrypt backups, restrict access, retain them according to policy, monitor completion, and protect required keys and configuration separately.
4. Test restores regularly in isolation. Measure restore time and verify schema version, row counts, constraints, checksums, tenant recovery, application startup, and point-in-time selection.
5. Test SQL and ORM behavior against the real engine and compatible production version. Use isolated databases with deterministic fixtures and clean state; do not rely only on mocks or a different in-memory database.
6. Test constraints, transaction anomalies, deadlock or serialization retry, migration upgrade and recovery, backfill restart, pool exhaustion, replica behavior, backup restore, and tenant isolation according to risk.
