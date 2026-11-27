---
name: working-with-databases
description: Gives measured methods for queries, indexes, slow query diagnosis, transactions, live schema changes and caching in PostgreSQL, MySQL, MariaDB, SQLite, MongoDB and Redis. Use when writing or changing a query, migration, index or cache, when a query is slow or data is wrong or locked, or before running psql, mysql, redis-cli or mongosh. Load before the first query or command to a database or a cache, also a read-only one, and before a migration or a cache change.
---

# Working with databases

Measure before changing anything, and prove the change with the same measurement afterwards.

## Live databases

Give each session a statement limit so a heavy read cannot hang or load the server, such as `SET statement_timeout = '30s'` in PostgreSQL, `SET SESSION max_execution_time = 30000` for selects in MySQL, or `SET SESSION max_statement_time = 30` in MariaDB. Prefer `LIMIT` and statistics views to scans of large tables.

These are live changes that wait for the user's go-ahead like any write, so name the exact statement: `SET GLOBAL`, Redis `CONFIG SET`, `db.setProfilingLevel`, enabling a slow log or an extension, `CREATE INDEX` in any form, `ANALYZE`, `VACUUM` or `OPTIMIZE` on large tables, resetting statistics, `EXPLAIN ANALYZE` of a write, `DROP`, `TRUNCATE`, `UPDATE` or `DELETE` without a narrow condition, and a restore. Before a data change, run a `SELECT` with the same condition, compare the count with what you expect, and run the change in a transaction where the engine allows it.

## Slow queries

Read the table sizes first, because a plan on ten rows says nothing about ten million. Find slow statements in the server's own statistics, then get the real plan before touching the query. Look for a full scan of a large table, a row estimate far from the actual count, a sort or hash spilling to disk and an inner step running once per outer row. Fix the largest cost and measure again.

Keep the column bare in a condition, because a function, a cast or a leading wildcard on it skips the index. Use `NOT EXISTS` where `NOT IN` could meet a null, and page by the last seen key rather than a growing offset.

In a composite index put equality columns first, then the sort column, then the range column. Every index slows writes, so confirm the existing ones are used before adding another, and drop one only after statistics show nothing reads it.

## Transactions and schema changes

Keep transactions short and free of network calls, take locks in one order, retry on deadlock or serialisation errors, and enforce invariants with constraints, because a check in application code races.

Change a live schema in steps that each keep the running code working. Add the new column or table, write to both, backfill in batches, switch reads, and remove the old one last. Set a short lock timeout before a statement that locks a table, since a waiting lock blocks every query behind it. Build indexes online and add constraints unvalidated, then validate. Try the migration on a copy with realistic data.

## References

Read `references/postgresql.md`, `references/mysql.md` for MySQL and MariaDB, or `references/mongodb.md` for that engine, and `references/caching.md` before adding or changing a cache or using Redis or Memcached.
