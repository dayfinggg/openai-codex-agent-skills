# MySQL and MariaDB

The two engines share a history and differ in syntax, defaults and features. Check which one runs and its version with `SELECT VERSION()`, and read the manual of that engine.

## Plans

In MySQL, `EXPLAIN ANALYZE` runs the statement and prints the actual time, rows and loops of each step in tree form. In MariaDB the same job is done by `ANALYZE` in front of the statement, and `ANALYZE UPDATE` or `ANALYZE DELETE` really changes the rows. In the classic `EXPLAIN` table, a `type` of `ALL` is a full table scan, `rows` is the estimate of rows examined, and `Using filesort` and `Using temporary` in `Extra` mark a sort and a temporary table. `Using index` there means that the index alone answered the query.

## Finding slow statements

The slow query log is off by default, and `long_query_time` defaults to 10 seconds. Turn it on with `SET GLOBAL slow_query_log = 1` and lower the threshold for the investigation. `log_queries_not_using_indexes` adds statements that scan. The Performance Schema table `events_statements_summary_by_digest` totals time and calls for each statement shape, and in MySQL the `sys` views `schema_unused_indexes` and `schema_redundant_indexes` list candidates for removal.

## Indexes

A composite index serves a condition only through a leftmost prefix of its columns. In InnoDB every secondary index carries the primary key, so a short primary key keeps all indexes small and a random one scatters inserts across the table. Test the removal of an index without dropping it. MySQL does this with `ALTER TABLE t ALTER INDEX i INVISIBLE`, and MariaDB with `ALTER TABLE t ALTER INDEX i IGNORED`.

## Transactions and locks

InnoDB defaults to `REPEATABLE READ`. Under it, a locking read or a write on a range also locks the gaps between rows, which is a frequent cause of deadlocks. A deadlock aborts one transaction, and the application retries it. `SELECT ... FOR UPDATE SKIP LOCKED` serves queue tables in MySQL 8 and in MariaDB from 10.6.

## Schema changes

State the algorithm and the lock in the statement, as in `ALTER TABLE t ADD INDEX i (c), ALGORITHM=INPLACE, LOCK=NONE`, so that the server returns an error when it cannot do the change online, and does not silently copy the table under a lock. Adding a column is usually `ALGORITHM=INSTANT`. Changing a column type copies the table. Any `ALTER TABLE` still waits for a metadata lock, so a long open transaction on the table blocks it, and the waiting statement then blocks everything behind it. Set `lock_wait_timeout` low for the session before the change.

## Writing

Use `utf8mb4`, because `utf8` and `utf8mb3` store only three-byte characters. The upsert is `INSERT ... ON DUPLICATE KEY UPDATE`. MySQL refers to the new row through an alias, as in `INSERT ... VALUES (...) AS new ON DUPLICATE KEY UPDATE c = new.c`, and has deprecated the `VALUES()` function in that clause, so check which form the engine in use accepts.
