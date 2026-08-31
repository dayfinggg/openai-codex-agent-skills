# Indexes and execution plans

- Add indexes for observed lookup, join, uniqueness, ordering, or range workloads, not for every column.
- An index can accelerate reads but adds storage, write, vacuum or maintenance, and planning overhead.
- Primary and unique constraints commonly create supporting indexes, but verify the target engine before adding duplicates.
- Index foreign-key columns used to find children during joins, deletes, or parent-key changes.
- Design a composite index from actual predicates and ordering; column order and skip-scan behavior are engine-specific.
- Verify composite-index access with the target vendor reference and `EXPLAIN`; do not infer later-column behavior from another engine.
- Consider a covering index only when its extra width pays for fewer table lookups on a measured hot query.
- Partial, expression, included-column, and filtered indexes are useful extensions but require dialect-specific migrations.
- Remove duplicate and unused indexes after observing production workload and write cost.
- Use `EXPLAIN` to understand a plan; use `EXPLAIN ANALYZE` carefully because it executes the statement.
- Test plans with realistic data distributions, parameter values, statistics, and concurrency.
- A sequential scan can be correct for a small or low-selectivity table; do not force an index without evidence.
- Online index builds, lock modes, and transactional DDL are engine-specific; use the target vendor’s documented migration path.
