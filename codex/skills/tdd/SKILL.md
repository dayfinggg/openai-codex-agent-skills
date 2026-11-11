---
name: tdd
description: Guides test-first work through a failing test and the smallest change that passes it, with tests placed at public seams. Use it before you write a new test for a feature or a bug fix, including a regression test, and when the user asks for test-first work, TDD, or red-green-refactor. The `testing` skill covers which check a change needs and the repair of existing tests.
---

<overview>
TDD is the red-green loop. This skill makes that loop produce tests worth keeping. It covers what a good test is, where tests go, the anti-patterns, and the rules of the loop. Every section applies on every cycle, so consult them before and during the loop, not after.

When you explore the codebase, read `GLOSSARY.md` if it exists. Test names and interface vocabulary then match the project's domain language. Respect the ADRs in the area you touch.
</overview>

<good_test>
Tests verify behavior through public interfaces, not implementation details. The code can change entirely, and the tests should not change with it. A good test reads like a specification. "user can checkout with valid cart" tells you exactly what capability exists. Such a test survives refactors, because it does not care about internal structure.

Read [tests.md](references/tests.md) whole before you write the first test of a task, because it shows the shape a good test takes, and read [mocking.md](references/mocking.md) whole before you add a mock, a stub, or a fake.
</good_test>

<seams>
A seam is the public boundary you test at. It is the interface where you observe behavior without reaching inside. Tests live at seams, never against internals.

Test only at chosen seams. Before you write any test, write down the seams under test. Give each one a one-line note on what it catches and what it misses. Choose the seams and state the choice in the report, and ask the user first only when the choice changes what gets built. You cannot test everything, so choosing the seams up front puts testing effort on the critical paths and complex logic.

When the shape of the interface is in question, such as module depth or seam placement, consult the `design` skill.
</seams>

<anti_patterns>
These three anti-patterns make tests worthless.
- An implementation-coupled test mocks internal collaborators, tests private methods, or verifies through a side channel. Querying the database instead of using the interface is such a side channel. The tell is that the test breaks on a refactor while the behavior stays the same.
- A tautological test has an assertion that recomputes the expected value the way the code does. One example is `expect(add(a, b)).toBe(a + b)`. Others are a snapshot derived by hand the same way, or a constant asserted equal to itself. Such a test passes by construction and can never disagree with the code. Expected values must come from an independent source of truth. Use a known-good literal, a worked example, or the spec.
- Horizontal slicing means writing all tests first and then all the implementation. Bulk tests verify imagined behavior. They test the shape of things instead of user-facing behavior, and they stop reacting to real changes. You also commit to a test structure before you understand the implementation. Work in vertical slices instead, with one test, then one implementation, then a repeat. Each test is a tracer bullet that responds to what the last cycle taught you.
</anti_patterns>

<rules_of_the_loop>
The loop has three rules.
- Red comes before green. Write the failing test first, then only enough code to pass it. Do not anticipate future tests or add speculative features.
- Work one slice at a time, with one seam, one test, and one minimal implementation per cycle.
- Refactoring is not part of the loop. Once a slice is green, tidy only the lines that slice added, and leave wider refactoring to a request from the user.
</rules_of_the_loop>
