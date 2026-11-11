<overview>
Read this file when a test passes and fails without a code change. It covers how to prove the flakiness, find its cause, and verify the fix. A test that fails every time is a real bug or regression, so use the `debugging` skill for it instead. The `verification` block of the coding instructions already rules out retries, longer timeouts, and skips as fixes.
</overview>

<detect>
Prove flakiness with repeated runs, because a test is not flaky just because someone says so. Run each suspect test at least 20 times. Run it alone and also in the full suite in parallel. Order and concurrency failures show up only one way.

Record a failure rate for each suspect test. Check existing `retry`, `flaky`, and `skip` markers, and the CI history if you can reach it. These commands repeat and shuffle tests.

| Runner | Repeat | Random order |
|---|---|---|
| Jest | A shell loop over `npx jest <file>` | `--randomize --seed=<n>` |
| Vitest | `vitest run --repeats=20` | `--sequence.shuffle.files --sequence.shuffle.tests` |
| pytest | `--count=20` with `pytest-repeat` | `pytest-randomly`, and `-p no:randomly` to compare |
| Go | `go test -count=20` | `-shuffle=on`, plus `-race` for data races |
| Playwright | `--repeat-each=20` | `--shuffle` from 1.64, which prints its seed, and `--fail-on-flaky-tests` in CI |

Note the seed of each failing shuffled run, so you can replay the exact order.
</detect>

<root_causes>
Diagnose the cause from evidence, and do not guess. These causes are the common ones.

| Cause | Sign | Fix |
|---|---|---|
| Test order or shared state | Passes alone and fails in the suite, or the reverse | Isolate the state, and reset it between tests |
| Time or clock | Fails near midnight, at a DST change, or under load | Use fake timers or inject a clock, with no real sleep |
| Async race or missing await | Fails under parallel runs or on slow CI | Await the actual condition, with no fixed timeout |
| Randomness | Fails at some rate with no pattern | Seed the random generator, and fix the seed in tests |
| Network or external I/O | Fails offline or on slow links | Mock or stub the boundary |
| Unordered collections | Fails on map or set iteration order | Sort before you assert |
| Resource leak or port reuse | Fails on repeated or parallel runs | Use unique resources, and clean them up |
</root_causes>

<product_races>
A flaky test sometimes means the code has a race, not the test. Do not make such a test stable in a way that hides a real concurrency bug. Report it to the user as a possible product bug, and fix the code when the user agrees.
</product_races>

<fix_and_verify>
Fix the cause, then prove the fix.
1. Run the test many times again, shuffled and in parallel, and with `-race` in Go. One green run proves nothing, because flakes are random.
2. Remove the `retry`, `skip`, or `flaky` marker that hid the flake once the cause is fixed.
3. Run the full suite, so you know the fix did not break neighboring tests.

A `sleep` that dodges a race slows the suite and still flakes under load. Await the condition instead.
</fix_and_verify>
