# Safe Database Changes

## Classify the change

- Identify whether the change is additive, compatibility-affecting, constraint-tightening, data-rewriting, or destructive.
- Determine which application versions, workers, replicas, and external consumers will coexist during rollout.
- Verify engine-specific lock, rewrite, transaction, replication, and online-operation behavior before choosing commands.
- Define acceptable lock duration, latency, replication lag, resource use, and error-rate limits.

## Expand before contracting

Use a staged sequence when old and new code must coexist:

1. Add compatible schema or document fields without removing the old representation.
2. Deploy code that can tolerate both representations.
3. Backfill existing data with bounded, restartable work.
4. Verify invariants and compare old and new reads where applicable.
5. Switch authoritative reads and writes using an explicit cutover criterion.
6. Stop writing the old representation and observe a defined safety window.
7. Remove obsolete data or schema only after confirming no remaining reader depends on it.

Avoid dual writes without a failure model. If dual writes are necessary, define ordering, retry semantics, reconciliation, and the authoritative copy.

## Build reliable backfills

- Select work by a stable key or snapshot boundary so inserts and updates cannot be silently skipped.
- Make each batch idempotent and safe to retry after partial completion.
- Persist checkpoints outside transient process memory.
- Bound batch size and transaction duration; throttle against database health rather than elapsed time alone.
- Avoid unbounded scans and per-row round trips when set-based or bulk operations are safe.
- Decide how concurrent application writes interact with the backfill and how conflicts are detected.
- Emit progress, failure, retry, lag, and invariant metrics without exposing sensitive data.
- Define pause and abort thresholds before starting.

## Tighten integrity safely

- Measure existing violations before adding or strengthening a constraint.
- Repair or quarantine invalid data with an auditable rule; do not silently discard ambiguous records.
- Introduce validation in stages when the engine supports it, then verify all existing data before making the rule mandatory.
- Account for the lock and scan behavior of index creation, constraint validation, and type conversion on production-sized data.

## Apply retention and deletion

- Translate retention requirements into a precise eligibility rule, time basis, and treatment of legal holds or exceptions.
- Trace dependent records, secondary indexes, search systems, caches, backups, change streams, and analytical copies.
- Define how soft deletion affects uniqueness, authorization, queries, restoration, and eventual hard deletion.
- Delete in bounded, observable batches when bulk deletion could create long transactions, lag, or storage pressure.
- Verify that deletion propagates to every required copy and that audit evidence retains no prohibited payload.

## Define recovery before execution

- State separately how to roll back application behavior, schema changes, and transformed data.
- Prefer a forward fix when reversal would lose valid writes created after cutover.
- Preserve old data until the compatibility window and verification gates have passed when policy permits.
- Confirm backup freshness, restore procedure, replay boundary, and recovery time; a backup is not a rollback plan until restoration is tested.
- Record the last safe decision point after which rollback becomes restore or forward repair.

## Verify and observe

- Check row or document counts, invariant queries, sampled or aggregate comparisons, and checksums suited to the transformation.
- Exercise concurrent writes, retries, cancellation, failover, and restart behavior.
- Compare representative query plans and performance before and after rollout.
- Monitor errors, latency, locks, deadlocks, connection saturation, replication lag, storage growth, and write amplification.
- Keep post-change observation long enough to cover delayed jobs and infrequent access paths before contraction.
