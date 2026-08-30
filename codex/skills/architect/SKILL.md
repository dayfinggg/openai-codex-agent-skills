---
name: architect
description: Design types, interfaces, module boundaries, and ownership before implementing a non-trivial feature or structural change. Use when an early design choice would constrain several files or components. Do not use for a small local edit or when an approved design already exists.
---

# Architect

Produce the smallest design that makes implementation predictable without turning the design into a second implementation.

## Ground the decision

Read the relevant entry points, types, tests, and one nearby precedent. State the user-visible outcome, hard constraints, existing invariants, and the decisions that remain open. Separate evidence from assumptions.

## Shape the design

Sketch concrete module names, responsibilities, public signatures, data flow, state ownership, and dependency direction. Prefer deep modules with narrow interfaces. Make invalid states difficult to represent. Keep validation at external boundaries and business logic independent of frameworks where practical.

Compare alternatives only when they produce materially different tradeoffs. Choose one design and explain the decisive reason. Identify migrations, compatibility needs, and failure modes that affect the shape.

## Stop at the right point

Return a design when the request asks for planning or architecture only. Implement only when the request also authorizes code changes. Ask a question only when an unresolved choice would materially change the public contract, data model, or risk.

## Output

Provide the proposed structure, key signatures, data flow, rejected alternatives, risks, and a verification strategy. Keep speculative files and abstractions out of the design.
