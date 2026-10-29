---
name: postgres
description: "Inspect PostgreSQL schemas or work on table design, SQL, indexes, extensions, search, or migrations. Select version-matched procedures for the actual database task."
---

Use the PostgreSQL procedure that owns the requested result. Establish the database version, connection scope, and relevant schemas before applying version-sensitive SQL.

Read [host integration](../.shared/host-integration.md) once when using these bundled procedures.

| Task | Read |
|---|---|
| Understand an existing database or establish query meaning | [Schema exploration](references/schema-exploration/guide.md) |
| Design tables, types, keys, constraints, or indexes | [Table design](references/design-postgres-tables.md) |
| Plan or perform a PostgreSQL schema migration | [Migration procedure](references/postgres-database-migration.md) |
| Design spatial data with PostGIS | [PostGIS tables](references/design-postgis-tables.md) |
| Implement vector similarity search with pgvector | [Vector search](references/pgvector-semantic-search.md) |
| Combine keyword and semantic search | [Hybrid text search](references/postgres-hybrid-text-search.md) |
| Configure an explicitly selected TimescaleDB deployment | [Hypertable setup](references/setup-timescaledb-hypertables.md) |
| Evaluate existing tables for hypertable conversion | [Candidate analysis](references/find-hypertable-candidates.md) |
| Convert tables to hypertables | [Hypertable migration](references/migrate-postgres-tables-to-hypertables.md) |

Use the [complete procedure overview](references/overview.md) only when a task spans several areas and the correct ownership remains unclear.

Load the selected procedure and only its task-relevant supporting files. Preserve plain PostgreSQL when an extension has not been selected. For database-independent rollout compatibility, use the installed database-migration-rollout skill when that release work is requested.

