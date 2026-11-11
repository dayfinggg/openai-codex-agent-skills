---
name: database
description: Guides safe, current database work on any SQL or NoSQL engine, with detailed rules for PostgreSQL and MySQL. Use it whenever a task touches a database, such as schema changes, migrations, queries, ORM code, indexes, data fixes, imports, backfills, or deletes. Use it before any command that resets, drops, truncates, flushes, or wipes data, or that connects to a production database.
---

<overview>
Write every migration and data change as if it runs against production. Until you know the real table sizes and traffic, assume a large table, live traffic, and the previous app version still serving requests during the deploy. A change that finishes at once on a dev database can lock a production table for an hour. Data that a statement deletes or overwrites is gone unless a backup exists.

These rules hold for every engine, relational or not. The `postgresql` and `mysql` sections add detail for those two engines, and `any_engine` says how to get the same detail for an engine this skill does not describe.
</overview>

<references>
The reference files hold rules that this file does not repeat, one engine area each. Read a file whole as soon as the work meets its condition, also when that happens later in the task.
- Before you write a PostgreSQL migration or change a PostgreSQL table, read [postgres-schema.md](references/postgres-schema.md). It covers data types, primary keys, foreign key indexes, idempotent constraints, identifiers, and partial and JSONB indexes.
- When you write a PostgreSQL query that an application or a script will keep, diagnose a slow query, or load or change rows in bulk, read [postgres-queries.md](references/postgres-queries.md). It covers N+1 batching, keyset pagination, upserts, transactions, deadlocks, queues, `EXPLAIN`, statistics, and bulk loads. A one-off read to look at data needs no reference.
- When you configure connections or access control, read [postgres-operations.md](references/postgres-operations.md). It covers connection pooling, prepared statements, timeouts, privileges, and row level security.
- Before any MySQL `ALTER TABLE` on a large table, read [mysql-online-ddl.md](references/mysql-online-ddl.md). It covers DDL algorithms, lock levels, and online schema change tools.
- When you write MySQL transactions or debug locking and connection errors, read [mysql-transactions.md](references/mysql-transactions.md). It covers isolation levels, InnoDB row locks, deadlocks, and connection limits.
</references>

<data_safety>
A destructive or production command runs only after the user confirms it in the conversation. A destructive command drops, truncates, resets, flushes, or wipes data, or changes existing rows, documents, or keys, as `UPDATE`, `DELETE`, and `MERGE` do in SQL. A production command is any command whose target is not a local or disposable database. Before each such command, read the target host and database name from `DATABASE_URL`, the ORM config, or the connection string.

These steps apply to every destructive change.
1. Work on a copy first when one exists, such as a local database, a branch database, or a restored dump.
2. Back up the data the command touches. Check that the backup exists and holds the expected number of rows or documents.
3. Count what the command will touch with the same filter, as `SELECT count(*)` with the same `WHERE` clause does, and note the count.
4. Tell the user what the command destroys, which database it targets, the count, and where the backup is. Then wait for confirmation.
5. Run the change in a transaction where the engine allows it. Compare the affected count with step 3 before `COMMIT`. Where the engine has no transaction that rolls back, run the change on a small batch first and check the result before the rest.

Store backups in a private directory outside the repository and shared folders. Restrict access to the owner and use encrypted storage for sensitive production data. Keep backups out of logs, chat, and commits. Use the engine's own dump or snapshot tool. Set `BACKUP_FILE` to the approved destination before these PostgreSQL and MySQL commands. Use the database's existing secure credential mechanism rather than putting passwords in command arguments.

```
umask 077
pg_dump --format=custom --table=public.orders --file="$BACKUP_FILE"
mysqldump --single-transaction mydb orders > "$BACKUP_FILE"
```

A copy inside the same database is enough for a small data fix. It does not survive a lost server, so prefer a dump for large changes.

```sql
CREATE TABLE orders_backup_20261107 AS SELECT * FROM orders WHERE status = 'stale';
```

