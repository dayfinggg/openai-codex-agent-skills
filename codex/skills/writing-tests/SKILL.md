---
name: writing-tests
description: Writes and reviews automated tests test-first, in each language's test framework. Use when writing, changing, or reviewing tests, fixing a bug in a project with tests, or adding behavior that tests should cover.
---

# Writing tests

Tests are what make code safe to change. Martin's rule is that test code is as important as production code, so it gets the same care for names, structure, and simplicity. Code-level rules live in the writing-clean-code skill.

## Test-driven development

Use the test-first cycle for new logic and for bug fixes when the project has a test suite, unless the user asks for a different workflow.

1. **Red.** Write the smallest test that fails for the next piece of behavior. A compile error counts as failing.
2. **Green.** Write only enough production code to make that test pass.
3. **Refactor.** Clean up production and test code while all tests stay green.

Work in small steps and run the tests after each one. As the tests get more specific, the code gets more generic, so never answer a new test with an `if` for that exact input. If the code only passes by special-casing test data, the design is wrong.

For a bug fix, first write a test that reproduces the bug and watch it fail for the right reason, then fix the code.

## What makes a test clean

- **Readable.** A test reads as a short story in three parts, arrange, act, assert, separated by blank lines. Hide noisy setup behind well-named helpers or builders.
- **One concept per test.** Several asserts are fine when they check one behavior. Split tests that check unrelated things.
- **Named after behavior.** The name states the situation and the expected result (`rejects_order_without_items`), not the method under test (`test_process`).
- **No logic.** No loops or branches inside a test. Use parametrized tests for tables of cases.
- **F.I.R.S.T.** Fast, independent of each other and of order, repeatable in any environment, self-validating with a clear pass or fail, and written in time, together with the code.

## Coupling between tests and code

- Test behavior through the public interface, not private methods or internal state.
- Do not mirror production structure one test class per production class. When a small refactor breaks many tests, the tests are coupled to structure, and the fix is a narrower test API.
- Assert on outcomes the caller can see, such as return values, state through public queries, and calls that cross a boundary.

## Test doubles

Replace only what is slow, nondeterministic, or outside the process (network, database, clock, random, file system, third-party services). Keep the code under test real.

Prefer simple hand-written stubs, spies, and fakes over mocking frameworks, because they are easier to read and do not lock tests to call sequences. When the project already uses a mocking library, follow its conventions. See [references/test-doubles.md](references/test-doubles.md) for the kinds of doubles and when to use each.

## What to test

- Every business rule and every branch with a different outcome.
- Edge values such as empty, one, many, zero, negative, maximum, missing, and malformed input.
- Error paths, including the message or type the caller relies on.
- Misuse and attack cases as negative tests, which the OpenSSF Concise Guide counts as part of automated testing. Cover denied access to another user's object and to privileged functions, malicious input at each sink the code reaches (HTML, file path, command, URL, query), error responses that must not contain stack traces or internal details, rollback when a multi-step operation fails halfway, and CR and LF in values that get logged. The writing-secure-code skill lists the sinks.
- Adapters with a few integration tests against the real technology, such as a test database or a local server.
- Skip trivial getters, framework code, and generated code.

## Integrity rules

- Never weaken, skip, or delete a failing test to make a change pass. If a test looks wrong, say so and explain why.
- Never put test-only branches or hard-coded expected values in production code.
- A test that cannot fail is worthless. When adding a test for existing code, break the code briefly or check the assertion against a wrong value to confirm the test can fail.

## Workflow

1. Find the project's test framework, layout, naming, and run command before writing tests.
2. Write or update tests using the TDD cycle above.
3. Run the relevant tests, then the full suite when it is fast enough, and fix failures.
4. Review the tests against the checklist below.

## Checklist

- [ ] Each test name states the behavior and the expected result
- [ ] Each test checks one concept with arrange, act, assert
- [ ] No loops, branches, sleeps, or shared mutable state in tests
- [ ] Doubles replace only slow or external dependencies
- [ ] Tests use the public interface and survive refactoring
- [ ] Edge cases and error paths are covered
- [ ] Code at trust boundaries has negative tests for denied access and malicious input
- [ ] Every new test was seen failing before it passed
- [ ] The whole suite passes

## Reference files

Read them before writing the first test, the framework section for the language at hand and the examples file, and the test doubles file when a dependency has to be replaced.

- [references/test-doubles.md](references/test-doubles.md) defines dummy, stub, spy, mock, and fake, with guidance on choosing.
- [references/frameworks.md](references/frameworks.md) has conventions for pytest, Jest and Vitest, JUnit 5, xUnit and NUnit, Go, and Rust.
- [examples.md](examples.md) has illustrative good and bad tests.
