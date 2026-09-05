---
name: refactor
description: Simplify existing code, improve module depth, or reduce reader load while preserving observable behavior. Use when the user explicitly requests restructuring or when a behavior-preserving cleanup is the task. Do not activate for ordinary feature work that merely touches imperfect code.
---

# Refactor

Follow the governing instructions and the user's requirements for communication, code style, authorization, and delegation. This skill supplies task-specific guidance, not permission to expand the task. Its workflow and output fields describe internal checks and relevant content, not a mandatory response layout or a progress report. When used within broader authorized work, continue that work through completion rather than stopping to deliver this skill's intermediate result.

Improve the shape of the code without changing its contract.

## Fix the invariant

Identify the observable behavior, public interfaces, performance constraints, and compatibility properties that must remain unchanged. Establish a passing focused test or another reliable baseline before editing.

## Find the load

Locate duplicated decisions, scattered state, shallow wrappers, hidden mutation, misleading names, weak types, and boundaries that force readers to cross many files. Prefer deletion, consolidation, and narrower interfaces over new layers.

## Change incrementally

Make one structural move at a time and rerun the focused checks. Preserve callers unless the request includes an interface migration. Do not mix unrelated formatting or feature changes into the refactor.

Within code already touched by the authorized refactor, make a small verified clarity improvement or remove local dead code when doing so reduces reader load. Do not use this as permission for adjacent cleanup or a repository-wide "boy scout" pass.

## Verify

Compare behavior and public surfaces before and after. Inspect the diff for accidental semantic changes and run broader checks based on the affected dependency graph.

## Output

Report the structural problem removed, the invariant preserved, the material simplification, and the evidence that behavior did not change.
