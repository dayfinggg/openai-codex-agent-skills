# Cross-engine boundary

- If the same application targets SQLite, keep engine-specific DDL for types, indexes, foreign-key timing, and migration operations.
- Do not assume SQLite's dynamic typing, single-writer model, or file backup rules match InnoDB behavior.
- Verify row counts, nullability, key uniqueness, foreign-key checks, numeric precision, timestamps, collations, and query plans after conversion.
