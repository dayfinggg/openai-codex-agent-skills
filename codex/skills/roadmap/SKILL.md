---
name: roadmap
description: Break a large or multi-session engineering objective into ordered, verifiable stages with dependencies and checkpoints. Use when the user asks for an implementation plan or complex authorized work needs internal sequencing. Do not turn an implementation request into a planning-only response.
---

# Roadmap

Follow the governing instructions and the user's requirements for communication, code style, authorization, and delegation. This skill supplies task-specific guidance, not permission to expand the task. Its workflow and output fields describe internal checks and relevant content, not a mandatory response layout or a progress report. When used within broader authorized work, continue that work through completion rather than stopping to deliver this skill's intermediate result.

Create a route to the outcome that remains usable across sessions and agents.

## Frame the destination

State the final observable outcome, current state, constraints, non-goals, and definition of done. Resolve only ambiguities that change sequencing or architecture.

## Decompose

Split work into vertical units that leave the system in a valid, testable state. Make dependencies explicit. Put risk-reducing discovery and irreversible decisions early. Avoid tasks titled with multiple independent outcomes.

Before introducing shared infrastructure or a general abstraction, require a present need such as real consumers, an existing compatibility contract, or an established safety boundary. Do not invent extra consumers or a demonstration stage merely to satisfy a process.

Each unit must state its result, likely scope, prerequisites, acceptance criteria, and concrete verification. Identify safe parallel work only after contracts and shared ownership are settled.

Limit simultaneous in-progress stages to the work the available owners can finish and integrate. Starting more lanes is not progress when reviews, dependencies, or verification are already the bottleneck.

For date-sensitive work, record an optimistic, nominal, and pessimistic range with its assumptions, dependency owners, next checkpoint, and fallback trigger. Do not present a nominal estimate as a promise. Update the forecast when evidence changes instead of preserving a stale date.

## Check the route

Ensure the sequence contains no circular dependency, hidden migration step, unverified handoff, or stage that is too large for one focused session. Add checkpoints where evidence should be reviewed before more work depends on it.

## Boundaries

For a planning-only request, return the plan without implementation. When planning supports an authorized implementation, keep it internal and continue the original task without an extra approval checkpoint. Do not overwrite an unrelated plan or create external tickets without authorization.

## Output

Return the destination, assumptions, ordered stages, dependency edges, checkpoints, risks, and open decisions.
