# Indexes and query planning

- Index columns used by selective `WHERE`, join, and ordering predicates, while accounting for index maintenance on writes. [M10]
- Do not add an index for every column; measure selectivity, write cost, storage cost, and plan quality. [M10]
- A composite index on `(a,b,c)` normally supports the leftmost prefixes `(a)`, `(a,b)`, and `(a,b,c)`, not `(b)` alone. [M11]
- Put composite columns in an order that matches real equality, range, join, and ordering predicates. [M11]
- MySQL 9.7 can use Skip Scan for certain single-table queries that omit a leading key part, but the access method is conditional and optimizer-selected. [M22]
- Treat Skip Scan as a possible plan, not as a guarantee that removes the need for a suitable index or query shape. [M22]
- Confirm Skip Scan with `EXPLAIN`, which reports `Using index for skip scan` when it is used. [M22]
- Skip Scan depends on predicates, index shape, statistics, optimizer switches, and data distribution, so benchmark representative data. [M22]
- Use `EXPLAIN` or `EXPLAIN ANALYZE` to inspect join order, access paths, estimates, and actual work before changing a query. [M12]
- Use `ANALYZE TABLE` when stale index statistics are causing poor estimates, then recheck the plan. [M22]
- Recheck plans after data growth, statistics changes, version upgrades, or index changes.
- Prefer sargable predicates and compare columns with compatible types so the optimizer can use indexes predictably.
