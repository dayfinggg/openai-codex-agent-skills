# Relational databases

Project conventions and the engine documentation for the version in use win over this file.

## Schema

- Normalize to third normal form. Denormalize only for a measured read problem, and document which copy is the source of truth.
- Every table has a surrogate primary key, a `bigint` identity or a UUIDv7, which is time ordered and friendlier to indexes than a random UUIDv4. Natural keys such as email get unique constraints.
- Use `timestamptz` for moments, `date` for calendar days, `numeric` for money, and `text` with a check or an enum type for small fixed sets.
- Columns are `NOT NULL` unless absence has a real meaning. Foreign keys declare an explicit `ON DELETE` rule.
- Use soft deletes only when the business needs history, and filter them in one place, such as a view or the repository.
- Use JSON columns only for attributes that genuinely vary.

## Naming

- `snake_case`, lowercase, no quoted identifiers. Choose plural or singular table names once per project.
- Primary key `id`, foreign keys `<referenced_singular>_id`, timestamps `created_at` and `updated_at`, booleans with an `is_` or `has_` prefix.
- Name constraints and indexes explicitly, as in `orders_customer_id_fkey` and `orders_status_created_at_idx`, so migrations can refer to them.

## Indexes and queries

- Index foreign keys used in joins and deletes. In composite indexes put equality columns first, then range or sort columns.
- Use partial indexes for small subsets, covering indexes with `INCLUDE` in PostgreSQL and SQL Server for hot reads, and an expression index for an expression in `WHERE`, such as `lower(email)`.
- List columns instead of `SELECT *`, so schema changes neither change results nor leak new fields.
- Write `created_at >= :start` instead of `date(created_at) = :day`, so the index stays usable.
- Use `INSERT ... ON CONFLICT` in PostgreSQL and SQLite, `MERGE`, or the engine's upsert for idempotent writes.

## Pagination

Use keyset pagination for large or changing data, because offset pagination reads and discards every skipped row and shifts when rows are inserted.

```sql
SELECT id, created_at, total
FROM orders
WHERE (created_at, id) < (:last_created_at, :last_id)
ORDER BY created_at DESC, id DESC
LIMIT 20;
```

Back it with an index on `(created_at DESC, id DESC)`. The sort includes a unique column so the order is total. SQL Server has no row value comparison, so expand it to `created_at < :c OR (created_at = :c AND id < :i)`.

## Transactions and concurrency

- The default isolation level is Read Committed in PostgreSQL, SQL Server, and Oracle, and Repeatable Read in MySQL InnoDB.
- Prevent lost updates with a `version` column checked in `UPDATE ... WHERE id = :id AND version = :version`, or with `SELECT ... FOR UPDATE` for short critical sections.
- Use `FOR UPDATE SKIP LOCKED` for simple job queues in PostgreSQL and MySQL 8.
- Retry serialization and deadlock failures a limited number of times.
- Size the connection pool for the database, not for the number of application threads.

## ORMs

- Turn on query logging in development to spot N+1 queries, and load relations with explicit eager loading.
- Write plain SQL for reports and complex queries.
- Automatic schema sync stays off in production, where migrations change the schema.

## Engine notes

- PostgreSQL. Prefer `timestamptz`, `text`, `jsonb`, and identity columns.
- MySQL. Use InnoDB and `utf8mb4`. `ALTER TABLE` locking depends on the operation, so check the online DDL algorithm before running it.
- SQLite. Set `PRAGMA foreign_keys = ON` on every connection, and use WAL mode for concurrent readers.
- SQL Server. Use `datetime2` or `datetimeoffset`, `nvarchar` for Unicode, and parameterized queries through the driver to keep plan reuse.
