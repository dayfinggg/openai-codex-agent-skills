# Operationally safe schema design

Make ownership, naming, retention, and data classification explicit in the schema.
Use explicit schemas and qualify objects in DDL, security-sensitive code, and migration scripts.
Keep stable relational attributes typed and constrained, and isolate flexible or externally owned payloads behind clear boundaries.
Choose key types, collations, and partition keys with future volume, replication, sharding, and retention in mind.
Treat collation as part of the schema contract; provider or locale changes can alter ordering and equality behavior used by indexes.
Prefer stable `C` or built-in collations where bytewise ordering is acceptable, and use natural-language collations only where they are needed.
Keep rows and frequently updated documents bounded enough to avoid unnecessary lock contention and write amplification.
Avoid accidental table rewrites, unbounded JSONB growth, unbounded indexes, and unbounded transaction duration.
Use `UNLOGGED` only when losing or truncating the relation after a crash and excluding it from physical replication is acceptable. Treat TOAST as storage mechanics rather than a substitute for bounded values and measured access patterns.
Record an owner and a purpose for every non-obvious index, constraint, extension, trigger, and scheduled maintenance action.
Back up and restore-test schema, extension files, roles, privileges, and collation assumptions before declaring a design production-ready.
