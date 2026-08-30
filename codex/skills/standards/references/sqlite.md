# SQLite design and query practice

This reference covers current SQLite behavior that affects schema, queries, migrations, backups, and deployment.
The links target the SQLite documentation and source material maintained by the SQLite project.
Use the exact SQLite library version, compile-time options, VFS, filesystem, and journal mode that production will run.

## Architecture and deployment model

- SQLite is an in-process library with no database server process; the application opens the database file directly. [S10] [S14]
- A database is normally one local file, which makes packaging, transport, and per-device storage simple. [S10] [S14]
- Copying the library and creating a file is often the whole installation procedure. [S10]
- SQLite is a strong fit for local application state, embedded devices, caches, single-host services, and low-writer workloads. [S10]
- A client/server database is usually a better fit when many computers send SQL directly to one shared database over a network. [S10]
- Avoid network filesystems for shared SQLite databases because broken or slow file locking can cause poor performance or corruption. [S10]
- Use separate database files for independent domains or tenants when application-level sharding can reduce writer contention. [S10]
- The official SQLite GitHub repository is a mirror; the project's Fossil repository is the source of truth for check-ins. [S13]

## Types and schema design

- SQLite associates a value's storage class with the value rather than rigidly with its column. [S1]
- The five storage classes are `NULL`, `INTEGER`, `REAL`, `TEXT`, and `BLOB`. [S1]
- A normal column can store any storage class, subject to affinity conversion and declared constraints. [S1]
- Declared names such as `VARCHAR(255)` express affinity but do not impose a length limit. [S1]
- SQLite has no separate Boolean storage class; Boolean values use integers `0` and `1`. [S1]
- SQLite has no date/time storage class; choose and document ISO-8601 `TEXT`, Julian-day `REAL`, or Unix-time `INTEGER`. [S1]
- Use `STRICT` tables when lossless type enforcement is required. `STRICT` permits `INT`, `INTEGER`, `REAL`, `TEXT`, `BLOB`, and `ANY`. [S2]
- `STRICT` rejects values that cannot be losslessly converted, while `ANY` preserves the inserted type and value. [S2]
- Define `NOT NULL`, `CHECK`, `UNIQUE`, primary-key, and foreign-key constraints explicitly rather than relying on affinity to validate data.
- Choose `INTEGER PRIMARY KEY` when the rowid alias and integer key behavior are intentional; use `WITHOUT ROWID` when its different storage tradeoffs fit the schema. [S1] [S2]
- Define a cross-engine representation for booleans, timestamps, decimals, identifiers, and JSON before sharing data with MySQL.

## Concurrency and isolation

- SQLite supports multiple simultaneous readers but only one simultaneous writer per database file. [S3] [S4]
- SQLite obtains serializable isolation by serializing writes rather than by allowing multiple writers to commit concurrently. [S3]
- Rollback mode prevents readers from observing a write while pages are being written to the database file. [S3]
- WAL mode lets readers and a writer proceed concurrently, but WAL still has only one writer. [S5]
- A WAL reader sees a stable snapshot until its read transaction ends. [S3] [S5]
- A reader that upgrades to a writer can receive `SQLITE_BUSY` if another connection has already written. [S4]
- Use `BEGIN IMMEDIATE` when a unit of work must reserve the write slot before reading and changing data. [S4]
- Configure a bounded busy handler or timeout, and handle the remaining `SQLITE_BUSY` result explicitly. [S12]
- Keep write transactions short, finalize statements promptly, and never perform slow external work inside a write transaction.
- WAL requires participating processes to share one host and does not work over a network filesystem. [S5]
- The SQLite documentation currently records a rare WAL-reset corruption bug fixed in 3.51.3 and backported to 3.44.6 and 3.50.7. Pin a fixed build when deploying WAL. [S5]

## Transactions and durability

- `BEGIN` starts an explicit transaction that ends at `COMMIT` or `ROLLBACK`; `SAVEPOINT` provides nesting. [S4]
- `BEGIN DEFERRED` is the default and delays acquiring a lock until the first access. [S4]
- `BEGIN IMMEDIATE` starts a write transaction immediately, while `BEGIN EXCLUSIVE` also blocks readers outside WAL mode. [S4]
- An implicit transaction commits when its last active statement finishes, so reset or finalize prepared statements deterministically. [S4]
- `COMMIT` can return `SQLITE_BUSY` while another connection has a pending read, leaving the transaction active for a later retry. [S4]
- Foreign-key enforcement settings cannot be changed in the middle of a transaction. [S6]
- Choose `PRAGMA synchronous` and journal mode as an explicit durability policy rather than as an unexplained performance tweak. [S5] [S14]
- Test power-loss, crash-recovery, disk-full, and interrupted-transaction behavior on the actual storage hardware when durability matters.

## Indexes and query planning

- SQLite's cost-based planner depends on programmer-created indexes and can use indexes for both searching and sorting. [S7]
- A covering index can avoid table lookups when it contains every value required by the query. [S7]
- Design composite indexes from actual equality, range, join, and ordering predicates, and remove redundant indexes after measuring write cost.
- Create child-key indexes for foreign-key checks and parent deletes even though SQLite does not require those child indexes. [S6]
- Use `EXPLAIN QUERY PLAN` during interactive tuning to see `SCAN`, `SEARCH`, index names, covering use, and temporary sort b-trees. [S8]
- Treat `EXPLAIN QUERY PLAN` output as diagnostic text, not as a stable application interface because its format can change between releases. [S8]
- Run `ANALYZE` or the appropriate statistics maintenance for the deployed workload before judging a plan. [S7]
- Prefer parameter binding and prepared statements, and make the bound value's intended type explicit at the application boundary. [S1] [S14]
- Recheck plans after data growth, statistics changes, SQLite upgrades, or index changes.

