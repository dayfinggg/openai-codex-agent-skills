# Migrations and schema evolution

- SQLite directly supports table and column rename, add column, drop column, and current releases also support `SET NOT NULL` and `DROP NOT NULL`. [S9]
- Adding a column without content-changing constraints edits schema text and is independent of table size. [S9]
- Changing a type, primary key, unique constraint, or complex constraint normally requires the documented 12-step rebuild. [S9]
- The safe rebuild creates `new_X`, copies selected columns, drops `X`, renames `new_X`, recreates indexes, triggers, and views, checks foreign keys, and commits. [S9]
- Keep the rebuild in one transaction and test column mapping against real data before running it on user files. [S9]
- Avoid `PRAGMA writable_schema` for routine migrations because a typo can make the database corrupt or unreadable. [S9]
- Store an application schema version and make each migration explicit, deterministic, and restart-safe.
- Do not assume a migration written for MySQL `ALTER TABLE` has equivalent SQLite locking, type, or rebuild behavior.
- The CI-backed `sqldef` example exposes `sqlite3def` dry-run and apply commands; review generated DDL and test it on a copy before applying. [G1]
