---
name: working-with-databases
description: Designs schemas and writes queries, migrations, and data access code for SQL and NoSQL stores with injection-safe queries. Use when writing or reviewing SQL, ORM code, schema or index changes, migrations, Redis caching, or slow queries.
---

# Working with databases

The data model is part of the design, and the database product is a detail. Keep business rules independent of the storage technology, put every query behind a repository or gateway owned by the application, and still design the schema, keys, and indexes with care, because data outlives code. This skill owns SQL and NoSQL injection, the writing-secure-code skill covers the other injection sinks and access control, and the adding-observability skill covers what may be logged. When the project already has conventions for naming, migrations, or data access, follow them.

## Data access in the architecture

- The use case layer declares a repository interface in business terms (`find_active_orders_for(customer_id)`), and an adapter implements it with SQL, an ORM, or a NoSQL client. The applying-clean-architecture skill covers the layers.
- Map rows and documents to domain objects inside the adapter. ORM models, cursors, and driver types never leave it.
- One repository per aggregate, meaning a cluster of objects that changes together, not one per table.
- Transactions are a use case concern. The use case decides where a unit of work starts and ends, the adapter implements it.
- Test repositories with integration tests against the real engine, for example in a container. An in-memory fake is fine for use case tests, not for testing SQL.

## Choosing a store

Default to a relational database. It handles flexible queries, constraints, and transactions, and PostgreSQL also stores JSON when parts of the data are loosely structured. Choose a document store when data is read and written as whole self-contained documents, a key-value or wide-column store such as DynamoDB when access patterns are known and few and scale is very high, and Redis for caches, rate limits, queues, and ephemeral state, never as the only copy of important data.

## Rules for every store

- **Never build queries from strings with user input.** Use parameterized queries or the query builder's bound values. For dynamic identifiers such as sort columns, map input to an allow-list. This applies equally to NoSQL, where user input must not become operators, as in a MongoDB filter receiving `{"$ne": null}`. Audit and log records written to a database follow the same rule.
- **Least privilege.** The application connects with an account that can only do what it needs, and migrations run with a separate account.
- **Secrets stay out of code.** Read connection strings from the environment or a secret manager.
- **Constraints live in the database** where the store supports them, such as types, `NOT NULL`, uniqueness, foreign keys, checks, and MongoDB schema validation, because application checks alone do not survive concurrent writers or other clients.
- **Bound every read.** Paginate, limit result sizes, and never load a whole table or collection into memory.
- **Keep transactions short** and do no network calls to other services inside them.
- **Make writes safe to retry** with natural keys, upserts, or idempotency keys.
- **Avoid N+1 queries.** Load related data with joins, batch loading, or explicit eager loading.
- **Store time in UTC** with a time-zone aware type, and money as exact decimals or integer minor units.
- **Never put personal data or secrets in logs** of queries or parameters.

## Schema changes

All schema changes go through versioned migrations in version control, using the project's tool. Never edit a migration that has already run in a shared environment, write a new one instead. For tables or collections in production use the expand and contract approach, which keeps old and new code working at once.

1. Expand. Add new nullable columns, tables, or indexes without breaking current code.
2. Deploy code that writes both old and new shapes and reads the new one with a fallback.
3. Backfill existing data in small batches.
4. Switch reads fully to the new shape and add constraints once data is complete.
5. Contract. Remove the old column or field in a later release.

Build indexes on large tables without locking writes, for example `CREATE INDEX CONCURRENTLY` in PostgreSQL. Treat destructive operations such as `DROP`, `TRUNCATE`, deletes without `WHERE`, and bulk updates as dangerous, and run them only when the user asks, after confirming the target and the backup.

## Performance

Measure before optimizing. Read the execution plan (`EXPLAIN ANALYZE` in PostgreSQL, `explain("executionStats")` in MongoDB), index for the queries the application actually runs, and remove indexes nothing uses, because each one slows writes. Add a cache only after the query itself is sound, and give every cache entry an expiry and an invalidation rule.

## Workflow

1. Find the database engine and version, the access library, the migration tool, and existing naming conventions.
2. List the access patterns the change needs, meaning which queries, how often, and how much data.
3. Design or adjust the schema, keys, and indexes for those patterns.
4. Write the migration, then the repository code with parameterized queries.
5. Add integration tests for the repository, and check the plan of new heavy queries.
6. Review against the checklist.

## Checklist

- [ ] All queries use bound parameters, and dynamic identifiers use an allow-list
- [ ] Data access stays behind a repository and driver types do not leak
- [ ] Constraints, types, and nullability express the real rules
- [ ] Every query that can grow is bounded and backed by a fitting index
- [ ] No N+1 patterns and no transactions spanning network calls
- [ ] Schema changes are new migrations that are safe for code running during deploy
- [ ] Destructive operations were requested and confirmed
- [ ] Repository integration tests pass against the real engine

## Reference files

Read them before the first change, the file for the store at hand and the examples file.

- [references/sql.md](references/sql.md) covers relational schema design, naming, indexes, query style, pagination, transactions, and isolation.
- [references/nosql.md](references/nosql.md) covers MongoDB, DynamoDB, and Redis modeling patterns and anti-patterns.
- [examples.md](examples.md) has illustrative repository code, keyset pagination, an expand and contract migration, and a MongoDB schema.
