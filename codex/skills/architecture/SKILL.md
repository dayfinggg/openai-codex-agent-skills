---
name: architecture
description: Design or review software and system architecture when a request requires structural boundaries, data ownership, integration, deployment, scaling, reliability, or migration decisions. Use for architecture proposals, ADRs, module or service boundaries, and evolutionary redesign; do not use for routine code changes whose architecture is already established.
---

# Architecture

Design the smallest architecture that satisfies verified requirements. Existing system evidence and real constraints outrank patterns, trends, and hypothetical scale. Every component must earn its existence.

## Activate Deliberately

Use this skill when the user asks for architecture or when the requested outcome requires a material structural decision. For routine implementation inside established boundaries, follow the current architecture without proposing alternatives.

If the request is design-only, inspect and decide without modifying the system. If implementation is also requested, preserve the architectural decision as an execution constraint.

## Ground The Decision

1. Trace the current system before proposing a target. Inspect deployment units, modules, interfaces, state, ownership, request and event flows, critical dependencies, configuration, tests, ADRs, telemetry, incidents, and migration history when available.
2. Identify the user-visible outcome, business invariants, compatibility, security and regulatory limits, delivery deadline, budget, team skills, operational capacity, expected load, data volume, growth, and recovery needs.
3. Separate verified facts, safe assumptions, and material unknowns. Ask only for missing information that could change the architecture, safety, or acceptance criteria.
4. Express every important quality requirement as an observable scenario with a stimulus, operating condition, expected response, and measurable threshold. Replace scalable, fast, resilient, and highly available with evidence.
5. Rank the few drivers that shape the design and record non-goals. Use measured baselines, credible forecasts, and explicit headroom rather than imagined internet scale.

## Choose The Least Distributed Sufficient Shape

Evaluate these shapes in order and stop at the first one that satisfies the drivers:

1. A focused change inside the current architecture.
2. A module inside the current deployment unit.
3. A separately executed worker or process with the same product ownership.
4. An independently deployed service.
5. A partitioned, distributed, or multi-region design.

For a greenfield system with an uncertain domain or a small team, prefer a cohesive monolith or modular monolith with enforced internal boundaries and a transactional store.

Choose services only when a boundary needs independent delivery, scaling, failure isolation, security, technology, or ownership, and the organization can operate automated deployment, monitoring, tracing, incident response, contract evolution, and distributed consistency.

Choose serverless functions for short-lived, event-triggered, stateless, bursty work when managed scaling outweighs runtime limits, cold starts, platform coupling, debugging cost, and externalized state. Choose event-driven integration only when producers and consumers need independent timing, multiple consumers, replay, burst absorption, or separate scaling. Keep simple request-response flows synchronous when they already meet the requirements.

Do not add a broker, cache, service mesh, gateway, orchestration platform, CQRS, event sourcing, sharding, or multiple regions without a named driver, owner, operating model, and verification method.

## Define Real Boundaries

1. Find bounded contexts and modules from business capabilities, language, invariants, ownership, and patterns of change, not from tables, entities, screens, or technical layers alone.
2. Keep responsibilities that change together and must remain consistent together inside one boundary. Separate work that must evolve, deploy, secure, scale, or fail independently.
3. Give each boundary one purpose, public contract, hidden implementation, authoritative data, operational owner, and dependency direction.
4. Prevent cycles and access another module only through its published interface. Moving code behind a network does not remove source, schema, runtime, deployment, temporal, or team coupling.
5. Treat a bounded context as a logical model boundary, not an automatic instruction to create a service.

Read [data and messaging](references/data-and-messaging.md) only when the design involves persisted state, cross-boundary consistency, transactions, events, queues, CQRS, or event sourcing.

Read [reliability and change](references/reliability-and-change.md) only when the design involves remote dependencies, SLOs, overload, scaling, caching, redundancy, migration, rollout, or recovery.

## Compare Real Options

Generate alternatives only when a material decision exists. Compare two or three viable options, including retaining or simplifying the current architecture when credible. Evaluate each against the same drivers: correctness, coupling, consistency, latency, failure behavior, operability, security, delivery time, ownership, cost, reversibility, migration risk, and proof of success.

State concrete consequences in this system instead of generic advantage and disadvantage lists. If evidence cannot distinguish the options, define the smallest time-bounded experiment and its decision threshold. Recommend an option only when the request calls for a decision.

## Make Decisions Verifiable

Create an ADR only for a decision that materially affects structure, interfaces, dependencies, quality attributes, operations, or reversibility. Keep one decision per record and capture context, drivers, options, decision, consequences, confidence, verification, status, and reconsideration triggers. Supersede accepted records instead of rewriting history.

Use diagrams only when they answer a concrete question. A system-context and container-level C4 view are sufficient for most designs. Add dynamic or deployment views only when interaction order, data flow, trust boundaries, failure domains, or placement need clarification.

Turn important rules into checks where practical: dependency-cycle and forbidden-import tests, contract and schema compatibility tests, migration rehearsals, restore tests, load and failure tests, and SLO telemetry.

## Final Audit

Reject or revise the design if any answer is no:

1. Does every new component satisfy a verified driver that the simpler preceding shape cannot meet?
2. Are business invariants, authoritative data, write ownership, and consistency boundaries explicit?
3. Are dependency direction, contracts, and material forms of coupling visible?
4. Can each remote dependency fail and recover without an undefined state?
5. Does the operational burden fit the team's capabilities and budget?
6. Can the design be introduced incrementally while remaining deployable, observable, and reversible where required?
7. Does each material quality claim have a measurable acceptance signal or bounded experiment?
8. Would removing any component leave all verified requirements satisfied? If so, remove it.
