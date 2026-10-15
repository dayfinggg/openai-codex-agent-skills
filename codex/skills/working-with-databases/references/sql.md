# Relational databases

Project conventions and the engine's documentation for the version in use win over this file.

## Contents

- Schema design
- Naming
- Indexes
- Query style
- Pagination
- Transactions and concurrency
- ORMs
- Engine notes

## Schema design

- Normalize to third normal form by default. Denormalize only for a measured read problem, and document which copy is the source of truth.
- Every table has a primary key. Use a surrogate key (`bigint` identity or UUID, with UUIDv7 being time ordered and friendlier to indexes than random UUIDv4) and add unique constraints on natural keys such as email.
- Choose precise types, such as `timestamptz` for moments, `date` for calendar days, `numeric` for money, `boolean` for flags, and `text` with a check or an enum type for small fixed sets.
- Mark columns `NOT NULL` unless absence has a real meaning.
- Declare foreign keys with an explicit `ON DELETE` rule.
- Use check constraints for simple invariants such as `quantity > 0`.
- Prefer soft deletes only when the business needs history, and then filter them in one place, such as a view or the repository.
- Use JSON columns for genuinely variable attributes, not to avoid designing a schema.

## Naming

- `snake_case`, lowercase, no quoted identifiers.
- Choose plural or singular table names once for the project and keep it.
- Primary key `id`, foreign keys `<referenced_singular>_id`, as in `customer_id`.
- Timestamps `created_at` and `updated_at`, booleans `is_` or `has_` prefixes.
- Name constraints and indexes explicitly, as in `orders_customer_id_fkey` and `orders_status_created_at_idx`, so migrations can refer to them.

## Indexes

- Index foreign key columns used in joins and deletes.
- In composite indexes put equality columns first, then range or sort columns, matching the query.
- Use partial indexes for queries on a small subset, as in `WHERE status = 'pending'`.
- Use covering indexes (`INCLUDE` in PostgreSQL and SQL Server) for hot read paths.
- Expressions in `WHERE` need an expression index, so `lower(email)` needs an index on `lower(email)`.
- Check the plan after adding an index, and drop indexes that no query uses.

## Query style

- List columns instead of `SELECT *`, so schema changes do not change results or leak new fields.
- Uppercase keywords, one clause per line for long queries, meaningful aliases.
- Use common table expressions with descriptive names to break complex queries into steps.
- Use `EXISTS` instead of `COUNT(*) > 0` and `IN` with large subqueries.
- Keep functions off indexed columns in `WHERE`, write `created_at >= :start` instead of `date(created_at) = :day`.
- Use `INSERT ... ON CONFLICT` (PostgreSQL, SQLite), `MERGE`, or the engine's upsert for idempotent writes.
- Insert and update in batches for bulk work.

## Pagination

Offset pagination (`LIMIT 20 OFFSET 10000`) reads and discards every skipped row and shifts when rows are inserted. Use keyset pagination for large or changing data.

```sql
SELECT id, created_at, total
FROM orders
WHERE (created_at, id) < (:last_created_at, :last_id)
ORDER BY created_at DESC, id DESC
LIMIT 20;
```

Back it with an index on `(created_at DESC, id DESC)` and include a unique column in the sort so the order is total. SQL Server does not support row value comparison, so expand it to `created_at < :c OR (created_at = :c AND id < :i)`.

## Transactions and concurrency

- Group statements that must succeed together in one transaction, and keep it short.
- Know the default isolation level, which is Read Committed in PostgreSQL, SQL Server, and Oracle, and Repeatable Read in MySQL InnoDB.
- Prevent lost updates with optimistic locking, a `version` column checked in `UPDATE ... WHERE id = :id AND version = :version`, or with `SELECT ... FOR UPDATE` for short critical sections.
- Use `FOR UPDATE SKIP LOCKED` for simple job queues in PostgreSQL and MySQL 8.
- Retry transactions that fail with serialization or deadlock errors, with a limit.
- Use a connection pool, and size it for the database, not for the number of application threads.

## ORMs

- Keep ORM models inside the persistence adapter and map them to domain objects.
- Turn on query logging in development to spot N+1 patterns, and use explicit eager loading (`joinedload` or `selectinload` in SQLAlchemy, `include` in Prisma or Entity Framework, `select_related` and `prefetch_related` in Django).
- Drop to plain SQL for reports and complex queries instead of fighting the ORM.
- Never let automatic schema sync run in production, use migrations.

## Engine notes

- **PostgreSQL.** Prefer `timestamptz`, `text`, `jsonb`, identity columns, and `CREATE INDEX CONCURRENTLY`. Use `EXPLAIN (ANALYZE, BUFFERS)`.
- **MySQL.** Use InnoDB and `utf8mb4`. Remember that `ALTER TABLE` locking depends on the operation, and check the online DDL algorithm before running it.
- **SQLite.** Enable `PRAGMA foreign_keys = ON` per connection and WAL mode for concurrent readers.
- **SQL Server.** Use `datetime2` or `datetimeoffset`, `nvarchar` for Unicode, and parameterized queries through the driver to keep plan reuse.
