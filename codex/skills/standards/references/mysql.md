# MySQL design and query practice

This reference covers current MySQL Server behavior that affects schema, queries, migrations, and operations.
The main links target the MySQL 9.7 Reference Manual published by Oracle.
Use the exact server, storage engine, SQL mode, connector, and release track that production will run.

## Architecture and design

- MySQL runs as a separate, multithreaded `mysqld` server that manages a data directory and accepts client connections. [M2]
- Clients can use TCP/IP, Unix sockets, named pipes, or shared memory according to platform and configuration. [M21]
- Treat the server, its data directory, its configuration, and its clients as separately operated components. [M2] [M1]
- InnoDB is the default MySQL storage engine in 9.7 and is the normal choice for transactional application tables. [M3]
- InnoDB uses a clustered primary-key index and provides ACID DML, crash recovery, MVCC, row locks, and foreign keys. [M3]
- A nontransactional engine does not gain InnoDB rollback or atomicity because a transaction is open. [M6]
- Mixing transactional and nontransactional tables can leave only the transactional portion rolled back after an error. [M6]
- Choose stable, narrow primary keys because the clustered key organizes InnoDB table data and is carried by secondary indexes. [M3]
- Normalize entities and relationships first, then denormalize only for a measured workload or a clear read model.
- Put ownership, nullability, uniqueness, and lifecycle rules in schema constraints instead of duplicating them only in application code.

## Types and schema constraints

- MySQL exposes numeric, date/time, string, binary, spatial, and native JSON types. [M7]
- Declare the narrowest type that covers the domain, with explicit precision, scale, nullability, character set, and collation.
- `DECIMAL` is exact fixed-point arithmetic, while `FLOAT` and `DOUBLE` are approximate. Use the former when decimal equality matters. [M20]
- `BOOL` and `BOOLEAN` are synonyms for `TINYINT(1)`, and `TRUE` and `FALSE` are aliases for `1` and `0`. [M20]
- MySQL's native `JSON` type validates documents and stores them in an optimized internal representation. [M8]
- Use JSON for genuinely document-shaped or sparse attributes, not as a substitute for columns used in joins, constraints, or frequent predicates.
- Choose character set and collation deliberately because they affect storage, equality, ordering, indexes, and foreign-key compatibility. [M7] [M13]
- SQL modes control accepted syntax and data validation, and modes can differ globally and per session. [M9]
- Set and verify the intended strict SQL mode for every connection instead of relying on an implicit server default. [M9]
- Test invalid, truncated, out-of-range, and time-zone-sensitive values under the same SQL mode used in production. [M9] [M7]
- Prefer explicit `CHECK`, `NOT NULL`, `UNIQUE`, and foreign-key constraints for invariants that MySQL can enforce.

## Concurrency and transactions

- InnoDB combines MVCC with two-phase locking and normally locks rows rather than whole tables. [M4]
- Ordinary `SELECT` statements use nonlocking consistent reads by default. [M4]
- A consistent read sees a snapshot of committed changes and excludes later or uncommitted changes. [M5]
- `REPEATABLE READ` is the default InnoDB isolation level, so one transaction reuses the snapshot from its first consistent read. [M5]
- `READ COMMITTED` creates a fresh consistent snapshot for each read in the transaction. [M5]
- Use locking reads such as `FOR UPDATE` or `FOR SHARE` only when the unit of work needs lock coordination. [M4]
- Start, commit, and roll back work with `START TRANSACTION`, `COMMIT`, and `ROLLBACK`, or use equivalent client API methods. [M6]
- `autocommit` is a session setting, so configure it explicitly for pooled connections and reset it before reuse. [M6]
- Group related writes into one transaction instead of committing every row. [M6]
- Keep transactions short and avoid network calls, user interaction, or unbounded loops while locks are held.
- Acquire locks in a consistent order across code paths to reduce deadlock probability.
- InnoDB can detect a deadlock, roll back one transaction, and return error `1213`; retry the entire transaction, not only its last statement. [M18]
- The official MySQL InnoDB locking walkthrough includes a video that visualizes lock waits and deadlock cycles. [M19]
- Use `START TRANSACTION READ ONLY` when the application can declare a read-only unit of work. [M6]
- Break huge data changes into bounded batches because rolling back a huge transaction can take several times as long as the original change. [M6]
- Do not assume a DDL statement and DML changes share one rollback boundary across every engine or statement. [M6]