Investigate a production database inside a read-only transaction. PostgreSQL uses `BEGIN READ ONLY`, and MySQL uses `START TRANSACTION READ ONLY`. On an engine without one, connect as a read-only user or to a replica. `EXPLAIN ANALYZE` executes the statement, so analyze a write only when the user asked for it, inside a transaction that ends with `ROLLBACK`.
</data_safety>

<never_run>
These commands wipe data or schema, so you never run them on your own initiative. The list gives examples, and the rule covers every command of this kind on any engine.
- `prisma migrate reset` and `prisma db push --force-reset|--accept-data-loss`
- `drizzle-kit push --force`
- `rails db:drop|reset|purge|schema:load`
- `manage.py flush` and `manage.py migrate <app> zero`
- `artisan migrate:fresh|reset|refresh|db:wipe`
- `alembic downgrade base`, `flyway clean`, and `dropdb`
- Raw `DROP`, `TRUNCATE`, or a `DELETE` without `WHERE` in a database client
- `dropDatabase()`, `drop()`, or `deleteMany({})` in MongoDB, `FLUSHALL` or `FLUSHDB` in Redis, and the delete of a whole index, bucket, or table in any other store

If one of these looks necessary, tell the user what it would destroy and which database it points at. Let the user run it. Run it yourself only when the user confirms that exact command and the target is local. `prisma migrate dev` asks to reset the database when it detects drift. Answer no and report the drift to the user.
</never_run>

<how_migrations_fail>
A migration takes production down in four ways.
1. A lock queue forms. DDL needs a lock, and even a brief lock waits behind any long-running query. Every query that arrives later waits behind the DDL, so the site stops even though the migration is "instant".
2. The database rewrites or scans the whole table while it holds that lock.
3. Old code meets the new schema during the deploy. Renames and drops break the version that is still running. A store without an enforced schema has the same problem in its data, because old and new shapes sit side by side until a backfill finishes.
4. Data is lost through drops, type narrowing, ORM renames that are really drop and add, and resets.

Other engines fail the same four ways under other names. A command that walks a whole keyspace or collection, such as `KEYS` in Redis, stalls a production store the way a lock queue does.
</how_migrations_fail>

<workflow>
Follow these steps for every migration.
1. Find the engine and its version in docker-compose, the `schema.prisma` `provider`, `database.yml`, settings, `SELECT version()`, or the engine's own version command. The rules below depend on the version.
2. Read the SQL or commands that will actually run, because ORMs and migration tools hide them. Generate the SQL with `prisma migrate dev --create-only`, `python manage.py sqlmigrate app 0042`, `alembic upgrade head --sql`, or `drizzle-kit generate`. Rails shows it in `structure.sql` after a local `rails db:migrate`.
3. Check every statement against the section for its engine and rewrite the dangerous ones. For an engine without a section, get the facts that `any_engine` lists first.
4. Put one risky operation in each migration. In PostgreSQL, a transaction holds its strongest lock until it commits. In MySQL, DDL is not transactional, so a failure partway leaves the schema half-applied.
5. Set a lock timeout at the top of each migration. The migration then fails fast instead of queueing the app behind it. PostgreSQL uses `SET lock_timeout = '5s'`, or `SET LOCAL` inside a transaction. MySQL uses `SET SESSION lock_wait_timeout = 5`. Its default is one year. Another engine gets its own lock or statement timeout.
6. Split the work across deploys when code and schema must change in order, as `expand_contract` describes. Say which deploy each step belongs to.
7. Run the migration on a local or copied database before any shared one.
8. Finish with the report that `report` describes.
</workflow>

<postgresql>
These rules hold for PostgreSQL 14 and later. This table maps each dangerous operation to its safe rewrite.

