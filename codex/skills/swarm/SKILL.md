---
name: swarm
description: Fan out several independent investigations or candidate solutions and synthesize them into one judged result. Use when parallel agents are authorized by the user or governing instructions and independent investigations materially benefit from them. Do not use for dependent steps or shared mutable state.
---

# Swarm

Follow the governing instructions and the user's requirements for communication, code style, authorization, and delegation. This skill supplies task-specific guidance, not permission to expand the task. Its workflow and output fields describe internal checks and relevant content, not a mandatory response layout or a progress report. When used within broader authorized work, continue that work through completion rather than stopping to deliver this skill's intermediate result.

Use parallel agents to increase coverage or diversity, not to duplicate the same unbounded request.

## Partition

Define the shared question, success criteria, evidence standard, and final decision owner. Divide work into non-overlapping lanes by component, hypothesis, source class, risk category, or candidate approach. Resolve shared contracts before fan-out.

## Dispatch

Give each worker a bounded brief with its lane, exclusions, output schema, and stopping condition. Use the smallest number of workers that covers the independent lanes. Do not let multiple workers edit the same files or state.

## Drain

Collect all results before synthesis unless one result proves that the remaining work is unnecessary. Track missing or failed lanes. Do not hide disagreement between workers.

## Judge

Compare evidence, reconcile duplicates, explain conflicts, and select a conclusion or base candidate. The primary agent remains responsible for integration and final verification.

## Boundaries

Use parallel agents only when the user or governing instructions authorize them and collaboration tools are available. This skill does not itself grant that authorization. Respect a request to work personally without subagents. Do not ask again when delegation is already authorized. Otherwise work locally without claiming independent review.
