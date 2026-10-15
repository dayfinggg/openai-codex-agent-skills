---
name: applying-clean-architecture
description: Structures applications with business rules at the center and frameworks, databases, and UI behind ports and adapters. Use when designing an application or service, choosing module structure, working in a layered or hexagonal codebase, or reviewing dependency direction. Skip for small scripts.
---

# Applying clean architecture

Clean architecture keeps the business rules independent of frameworks, UI, databases, and external services, so those details can change and the core can be tested without them. Code-level quality rules live in the writing-clean-code skill, and this skill covers how code is split into layers and how the layers depend on each other.

## The dependency rule

Source code dependencies point only inward. Nothing in an inner layer names a class, function, variable, or data format from an outer layer. This one rule matters more than the number of layers or the folder names.

## Layers

| Layer | Contains | Knows about |
|---|---|---|
| Entities (domain) | Enterprise business rules, value objects, invariants | Nothing outside itself |
| Use cases (application) | Application-specific scenarios that orchestrate entities, plus the ports (interfaces) they need | Entities |
| Interface adapters | Controllers, presenters, gateways, repository implementations, mappers between external and internal formats | Use cases and entities |
| Frameworks and drivers | Web framework, ORM, database, message broker, UI, external APIs, configuration, the composition root | Everything, and nothing depends on it |

Four layers are a model, not a quota. Use fewer when the domain is thin, more when it is rich, and keep the dependency rule in every case.

## Crossing boundaries

- When control must flow outward (a use case saves data or sends an email), the inner layer declares an interface, called a port, and the outer layer implements it. This is dependency inversion.
- Data crossing a boundary is a simple structure shaped for the inner layer, such as a request or response object or plain arguments. Do not pass ORM models, HTTP requests, framework objects, or database rows inward, and do not hand entities to the UI.
- Map between external and internal formats in the adapters.
- Wire concrete implementations together in one composition root (`main`, the app factory, or the DI container setup) at the outermost layer.
- Read configuration from the environment once, in the composition root, into a typed settings object that is validated at startup, and pass the values inward, following the Twelve-Factor rule. Inner layers never read environment variables or configuration files themselves.

## Scaling to the project

Architecture is a cost paid in indirection, so spend it where the business logic is.

- **Scripts, prototypes, thin CRUD over a database.** Use the framework directly. Keep business rules in plain functions so they can move later.
- **Growing service with real rules.** Separate domain and use cases from the framework, and add ports only for I/O you need to swap or fake in tests (database, external APIs, clock, messaging).
- **Large or long-lived system.** Full layering, module boundaries by business capability, and dependency checks in CI.
- **Existing codebase.** Follow its current architecture. Move toward these rules gradually, one feature at a time, and never in an unrequested rewrite. Use the Strangler Fig pattern to replace a legacy part piece by piece behind a stable facade, and an Anti-Corruption Layer to keep a legacy or external model from leaking into the new core, as the Azure Architecture Center describes.

## Workflow

1. Name the use case in business terms (`RegisterUser`, `PlaceOrder`) and define its input and output data.
2. Put business rules and invariants in entities, and keep them free of I/O.
3. Write the use case against ports it declares for every external need.
4. Implement the ports in adapters, with mapping at the edge.
5. Wire everything in the composition root.
6. Test entities and use cases with in-memory fakes, and test adapters with integration tests against the real technology.
7. Run the dependency checklist below on the result.
8. When the change sets or alters module boundaries, record the decision and, if the user wants a diagram, a C4 context or container view with the recording-architecture-decisions skill.

## Dependency checklist

- [ ] No import in the domain or use case layer refers to a framework, ORM, HTTP, UI, or driver package
- [ ] Every outward call from a use case goes through a port the inner layer owns
- [ ] Framework and ORM types stop at the adapters
- [ ] Use cases are tested without a database, network, or web server
- [ ] Only the composition root creates concrete adapters
- [ ] Folder names show what the system does (orders, billing), not only which framework it uses
- [ ] The amount of layering matches the size and lifetime of the project

## Reference files

Read them before the first change, the project structure file for the language at hand and the examples file, and the component principles when splitting a system into modules or packages.

- [references/project-structure.md](references/project-structure.md) has folder layouts for Python, TypeScript, Java, C#, and Go, plus ways to enforce dependency direction automatically.
- [references/component-principles.md](references/component-principles.md) has SOLID at the architecture level and the component cohesion and coupling principles, for splitting a system into modules or packages.
- [examples.md](examples.md) has one feature implemented end to end across all layers, with a use case test.
