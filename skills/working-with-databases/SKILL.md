---
name: working-with-databases
description: Covers schema design, queries, indexes, slow query diagnosis, transactions, live schema changes and caching for SQL and NoSQL stores such as PostgreSQL, MySQL, MariaDB, SQLite, MongoDB, Redis and Memcached. Use when writing or changing a query, a migration, a model, an index or a cache, when a query or a page is slow, when data is wrong, duplicated or locked, when choosing a data type or a store, and before running any statement that changes data or structure.
---

# Working with databases

Measure before you change anything, and prove the change with the same measurement afterwards. Most database work goes wrong through a guess about what the engine does.

## Start with facts

Find the engine and its exact version from the project or from the server, because syntax, defaults and planner behaviour differ between versions. Read the schema, the existing indexes and the size of the tables involved. A plan on ten rows says nothing about ten million.

## Slow queries

Get the real plan with the engine's own tool before you touch the query. Look for a full scan of a large table, a row estimate far from the actual count, a sort or a hash that spills to disk, and an inner step that runs once for each outer row. Fix the largest cost first, then measure again. Find the slow statements from the server's own statistics and not from a hunch.

## Queries

Fetch only the columns and rows that the code uses. A query inside a loop is the most common cause of a slow page, so load the related rows in one query. Page with a condition on the last seen key and not with a growing offset. Write and update in batches, in transactions of bounded size. Keep a column bare in a condition, because a function, a cast or a leading wildcard on it stops the index. Use `NOT EXISTS` where `NOT IN` could meet a null. Pass values as parameters, never by building the statement from input.

## Indexes

Build an index for a query that exists. In a composite index, put the columns compared for equality first, then the sort column, then the range column. Include the selected columns when that lets the engine answer from the index alone. Use a partial or filtered index for a small hot subset. Every index slows writes, so check that an index is used before you add another, and drop one only after the statistics show that nothing reads it.

## Transactions

Know the default isolation level of the engine and what it allows. Keep a transaction short, and do not call a network service inside one. Take locks in the same order everywhere, and retry a transaction that fails with a deadlock or a serialisation error. Let the database enforce what must be true with unique constraints, foreign keys and checks, because a check in application code races. Make a write that may be repeated idempotent.

## Changing a live schema

Change structure in steps that each keep the running code working. Add the new column or table, write to both, backfill in batches, switch reads, and remove the old one last. Set a short lock timeout before a statement that locks a table, because a statement that waits for a lock blocks every query behind it. Build indexes with the engine's online option. Add a constraint without validation first and validate it after. Know the way back before you start, and try the migration on a copy with realistic data.

## Types and modelling

Store time with its zone, money as an exact number, and text in a full Unicode encoding. Prefer a time-ordered key to a random one for large tables. Normalise data that changes, and denormalise only for a read that you measured.

## Needs the user's go-ahead

Ask before each of these and name the exact statement: `DROP`, `TRUNCATE`, a `DELETE` or an `UPDATE` without a narrow condition, any change to data or structure on a production database, and a restore. Before a change to data, run a `SELECT` with the same condition, compare the count with what you expect, and run the change inside a transaction where the engine allows it.

## References

Read `references/postgresql.md` for PostgreSQL, `references/mysql.md` for MySQL and MariaDB, `references/mongodb.md` for MongoDB, and `references/caching.md` before you add or change a cache or use Redis or Memcached.

## Related skills

Load `diagnosing-bugs` when the data is wrong and the cause is unknown, `clean-code` for the code around the queries, and `verifying-work` before you report.
