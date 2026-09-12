---
name: specify
description: Consolidate accepted requirements into a testable implementation specification. Skip open-ended product discovery and implementation.
---

# Specify

Synthesize what is already known. Do not restart discovery or invent missing product decisions.

## Establish the source

Use the current conversation, linked issue, accepted decisions, and relevant project evidence. Mark unresolved material as an open question. If one missing decision prevents a coherent contract, ask only that question.

## Define the contract

State the problem, users or callers, desired behavior, inputs, outputs, state transitions, error behavior, compatibility constraints, and non-functional requirements that affect implementation. Express acceptance criteria as observable outcomes.

Cover successful, boundary, and failure cases. Resolve ambiguous business terms and keep stable business behavior separate from volatile UI or implementation detail. When several roles own the contract, use available accepted decisions and identify genuinely missing requirements. Do not invent a mandatory stakeholder review or contact other people unless the task requires and authorizes it.

Keep implementation choices only when they are already decided or required by the repository. Separate product requirements from implementation notes. Name what is out of scope so downstream work does not expand silently.

## Quality check

Confirm that every requirement is testable, terms are consistent, conflicts are surfaced, and no acceptance criterion depends on an undefined concept. Remove duplicated background and speculative features.

## Output

Return a concise specification with problem, behavior, acceptance criteria, constraints, out-of-scope items, open questions, and supporting evidence. Write to an external tracker or file only when the request authorizes that write.
