# Property-based and mutation testing

Use this reference when example tests do not cover a useful range of inputs or when the suite may not detect realistic implementation mistakes. Prefer the property-testing or mutation tool the repository already uses.

## Property-based tests

- Assert the strongest useful property, such as round-trip behavior, equivalence to a trusted reference, idempotence, preserved invariants, or a documented error for invalid input.
- Generate valid values directly instead of discarding most cases with assumptions or filters. Pin important edge cases so they are always exercised.
- Keep expected results independent of the implementation. A test that repeats the same algorithm is unlikely to catch its defect.
- Record the seed and minimized counterexample from a failure so the test can be reproduced.
- Classify a failing case against the documented contract, generator preconditions, types, and implementation before changing code.

## Mutation tests

- Limit mutation runs to relevant production code during development. Exclude tests, mocks, generated files, and vendored code.
- Treat a surviving mutant as a prompt to inspect reachability and observability. Add an assertion only when it protects a documented behavior.
- A timeout is inconclusive. Check a mutant for equivalence before treating its survival or removal as a test result.
- Review the mutation tool's configuration and report against the installed version. Diff-based modes can miss non-code dependencies or tests-only changes.
- Reserve broad mutation campaigns for a project gate, release, or a specifically requested coverage investigation. They are not a routine requirement for a small code change.
