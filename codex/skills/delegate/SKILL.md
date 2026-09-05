---
name: delegate
description: Prepare and assign one bounded, independently verifiable subtask to a subagent. Use when delegation is authorized by the user or governing instructions, collaboration tools are available, and one independent work unit will materially help. Do not use merely to avoid doing a small task locally.
---

# Delegate

Follow the governing instructions and the user's requirements for communication, code style, authorization, and delegation. This skill supplies task-specific guidance, not permission to expand the task. Its workflow and output fields describe internal checks and relevant content, not a mandatory response layout or a progress report. When used within broader authorized work, continue that work through completion rather than stopping to deliver this skill's intermediate result.

Delegate an outcome, not a vague topic or a copy of the whole parent task.

## Confirm fit

Delegate only when the user or governing instructions authorize delegation and the collaboration tools are available. This skill does not itself grant that authorization. Respect a request to work personally without subagents. Do not ask again when delegation is already authorized. The subtask must have a clear boundary, enough context to start, an observable completion condition, and no need for ongoing parent judgment. Keep work that owns shared state or final integration with the primary agent.

## Write the brief

State the objective, why it matters, exact scope, inputs, relevant paths or sources, constraints, allowed side effects, expected artifact or answer, required evidence, and stopping condition. Include exclusions that prevent overlap with the parent or another agent.

When uncertainty or external dependencies can delay the lane, name their owner, an early-warning threshold, and the parent integration checkpoint. Do not let a delegated estimate silently become a parent-level commitment.

Provide raw evidence rather than the intended conclusion when the subagent is evaluating or reviewing. Do not preload a suspected answer that would bias an independent result.

## Integrate

Inspect the returned evidence and artifacts. Verify claims that affect the parent outcome. Do not accept completion based only on the subagent's status message.

## Output

Return or send one self-contained brief. If delegation is unavailable or prohibited by a higher-priority instruction, keep the work local rather than inventing a delegation mechanism.
