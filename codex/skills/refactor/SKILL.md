---
name: refactor
description: Simplify code while preserving behavior and public contracts when restructuring is requested. Skip incidental cleanup during unrelated feature work.
---

# Refactor

Improve the shape of the code without changing its contract.

## Establish the invariant

Identify the observable behavior, public interfaces, performance constraints, and compatibility properties that must remain unchanged. Establish a passing focused test or another reliable baseline before editing.

## Find the complexity

Locate duplicated decisions, scattered state, shallow wrappers, hidden mutation, misleading names, weak types, and boundaries that force readers to cross many files. Prefer deletion, consolidation, and narrower interfaces over new layers.

## Change incrementally

Group coherent structural edits and check behavior at meaningful boundaries. Preserve callers unless an interface migration is authorized. Clarity improvements or dead-code removal belong only in the requested refactor's scope. Avoid unrelated formatting, features, and adjacent cleanup.

## Verify

Compare behavior and public surfaces before and after. Inspect the diff for accidental semantic changes and run broader checks based on the affected dependency graph.

## Output

Report the structural problem removed, the invariant preserved, the material simplification, and the evidence that behavior did not change.
