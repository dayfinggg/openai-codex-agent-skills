# PostgreSQL

## Plans

`EXPLAIN (ANALYZE, BUFFERS)` runs the statement and shows actual rows, time and buffers per node, so wrap a write in `BEGIN` and `ROLLBACK`. Compare estimated with actual rows first, because a large gap means stale statistics. Look for `Seq Scan` on a large table, `Sort Method: external merge`, a hash with more than one batch and high `loops` on the inner side of a nested loop. Run twice to separate a cold cache from a warm one.

## Finding slow statements

`pg_stat_statements` ranks statements by `total_exec_time`, `mean_exec_time` and `calls` when it is installed. Enabling it needs `shared_preload_libraries`, a restart and `CREATE EXTENSION`, which is a live change. `log_min_duration_statement` logs statements above a threshold and is off at `-1`, `log_temp_files = 0` logs every spill, and `auto_explain` with `log_analyze` adds real cost to every query.

## Indexes

A multi-column B-tree narrows the scan by equality on its leading columns and the first inequality after them, and from version 18 the planner can skip a leading column with few distinct values. `INCLUDE (col)` enables index-only scans while vacuum keeps the visibility map current. `WHERE condition` indexes a subset, and with `UNIQUE` enforces uniqueness within it. An expression index serves a condition on the same expression. GIN suits arrays, `jsonb` and full text, and BRIN a huge table whose column follows the physical order. `LIKE 'abc%'` can use a B-tree, `LIKE '%abc'` cannot. `pg_stat_user_indexes` shows scans per index since the last statistics reset.

## Locks and schema changes

`ALTER TABLE` takes an `ACCESS EXCLUSIVE` lock unless the manual says otherwise for that form, so run `SET lock_timeout = '5s'` first and retry on failure. A column with a constant default changes only the catalogue, and a volatile default such as `clock_timestamp()` rewrites the table. `CREATE INDEX CONCURRENTLY` keeps writes running, cannot run in a transaction block, and leaves an invalid index on failure that you drop before retrying. Add foreign keys and checks `NOT VALID`, then `VALIDATE CONSTRAINT`. `SET NOT NULL` skips its scan when a validated check already rules out nulls.

## Transactions

The default is Read Committed. Repeatable Read and Serializable abort with SQLSTATE `40001` on a conflict, and the application retries. `FOR UPDATE SKIP LOCKED` lets several workers take rows from a queue table. A session-level advisory lock outlives the transaction, a transaction-level one does not. Idle open transactions hold back vacuum, so set `idle_in_transaction_session_timeout`.

## Writing

`INSERT ... ON CONFLICT (key) DO UPDATE SET col = EXCLUDED.col` is the atomic upsert, with a conflict target matching a unique index. Use `timestamptz`, `numeric` or integer minor units for money, `text` and identity columns. Version 18 adds `uuidv7()` for time-sorted keys.

## Pooling

PgBouncer in transaction mode hands each transaction any server connection, so `SET`, `LISTEN`, session advisory locks and SQL `PREPARE` do not carry over, and protocol-level prepared statements need `max_prepared_statements` above zero.
