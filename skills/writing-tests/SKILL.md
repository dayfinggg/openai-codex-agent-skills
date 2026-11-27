---
name: writing-tests
description: Covers which behaviour to test and how to write tests that fail for the right reason, across unit, integration, end-to-end and property tests, and how to handle failing or flaky ones. Use when adding or changing tests or specs, when changing code the repository keeps tests for, when a bug fix needs a regression test, and when a test fails or flakes. Use before writing or changing a test or spec, and before investigating a failing or flaky test.
---

# Writing tests

A good test fails when the behaviour breaks and passes when the code is only rearranged.

## Fit the repository

Read two or three existing test files and follow their runner, naming, helpers, fixtures and assertion style. Run one existing test first, so you know the suite works here.

## What to test

- Behaviour through the public interface, meaning what a caller passes in and sees come out, because tests of private functions or internal call order break on every refactor.
- The main path, the boundaries such as empty, one, the maximum and just past it, and the invalid inputs with the error they should raise.
- For a bug fix, write the test first and watch it fail, then fix and watch it pass. A test never seen failing may test nothing.

## Shape

- One behaviour per test, named in the suite's form, with setup, action and assertion in that order.
- Straight-line bodies, because a loop or a condition is a place for the test itself to be wrong. Use the runner's parametrisation for several inputs.
- Exact assertions such as `assert result == 4` in place of truthy or non-empty checks.
- Each test builds what it needs and cleans up, so results do not depend on run order.

## Doubles

Replace only what crosses a boundary, such as the network, the clock, randomness, a slow file system and services you do not own. Prefer a small fake with real behaviour to a mock that only records calls, and keep the code under test real.

## Stronger kinds

A rule that holds for every input, such as "decoding an encoded value gives the original", fits a property test with Hypothesis in Python or fast-check in TypeScript and JavaScript. When new code replaces old code, run both on the same inputs and compare.

## Failing and flaky tests

- Fix the code when a test fails. Change a test only when the requested behaviour makes its expectation outdated, and name that test in the final answer. When a test looks wrong for another reason, stop and show the user why, keeping assertions, skips and expected-failure marks as they were.
- A flaky test usually comes from time, ordering, shared state or a real network call. Run it alone and in a loop to find which, and fix that cause in place of a retry or a sleep.

## Check

Run the new tests alone, then the whole suite. Break the code once on purpose to see the new test fail, then restore it.
