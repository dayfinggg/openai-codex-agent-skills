---
name: design-software-architecture
description: Design or evaluate system-level architecture from verified constraints, boundaries, dependencies, and flows. Use for decomposition and cross-boundary structural decisions; exclude concrete implementation within one backend service, routine coding, and detailed API or database design.
---

# Design Software Architecture

## Establish the decision

1. Define the architecture question, affected system, decision horizon, and success criteria.
2. Inspect the existing codebase, diagrams, contracts, deployment topology, operational evidence, and prior decisions before proposing a target state.
3. Separate verified requirements and constraints from assumptions, inferences, preferences, and unknowns. Ask only for missing information that can materially change the decision.
4. Express important quality attributes as concrete scenarios. Include the stimulus, operating conditions, expected response, and measurable threshold when evidence supplies one.
5. Keep implementation details, endpoint and payload design, database schema design, and delivery scheduling outside the scope except where an interface or migration constraint determines the architecture.

## Shape the system

1. Identify domain capabilities and responsibilities before naming components or technologies.
2. Give each responsibility and mutable datum a clear owner. Place boundaries where change cadence, cohesion, trust, deployment, failure isolation, or consistency requirements justify them.
3. Make dependency direction explicit. Keep policy independent from infrastructure where that separation reduces verified change risk, and eliminate dependency cycles.
4. Trace critical data and control flows end to end. Show state ownership, synchronous and asynchronous transitions, trust boundaries, failure modes, recovery paths, and externally visible effects.
5. Distinguish the current state, constraints that must remain, and the proposed target state.
6. Reuse established project patterns when they satisfy the requirements. Prefer a single deployable unit or modular monolith unless independent scaling, isolation, ownership, compliance, or deployment evidence requires distribution.
7. Add abstractions, services, queues, caches, replicas, and extension points only when a present requirement or measured risk pays for their operational and cognitive cost.

## Compare viable alternatives

1. Include the minimal-change baseline and only materially distinct alternatives.
2. Evaluate each option against the same verified criteria, including correctness, complexity, security, operability, latency, consistency, resilience, evolvability, testability, migration risk, and cost where relevant.
3. Distinguish reversible choices from expensive or irreversible commitments. Preserve optionality at uncertain boundaries without generalizing the entire design.
4. Reject options through explicit evidence and tradeoffs, not popularity, novelty, or generic best-practice claims.
5. Use focused prototypes, measurements, or primary documentation when uncertainty about feasibility or performance could change the choice.

## Record the decision

Present the result in the user's requested format while making these elements traceable:

1. The decision and its scope.
2. Verified drivers, constraints, assumptions, and unresolved unknowns.
3. Component responsibilities, ownership boundaries, and dependency direction.
4. Critical data and control flows, including failure and recovery behavior.
5. Architectural interfaces described by responsibility, semantics, ownership, and compatibility rather than low-level schemas.
6. Alternatives considered, decisive tradeoffs, and consequences of the selected option.
7. Migration implications, compatibility boundaries, rollback conditions, and evidence required before irreversible steps.
8. Validation criteria that can disprove the design.

Use a diagram only when it materially clarifies boundaries or flows. Label ownership and dependency direction, and keep the diagram at the decision's abstraction level.

## Validate the architecture

1. Walk each critical scenario through the proposed boundaries and flows.
2. Test dependency rules, trust boundaries, state consistency, failure containment, recovery, and compatibility against the stated drivers.
3. Confirm that every component and abstraction has a verified responsibility and that removing it would violate a requirement or accepted tradeoff.
4. Check migration implications against the current system and identify where evidence, experiments, or stakeholder decisions remain necessary.
5. Report limitations and uncertainty directly. Never invent requirements, measurements, constraints, or operational guarantees.
