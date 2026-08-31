# Minimal APIs and controllers

- Start new HTTP APIs with Minimal APIs unless controller-specific features justify another choice.
- Minimal APIs reduce ceremony and support route groups, filters, authorization, typed results, OpenAPI metadata, and dependency injection.
- Use `MapGroup` to keep a feature's prefix, tags, policies, filters, and endpoint mappings together.
- Use `TypedResults` when response types should be visible to OpenAPI and directly assertable in unit tests.
- Use controllers when the app needs MVC model-binding extensibility, advanced MVC validation, application parts, conventions, or OData support.
- Choose one style per feature based on required behavior, not on a blanket preference or a benchmark detached from the workload.
- Do not rewrite stable controllers merely to adopt Minimal APIs.
- Both styles should keep HTTP translation at the edge and delegate business decisions to testable application or domain code.
