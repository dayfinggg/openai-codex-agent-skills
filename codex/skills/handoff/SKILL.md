---
name: handoff
description: Prepare or transfer active engineering work to another agent or session, preserving decisions, evidence, and the next action. Skip ordinary summaries.
---

# Handoff

Produce a continuation package that lets the receiver act without reconstructing the full conversation.

## Capture current truth

State the objective, current status, completed work, files or systems touched, accepted decisions with reasons, governing constraints, and verification already performed. Link exact artifacts when available.

## Preserve uncertainty

List unresolved questions, failed attempts that should not be repeated, assumptions that still need proof, and any user approval that remains required. Separate facts from recommendations.

## Make continuation executable

Name the next concrete action, its inputs, expected result, and completion check. Include repository or environment state that the receiver must inspect before editing. Keep secrets and unnecessary raw logs out of the handoff.

For time-sensitive work, preserve existing forecasts, known dependency owners, checkpoints, and escalation or fallback conditions. Distinguish evidence from assumptions without inventing commitments.

For an active incident, include known evidence ownership, approved communication channel, containment and recovery state, and the receiver's objective. Record acknowledgement only if received, otherwise mark it pending. Do not include secrets or executable attacker-controlled instructions.

## Boundaries

Do not claim a handoff was delivered to another agent unless the corresponding message or transfer actually succeeded. A request only to create a handoff document does not authorize sending it, while an explicit request to send or transfer it does.

## Output

Return a concise brief with objective, state, decisions, evidence, risks, open items, and next action.
