---
name: model-business-domain
description: Model complex business rules with domain-driven design. Use when terminology, lifecycles, invariants, workflows, ownership, or service boundaries are complex or disputed. Avoid tactical DDD ceremony for simple CRUD and thin data services.
---

# Model Business Domain

## Workflow

1. Learn business language, actors, policies, processes, exceptions, documents, APIs, and data. Resolve ambiguous terms with domain experts or explicit assumptions.
2. Establish a ubiquitous language and bounded contexts. Map relationships and translations between contexts.
3. Model entities by identity and lifecycle, immutable value objects by attributes, and aggregates around invariants and transaction boundaries.
4. Allow mutation through the aggregate root. Reference other aggregates by identity unless a shared transaction is required.
5. Keep domain behavior independent of transport, persistence, and frameworks. Use domain services only when behavior has no natural owner and repositories at aggregate boundaries.
6. Distinguish internal domain events from integration events. Define delivery, ordering, idempotency, and retry semantics at boundaries.
7. Test invariants, state transitions, terminology, and boundary translations.

Prefer the smallest model that protects real business rules. Do not turn every noun into an entity or every application into microservices.

Read [domain modeling practices](references/practices.md) for aggregate and bounded-context guidance.
