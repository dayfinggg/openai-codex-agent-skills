# Partitioning

Partition only when data volume, access locality, or retention operations justify the added hierarchy.
Choose range, list, or hash partitioning from query predicates, data distribution, and lifecycle operations.
Choose a partition key that common `WHERE` clauses can use for pruning and that matches the unit of data you remove together.
Define non-overlapping bounds and create the next partition before inserts need it, or provide a deliberate default partition policy.
Partition pruning uses partition bounds rather than indexes, so keep pruning enabled and verify it in `EXPLAIN`.
Do not create more partitions than the workload can prune; planning time and per-session metadata memory grow when many remain relevant.
Remember that a partitioned parent stores no tuples and that parent indexes and unique constraints are virtual child structures.
Design global uniqueness early because a partitioned primary key or unique constraint must include every partition-key column.
Use `DROP` or `DETACH PARTITION` for bulk retention work instead of row-by-row deletes when the lifecycle allows it.
Use a matching `CHECK` constraint before `ATTACH PARTITION` to avoid a validation scan under a stronger lock.
Run manual `ANALYZE` on the partitioned parent after initial population and when partition distributions change materially.
Rehearse partition creation, attachment, detachment, default-partition behavior, and out-of-range inserts before production rollout.
