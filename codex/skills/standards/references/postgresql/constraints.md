# Constraints

Put integrity rules in the database so every writer receives the same protection.
Mark required columns `NOT NULL`; PostgreSQL checks it more directly than an equivalent check constraint.
Remember that a `CHECK` expression passes when it returns `TRUE` or `NULL`; pair it with `NOT NULL` when null is invalid.
Keep `CHECK` constraints row-local and based on stable functions.
Do not make a `CHECK` depend on other table rows or mutable function behavior because dump and restore consistency can fail.
Use a primary key for stable row identity and unique constraints for alternate keys.
On PostgreSQL 15 and later, use `UNIQUE NULLS NOT DISTINCT` when null values must collide. On older supported releases, use a carefully tested expression or partial-index design. Ordinary unique constraints treat nulls as distinct.
Use foreign keys for referential integrity and choose `ON DELETE` and `ON UPDATE` actions explicitly.
Index referencing foreign-key columns when joins or parent updates and deletes must find children quickly.
PostgreSQL does not automatically create the child-side foreign-key index.
Use `EXCLUDE USING gist` for invariants such as non-overlapping reservations or ranges.
Name constraints predictably so migrations, diagnostics, and incident fixes can address them safely.
