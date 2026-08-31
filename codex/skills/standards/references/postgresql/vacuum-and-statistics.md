# Vacuum and statistics

Keep autovacuum enabled unless a documented exception has a compensating maintenance plan.
Vacuum reclaims dead-tuple space for reuse, updates planner statistics, maintains the visibility map, and prevents transaction-ID wraparound.
Use ordinary `VACUUM` for routine concurrent maintenance; reserve `VACUUM FULL` for planned rewrites because it takes `ACCESS EXCLUSIVE` and extra disk space.
Use `VACUUM (ANALYZE)` after bulk loads or major distribution changes when the normal schedule is too slow.
Tune autovacuum thresholds and scale factors per high-churn table instead of disabling the daemon globally.
Monitor `n_dead_tup`, `n_mod_since_analyze`, last vacuum and analyze times, freeze age, and autovacuum duration.
Use the target major version's `pg_stat_progress_vacuum` fields because progress counters changed in PostgreSQL 17. Treat autovacuum worker memory as aggregate capacity and include insert-triggered vacuum thresholds based on unfrozen pages.
Watch for long or idle transactions because they can prevent vacuum from removing row versions visible to their snapshots.
Remember that autovacuum processes partitions but does not analyze the partitioned parent; schedule parent `ANALYZE` explicitly.
Use higher per-column statistics targets only for skewed, high-value predicates that need better estimates.
Use `CREATE STATISTICS` for correlated columns, functional dependencies, most-common combinations, or expressions.
Re-run `ANALYZE` after creating expression indexes, extended statistics, or bulk data changes.
Treat anti-wraparound vacuum warnings as an operational incident, not as an ordinary performance symptom.
Use `COPY FREEZE` only when its documented table-creation or truncation and snapshot conditions hold, because it changes normal MVCC visibility expectations. On PostgreSQL 18, evaluate eager freezing and vacuum buffer limits against the workload instead of copying older tuning rules.