## Foreign keys and constraints

- SQLite parses foreign keys but disables enforcement by default for backwards compatibility. [S6]
- Execute `PRAGMA foreign_keys = ON` on every database connection and verify the setting. [S6]
- Enable or disable foreign keys only outside a transaction because changing the pragma inside a transaction has no effect. [S6]
- A parent key must be a primary key or an exact matching `UNIQUE` key with the required collation. [S6]
- SQLite does not require child-key indexes, but without them parent deletes and updates can scan the entire child table. [S6]
- Immediate checks are the default, and `DEFERRABLE INITIALLY DEFERRED` or `PRAGMA defer_foreign_keys` can defer checks until commit. [S6]
- `ON DELETE` and `ON UPDATE` support `NO ACTION`, `RESTRICT`, `SET NULL`, `SET DEFAULT`, and `CASCADE`; choose actions as domain rules. [S6]
- Run `PRAGMA foreign_key_check` after rebuild-style migrations and before shipping a converted database. [S6] [S9]

## Migrations and schema evolution

- SQLite directly supports table and column rename, add column, drop column, and current releases also support `SET NOT NULL` and `DROP NOT NULL`. [S9]
- Adding a column without content-changing constraints edits schema text and is independent of table size. [S9]
- Changing a type, primary key, unique constraint, or complex constraint normally requires the documented 12-step rebuild. [S9]
- The safe rebuild creates `new_X`, copies selected columns, drops `X`, renames `new_X`, recreates indexes, triggers, and views, checks foreign keys, and commits. [S9]
- Keep the rebuild in one transaction and test column mapping against real data before running it on user files. [S9]
- Avoid `PRAGMA writable_schema` for routine migrations because a typo can make the database corrupt or unreadable. [S9]
- Store an application schema version and make each migration explicit, deterministic, and restart-safe.
- Do not assume a migration written for MySQL `ALTER TABLE` has equivalent SQLite locking, type, or rebuild behavior.
- The CI-backed `sqldef` example exposes `sqlite3def` dry-run and apply commands; review generated DDL and test it on a copy before applying. [G1]

## Backups and file movement

- Rollback journal mode does not make a live byte-for-byte file copy safe; an active transaction can leave a copy with mixed old and new content. [S15]
- For a live database, choose one safe method: quiesce all transactions before copying, use the Online Backup API, or use `VACUUM INTO`. [S15] [S11]
- The Online Backup API can copy incrementally and produces a consistent snapshot while other users continue with short lock periods. [S11]
- `VACUUM INTO` writes the current database state to a separate file and is suitable for a live database. [S15] [S11]
- If an active `-journal`, `-wal`, or `-shm` sidecar exists, preserve the required sidecars with the database when moving it. [S15] [S5]
- Never detach, rename, delete, or mix a hot journal or WAL file with another database. [S15]
- A quiescent copy is safe only when no transactions are in progress during the copy. [S15]
- Verify copied files with `PRAGMA integrity_check`, `PRAGMA quick_check`, row counts, and `PRAGMA foreign_key_check` before release. [S2] [S6]

## Operational checklist

- Record SQLite version, compile-time options, VFS, filesystem, journal mode, synchronous setting, collation, and foreign-key setting in deployment metadata.
- Keep one SQLite build in the process when possible, and open connections in the process that owns them rather than carrying them across `fork()`. [S15]
- Use a connection pool only when its transaction, statement-finalization, and busy-timeout behavior is explicit.
- Measure representative queries with `EXPLAIN QUERY PLAN`; do not infer index use from schema text alone. [S8]
- Test multiple connections under reader, writer, lock-wait, busy, checkpoint, and crash-recovery workloads.
- Use the Online Backup API or `VACUUM INTO` for live backups, and keep sidecars paired during file movement. [S15] [S11]
- Treat a SQLite file as application data with a lifecycle, migration policy, backup policy, and version compatibility policy.

## Sources

### Official SQLite documentation

- [S1: SQLite datatypes and affinity](https://www.sqlite.org/datatype3.html)
- [S2: SQLite STRICT tables](https://www.sqlite.org/stricttables.html)
- [S3: SQLite isolation](https://www.sqlite.org/isolation.html)
- [S4: SQLite transactions](https://www.sqlite.org/lang_transaction.html)
- [S5: SQLite write-ahead logging](https://www.sqlite.org/wal.html)
- [S6: SQLite foreign-key support](https://www.sqlite.org/foreignkeys.html)
- [S7: SQLite query planning](https://www.sqlite.org/queryplanner.html)
- [S8: SQLite EXPLAIN QUERY PLAN](https://sqlite.org/eqp.html)
- [S9: SQLite ALTER TABLE and the 12-step rebuild](https://sqlite.org/lang_altertable.html)
- [S10: Appropriate uses for SQLite](https://www.sqlite.org/whentouse.html)
- [S11: SQLite Online Backup API](https://www.sqlite.org/backup.html)
- [S12: SQLite busy timeout API](https://www.sqlite.org/c3ref/busy_timeout.html)

### Maintainer and source material

- [S13: Official SQLite source-tree GitHub mirror](https://github.com/sqlite/sqlite)
- [S15: SQLite “How To Corrupt An SQLite Database File”](https://www.sqlite.org/howtocorrupt.html)

### Talk or video source

- [S14: SQLite “How It Works” slides, 2024-06-24](https://sqlite.org/talks/howitworks-20240624.pdf)

### Verified GitHub example

- [G1: sqldef idempotent schema management with CI-tested MySQL and SQLite commands](https://github.com/sqldef/sqldef)
