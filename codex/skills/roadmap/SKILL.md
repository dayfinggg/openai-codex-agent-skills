---
name: roadmap
description: Break a large or multi-session engineering objective into ordered, verifiable stages with dependencies and checkpoints. Use when the work spans several components or cannot be safely held in one execution pass. This skill plans but does not implement.
---

# Roadmap

Create a route to the outcome that remains usable across sessions and agents.

## Frame the destination

State the final observable outcome, current state, constraints, non-goals, and definition of done. Resolve only ambiguities that change sequencing or architecture.

## Decompose

Split work into vertical units that leave the system in a valid, testable state. Make dependencies explicit. Put risk-reducing discovery and irreversible decisions early. Avoid tasks titled with multiple independent outcomes.

Before a stage creates shared infrastructure, a generic framework, or a cross-cutting abstraction, require evidence from one working vertical scenario and multiple real consumers. Make generalization a checkpoint decision rather than an assumption in the first stage.

Each unit must state its result, likely scope, prerequisites, acceptance criteria, and concrete verification. Identify safe parallel work only after contracts and shared ownership are settled.

Limit simultaneous in-progress stages to the work the available owners can finish and integrate. Starting more lanes is not progress when reviews, dependencies, or verification are already the bottleneck.

For date-sensitive work, record an optimistic, nominal, and pessimistic range with its assumptions, dependency owners, next checkpoint, and fallback trigger. Do not present a nominal estimate as a promise. Update the forecast when evidence changes instead of preserving a stale date.

## Check the route

Ensure the sequence contains no circular dependency, hidden migration step, unverified handoff, or stage that is too large for one focused session. Add checkpoints where evidence should be reviewed before more work depends on it.

## Boundaries

Do not start implementation. Do not overwrite an existing incomplete plan for different work. Do not create external tickets without authorization.

## Output

Return the destination, assumptions, ordered stages, dependency edges, checkpoints, risks, and open decisions.
