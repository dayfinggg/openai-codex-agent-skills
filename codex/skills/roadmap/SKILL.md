---
name: roadmap
description: Sequence large engineering work into verifiable stages and dependencies. Use for requested plans or internal planning during authorized implementation.
---

# Roadmap

Create a route to the outcome that remains usable across sessions and agents.

## Frame the destination

State the final observable outcome, current state, constraints, non-goals, and definition of done. Resolve only ambiguities that change sequencing or architecture.

## Decompose

Split work into coherent, testable stages with explicit dependencies. Investigate high-risk and irreversible commitments early, but perform irreversible actions only after their prerequisites and authorization are satisfied. Keep independent outcomes separate.

Before introducing shared infrastructure or a general abstraction, require a present need such as real consumers, an existing compatibility contract, or an established safety boundary. Do not invent extra consumers or a demonstration stage merely to satisfy a process.

Each unit must state its result, likely scope, prerequisites, acceptance criteria, and concrete verification. Identify safe parallel work only after contracts and shared ownership are settled.

Limit simultaneous in-progress stages to the work the available owners can finish and integrate. Starting more parallel stages is not progress when reviews, dependencies, or verification are already the bottleneck.

When scheduling is part of the request, use evidence-backed ranges with assumptions, known dependency owners, checkpoints, and fallback conditions. Do not invent estimates or present a forecast as a promise. Revise it when evidence changes.

## Check the route

Check for dependency cycles, hidden migrations, and unverified handoffs. Give long stages resumable checkpoints rather than imposing a fixed session length. Place verification before dependent work.

## Boundaries

For a planning-only request, return the plan without implementation. When planning supports an authorized implementation, keep it internal and continue the original task without an extra approval checkpoint. Do not overwrite an unrelated plan or create external tickets without authorization.

## Output

Return the destination, assumptions, ordered stages, dependency edges, checkpoints, risks, and open decisions.
