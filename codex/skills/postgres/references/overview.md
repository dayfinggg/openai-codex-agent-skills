Read [local host integration](../../.shared/host-integration.md) before applying this imported workflow.

# PostgreSQL Expert Skills

This skill provides comprehensive PostgreSQL expertise through specialized references. Load the appropriate reference based on the task.

## Available References

### Existing Databases
- **[schema-exploration](schema-exploration/guide.md)** — Read-only, question-driven exploration of schemas, tables, views, routines, triggers, RLS, and extensions using `pg_catalog`. **Use to understand an existing database before designing changes or writing queries.**

### Table Design
- **[design-postgres-tables](design-postgres-tables.md)** — Data types, constraints, indexes, JSONB patterns, partitioning, and PostgreSQL best practices. **Use for any general table/schema design task.**
- **[design-postgis-tables](design-postgis-tables.md)** — PostGIS spatial table design: geometry vs geography types, SRIDs, spatial indexing, and location-based query patterns. **Use when the task involves geographic or spatial data.**

### Search
- **[pgvector-semantic-search](pgvector-semantic-search.md)** — Vector similarity search with pgvector: HNSW/IVFFlat indexes, halfvec storage, quantization, filtered search, and tuning. **Use for embeddings, RAG, or semantic search.**
- **[postgres-hybrid-text-search](postgres-hybrid-text-search.md)** — Hybrid search combining BM25 keyword search with pgvector semantic search using RRF. **Use when combining keyword and meaning-based search.**

### TimescaleDB
- **[setup-timescaledb-hypertables](setup-timescaledb-hypertables.md)** — Hypertable creation, compression, retention policies, continuous aggregates, and indexes. **Use when setting up TimescaleDB from scratch.**
- **[find-hypertable-candidates](find-hypertable-candidates.md)** — SQL queries to analyze existing tables and score them for hypertable conversion. **Use when evaluating which tables to migrate.**
- **[migrate-postgres-tables-to-hypertables](migrate-postgres-tables-to-hypertables.md)** — Step-by-step migration: partition column selection, in-place vs blue-green, validation. **Use when executing a migration.**

### Migrations
- **[postgres-database-migration](postgres-database-migration.md)** — DDL lock reference, safe migration patterns, timeout strategies, rollback planning, and fork-based testing. **Use when planning or executing schema changes on production databases.**

## How to Use

1. Identify which reference matches the user's task from the descriptions above.
2. Load the reference file to get detailed instructions and SQL patterns.
3. For tasks spanning multiple areas (e.g., "design a table with vector search"), load multiple references as needed.
