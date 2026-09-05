---
name: architect
description: Design types, interfaces, module boundaries, and ownership for a non-trivial feature or structural change. Use when an early choice affects several components. Skip small local edits and settled designs.
---

# Architect

Follow the governing instructions and the user's requirements for communication, code style, authorization, and delegation. This skill supplies task-specific guidance, not permission to expand the task. Its workflow and output fields describe internal checks and relevant content, not a mandatory response layout or a progress report. When used within broader authorized work, continue that work through completion rather than stopping to deliver this skill's intermediate result.

Produce the smallest design that makes the requested implementation predictable.

## Ground the decision

Read the relevant entry points, types, tests, and one nearby precedent. Establish the user-visible outcome, current invariants, compatibility requirements, and decisions that actually remain open. Separate evidence from assumptions. Resolve routine reversible choices without asking the user.

## Shape the design

Identify responsibilities, public signatures, state ownership, data flow, and dependency direction only where they affect the requested behavior. Prefer existing boundaries and concrete code over speculative layers or services. Make invalid states difficult to represent and validate external inputs at their boundaries.

When the actual task involves distributed state, domain boundaries, resilience, recovery, or a critical external dependency, consult the relevant paragraphs in [design considerations](references/design-considerations.md). Do not apply all advanced considerations to every feature. Do not invent capacity plans, emergency procedures, migration stages, or organizational ownership for a local change.

Compare alternatives internally when they materially differ. Provide options, rejected alternatives, or recommendations only when the user requests them. Choose the approach consistent with accepted requirements and existing design.

## Complete the task

For an architecture-only request, return the requested design and relevant evidence without implementing it. When design supports an authorized implementation, continue directly into that work. Ask only when an essential unresolved choice prevents a sound result and cannot be inferred from context. Do not create a separate approval gate merely because design work occurred.

Use the user's response format. Include the concrete structure and consequences needed to understand the result, with material uncertainty and the relevant verification. Do not turn the design notes into a long generic checklist.
