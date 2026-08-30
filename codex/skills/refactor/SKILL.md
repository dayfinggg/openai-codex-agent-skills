---
name: refactor
description: Simplify existing code, improve module depth, or reduce reader load while preserving observable behavior. Use when the user explicitly requests restructuring or when a behavior-preserving cleanup is the task. Do not activate for ordinary feature work that merely touches imperfect code.
---

# Refactor

Improve the shape of the code without changing its contract.

## Fix the invariant

Identify the observable behavior, public interfaces, performance constraints, and compatibility properties that must remain unchanged. Establish a passing focused test or another reliable baseline before editing.

## Find the load

Locate duplicated decisions, scattered state, shallow wrappers, hidden mutation, misleading names, weak types, and boundaries that force readers to cross many files. Prefer deletion, consolidation, and narrower interfaces over new layers.

## Change incrementally

Make one structural move at a time and rerun the focused checks. Preserve callers unless the request includes an interface migration. Do not mix unrelated formatting or feature changes into the refactor.

## Verify

Compare behavior and public surfaces before and after. Inspect the diff for accidental semantic changes and run broader checks based on the affected dependency graph.

## Output

Report the structural problem removed, the invariant preserved, the material simplification, and the evidence that behavior did not change.
