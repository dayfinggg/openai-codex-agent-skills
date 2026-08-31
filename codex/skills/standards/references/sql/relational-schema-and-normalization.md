# Relational schema and normalization

- State the grain of every table and result, such as “one row per order item.”
- Store one fact in one column and one row at the table’s declared grain.
- Split subject-based facts into related tables instead of repeating a customer, product, or address on every transaction row.
- First normal form removes repeating groups and multi-valued fields from ordinary relational columns.
- Second normal form requires every non-key fact to depend on the whole key, which matters most for composite keys.
- Third normal form removes facts that depend on another non-key fact rather than directly on the row key.
- A many-to-many relationship normally becomes a junction table with two foreign keys.
- Make the junction key match the relationship grain, often with a composite primary key or an explicit relationship identifier plus a unique constraint.
- Normalize first to protect update, insert, and delete integrity.
- Denormalize only for a measured access pattern, and document the duplicated fact, owner, refresh path, and consistency guarantee.
- A materialized summary is a cache or projection, not a second undocumented source of truth.
- Do not persist a value that can be safely derived unless its snapshot meaning or performance purpose is explicit.
- If a derived value is persisted, define who recomputes it and test stale-value behavior.
- Avoid generic entity tables that discard domain types, keys, and constraints merely to reduce table count.
- Model optional, repeating, and historical facts as separate relations when their lifecycles differ.
- Prototype the design with sample rows and the queries the application must answer.