## Indexes and query planning

- Index columns used by selective `WHERE`, join, and ordering predicates, while accounting for index maintenance on writes. [M10]
- Do not add an index for every column; measure selectivity, write cost, storage cost, and plan quality. [M10]
- A composite index on `(a,b,c)` normally supports the leftmost prefixes `(a)`, `(a,b)`, and `(a,b,c)`, not `(b)` alone. [M11]
- Put composite columns in an order that matches real equality, range, join, and ordering predicates. [M11]
- MySQL 9.7 can use Skip Scan for certain single-table queries that omit a leading key part, but the access method is conditional and optimizer-selected. [M22]
- Treat Skip Scan as a possible plan, not as a guarantee that removes the need for a suitable index or query shape. [M22]
- Confirm Skip Scan with `EXPLAIN`, which reports `Using index for skip scan` when it is used. [M22]
- Skip Scan depends on predicates, index shape, statistics, optimizer switches, and data distribution, so benchmark representative data. [M22]
- Use `EXPLAIN` or `EXPLAIN ANALYZE` to inspect join order, access paths, estimates, and actual work before changing a query. [M12]
- Use `ANALYZE TABLE` when stale index statistics are causing poor estimates, then recheck the plan. [M22]
- Recheck plans after data growth, statistics changes, version upgrades, or index changes.
- Prefer sargable predicates and compare columns with compatible types so the optimizer can use indexes predictably.

## Foreign keys and constraints

- InnoDB enforces foreign-key existence checks and supports `RESTRICT`, `CASCADE`, `SET NULL`, and `NO ACTION` actions. [M13]
- MySQL does not defer InnoDB foreign-key checks, and `NO ACTION` is treated as `RESTRICT`. [M13]
- Parent and child tables must use the same storage engine, and corresponding columns need compatible types. [M13]
- MySQL requires indexes for foreign-key columns and may create a child-side index automatically. [M13]
- Align integer sign and size, string character set, and string collation between referenced and referencing columns. [M13]
- Keep referenced keys primary or unique and name constraints explicitly so migrations can alter them deterministically. [M13] [M14]
- Choose cascade behavior as a domain rule, and test multi-row cascades and deletion failure paths before production use. [M13]

## Migrations and upgrades

- Treat each schema migration as a versioned, reviewed change tested on a copy containing production-shaped data.
- `ALTER TABLE` may use `COPY`, `INPLACE`, or `INSTANT`; `COPY` blocks concurrent DML, while the other algorithms have different lock and rebuild behavior. [M14]
- Specify `ALGORITHM=INSTANT` or `ALGORITHM=INPLACE` when the migration must fail rather than silently fall back to a more disruptive operation. [M14]
- Check metadata locks, available disk space, replica lag, foreign-key dependencies, and forward-fix procedures before a large alteration.
- Add nullable columns or compatible defaults before deploying application code that writes them, then backfill in bounded batches.
- Separate destructive cleanup from an expand-and-contract rollout when old application versions may still run.
- MySQL documents in-place, logical dump/load, and replication-topology paths for server upgrades. [M15]
- Run the upgrade checker, test and benchmark the application, rehearse the final procedure, and verify a restorable backup first. [M15]
- Do not skip a required major-version path merely because the binaries appear compatible. [M15]
- Pin an LTS or innovation release track deliberately and document the exact server and connector versions. [M16]
- The CI-backed `sqldef` example exposes `mysqldef` dry-run and apply commands; review generated DDL and test it on the target data before applying. [G1]

## Deployment and operations

