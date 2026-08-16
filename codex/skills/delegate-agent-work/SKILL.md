---
name: delegate-agent-work
description: Coordinate subagents for explicit delegation or bounded independent work. Use for parallel streams or author-reviewer handoffs. Exclude other serial or unclear work. Small tasks need an explicit request.
---

# Delegate Agent Work

Keep one accountable coordinator. Delegate separable outcomes, then integrate and verify them centrally.

## Decide Whether to Delegate

1. Honor an explicit request for subagents or broad fan-out within platform, safety, and task-scope limits. This includes a small task when the user explicitly requests delegation; keep the assignment proportional.
2. Otherwise delegate only when at least two bounded workstreams can proceed independently and parallel work materially improves latency, coverage, or independent scrutiny.
3. Work locally when the task is small without an explicit delegation request, ownership cannot be separated, or coordination would cost more than execution. Exclude purely serial work unless it contains a useful bounded handoff, such as an independent author-reviewer pass.
4. Do not assign the parent task unchanged to several agents. Use duplicate attempts only as an intentional evaluation, with independent evidence and distinct review criteria.

Use `$plan-engineering-work` when the work first needs engineering decomposition. Use `$run-agent-evals` for formal behavioral evaluation design. Keep this skill focused on assignment, coordination, integration, and verification.

## Define Assignments

Give each agent one concrete outcome and an explicit return contract. Include only the context required to act correctly:

1. State the owned artifact, question, path, module, or decision.
2. Define success criteria, required evidence, validation, and expected output.
3. State allowed writes, prohibited scope, dependencies, and applicable user or repository constraints.
4. Give one agent exclusive write ownership of each file or overlapping subsystem. Prefer read-only reviewers.
5. Tell every writer that the filesystem is shared and that unrelated or concurrent changes must be preserved.

Do not delegate ambiguous responsibility. Retain cross-cutting decisions, integration, conflict resolution, and final verification at the coordinator.

## Runtime Capability Discovery

Delegation is runtime-dependent. Before assigning work, inspect the current callable capabilities, their schemas, supported models and reasoning settings, lifecycle operations, concurrency limits, and permission or sandbox metadata. Some Codex versions expose versioned multi-agent modes, while others expose a general subagent operation. Do not infer the active mode, field names, or permissions from memory, a different installation, or public API documentation.

Use only the live schema exposed in the current turn. Provide a self-contained launch packet with the task, context, constraints, return contract, and allowed side effects. Pass only fields that the schema accepts. Store the stable identifier returned by the runtime, not a display name. If the user requests a particular model or reasoning level, request it only when the live schema supports it and treat it as unverified until the runtime reports the effective setting. Treat missing metadata as unknown rather than filling it by inference.

Treat a textual instruction such as “read-only” as an assignment constraint, not as technical permission enforcement. Use a runtime-provided read-only profile or observable sandbox and approval metadata when available. If effective permissions are unknown, do not claim read-only execution and keep the assignment free of side effects. Do not broaden a child agent's permissions without a new authorization. Retain the coordinator's responsibility for external writes, secrets, irreversible changes, and final high-risk decisions.

Keep subagent delegation distinct from creating a user-facing Codex task or thread. Do not replace a subagent with a user-facing task merely because the local delegation capability is unavailable. If no callable delegation capability is exposed, do not invent a call or claim that delegation occurred. Continue the bounded work locally when safe, or report that explicit delegation is unavailable.

Launch independent assignments in one concurrent batch when the runtime permits it. Retain every returned identifier and map it to ownership, dependencies, expected evidence, and state. Use the exposed wait or status operation with a bounded timeout. Verify every requested identifier because a multi-target status update may include only agents that changed state. Do not treat one completed result as completion of the whole batch.

Reuse an existing agent through the exposed follow-up operation when a clarification, missing evidence, or bounded continuation is needed. Queue a message by default and interrupt only for a material scope correction, safety issue, or discovered dependency. After integration, release completed agents through the exposed lifecycle operation so they do not consume concurrency. Do not busy-poll. Use the result interval for non-overlapping coordinator work.

Public API documentation and local Codex wrappers may use different names, schemas, and versioning. Treat public descriptions as conceptual background only. Never claim that a particular version, tool, model, permission, or lifecycle action was used unless the current runtime exposed and confirmed it.

## Coordinate Execution

Launch independent assignments concurrently. Continue useful coordinator work while agents run. Record agent identity, ownership, dependencies, and current state.

Use event-driven or bounded waits. Batch progress checks and wait on current cursors when supported. Do not busy-poll, repeatedly request unchanged status, or confuse commentary with completion. Send follow-up instructions only when scope, evidence, or a discovered dependency materially changes.

For large user-requested fan-out, create one leaf assignment per meaningful independent unit. Introduce domain coordinators only when the number of leaf results would make direct integration unreliable. Do not manufacture duplicate work merely to increase agent count.

Read [coordination patterns](references/coordination-patterns.md) when using three or more agents, separating author and reviewer roles, coordinating research fan-out, or recovering from overlapping edits.

## Protect Shared Work

Inspect relevant working-tree state before integration. Treat unfamiliar changes as user or peer-agent work. Never discard, reset, overwrite, or reformat them to simplify coordination.

If ownership begins to overlap, stop additional writers for that area. Inspect the competing changes, select one integrator, preserve compatible work, and rerun affected validation. When isolation is available, prefer separate worktrees or branches for broad changes, but do not assume isolation in a shared workspace.

Require writers to return changed paths, material decisions, commands run, validation results, and unresolved risks. Require researchers to return source links, supported claims, dates or versions when relevant, and uncertainty.

## Integrate and Verify

Evaluate each result against its assignment before using it. Inspect primary artifacts and evidence instead of trusting completion claims. Reconcile contradictions through source evidence, direct inspection, or a narrowly scoped tie-breaker agent.

Combine compatible results into one coherent outcome. Do not concatenate agent reports or expose internal coordination as the user-facing answer unless requested.

Run independent, proportionate verification after integration. Use an author/reviewer split for high-risk or material changes: the author produces the artifact, the reviewer receives the raw artifact and acceptance criteria without the author's intended answer, and the coordinator adjudicates findings. Treat an agent's own tests as supporting evidence, not sufficient proof of integrated correctness.

Do not treat a delegated review, same-model second pass, or interface test as sufficient evidence for authentication, authorization, secrets, payments, migrations, deletion, privacy, concurrency, external side effects, security-sensitive logic, or regulatory behavior. A bounded read-only review may gather evidence, but the coordinator must inspect primary artifacts and retain final verification against an appropriate source of truth.

Report work as complete only when all required outcomes are integrated, material conflicts are resolved, and final evidence supports the claim.
