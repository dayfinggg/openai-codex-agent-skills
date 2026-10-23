---
name: applying-clean-architecture
description: Keeps business rules independent of frameworks, databases, and UI through ports and adapters. Use when designing a service, choosing module structure, or reviewing dependency direction in layered or hexagonal code.
---

# Applying clean architecture

Source dependencies point only inward. Nothing in the domain or use case layer names a framework, ORM, HTTP, UI, or driver type. This rule matters more than the number of layers or the folder names.

| Layer | Contains | Depends on |
|---|---|---|
| Domain | Entities, value objects, invariants, free of I/O | Nothing |
| Application | Use cases named in business terms, and the ports they declare | Domain |
| Adapters | Controllers, presenters, repositories, gateways, mappers | Application, domain |
| Infrastructure | Framework, ORM, broker, UI, configuration, composition root | Everything |

Use fewer layers for a thin domain and more for a rich one, and keep the dependency rule either way.

## Boundaries

- A use case declares a port for each outward need, such as the database, an external API, the clock, or messaging, and an adapter implements it.
- Data crossing inward is a plain request or response structure. ORM models, HTTP requests, framework objects, and database rows stop at the adapters, entities never reach the UI, and mapping happens in the adapters.
- One composition root, such as `main`, the app factory, or the DI setup, creates every concrete adapter. It reads configuration from the environment once into a typed settings object validated at startup and passes the values inward. Inner layers never read environment variables or config files.

## How much architecture

Architecture costs indirection, so spend it where the business logic is.

- Scripts, prototypes, and thin CRUD use the framework directly, with business rules in plain functions so they can move later.
- A growing service with real rules separates domain and use cases from the framework, with ports only for I/O that must be swapped or faked in tests.
- A large or long-lived system groups modules by business capability with the layers inside each, and checks dependency direction in CI.
- An existing codebase keeps its architecture and moves toward these rules one feature at a time, never in an unrequested rewrite. Replace legacy parts with the Strangler Fig pattern behind a stable facade, and keep legacy or external models out of the new core with an Anti-Corruption Layer.

## Modules

- Early on, put classes that change together in one component, and favor reuse as the system matures.
- The component graph has no cycles. Break one with dependency inversion or a new shared component.
- A well-layered monolith comes first. A service boundary follows a stable module boundary.
- Top-level folder names say what the system does, such as orders and billing, not which framework it uses.

## Tests and records

Test entities and use cases with in-memory fakes, without a database, network, or web server. Test adapters with integration tests against the real technology. When a change sets or alters module boundaries, record the decision with the recording-architecture-decisions skill.

## Reference files

- [reference/project-structure.md](reference/project-structure.md) has folder layouts for Python, TypeScript, Java, C#, and Go and the CI tools that enforce dependency direction. Read it when creating or reorganizing modules.
