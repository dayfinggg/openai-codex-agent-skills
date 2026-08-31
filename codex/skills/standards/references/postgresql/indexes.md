# Indexes

Create indexes for measured predicates, joins, and orderings rather than indexing every column.
Every index consumes storage and adds work to inserts, updates, deletes, vacuum, and backups.
Use B-tree by default for equality, ranges, anchored prefix patterns with the right collation or operator class, and ordered scans.
Use hash only for simple equality, and select GiST, SP-GiST, GIN, or BRIN from the operator class and data shape.
Account for access-method semantics such as lossy matches and rechecks, KNN support, GIN pending-list behavior, and BRIN range summaries instead of treating every index as an exact B-tree lookup.
Use GIN for values with multiple searchable components such as arrays or JSONB.
Use BRIN when column values correlate with the table's physical block order.
Order multicolumn B-tree keys with leading equality predicates before range or ordering predicates.
On releases that support B-tree skip scan, later-column predicates can sometimes generate repeated searches over leading values. Verify selectivity and the actual plan instead of assuming either full support or impossibility.
Use partial indexes only for stable selective predicates that the planner can recognize in the query.
Do not use a collection of partial indexes as a substitute for declarative partitioning.
Use expression indexes when the query applies the same transformation, and keep every function and operator immutable.
Remember that expression indexes trade faster reads for extra computation on writes.
Use `INCLUDE` payload columns sparingly because wide payloads bloat indexes and can make inserts fail at the index size limit.
Expect index-only scans to win mainly when the visibility map marks many heap pages all-visible.
Expect HOT updates only when no indexed value that matters to an ordinary index changes and the heap page has enough space. Treat fillfactor as a measured write-locality tradeoff, not a universal setting.
Create indexes on live large tables with `CREATE INDEX CONCURRENTLY` when the extra scans and I/O are acceptable.
Concurrent builds keep writers running but take longer, cannot run inside a transaction block, and can leave an invalid index after failure.
Drop an invalid failed concurrent index before retrying, or use the documented concurrent rebuild path.
Inspect `pg_stat_user_indexes` and query plans before removing an index; low `idx_scan` alone is not proof that it is unused.