| Operation | Why it hurts | Safe rewrite |
|---|---|---|
| `CREATE INDEX` | Blocks all writes for the whole build | Use `CREATE INDEX CONCURRENTLY`. It cannot run inside a transaction. A failed build leaves an `INVALID` index, so drop it with `DROP INDEX CONCURRENTLY` and retry. |
| `DROP INDEX` | Takes an `ACCESS EXCLUSIVE` lock | Use `DROP INDEX CONCURRENTLY`. |
| `REINDEX`, `VACUUM FULL`, `CLUSTER` | Block the table while they rebuild it | Use `REINDEX ... CONCURRENTLY`. Use `pg_repack` for bloat. |
| `ADD COLUMN` with a volatile default such as `gen_random_uuid()` or `clock_timestamp()` | Rewrites the whole table and its indexes. A stored generated column or an identity column does the same. | Add the column nullable with no default. Then `SET DEFAULT` for new rows and backfill in batches. Constant defaults, `now()`, and virtual generated columns need no rewrite. |
| `ALTER COLUMN ... SET NOT NULL` | Scans the full table under `ACCESS EXCLUSIVE` | Add `CHECK (col IS NOT NULL) NOT VALID`. In the next migration, run `VALIDATE CONSTRAINT`, then `SET NOT NULL`, which skips the scan, then drop the check. On PostgreSQL 18, `ADD CONSTRAINT x NOT NULL col NOT VALID` and a later `VALIDATE CONSTRAINT x` do the same. |
| `ALTER COLUMN ... TYPE`, such as `int` to `bigint` | Rewrites the table under `ACCESS EXCLUSIVE`. Growing a `varchar(n)` or changing it to `text` is exempt. | Use expand and contract with a new column, dual writes, a backfill, switched reads, and a later drop. |
| `ADD FOREIGN KEY` | Blocks writes on both tables while it scans | Add it with `NOT VALID`. Run `VALIDATE CONSTRAINT` in a separate migration. |
| `ADD CHECK` | Scans while it holds the lock | Add it with `NOT VALID` and run `VALIDATE CONSTRAINT` later. |
| `ADD UNIQUE`, `ADD PRIMARY KEY` | Builds the index under lock | Run `CREATE UNIQUE INDEX CONCURRENTLY idx`. Then run `ADD CONSTRAINT c UNIQUE USING INDEX idx` or `PRIMARY KEY USING INDEX idx`. |
| `RENAME COLUMN`, `RENAME TABLE` | Instant, but the running code breaks | Use expand and contract. For a table, rename it and create a view with the old name until the old code is gone. |
| `DROP COLUMN`, `DROP TABLE` | Instant, but old code still reads it, and the data is gone | In deploy 1, the code stops reading and writing it. In deploy 2, back it up and drop it. |
| `ALTER TYPE ... ADD VALUE` | The new value is unusable in the transaction that added it | Put it in its own migration, before the code that uses it. |
| Large `UPDATE` or `DELETE` in a migration | One huge transaction causes row locks, a WAL spike, and replica lag | Run a separate batched backfill outside the schema migration. |

Some changes are already safe and need no rewrite. They include new tables, nullable columns without a default, constant defaults, `SET DEFAULT`, `DROP DEFAULT`, `DROP NOT NULL`, growing a `varchar`, and `COMMENT ON`.
</postgresql>

<mysql>
These rules assume InnoDB on MySQL 8.4 LTS or 9.x, because MySQL 8.0 reached end of life in April 2026.
- State the algorithm, as in `ALTER TABLE t ADD COLUMN c INT, ALGORITHM=INSTANT` or `ALGORITHM=INPLACE, LOCK=NONE`. MySQL then fails with an error instead of silently copying the table.
- INSTANT covers adding, dropping, and renaming a column, setting or dropping a default, and adding `ENUM` values at the end. A table allows 64 instant row versions, or 255 from MySQL 9.1, before it needs a rebuild.
- A column type change copies the table and blocks writes. A charset conversion rebuilds the table and also blocks writes.
- Growing a `VARCHAR` across the 256-byte length boundary needs a table copy. A `utf8mb4` column crosses it between 63 and 64 characters.
- On big tables, run blocking changes through `gh-ost` or `pt-online-schema-change`.
- Metadata locks queue the same way PostgreSQL locks do. One open transaction can stall the DDL and everything behind it, so set `lock_wait_timeout`.
- Each DDL statement commits implicitly, so put one DDL statement in each migration.
</mysql>

