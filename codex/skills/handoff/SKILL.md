---
name: handoff
description: Transfer active engineering work to another agent or session without losing decisions, evidence, or the next executable step. Use when the user requests a handoff, work must continue elsewhere, or context limits threaten continuity. Do not use as a generic session summary.
---

# Handoff

Follow the governing instructions and the user's requirements for communication, code style, authorization, and delegation. This skill supplies task-specific guidance, not permission to expand the task. Its workflow and output fields describe internal checks and relevant content, not a mandatory response layout or a progress report. When used within broader authorized work, continue that work through completion rather than stopping to deliver this skill's intermediate result.

Produce a continuation package that lets the receiver act without reconstructing the full conversation.

## Capture current truth

State the objective, current status, completed work, files or systems touched, accepted decisions with reasons, governing constraints, and verification already performed. Link exact artifacts when available.

## Preserve uncertainty

List unresolved questions, failed attempts that should not be repeated, assumptions that still need proof, and any user approval that remains required. Separate facts from recommendations.

## Make continuation executable

Name the next concrete action, its inputs, expected result, and completion check. Include repository or environment state that the receiver must inspect before editing. Keep secrets and unnecessary raw logs out of the handoff.

For time-sensitive work, include the latest forecast or range, the owner of each blocking dependency, the next checkpoint, and the condition that triggers escalation or a fallback. Mark whether the forecast is evidence-based or still an assumption.

For an active incident, include evidence ownership, secure communication channel, current containment and recovery state, the next shift's objective, and explicit acknowledgement from the receiver. Do not place secrets or attacker-controlled content in the handoff.

## Boundaries

Do not claim a handoff was delivered to another agent unless the corresponding message or transfer actually succeeded. A request only to create a handoff document does not authorize sending it, while an explicit request to send or transfer it does.

## Output

Return a concise brief with objective, state, decisions, evidence, risks, open items, and next action.
