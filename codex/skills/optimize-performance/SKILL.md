---
name: optimize-performance
description: Measure and improve performance with reproducible baselines and profiling. Use for latency, throughput, CPU, memory, I/O, startup, scale, or cost. Exclude correctness bugs and architecture without measurable targets.
---

# Optimize Performance

Optimize measured behavior for a defined workload while preserving correctness and operational constraints. Prefer the smallest change supported by evidence; do not claim an improvement that was not measured.

## Workflow

1. Define the workload, environment, primary metric, constraints, and success threshold. Use a verified service objective or user requirement when one exists. Otherwise derive thresholds only after measuring normal variance; do not invent a percentage, noise allowance, or rollback limit.
2. Establish a reproducible baseline before editing. Record the build, runtime, dependencies, hardware or service tier, configuration, dataset, command, warm-up policy, trial count, metric distribution, and correctness result.
3. Profile the workload with evidence suited to the symptom. Separate wall time from CPU time, useful work from waiting, averages from tail behavior, retained memory from allocation rate, and application cost from external-service cost. Account for instrumentation overhead.
4. Rank bottlenecks by their contribution to the target metric. Form a falsifiable hypothesis and identify the observation that would confirm or reject it.
5. Change one causal factor at a time. Keep the change local, reversible, and compatible with project conventions. Avoid speculative caching, concurrency, batching, indexes, or architecture changes when the measured bottleneck does not justify them.
6. Repeat the benchmark under equivalent conditions. Compare absolute values, relative change, dispersion, and tail percentiles where relevant. Treat changes within measurement noise as inconclusive.
7. Validate outputs, tests, concurrency behavior, memory lifetime, failure handling, and resource limits. Check that improvement in the primary metric did not cause unacceptable regressions elsewhere.
8. Add a regression guard only when the measurement is stable enough to enforce. Set thresholds outside normal noise and document the workload and environment required to reproduce them.
9. Report the workload, baseline, profile evidence, change, after-result, variance, tradeoffs, validation, and remaining uncertainty. State plainly when no reliable improvement was demonstrated.

## Evidence selection

Read [measurement-and-benchmarking.md](references/measurement-and-benchmarking.md) before defining any benchmark, comparison, success threshold, regression guard, or rollback threshold.

Read [bottleneck-evidence.md](references/bottleneck-evidence.md) before selecting or claiming a bottleneck, even when traces or counters already suggest a likely cause.

## Boundaries

- Keep functional debugging in the debugging workflow unless a reproducible performance symptom is the primary failure.
- Keep system decomposition and long-term architecture choices in the architecture workflow unless a measured bottleneck requires evaluating a specific structural change.
- Do not replace project benchmarks, profilers, or observability with a preferred tool without evidence that the existing setup is inadequate.
- Do not tune synthetic microbenchmarks at the expense of end-to-end behavior.
- Do not infer production gains from debug builds, tiny datasets, single runs, or unmatched environments.