<any_engine>
The `postgresql` and `mysql` sections are written for those engines and versions only. A fork or a compatible engine, such as MariaDB or a managed cloud variant, differs in commands and limits, so treat it as its own engine. The reference file for the engine it derives from helps as background, with each command and limit checked against the fork's own documentation.

For an engine without a section here, read its official documentation for the installed version before you run a change, as the `research` skill describes, and find these facts.
- What each schema or index change locks or blocks, whether it rewrites or scans the data, and whether an online form exists.
- Whether schema and data changes run in a transaction that can roll back.
- Which timeout stops a statement that waits or runs too long.
- How to back up and restore the object you change, and how to count what a filter matches.

A store without an enforced schema, such as a document, key-value, wide-column, or search store, keeps the schema in the application code. Change it in the order `expand_contract` gives. The code reads both the old and the new shape first, a batched backfill rewrites the old data, and the old shape goes last. Build or change an index in the engine's online or background mode, and watch its progress and the load before you start the next one. Walk a whole keyspace or collection in batches with the engine's cursor, as `SCAN` does in Redis. Expire data with the engine's own expiry where it has one, in place of a mass delete.
</any_engine>

<expand_contract>
Renames, type changes, and column splits go through six steps.
1. Expand by adding the new column or table as nullable, in a migration.
2. Deploy code that writes both the old and the new column.
3. Backfill existing rows in batches, with a script or job.
4. Deploy code that reads the new column.
5. Deploy code that stops writing the old column.
6. Contract by dropping the old column in a migration of a later release.

Do the steps that belong in the current change. List the rest as follow-ups the user must schedule. Never collapse all six steps into one migration.
</expand_contract>

<batched_backfill>
The `shared_systems` block of the coding instructions applies to every write that changes many rows on a live database, also a one-time import, a relinking of records, a reindex, or a flag set on a whole table. Count the rows the write changes through triggers, cascades, and denormalized columns, and the indexes on each table it touches, because every changed row is rewritten in each of them. Start with a small batch, take the health signal between batches, such as the response time of a real page or the replication lag, and raise the batch or shorten the pause when the measurements leave room, because a fixed long pause only slows the work. Check for a scheduled job that works on the same rows.

Keep a backfill out of the schema migration. Walk the primary key in fixed ranges and commit each batch. This statement updates one batch of 5000 rows. Repeat it with `:start` raised by 5000 until it passes `max(id)`, and pause briefly between batches.

```sql
UPDATE users SET email_lower = lower(email)
WHERE id >= :start AND id < :start + 5000 AND email_lower IS NULL;
```

Make the backfill idempotent, so a killed run can restart safely. Watch replica lag on big tables. After a large backfill or import on PostgreSQL, run `ANALYZE` on the table so the planner sees the new data.
</batched_backfill>

<orm_migrations>
`CONCURRENTLY` must run outside a transaction. This table shows how each tool does that and where each tool loses data.

| Tool | Run outside a transaction | Trap |
|---|---|---|
| Prisma | Put `CREATE INDEX CONCURRENTLY` alone in its own `migration.sql`, edited after `--create-only` | A renamed field becomes DROP and ADD, which loses data. Rewrite it as `RENAME COLUMN` or expand and contract. |
| Drizzle | The PostgreSQL migrator wraps pending migrations in a transaction. Run concurrent index creation through a separately authorized connection outside that migrator, and reconcile migration history before later migrations. | A separate SQL file does not escape the transaction. `drizzle-kit push` applies schema diffs directly. Never point it at production. |
| Rails | Use `disable_ddl_transaction!` with `add_index ..., algorithm: :concurrently`. Add foreign keys with `validate: false` and then `validate_foreign_key`. | Set `ignored_columns` before a drop. The `strong_migrations` gem enforces most of these rules. |
| Django | Set `atomic = False` and use `AddIndexConcurrently` from `django.contrib.postgres.operations` | `RenameField` is a real rename, so old code breaks. Use `SeparateDatabaseAndState` for two-step drops. |
| Alembic | Wrap `op.create_index(..., postgresql_concurrently=True)` in `with op.get_context().autocommit_block()` | Autogenerate turns renames into drop and add. |
| Laravel | Set `public $withinTransaction = false` and run `DB::statement('CREATE INDEX CONCURRENTLY ...')` | |
| Knex | Export `exports.config = { transaction: false }` | |
| Ecto | Set `@disable_ddl_transaction true` and `@disable_migration_lock true`, then use `create index(..., concurrently: true)` | |

