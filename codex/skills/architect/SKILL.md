---
name: architect
description: Design types, interfaces, module boundaries, and ownership before implementing a non-trivial feature or structural change. Use when an early design choice would constrain several files or components. Do not use for a small local edit or when an approved design already exists.
---

# Architect

Produce the smallest design that makes implementation predictable without turning the design into a second implementation.

## Ground the decision

Read the relevant entry points, types, tests, and one nearby precedent. State the user-visible outcome, hard constraints, existing invariants, and the decisions that remain open. Separate evidence from assumptions.

Identify both functional requirements and system qualities such as availability, durability, latency, security, operability, recoverability, and sustained delivery speed. Treat these qualities as emergent properties of the whole design and delivery process, not features that can be added in one isolated module.

State the invariants that must survive faults or attack, the smallest trusted computing base that enforces them, the critical functions and cost of losing each one, and whether failure must be fail-closed, fail-open, or fail-static for that specific operation.

Name the forces that shape the design, including scale, consistency, failure tolerance, data sensitivity, compatibility, team ownership, cost, and expected rate of change. Distinguish a reversible local choice from a one-way decision that constrains stored data, public protocols, deployment topology, or organizational ownership.

For a domain-heavy system, map bounded contexts, their owners, shared or translated contracts, and upstream or downstream relationships. Keep the ubiquitous language consistent across code, tests, documentation, and stakeholder discussion within each context. Separate the core domain that deserves custom design effort from generic subdomains that can remain simple or use existing solutions.

## Shape the design

Sketch concrete module names, responsibilities, public signatures, data flow, state ownership, and dependency direction. Also identify consistency boundaries, trust boundaries, failure domains, and the component responsible for each cross-cutting invariant. Prefer deep modules with narrow, consistent, typed interfaces. Make invalid states difficult to represent. Keep validation at external boundaries and business logic independent of frameworks where practical.

Separate policy from mechanism when the mechanism is likely to change independently, and model lifecycle transitions explicitly when startup, shutdown, cancellation, retry, or recovery can race with normal work.

When the system has substantial domain policy, design from the domain and use cases inward. Let transport, persistence, frameworks, queues, and vendors implement ports owned by the application rather than making business policy depend on those details. Add a repository, service layer, unit of work, aggregate, message bus, or read model only when current domain complexity or substitution pressure pays for the extra indirection. Simple CRUD does not earn those patterns automatically.

Make the top-level structure reveal domain capabilities and use cases rather than the selected framework. Distinguish organization-wide domain policy from application-specific orchestration, and keep request, response, and persistence representations from leaking into either when their contracts differ. Centralize construction and adapter selection in a visible composition root.

Choose the strength of a boundary from current evidence. A source-module boundary, separate artifact, process, or service carries progressively higher build, deployment, runtime, and operational cost. If using an intentionally incomplete boundary, name its owner, protected seam, and the condition that will justify materializing the full boundary later.

When contexts integrate, choose the relationship deliberately: joint ownership, a small shared kernel, customer and supplier, conscious conformity, an anticorruption layer, an open-host service with a published language, or separate ways. Do not share tables, packages, or domain objects by default merely because two contexts use similar words.

When transactions matter, define the atomic unit explicitly. Keep an aggregate as small as possible while still protecting its invariants, and reference other aggregates by stable identity when cross-aggregate object graphs would enlarge locks or transaction scope. State what becomes eventually consistent outside that boundary.

For asynchronous or distributed flows, distinguish commands from events and internal events from published contracts. Define delivery semantics, ordering assumptions, idempotency, retries, deduplication, schema evolution, poison-message handling, and observability before treating a queue as decoupling. Keep the logical flow discoverable even when no single call stack contains it.

Treat a timeout as an unknown outcome unless the protocol proves non-execution. Retry only an idempotent operation or one protected by a stable deduplication key, and define how a caller discovers the final state.

For every external dependency, describe timeout, cancellation, retry budget, overload behavior, fallback, and the effect of unavailability. Prevent retries, failover, or health-based removal from amplifying overload. Use backpressure, admission control, load shedding, and bounded queues when demand can exceed capacity.

Design recovery alongside normal operation. Record intended state, rollback and forward-fix limits, backup and restore ownership, partial-restore granularity, emergency access, and the smallest failure or security blast radius. Prefer recovery paths that reuse routinely exercised mechanisms instead of rarely used special modes.

For a critical control-plane dependency, define a low-dependency fallback where justified and exercise it regularly. Ensure rollback, restore, credential rotation, revocation, and emergency access cannot silently reintroduce state below an accepted security floor.

Compare alternatives only when they produce materially different tradeoffs. Choose one design and explain the decisive reason. Identify migrations, compatibility needs, and failure modes that affect the shape.

Use patterns as vocabulary after the problem is understood, not as a template imposed before evidence. A real architecture may evolve, but its module boundaries, interface contracts, and guiding principles must remain explicit enough to review when change pressure erodes them.

## Stop at the right point

Return a design when the request asks for planning or architecture only. Implement only when the request also authorizes code changes. Ask a question only when an unresolved choice would materially change the public contract, data model, or risk.

## Output

Provide the proposed structure, key signatures, data flow, rejected alternatives, risks, and a verification strategy. Include the important system qualities, failure and recovery story, rollout and rollback shape, and evidence needed to validate the riskiest architectural claim. Keep speculative files and abstractions out of the design.

## Sources

- [The Architecture of Open Source Applications](https://aosabook.org/en/)
- [Architecture Patterns with Python](https://www.cosmicpython.com/)
- [Google: Building Secure and Reliable Systems](https://google.github.io/building-secure-and-reliable-systems/)
