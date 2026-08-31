# JSONB

Use `jsonb` for queryable JSON documents; use `json` only when preserving the exact input text matters.
`jsonb` validates JSON and stores a decomposed binary representation that avoids reparsing on every read.
Keep JSONB structure predictable, and promote stable, frequently filtered, or strongly constrained fields to typed columns.
Use a `CHECK` constraint or a vetted validation function for essential document shape and business rules.
Remember that SQL `NULL` and JSON `null` are different values.
Keep JSONB documents manageable because updating any field locks the whole containing row.
Use the default GIN operator class for key existence, containment, and JSONPath operators when those are the query operators.
Use `jsonb_path_ops` only when its narrower operator set matches the workload and its measured trade-offs are favorable.
Write predicates against the indexed expression; for example, `doc -> 'tags' ? 'x'` may need an expression index rather than a plain `doc` GIN index.
Treat JSONB as a flexible boundary, not as permission to omit data ownership, constraints, or migration plans.
