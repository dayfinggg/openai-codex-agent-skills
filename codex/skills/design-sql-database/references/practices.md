# SQL Database Practices

Choose types and constraints from business invariants. A foreign key does not automatically index the referencing columns in every product. Index design must follow real predicates, joins, ordering, and data distribution, then be checked with the product's execution-plan tools.

Transaction isolation is observable behavior. Define which anomalies are acceptable and build deadlock or serialization retry only where the product documents it. Use compatible staged migrations, product-specific concurrent or online operations, and verified backup and restore.

Primary PostgreSQL sources:

- [Constraints](https://www.postgresql.org/docs/current/ddl-constraints.html)
- [Indexes](https://www.postgresql.org/docs/current/indexes.html)
- [Transaction isolation](https://www.postgresql.org/docs/current/transaction-iso.html)
- [Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html)
- [ALTER TABLE](https://www.postgresql.org/docs/current/sql-altertable.html)
- [CREATE INDEX](https://www.postgresql.org/docs/current/sql-createindex.html)
- [Backup and restore](https://www.postgresql.org/docs/current/backup.html)
