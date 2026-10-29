---
name: database-query-diagnosis
description: "Diagnose slow SQL, lock waits, or connection exhaustion using actual queries, plans, and workload evidence. Use for database latency and throughput defects, not routine schema design."
---

Locate the database bottleneck with evidence from the affected workload.

1. Establish the engine, version, database, role, time interval, query fingerprint, parameters, and user-visible symptom. Separate execution time from connection checkout, network time, and application materialization.
2. Inspect the schema, constraints, indexes, statistics, expected result grain, and relevant transaction boundaries. Reuse existing authorized access and keep queries bounded.
3. Read a plain execution plan where appropriate. Before EXPLAIN ANALYZE, inspect side effects and workload cost because it executes the statement. Use a safe representative environment when execution would exceed authorization.
4. Examine estimated and actual rows, loops, filtering, sort or hash spills, access paths, and wait events where available. A sequential scan or filesort is not automatically a defect.
5. For locking, identify blockers, transaction age, lock ordering, and application retry behavior. For connections, separate pool configuration, leaks, long transactions, and server saturation.
6. Test the smallest plausible correction against counterevidence. Consider index write cost, parameter sensitivity, result correctness, and other consumers before changing a shared object.
7. Compare equivalent inputs, data, concurrency, and cache conditions before and after. Verify row identity and ordering as well as latency. Stop when the reported issue is resolved and the relevant regression check passes.

Use installed PostgreSQL, MongoDB, Redis, or ClickHouse specialists when their engine-specific procedure applies. Do not broaden production scans or terminate sessions merely to simplify investigation.

Consult the engine's official plan and monitoring documentation. Distinguish a suspected bottleneck from a reproduced and measured cause.

