---
name: architect
description: Design types, interfaces, and ownership when a feature or structural change affects several components. Skip small edits and already-settled designs.
---

# Architect

Produce the smallest design that makes the requested implementation predictable.

## Ground the decision

Read relevant entry points, types, tests, and a nearby precedent when one exists. Establish the outcome, invariants, compatibility needs, and open decisions. Separate evidence from assumptions and resolve routine reversible choices from context.

## Shape the design

Identify responsibilities, public signatures, state ownership, data flow, and dependency direction only where they affect the requested behavior. Prefer existing boundaries and concrete code over speculative layers or services. Make invalid states difficult to represent and validate external inputs at their boundaries.

Start from a direct implementation within the existing structure. Introduce another boundary only when current behavior, an established contract, or a concrete risk requires it. One implementation does not by itself justify an interface and factory, although a required framework or safety boundary may. Do not invent future consumers to justify a general design. Keep any rationale internal unless the requested deliverable calls for it.

When the actual task involves distributed state, domain boundaries, resilience, recovery, or a critical external dependency, open [design considerations](references/design-considerations.md) and read its matching sections before you settle the design. Do not apply all advanced considerations to every feature. Do not invent capacity plans, emergency procedures, migration stages, or organizational ownership for a local change.

Compare alternatives internally when they materially differ. Provide options, rejected alternatives, or recommendations only when the user requests them. Choose the approach consistent with accepted requirements and existing design.

## Complete the task

For design-only work, provide the concrete structure, consequences, evidence, and material uncertainty without implementation. Otherwise continue the authorized implementation without a new design-approval gate. Ask only about an essential choice that cannot be resolved from context.
