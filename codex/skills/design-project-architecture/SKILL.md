---
name: design-project-architecture
description: Assess, design, or evolve module, data, runtime, deployment, or team-ownership boundaries. Use when those responsibility boundaries or their contracts are the task; skip business-meaning decisions, UI/UX decisions, file-tree organization, isolated code changes, and refactors that leave boundaries intact.
---

# Design Project Architecture

Choose one mode before proposing changes.

- **Assessment:** map current boundaries, evidence, risks, and gaps against stated drivers.
- **Design:** compare viable boundary options and define the smallest target that satisfies the drivers.
- **Evolution:** preserve behavior while moving toward a target through reversible, observable steps.

## Coordinate adjacent decisions

Treat settled domain language, business invariants, and consistency ownership as inputs. If they are materially unclear, resolve them with `domain-modeling` before choosing technical boundaries. Treat settled user journeys and interaction requirements as inputs from `design-ui-ux`. Use `clarify-and-specify` only when repository evidence and the relevant discipline leave a material product or acceptance decision unresolved.

Architecture owns responsibility and contract decisions, not their filesystem spelling. After the boundaries are settled, use `organize-project-structure` when the remaining task is to express them through package roots, feature or layer folders, colocation, entry points, and filenames. Do not infer an architectural boundary from a folder, role suffix, or framework module alone.

## Establish the decision

1. State the system scope, stakeholders, constraints, affected boundary types, and decision owner. Turn the material concerns into measurable quality-attribute scenarios: source and stimulus, environment, affected asset, required response, metric, and acceptance threshold. Read [architecture principles](references/architecture-principles.md) for the template.
2. Map only the views needed to answer the decision: module dependencies and contracts; data ownership and flows; runtime calls and failure paths; deployment and operational topology; and team ownership and interactions. For an existing system, use [existing-project evolution](references/existing-projects.md). For a new one, use [new-project design](references/new-projects.md).
3. Stop before finalizing an irreversible contract, data, security, availability, deployment, or ownership decision if its drivers are unknown. Record the missing business, regulatory, load, failure-tolerance, rollback, operating-capacity, or accountable-owner information; present reversible options or experiments instead of selecting a target.

## Shape boundaries from drivers

Give each responsibility and state transition an explicit owner and contract. Choose cohesion, information hiding, dependency direction, integration style, and operational scope by the change, consistency, performance, security, availability, cost, and team-flow drivers.

Include preserving the current boundary as an option when it remains viable. Choose the smallest sufficient architecture. Trace every new package, service, layer, public contract, datastore, queue, configuration surface, deployment unit, or team handoff to a current driver and accountable owner. Do not add a generic abstraction, shared layer, extension point, or distributed mechanism for a hypothetical future consumer.

Treat dependency cycles, shared mutable state, replacement seams, and deployment splits as trade-offs rather than universal defects or goals. Retain a cycle or shared state only with a named benefit, a bounded scope, an owner, an enforcement mechanism, and an exit condition. Add an adapter or replacement seam only for a credible source of change, isolation, test, or migration value. Split runtime or deployment units only when selected drivers outweigh added latency, failure, observability, release, and consistency costs.

For every data or distributed boundary, resolve or explicitly mark out of scope: source of truth, ownership, schema evolution, transaction and consistency model, derived data, idempotency, retries, reconciliation, retention, and rollback. Account for a team's cognitive load, operational burden, and interaction modes. Time-box collaboration for discovery, define service contracts and support expectations for X-as-a-Service, and define an objective and exit condition for facilitation.

## Verify proportionately

Turn each important scenario into the smallest credible fitness function. Specify its signal, threshold, cadence, owner, and failure action. Use a reviewable manual check for low-risk one-off decisions; use automated import, contract, schema, or deployment checks for recurring risks; use representative load, resilience, security, restore, or reconciliation checks and production signals when the consequence warrants them. Read [architecture validation](references/architecture-validation.md) for examples and evidence expectations.

Record only the artifacts needed to communicate or govern the decision. Use the repository's established location and naming scheme. Name an artifact by its purpose, such as a boundary map, quality-attribute scenarios, decision record, evolution plan, or fitness gates. Use diagrams and decision records only when they resolve a stakeholder question or preserve a consequential durable choice. Do not create an architecture folder, document set, or filename taxonomy for symmetry. Consult [sources](references/sources.md) for primary guidance or contested choices.

Finish when the applicable boundaries are understandable, the selected option is justified by measurable drivers, the resulting risks have owners and evidence, and unverified assumptions or deferred decisions are explicit.