- Package, service, and container deployments all run `mysqld`; persist the data directory and pin a versioned image or package. [M17]
- The Oracle Docker instructions use version tags and require persisted data and configuration for container upgrades. [M17]
- The Docker Official Image repository is maintained by the Docker Community and MySQL Team and exposes the packaging source. [M23]
- Keep credentials out of command lines and source control, and use the server's account and privilege system for least privilege.
- Monitor connection pressure, lock waits, deadlocks, slow queries, disk space, redo and undo pressure, and replication health.
- Verify backups by restoring them, not merely by checking that a dump or snapshot file exists.
- Test failover, restart recovery, migration rollback or forward-fix, and client reconnection behavior before relying on them.

## Cross-engine boundary

- If the same application targets SQLite, keep engine-specific DDL for types, indexes, foreign-key timing, and migration operations.
- Do not assume SQLite's dynamic typing, single-writer model, or file backup rules match InnoDB behavior.
- Verify row counts, nullability, key uniqueness, foreign-key checks, numeric precision, timestamps, collations, and query plans after conversion.

## Sources

### Official MySQL and Oracle documentation

- [M1: MySQL 9.7 Reference Manual](https://dev.mysql.com/doc/refman/9.7/en/)
- [M2: `mysqld` server architecture](https://dev.mysql.com/doc/refman/9.7/en/mysqld.html)
- [M3: Introduction to InnoDB](https://dev.mysql.com/doc/refman/9.7/en/innodb-introduction.html)
- [M4: InnoDB transaction model](https://dev.mysql.com/doc/refman/9.7/en/innodb-transaction-model.html)
- [M5: InnoDB consistent reads](https://dev.mysql.com/doc/refman/9.7/en/innodb-consistent-read.html)
- [M6: START TRANSACTION, COMMIT, and ROLLBACK](https://dev.mysql.com/doc/refman/9.7/en/commit.html)
- [M7: MySQL data types](https://dev.mysql.com/doc/refman/9.7/en/data-types.html)
- [M8: MySQL JSON data type](https://dev.mysql.com/doc/refman/9.7/en/json.html)
- [M9: MySQL server SQL modes](https://dev.mysql.com/doc/refman/9.7/en/faqs-sql-modes.html)
- [M10: MySQL optimization and indexes](https://dev.mysql.com/doc/refman/9.7/en/optimization-indexes.html)
- [M11: MySQL multiple-column indexes](https://dev.mysql.com/doc/refman/9.7/en/multiple-column-indexes.html)
- [M12: MySQL EXPLAIN statement](https://dev.mysql.com/doc/refman/9.7/en/explain.html)
- [M13: MySQL foreign-key constraints](https://dev.mysql.com/doc/refman/9.7/en/create-table-foreign-keys.html)
- [M14: MySQL ALTER TABLE algorithms](https://dev.mysql.com/doc/refman/9.7/en/alter-table.html)
- [M15: MySQL upgrade best practices](https://dev.mysql.com/doc/refman/9.7/en/upgrade-best-practices.html)
- [M16: MySQL LTS and innovation release model](https://dev.mysql.com/doc/refman/9.7/en/mysql-releases.html)
- [M17: MySQL Docker deployment](https://dev.mysql.com/doc/refman/9.7/en/linux-installation-docker.html)
- [M18: InnoDB deadlock example](https://dev.mysql.com/doc/refman/9.7/en/innodb-deadlock-example.html)
- [M20: MySQL numeric type syntax](https://dev.mysql.com/doc/refman/9.7/en/numeric-type-syntax.html)
- [M21: MySQL main features and connection protocols](https://dev.mysql.com/doc/refman/9.7/en/features.html)
- [M22: MySQL range optimization and Skip Scan](https://dev.mysql.com/doc/refman/9.7/en/range-optimization.html)

### Maintainer and packaging source

- [M23: Docker Official Image packaging maintained by the Docker Community and MySQL Team](https://github.com/docker-library/mysql)

### Talk or video source

- [M19: MySQL InnoDB Data Locking Part 3, with explanatory video](https://dev.mysql.com/blog-archive/innodb-data-locking-part-3-deadlocks/)

### Verified GitHub example

- [G1: sqldef idempotent schema management with CI-tested engine commands](https://github.com/sqldef/sqldef)
