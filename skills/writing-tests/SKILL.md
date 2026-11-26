---
name: writing-tests
description: Covers what to test and how to write tests that fail for the right reason, including unit, integration, end-to-end and property tests and the handling of failing or flaky ones. Use when the user asks for tests, when adding or changing a test, when changing code in a repository that keeps tests for that kind of code, when fixing a bug that needs a regression test, and when a test fails, is flaky or is slow. Load before a test, a spec or a check script that stays in the project is written or changed, also when the test only reproduces a bug, and before you investigate a failing, flaky or slow test.
---

# Writing tests

A test is worth having when it fails if the behaviour breaks and passes when the code is only rearranged. Write tests where the user asks for them or where the repository already keeps tests for this kind of change.

## Fit the repository

Read two or three existing test files first. Use the same runner, the same folder and file naming, the same helpers and fixtures, and the same style of assertion. Run one existing test before you add yours, so that you know the suite works here.

## What to test

Test behaviour through the public interface, which means the inputs a caller gives and the results or effects the caller sees. A test that checks private functions or the order of internal calls breaks on every refactor and catches nothing.

Cover the main path, the boundaries and the failures. Boundaries are the empty input, one element, the largest allowed value, and the value just past it. Failures are the invalid input and the error the code should raise for it.

For a bug fix, write the test that fails without the fix, watch it fail, then apply the fix and watch it pass. A test that was never seen failing may be testing nothing.

## Shape of a test

One test checks one behaviour, and its name says which, in the form the suite already uses. The body has three parts, which set up the input, run the code and check the result. Keep logic out of tests. A loop or a condition in a test is a place for the test itself to be wrong.

Assert on exact values. `assert result == 4` catches more than a check that the result is truthy or not empty.

Each test builds what it needs and leaves nothing behind. Tests that share state pass or fail by the order they run in.

## Doubles

Use the real thing where it is fast and deterministic. Replace only what crosses a boundary, such as the network, the clock, randomness, the file system when it is slow, and services you do not own. Prefer a small fake with real behaviour to a mock that only records calls, and do not mock the code under test.

## Stronger kinds

Where a function has a rule that holds for every input, such as "decoding an encoded value gives the original", write a property test with the library the language has, for example Hypothesis in Python or fast-check in TypeScript and JavaScript.

When code replaces older code, run both on the same inputs and compare the results.

## Failing and flaky tests

A failing test is information. Find out whether the code or the test is wrong, and change that one. Do not delete an assertion, loosen it, skip the test or mark it as expected to fail to get a green run.

A flaky test has a cause, usually time, ordering, shared state or a real network call. Find it by running the test alone and in a loop. A retry or a sleep hides it.

## Check

Run the new tests alone, then the whole suite. Break the code on purpose once to see that the new test fails, and restore it.

## Report

Say how many tests you added, which behaviours they cover and how you ran them, in two or three sentences of prose. Do not list the tests one by one.

## Related skills

Load `clean-code` for the code under test when you change it, and `verifying-work` before you report.
