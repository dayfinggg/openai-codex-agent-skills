# Authority and portability

- Treat SQL standard core features as the portability baseline, not as a promise that every engine behaves identically.
- Basic `SELECT`, DML, integrity constraints, and transaction control are standard features; vendor syntax extends that core.
- Index definition syntax is not part of the SQL standard, so isolate index DDL by engine when necessary.
- Record the supported engine and version beside every dialect-specific query or migration.
- Keep schema definitions, migrations, queries, and representative fixtures under version control.
- Prefer standard types and predicates when they express the requirement clearly.
- Put engine-specific types, hints, generated syntax, and index options behind a documented dialect boundary.
- Engine differences in null uniqueness, transaction isolation, composite-index access, DDL atomicity, and online schema changes belong in the target vendor reference and versioned tests.
- Run integration tests against every engine that production supports; a parser or ORM abstraction is not proof of portability.
