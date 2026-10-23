---
name: working-with-databases
description: Writes schemas, queries, migrations, and data access code for SQL and NoSQL stores. Use when writing or reviewing SQL, ORM code, schema or index changes, migrations, Redis caching, or slow queries.
---

# Working with databases

This skill owns SQL and NoSQL injection. Other sinks and access control belong to writing-secure-code, and what may be logged to adding-observability. The project's conventions for naming, migrations, and data access come first.

## Design

The use case declares a repository interface in business terms, such as `find_active_orders_for(customer_id)`, one per aggregate, and decides where transactions start and end. The adapter implements it and keeps rows, ORM models, cursors, and driver types inside. Test repositories against the real engine, for example in a container, because an in-memory fake cannot test SQL.

Default to a relational database, PostgreSQL with JSON columns for loosely structured parts. Use a document store for data read and written as whole documents, DynamoDB or another key-value store for few known access patterns at very high scale, and Redis for caches, rate limits, queues, and ephemeral state, never as the only copy of important data.

## Rules

- User input reaches a query only as bound parameters, and dynamic identifiers such as sort columns go through an allow-list. NoSQL input never becomes an operator, so a MongoDB filter rejects `{"$ne": null}` and keys that start with `$`.
- The application account has only the rights it needs, and migrations run with a separate account.
- Constraints live in the database, such as `NOT NULL`, uniqueness, foreign keys, checks, and MongoDB `$jsonSchema` validation, because application checks do not survive concurrent writers or other clients.
- Every read is bounded. Transactions stay short and hold no calls to other services. Writes are safe to retry through natural keys, upserts, or idempotency keys.
- Time is stored in UTC with a time-zone aware type, and money as exact decimals or integer minor units.
- Personal data and secrets stay out of query and parameter logs.

## Schema changes

Every change is a new versioned migration in the project's tool. A migration that ran in a shared environment stays as it is, and a new migration corrects it. Production tables and collections change by expand and contract, so old and new code run side by side.

1. Expand. Add nullable columns, tables, or indexes without breaking current code.
2. Deploy code that writes both shapes and reads the new one with a fallback.
3. Backfill in small batches.
4. Switch reads to the new shape and add constraints once the data is complete.
5. Contract. Remove the old column or field in a later release.

Build indexes on large tables without blocking writes, as with `CREATE INDEX CONCURRENTLY` in PostgreSQL. Run `DROP`, `TRUNCATE`, deletes without `WHERE`, and bulk updates only when the user asks, after confirming the target and the backup.

## Performance

Read the plan first, with `EXPLAIN (ANALYZE, BUFFERS)` in PostgreSQL or `explain("executionStats")` in MongoDB. Index for the queries the application runs and drop unused indexes, because each one slows writes. Add a cache only after the query is sound, with an expiry and an invalidation rule for every entry.

## Reference files

- [reference/sql.md](reference/sql.md) has relational schema, naming, index, pagination, and locking choices. Read it before relational work.
- [reference/nosql.md](reference/nosql.md) has MongoDB, DynamoDB, and Redis modeling rules. Read it before work on those stores.
