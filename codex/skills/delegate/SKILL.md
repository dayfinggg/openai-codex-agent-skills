---
name: delegate
description: Coordinate Codex subagents for complex work that divides into independent, valuable workstreams. Use for parallel research, isolated verification, competing hypotheses, or disjoint implementation where delegation materially improves speed or quality; do not use for quick, tightly coupled, sequential, or same-file work.
---

# Delegate

Keep the parent agent responsible for scope, integration, validation, and the final answer. Delegate only work that remains useful when completed independently.

## Delegation Gate

Delegate a subtask only when all of these are true:

1. It has a bounded deliverable that can be evaluated independently.
2. It has no unresolved dependency on another concurrently running subtask.
3. Parallelism, context isolation, specialized investigation, or an independent check is worth the coordination and token cost.
4. Its tools, permissions, data access, and write scope are sufficient and safe.

Keep the work in the parent when it is a quick change, a single ordered reasoning chain, dominated by one external wait, requires frequent parent decisions, or would make agents contend over the same mutable resource.

## Decompose Before Spawning

1. State the final acceptance criteria.
2. Map work as a small dependency graph. Mark each node ready, blocked, or owned.
3. Combine tiny tasks whose coordination cost would exceed their value. Split oversized tasks that lack a crisp deliverable.
4. Give every ready node one distinct lane, such as a component, file set, evidence source, review lens, or competing hypothesis.
5. Reserve cross-cutting decisions, shared files, integration, and final validation for the parent.

Start with no more than three active subagents. Scale only when live capacity permits and another independent critical path justifies it. Never spawn agents merely to fill capacity.

## Write-Safety Rules

Prefer read-only delegation for exploration, research, triage, test-output analysis, and review.

For implementation, assign disjoint write ownership before spawning. State the exact files or directories each agent owns and what it must not touch. If two tasks need the same file or shared generated state, run them sequentially, keep that file with the parent, or use isolated worktrees when the environment supports safe integration.

Do not assign overlapping work unless independent replication is intentional. For an intentional second opinion, keep the investigators independent, give them the same evidence and criteria without sharing conclusions, then reconcile their results.

## Delegation Contract

Every spawn prompt must make these points unambiguous:

1. The concrete objective and why this lane exists.
2. The owned scope, permitted side effects, and explicit non-goals.
3. The minimum task-specific context, inputs, constraints, dependencies, and applicable instructions.
4. The required deliverable and acceptance criteria.
5. The evidence to return, including file references, commands, test results, source links, or reproduced behavior as applicable.
6. The stopping condition and any condition that must be escalated instead of guessed.

Use concise, outcome-first prompts. Do not assume a fresh subagent knows the parent conversation, prior tool results, or current file ownership. Include what it needs, but do not copy irrelevant history. Inherit the parent model and reasoning settings unless the user or higher-priority instructions require an override.

Require each agent to return a compact report containing the result, changed files or concrete findings, validation performed with outcomes, and unresolved blockers or risks. Raw logs and long transcripts stay in the subagent unless they are the evidence needed for integration.

## Dispatch And Coordination

Spawn all ready, independent lanes in one wave. Give each agent one primary responsibility. While agents run, the parent should handle integration planning, shared-state work, prerequisites for the next wave, or another non-overlapping lane.

Use the collaboration tools deliberately:

1. Use `list_agents` to inspect capacity or confirm ownership, not as a polling loop.
2. Use `send_message` to steer a running agent or supply missing context without restarting its task.
3. Use `followup_task` for a new bounded action after an agent is idle, especially correction or verification of its own deliverable.
4. Use `interrupt_agent` when work is obsolete, unsafe, conflicting, or materially off course.
5. Use `wait_agent` with a long timeout for completions and mailbox updates. Do not busy-poll.

Do not repeat completed work in the parent or another agent. Before assigning follow-up work, check whether the existing result already satisfies it.

## Dependencies And Waves

Spawn only dependency-ready nodes. When one lane produces input for another, wait for the producer, verify its result, then pass only the necessary output to the consumer. Do not disguise a sequential pipeline as parallel work.

Nested delegation is off by default. Allow one delegated agent to spawn children only when its own lane splits into multiple independent branches, it can keep their write sets disjoint, and it explicitly owns their synthesis. Keep nesting shallow and bounded; never create an unmonitored agent tree.

## Quality Control

Treat every agent report as evidence to inspect, not as proof of completion.

1. Wait for every required lane before synthesizing. An early partial result does not close the task.
2. Check each acceptance criterion against an artifact, cited location, command result, or reproducible observation.
3. Inspect the actual shared files and diff. Re-run proportionate integrated tests or checks from the parent environment.
4. Merge duplicate findings and resolve contradictions by evidence. If a material conflict remains, send a targeted follow-up or use a fresh verifier.
5. For high-risk changes or multi-agent implementation, use an independent read-only verifier with the requirements and final diff, not the implementers' reasoning. Ask it to report only correctness, safety, scope, or acceptance-criteria gaps.
6. Make cross-cutting fixes in one place. Do not let several agents race to repair the same issue.

The parent owns the final synthesis. Preserve material caveats and provenance, but return one coherent result rather than concatenated agent reports.

## Failure And Escalation

If an agent lacks context, send the smallest missing input. If it is on the wrong path, steer it once with a concrete correction; interrupt and reassign or complete locally if the correction fails. Retry a transient failure only when the cause changed or the retry has a reasonable chance to succeed.

When capacity is exhausted, wait for a useful lane to finish instead of repeatedly spawning. When required information, authorization, or a material choice is missing, use the available question tool. Delegation never expands the user's scope or permissions, and a subagent must not perform an external or destructive action the parent is not authorized to perform.

Finish only after the parent has reconciled all required results, verified the integrated state, and accounted for every acceptance criterion.
