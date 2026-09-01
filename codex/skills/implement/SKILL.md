---
name: implement
description: Make an authorized code or configuration change from a settled request, specification, or task. Use when the user asks to build, fix, add, or change something and the implementation scope is clear. Do not use for diagnosis-only, review-only, or planning-only requests.
---

# Implement

Deliver the requested behavior with the smallest coherent change and evidence that it works.

## Prepare

Read the governing instructions, target files, relevant tests, and one local precedent. Restate the required outcome internally and identify the narrowest verification that can prove it. Ask only if a missing decision would materially change behavior or risk.

When progress depends on another subsystem or owner, locate the owning code, documentation, or person early. Ask one concise question with the observed evidence, required decision, and expected outcome, then record the answer instead of spending days reverse-engineering an unavailable contract in isolation.

Distinguish an estimate from a commitment. Before committing to a date or irreversible scope, expose material uncertainty, external dependencies, and assumptions. Commit only to actions within the task's control, and define the next checkpoint when evidence is still incomplete.

## Change

Preserve user work and repository conventions. Before writing custom code, check whether no change is needed, the behavior already exists in the codebase, the standard library or native platform covers it, or an already-installed dependency solves it. Use the first option that completely satisfies the current requirements. Add a new dependency only when its current benefit outweighs its ownership, update, compatibility, and security costs. Keep the patch focused, update all affected callers, and avoid compatibility layers that the request does not require. Do not refactor adjacent code unless it is necessary for correctness.

Raise an early warning as soon as evidence invalidates the forecast or required scope. Negotiate scope, priority, sequencing, or a safe fallback instead of promising to "try" without a credible path. Schedule pressure does not justify silently dropping required tests, review, migration safety, or structural safeguards.

Run safe independent reads and checks efficiently. Continue through ordinary in-scope external writes, commits, pushes, and deployments when the user or trusted project rules authorize the workflow. Stop only before a genuinely dangerous action that lacks exact authorization, a purchase, or a material scope expansion.

Integrate in small working increments when the change spans several units. Treat strict compiler, linter, analyzer, and warning diagnostics as feedback to resolve or narrowly justify, not output to suppress broadly. Do not optimize without a relevant baseline and profile, and remeasure after any performance-motivated change.

When changing build, configuration, deployment, or supply-chain behavior, version and review the configuration, bind provenance to the exact artifact, pass through one enforceable deployment policy, stage the rollout, observe the result, and preserve a tested rollback. Use the normal mechanism with an explicitly accelerated policy for emergencies rather than an untested alternate path. Audit break-glass use immediately and assign removal of any temporary bypass.

## Verify

Run the most relevant focused tests first, followed by broader checks in proportion to risk. Inspect the actual diff and exercise the real behavior when feasible. Treat a passing build as insufficient when the feature can be observed directly.

## Finish

Report the behavior delivered, material files changed, verification performed, and any limitation or skipped check. Never claim completion when required evidence is missing.
