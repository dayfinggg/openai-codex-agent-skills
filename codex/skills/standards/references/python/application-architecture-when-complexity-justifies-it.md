# Application architecture when complexity justifies it

- Keep a rich domain model as plain Python when business rules must remain testable without a framework, ORM session, network, or process environment. Simple CRUD does not need a separate domain layer.
- Define application use cases at a stable service boundary that accepts transport-neutral values and coordinates domain behavior, persistence, and external ports. Keep HTTP, CLI, and message consumers as thin adapters.
- Introduce a repository only when the domain benefits from a collection-like persistence port or must remain independent of storage details. Do not add a generic repository over every ORM model.
- Use an explicit unit of work when several changes must share one atomic transaction. Make commit and rollback behavior visible and test the real transaction adapter.
- Keep aggregate boundaries small enough to protect current invariants without loading or locking an unrelated object graph. Coordinate cross-aggregate work through stable identifiers and an explicit consistency decision.
- Treat internal domain events and external integration messages as different contracts. Published handlers need idempotency, retry and ordering rules, schema evolution, poison-message handling, and end-to-end observability.
- Wire real adapters, configuration, and defaults in one composition root or bootstrap function, and allow tests to supply fakes through the same explicit ports.
- Use a domain service only for a significant operation that does not naturally belong to one entity or value object. Use a factory only when constructing a valid aggregate or value object requires hiding meaningful internal assembly.
- Translate between bounded contexts when their models or language differ. Do not reuse an upstream DTO, ORM model, or event payload as the local domain model solely to avoid a small mapping function.
