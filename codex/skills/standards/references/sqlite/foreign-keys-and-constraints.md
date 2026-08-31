# Foreign keys and constraints

- SQLite parses foreign keys but disables enforcement by default for backwards compatibility. [S6]
- Execute `PRAGMA foreign_keys = ON` on every database connection and verify the setting. [S6]
- Enable or disable foreign keys only outside a transaction because changing the pragma inside a transaction has no effect. [S6]
- A parent key must be a primary key or an exact matching `UNIQUE` key with the required collation. [S6]
- SQLite does not require child-key indexes, but without them parent deletes and updates can scan the entire child table. [S6]
- Immediate checks are the default, and `DEFERRABLE INITIALLY DEFERRED` or `PRAGMA defer_foreign_keys` can defer checks until commit. [S6]
- `ON DELETE` and `ON UPDATE` support `NO ACTION`, `RESTRICT`, `SET NULL`, `SET DEFAULT`, and `CASCADE`; choose actions as domain rules. [S6]
- Run `PRAGMA foreign_key_check` after rebuild-style migrations and before shipping a converted database. [S6] [S9]
