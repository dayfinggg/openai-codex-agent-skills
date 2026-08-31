# EXPLAIN

Use `EXPLAIN` to inspect the planner's chosen plan before changing SQL or adding an index.
Run `EXPLAIN (ANALYZE, BUFFERS)` on representative data to compare estimated and actual rows and I/O.
Inspect `Recheck Cond` and lossy bitmap pages, `Heap Fetches` for index-only scans, sort and hash spill, Memoize hits and evictions, and planned versus launched workers when those nodes appear.
Treat large row-estimate errors as a statistics, correlation, predicate, or data-distribution problem to investigate.
Read node times together with `loops`; per-loop values must be multiplied to understand total work.
Treat planner costs as arbitrary units rather than milliseconds.
Remember that `EXPLAIN ANALYZE` executes the statement and triggers its side effects.
Wrap data-modifying analysis in a transaction and roll it back when a safe rehearsal is possible.
Do not extrapolate a plan from a toy table to production scale, and record relevant planner settings with the plan.
Budget `work_mem` per eligible plan node and parallel worker rather than once per query. Compare generic and custom prepared plans when parameter skew changes selectivity.
Do not interpret `pg_stat_io` reads as proof of physical disk access because operating-system cache hits are not distinguished there.
