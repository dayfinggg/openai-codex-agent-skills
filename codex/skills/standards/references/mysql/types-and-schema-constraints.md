# Types and schema constraints

- MySQL exposes numeric, date/time, string, binary, spatial, and native JSON types. [M7]
- Declare the narrowest type that covers the domain, with explicit precision, scale, nullability, character set, and collation.
- `DECIMAL` is exact fixed-point arithmetic, while `FLOAT` and `DOUBLE` are approximate. Use the former when decimal equality matters. [M20]
- `BOOL` and `BOOLEAN` are synonyms for `TINYINT(1)`, and `TRUE` and `FALSE` are aliases for `1` and `0`. [M20]
- MySQL's native `JSON` type validates documents and stores them in an optimized internal representation. [M8]
- Use JSON for genuinely document-shaped or sparse attributes, not as a substitute for columns used in joins, constraints, or frequent predicates.
- Choose character set and collation deliberately because they affect storage, equality, ordering, indexes, and foreign-key compatibility. [M7] [M13]
- SQL modes control accepted syntax and data validation, and modes can differ globally and per session. [M9]
- Set and verify the intended strict SQL mode for every connection instead of relying on an implicit server default. [M9]
- Test invalid, truncated, out-of-range, and time-zone-sensitive values under the same SQL mode used in production. [M9] [M7]
- Prefer explicit `CHECK`, `NOT NULL`, `UNIQUE`, and foreign-key constraints for invariants that MySQL can enforce.
