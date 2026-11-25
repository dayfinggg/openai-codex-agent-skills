# PostgreSQL

## Plans

`EXPLAIN (ANALYZE, BUFFERS)` runs the statement and shows actual rows, time and buffer use for each node. It executes writes, so wrap a write in `BEGIN` and `ROLLBACK`. Compare the estimated rows with the actual rows first, because a large gap means stale or missing statistics, and `ANALYZE` on the table refreshes them. Look for `Seq Scan` on a large table, for `Sort Method: external merge`, for a hash with more than one batch, and for the `loops` count on the inner side of a nested loop. Run the statement twice to separate a cold cache from a warm one.

## Finding slow statements

`pg_stat_statements` ranks statements by `total_exec_time`, `mean_exec_time` and `calls`. It needs `shared_preload_libraries = 'pg_stat_statements'`, a restart and `CREATE EXTENSION pg_stat_statements`. `log_min_duration_statement` logs statements above a threshold and is off at `-1`. `log_temp_files = 0` logs every sort and hash that spills. The `auto_explain` module logs plans of slow statements, and its `log_analyze` option adds real cost to every query.

## Indexes

A B-tree index on several columns limits the scan with the equality conditions on its leading columns and with the first inequality after them. From version 18 the planner can skip a leading column that has few distinct values. `CREATE INDEX ... INCLUDE (col)` adds columns for index-only scans, which pay off only while the table is vacuumed often enough to keep its visibility map current. `CREATE INDEX ... WHERE condition` indexes a subset, and with `UNIQUE` it enforces uniqueness inside that subset. An index on an expression serves a condition on the same expression. GIN suits arrays, `jsonb` and full text. BRIN suits a very large table whose column follows the physical row order. `LIKE 'abc%'` can use a B-tree and `LIKE '%abc'` cannot. `pg_stat_user_indexes` shows how often each index is scanned since the statistics were last reset.

## Locks and schema changes

`ALTER TABLE` takes an `ACCESS EXCLUSIVE` lock unless the manual says otherwise for that form. Run `SET lock_timeout = '5s'` before it and retry on failure. Adding a column with a constant default changes only the catalogue, and a volatile default such as `clock_timestamp()` rewrites the table. `CREATE INDEX CONCURRENTLY` does not block writes, cannot run inside a transaction block, and leaves an invalid index behind when it fails, which you drop before the retry. Add a foreign key or a check with `NOT VALID` and run `VALIDATE CONSTRAINT` as a second step. `SET NOT NULL` skips its scan when a validated check already proves that the column has no nulls.

## Transactions

The default isolation level is Read Committed. Repeatable Read and Serializable abort a transaction with SQLSTATE `40001` when they detect a conflict, and the application retries it. `SELECT ... FOR UPDATE SKIP LOCKED` lets several workers take rows from a queue table. A session-level advisory lock outlives the transaction, and a transaction-level one does not. An idle open transaction holds back vacuum, so set `idle_in_transaction_session_timeout`.

## Writing

`INSERT ... ON CONFLICT (key) DO UPDATE SET col = EXCLUDED.col` is the atomic upsert, and its conflict target must match a unique index. Use `timestamptz` for time, `numeric` or an integer of minor units for money, `text` for strings and an identity column for a generated key. Version 18 adds `uuidv7()` for keys that sort by time.

## Pooling

PgBouncer in transaction mode gives each transaction any server connection, so session state does not survive. `SET`, `LISTEN`, session-level advisory locks and SQL-level `PREPARE` do not work there, and protocol-level prepared statements need `max_prepared_statements` above zero.
