# Migrations and schema evolution

- Treat an applied migration as immutable history; add a new migration instead of editing an old one.
- Give each migration a clear forward purpose, preconditions, postconditions, and operational notes.
- Prefer expand, migrate, and contract for live systems that may run old and new application versions together.
- Expand additively, deploy code that reads or writes the new shape, backfill in bounded batches, then contract after old readers are gone.
- Make dual writes temporary, observable, and reconciled before switching the source of truth.
- Backfill by stable key ranges or batches, with progress, throttling, restart safety, and a repair path.
- Add a new nullable column before making it required; validate existing rows before adding `NOT NULL`.
- Deploy a new index separately when its build duration or lock behavior could affect application traffic.
- DDL atomicity, transactional behavior, locking, and `ALTER TABLE` capabilities differ by engine and version; consult vendor references before choosing a migration shape.
- Keep dialect-specific DDL isolated in migration files and test it on the exact production engine and version.
- Test lock duration, table size, replica lag, disk headroom, and failure recovery on production-like data.
- Run migrations in CI from a clean schema and from representative prior versions.
- Verify row counts, null counts, uniqueness, foreign keys, and old-versus-new query results before removing the old shape.
- Keep irreversible data deletion in a separately reviewed step with backups or a verified archive.
