---
name: implement
description: Make an authorized code or configuration change from a settled request, specification, or task. Use when the user asks to build, fix, add, or change something and the implementation scope is clear. Do not use for diagnosis-only, review-only, or planning-only requests.
---

# Implement

Follow the governing instructions and the user's requirements for communication, code style, authorization, and delegation. This skill supplies task-specific guidance, not permission to expand the task. Its workflow and output fields describe internal checks and relevant content, not a mandatory response layout or a progress report. When used within broader authorized work, continue that work through completion rather than stopping to deliver this skill's intermediate result.

Deliver the requested behavior with the smallest coherent change and evidence that it works.

## Prepare

Read the governing instructions, target files, relevant tests, and one local precedent. Restate the required outcome internally and identify the narrowest verification that can prove it. Ask only if a missing decision would materially change behavior or risk.

When progress depends on another subsystem, inspect its code and documentation first. Ask the user only for essential information that cannot be inferred. Continue independent authorized work while waiting. Do not contact another person without explicit authorization.

Provide estimates only when requested. Base them on evidence and distinguish uncertainty from a commitment.

## Change

Preserve user work and repository conventions. Before writing custom code, check whether no change is needed, the behavior already exists in the codebase, the standard library or native platform covers it, or an already-installed dependency solves it. Use the first option that completely satisfies the current requirements. Add a new dependency only when its current benefit outweighs its ownership, update, compatibility, and security costs. Keep the patch focused, update all affected callers, and avoid compatibility layers that the request does not require. Do not refactor adjacent code unless it is necessary for correctness.

Do not narrate progress or routine plan changes. Interrupt only when essential user input, required approval, or a blocking condition needs intervention. Preserve the requested scope and required verification.

Run safe independent reads and checks efficiently. Perform external writes, commits, pushes, or deployments only when covered by the active request or existing user authorization. A local edit request does not by itself authorize publication or production changes. Follow governing permission rules without adding redundant confirmation steps.

Integrate in small working increments when the change spans several units. Treat strict compiler, linter, analyzer, and warning diagnostics as feedback to resolve or narrowly justify, not output to suppress broadly. Do not optimize without a relevant baseline and profile, and remeasure after any performance-motivated change.

When release or deployment behavior is in scope, use the project's existing validation, provenance, rollout, and recovery mechanisms appropriate to the affected risk. A small configuration edit does not require designing a new delivery system. Deploy or exercise emergency access only within the user's authorization.

## Verify

Run the most relevant focused tests first, followed by broader checks in proportion to risk. Inspect the actual diff and exercise the real behavior when feasible. Treat a passing build as insufficient when the feature can be observed directly.

## Finish

Report the behavior delivered, material files changed, verification performed, and any limitation or skipped check. Never claim completion when required evidence is missing.
