---
name: writing-tests
description: Writes and reviews automated tests test-first in the project's test framework. Use when writing, changing, or reviewing tests, fixing a bug in a tested project, or adding behavior tests should cover.
---

# Writing tests

Test code gets the same care as production code, and the writing-clean-code skill covers code-level rules. The project's framework, layout, naming, and run command come first.

## Test first

Use red, green, refactor for new logic and bug fixes when the project has a test suite, unless the user asks for another workflow. Write the smallest test that fails, where a compile error counts, then only enough code to pass it, then clean up with all tests green. Run the tests after each step. As tests get more specific the code gets more generic, so a new test is answered with general logic, never with an `if` for that exact input. For a bug, first write a test that reproduces it and watch it fail for the right reason.

## Shape of a test

- Arrange, act, and assert, separated by blank lines, with noisy setup behind named helpers or builders.
- One concept per test, named after the situation and the result, as in `rejects_order_without_items`.
- No loops, branches, sleeps, or shared mutable state. Tables of cases use the framework's parametrization.
- Test through the public interface and assert on what a caller can see. When a small refactor breaks many tests, narrow the test API instead of mirroring production classes.
- Follow framework idioms, such as Go `t.Run` subtests with `errors.Is` instead of error strings, C# names like `Method_Scenario_ExpectedResult`, Rust `#[should_panic]` only for panics that are the contract, and mocks reset between Jest or Vitest tests.

## Test doubles

Replace only what is slow, nondeterministic, or outside the process, such as network, database, clock, randomness, file system, and third-party services. Prefer hand-written stubs, spies, and fakes to mocking frameworks, because they read better and do not lock tests to call sequences, unless the project already uses a mocking library. Verify interactions only at architectural boundaries. Double only interfaces you own, so wrap a third-party API and cover the wrapper with an integration test. A fake that grows logic gets its own tests.

## What to test

- Every business rule and branch with a different outcome, edge values such as empty, zero, negative, maximum, missing, and malformed, and error paths with the message or type the caller relies on.
- Negative tests for misuse and attacks, which the OpenSSF Concise Guide counts as part of automated testing. Cover denied access to another user's object and to privileged functions, malicious input at each sink (HTML, file path, command, URL, query), error responses free of stack traces and internals, rollback after a failure halfway, and CR and LF in logged values.
- Adapters with a few integration tests against the real technology.
- Skip trivial getters, framework code, and generated code.

## Integrity

A failing test is fixed by fixing the code. Weakening, skipping, or deleting it to make a change pass is off limits, and a test that looks wrong is reported with the reason. Production code holds no test-only branches or hard-coded expected values. Every new test is seen failing before it passes, so for existing code break the code briefly or assert against a wrong value. Run the relevant tests, then the full suite when it is fast enough.
