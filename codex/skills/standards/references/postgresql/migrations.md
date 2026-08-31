# Migrations

Use an expand, migrate, and contract sequence when old and new application versions must overlap during deployment. For a simple offline or atomic migration with no mixed-version window, use the smallest safe transaction and verification plan instead.
Review the lock level of every `ALTER TABLE`; unless documented otherwise, it acquires `ACCESS EXCLUSIVE`, and a combined statement takes the strictest required lock.
On current supported releases, a non-volatile default when adding a column is stored in metadata without rewriting existing rows.
Treat volatile defaults, stored generated columns, identity columns, constrained domains, and most type changes as potential table rewrites.
Add foreign-key and check constraints as `NOT VALID` when a large-table scan must be separated from enforcement. PostgreSQL 18 and later also support `NOT VALID` for `NOT NULL`. On older releases, add and validate an equivalent check before `SET NOT NULL`.
Validate later with `VALIDATE CONSTRAINT`; new writes are protected while existing rows are checked under a less restrictive lock.
Use a validated nullability check to let `SET NOT NULL` skip a redundant full-table scan where the release supports that optimization.
Build a unique index concurrently first, then attach it as a unique or primary-key constraint with `USING INDEX` when the index qualifies.
Run `CREATE INDEX CONCURRENTLY` outside the migration transaction and plan cleanup for an invalid index after failure.
For partitioned tables, build child indexes concurrently and attach them to a parent index because concurrent parent builds are unsupported.
Backfill in small committed batches, throttle when necessary, and make each batch restartable and observable.
For a concurrent batched update, select a deterministic batch through a CTE and `ctid`, optionally use `SKIP LOCKED` for cooperating workers, and finish with a pass that does not skip locked rows. Recheck the remaining authoritative row count after every restart.
Use per-migration lock and statement timeouts so a waiting deployment fails instead of queueing application traffic.
Use a dedicated migration role that can alter schema without granting those powers to the application role.
For large or live migrations, test duration, lock waits, rewrite space, replica impact, and rollback or forward-fix procedures on production-scale data. For small offline migrations, verify the transaction, resulting schema and data, and recovery path in proportion to risk.
The reviewed `strong_migrations` GitHub examples illustrate concurrent indexes, batched throttled backfills, lock timeouts, and a separate migration user.
