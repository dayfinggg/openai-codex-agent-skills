# MySQL and MariaDB

The two engines differ in syntax, defaults and features. Check which runs with `SELECT VERSION()` and read that engine's manual.

## Plans

MySQL's `EXPLAIN ANALYZE` runs the statement and prints actual time, rows and loops per step. MariaDB's equivalent is `ANALYZE` before the statement, and `ANALYZE UPDATE` or `ANALYZE DELETE` really changes the rows. In classic `EXPLAIN`, `type` `ALL` is a full scan, `rows` is the estimate, `Using filesort` and `Using temporary` mark a sort and a temporary table, and `Using index` means the index alone answered.

## Finding slow statements

Start with Performance Schema `events_statements_summary_by_digest`, which totals time and calls per statement shape and needs no setting change. In MySQL, the `sys` views `schema_unused_indexes` and `schema_redundant_indexes` list removal candidates. The slow query log is off by default with `long_query_time` at 10 seconds, and turning it on with `SET GLOBAL slow_query_log = 1` is a live setting change.

## Indexes

A composite index serves a condition only through a leftmost prefix. InnoDB secondary indexes carry the primary key, so a short key keeps them small and a random one scatters inserts. Test removing an index with `ALTER INDEX i INVISIBLE` in MySQL or `ALTER INDEX i IGNORED` in MariaDB before dropping it.

## Transactions and locks

InnoDB defaults to `REPEATABLE READ`, where locking reads and writes on a range also lock the gaps, a frequent deadlock cause. The application retries the aborted transaction. `SELECT ... FOR UPDATE SKIP LOCKED` serves queue tables in MySQL 8 and MariaDB 10.6 and later.

## Schema changes

State the algorithm and lock, as in `ALTER TABLE t ADD INDEX i (c), ALGORITHM=INPLACE, LOCK=NONE`, so the server errors instead of silently copying the table under a lock. Adding a column is usually `ALGORITHM=INSTANT`, and changing a column type copies the table. Every `ALTER TABLE` waits for a metadata lock behind long open transactions and then blocks everything behind it, so set a low `lock_wait_timeout` for the session first.

## Writing

Use `utf8mb4`, because `utf8` and `utf8mb3` store only three-byte characters. The upsert is `INSERT ... ON DUPLICATE KEY UPDATE`. MySQL now prefers a row alias, as in `INSERT ... VALUES (...) AS new ON DUPLICATE KEY UPDATE c = new.c`, and has deprecated `VALUES()` there, so check which form the engine in use accepts.
