# Component principles

Use these when splitting a system into modules, packages, or services.

## Contents

- SOLID at the architecture level
- Component cohesion
- Component coupling
- Boundaries and details

## SOLID at the architecture level

| Principle | Meaning for architecture |
|---|---|
| Single responsibility | A module answers to one actor, meaning one group of people who request its changes |
| Open and closed | New behavior arrives as new adapters or new use cases, not edits to the core |
| Liskov substitution | Every implementation of a port honors the same contract, so adapters are interchangeable |
| Interface segregation | Ports are small and shaped for the use case that needs them |
| Dependency inversion | The core owns the interfaces, details implement them |

## Component cohesion

These three pull against each other. Early in a project favor the common closure principle, and favor reuse as the system matures.

| Principle | Rule |
|---|---|
| Reuse/release equivalence | What is reused together is released and versioned together |
| Common closure | Classes that change for the same reason at the same time live in one component |
| Common reuse | Do not force users of a component to depend on things they do not use |

## Component coupling

| Principle | Rule |
|---|---|
| Acyclic dependencies | The component dependency graph has no cycles. Break a cycle with dependency inversion or a new shared component |
| Stable dependencies | Depend in the direction of stability. Volatile components depend on stable ones |
| Stable abstractions | The more stable a component is, the more abstract it is, so stability does not block extension |

## Boundaries and details

- The database, the web, frameworks, and devices are details. Decisions about them can wait until the business rules are clear.
- A framework is something you use, not something you marry. Keep its types at the edge.
- Use the humble object pattern at boundaries that are hard to test. Move logic out of the view, the database gateway, or the message handler into a testable object, and leave only thin glue behind.
- The main component is the dirtiest one. It creates and wires everything and nothing depends on it.
- Splitting into services is a deployment decision, not an architecture by itself. A well-layered monolith comes first, and a service boundary follows a stable module boundary.