If [squawk](https://github.com/sbdchd/squawk) is installed, also run `squawk <file>.sql` on PostgreSQL migrations.
</orm_migrations>

<parameterized_queries>
Bind every value as a parameter, as the `code_rules` block of the coding instructions requires. Each ORM escape hatch for raw SQL has a binding form and a string-building form.
- Prisma binds values in `$queryRaw` and `$executeRaw` tagged templates. `$queryRawUnsafe` with interpolated strings does not.
- Drizzle binds values in the `sql` template. `sql.raw()` inserts text unchanged.
- Knex binds with `knex.raw('email = ?', [email])`. A template string passed to `raw` does not.
- SQLAlchemy binds with `text("id = :id")` and a parameter dict. An f-string inside `text()` does not.
- Django binds with `raw(sql, params)` and `cursor.execute(sql, params)`. Python string formatting in the SQL does not.
- Rails binds with `where("email = ?", email)`. String interpolation inside `where` does not.
- Laravel binds with `whereRaw('email = ?', [$email])` and `DB::select($sql, $bindings)`. `DB::raw` with concatenated input does not.
- Doctrine binds with `setParameter()` in DQL and the params array of `executeQuery()` in DBAL.

Table names, column names, and sort directions cannot be bound, so check them against an allowlist in code. Escape `%` and `_` in user input that goes into a `LIKE` pattern. Pass a list through the driver's array binding, such as `= ANY($1)` in PostgreSQL. Never join the values into an `IN` string.

A store whose queries are objects has its own form of injection. An object such as `{"$ne": ""}` in place of a string turns an equality check into a different query. Check that each input has the expected scalar type before you build the filter, and never pass a client-supplied object through as a field value or as a whole query.
</parameterized_queries>

<n_plus_one>
A query inside a loop over rows is an N+1 pattern. Load the related rows in one query with a join or an `IN` list instead. A store without joins batches the lookups with its multi-get or its `in` operator.
- Eloquent loads relations up front with `with('posts')`. `Model::preventLazyLoading(! $this->app->isProduction())` in `AppServiceProvider::boot` throws on every lazy load outside production. `chaperone()` on a `hasMany` stops the N+1 when children read their parent.
- Doctrine loads an association in the same query with a fetch join, as in `->leftJoin('u.posts', 'p')->addSelect('p')`. A fetch join of a collection with `setMaxResults` needs a paginator from `Doctrine\ORM\Tools\Pagination`, because the limit applies to joined rows. That is `OffsetPaginator` from ORM 3.7 and `Paginator` before it.
- SQLAlchemy loads collections best with `selectinload()` and many-to-one relations with `joinedload()`. `raiseload("*")` or `lazy="raise"` turns an unplanned lazy load into an error. Under asyncio a lazy load fails anyway, so eager load every relationship the code reads.
</n_plus_one>

<report>
End every migration task with a migration safety report in the reply, inside the length the `writing_style` rules set. Give one sentence per risky statement that names the statement, its risk, and your change, and group statements that share a risk. An example is "`CREATE INDEX` on `orders` blocked writes, so it now runs `CONCURRENTLY` alone." Then say whether a lock timeout is set. Name the expand and contract steps left for later deploys, or say that none remain. If you could not make a statement safe, say so in the first sentence of the report.
</report>
