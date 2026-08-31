# Types and schema design

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
