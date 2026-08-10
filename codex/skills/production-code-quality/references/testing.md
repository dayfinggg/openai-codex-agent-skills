# Testing strategy

Load this reference when selecting or changing the project's test strategy, not for every trivial edit.

Map each risk to the cheapest test level that can observe it reliably. Use unit tests for local behavior, integration tests for component boundaries, contract tests for independently evolving interfaces, end-to-end tests for critical user journeys, and property or fuzz tests for broad input spaces and invariants.

Prefer observable behavior and public contracts over implementation structure. Exercise the material boundary values, failure paths, invariants, and regression cases at the narrowest reliable seam. Keep fixtures minimal and meaningful, isolate nondeterminism, control time and external state, and make failures diagnostic. Avoid coupling tests to incidental implementation details or duplicating coverage that adds cost without distinguishing a new risk.

For a reproducible defect, add a focused regression test before the fix when the repository has a suitable seam and doing so is practical. Confirm that it detects the intended failure rather than setup or an unrelated defect. For migrations and compatibility, test both transition and steady states. Measure coverage only as a gap-finding signal; a percentage is not evidence that important behavior is correct.
