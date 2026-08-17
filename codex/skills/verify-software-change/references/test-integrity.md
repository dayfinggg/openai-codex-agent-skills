# Test Integrity

Passing the available suite is a proxy for the intended outcome. Coding agents can satisfy that proxy without building a general solution, especially when they can read or modify tests and harnesses.

## Inspect for false green

Review every change to tests, fixtures, snapshots, test runners, CI, coverage, lint, types, timeouts, retries, environment detection, and dependency resolution. Look for:

- deleted, skipped, focused, quarantined, or renamed tests that stop running;
- weaker assertions, broader tolerances, replaced exact values, or snapshots accepted without semantic review;
- hardcoded answers, fixture-specific branches, lookup tables, magic constants, or input fingerprints;
- production code that reads test files, expected outputs, snapshots, environment names, stack traces, caller identities, clocks, random seeds, or filesystem paths to recognize evaluation;
- mocks and fakes that bypass the real boundary or reproduce the implementation instead of the contract;
- caught exceptions, forced zero exit codes, mocked assertions, patched runners, empty test discovery, coverage exclusions, or commands that ignore failure;
- longer sleeps, retries, thresholds, or timeouts that reduce detection without addressing nondeterminism;
- generated output or golden files updated by the implementation under test;
- tests that assert existence, call count, or a tautology while missing the requested behavior;
- only happy-path examples, duplicated inputs, no boundary composition, or no negative cases.

Changing a test is legitimate when the requested contract changed or the old test was wrong. Explain the contract change, preserve unrelated coverage, and add evidence that the new oracle rejects incorrect behavior.

## Demonstrate detection power

For a regression, run the new test against the old behavior when feasible. Otherwise temporarily revert the production fix, introduce a controlled mutation, or use a known-invalid implementation and confirm the test fails for the intended reason. Restore the real change before final validation.

Use triangulation: add examples that force a general rule rather than one hardcoded result. Use property tests for invariants, metamorphic tests for relationships between inputs and outputs, fuzzing for parsers and boundaries, contract tests for consumers, and integration tests for real adapters.

Keep some independent cases outside the implementation loop when risk warrants it. Derive them from the specification, another implementation, production examples, or boundary partitions rather than copying visible fixtures. Review the diff and runtime behavior even when held-out tests pass.

## Preserve honesty

If a requirement is impossible, contradictory, or not verifiable in the environment, report it. Do not redefine success, hide the missing evidence, or alter the evaluator. A failing honest check is more useful than a fabricated pass.

Primary sources:

- [OpenAI monitoring reasoning models for misbehavior](https://cdn.openai.com/pdf/34f2ada6-870f-4c26-9790-fd8def56387f/CoT_Monitoring.pdf)
- [OpenAI and Anthropic safety evaluation findings](https://openai.com/index/openai-anthropic-safety-evaluation/)
- [OpenAI on limitations in SWE-bench Verified](https://openai.com/index/why-we-no-longer-evaluate-swe-bench-verified/)
- [SpecBench](https://arxiv.org/abs/2605.21384)
- [EvilGenie reward-hacking benchmark](https://arxiv.org/abs/2511.21654)
- [Google DeepMind on specification gaming](https://deepmind.google/blog/specification-gaming-the-flip-side-of-ai-ingenuity/)
- [Anthropic on reward hacking in programming tasks](https://www.anthropic.com/research/emergent-misalignment-reward-hacking)
