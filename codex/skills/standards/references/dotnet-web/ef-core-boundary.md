# EF Core boundary

- Treat one short-lived `DbContext` as one unit of work, normally scoped to an HTTP request.
- Dispose contexts through DI and never share one context concurrently across threads or parallel operations.
- Await each EF Core operation before starting another operation on the same context.
- Keep persistence-specific context, mappings, migrations, and provider code behind a real infrastructure boundary when the application has one.
- Do not add a generic repository or unit-of-work wrapper solely for ceremony; `DbContext` already supplies those patterns for simple CRUD.
- Add a focused repository or port when it expresses a domain boundary, isolates a provider, or provides a useful testing seam.
- Project only the columns needed by the response and use no-tracking queries for read-only paths when identity resolution is not required.
- Limit result sets and use pagination; test against data volumes that resemble production.
- Inspect generated SQL, query plans, round trips, and related-entity loading before adding a performance abstraction.
- Use raw SQL only when EF Core cannot produce the required query and measured performance or database-specific behavior justifies the maintenance cost.
- Keep DTO mapping explicit at the persistence or application boundary so database shape does not become the HTTP contract.
