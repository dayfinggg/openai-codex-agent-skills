# Active Record

- Model tables and relationships with clear `belongs_to`, `has_many`, `has_one`, and `through` associations.
- Choose `dependent` behavior deliberately because `destroy`, `delete`, nullification, and restriction have different effects.
- Add foreign keys, unique indexes, check constraints, and non-null constraints in migrations when the database can enforce them.
- Use scopes for small, chainable relation definitions that do not perform writes or surprise callers.
- Return relations from query methods so callers can compose, paginate, or further constrain them.
- Use `find_by!` or bang persistence methods when failure must be visible at the boundary.
- Use non-bang methods when invalid user input is an expected branch and render the errors deliberately.
- Use `update_all`, `delete_all`, `insert_all`, and `upsert_all` only with an explicit decision about skipped callbacks and validations.
- Remember that bulk SQL can bypass timestamps, callbacks, validations, and application-level invariants.
- Parameterize custom SQL and prefer Arel or documented query methods over string interpolation.
- Keep raw SQL narrowly scoped and make the reason visible through a named query, test, or public API documentation. Add a source note only when the relation API limitation is non-obvious and cannot be expressed otherwise.
- Use `includes`, `preload`, or `eager_load` intentionally, and verify the resulting query plan.
- Use `find_each` or `in_batches` for large sets instead of loading every row into memory.
- Select or pluck only the columns needed by a measured hot path, while retaining records when behavior needs models.
- Keep transactions around one database connection and do not assume they coordinate separate databases.
- Put database invariants in the database and use model validations for useful application-facing error messages.
