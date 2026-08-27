---
name: performance
description: Diagnose and improve measured software performance with representative workloads, profiling, controlled experiments, and regression proof. Use for latency, throughput, CPU, memory, I/O, database, web, capacity, or performance-test work; do not use for speculative optimization or routine cleanup without evidence of a bottleneck.
---

# Performance

Optimize only a measured bottleneck. Preserve correctness, security, durability, compatibility, and user-visible behavior. A faster wrong result is a regression.

## Define The Performance Contract

1. Name the user flow, operation, endpoint, job, or workload that is too slow or too expensive.
2. Define one primary outcome metric and the guardrail metrics that must not regress. Use latency percentiles, throughput, completion time, allocation rate, memory, CPU, I/O, cost, Core Web Vitals, errors, or saturation only when they match the actual problem.
3. State the target population, data size, request mix, concurrency, device, network, runtime, configuration, cache state, and warm or cold conditions.
4. Set the required improvement or performance budget before changing code. Separate an absolute requirement from a relative comparison.
5. Record correctness invariants and existing tests that the optimization must preserve.

If the complaint is vague, reproduce and measure it before proposing a fix. If no material bottleneck or missed budget is found, report that result instead of manufacturing an optimization.

## Establish A Representative Baseline

Run the narrowest workload that still represents the real problem. Prefer production telemetry or a faithful replay over synthetic convenience. Use realistic data volume, cardinality, skew, payloads, user flows, arrival pattern, and dependency behavior.

Record the code revision, runtime and dependency versions, build mode, hardware, operating system, power settings, container limits, database statistics, configuration, background load, and commands. Warm up JITs, pools, caches, and adaptive systems when steady-state behavior matters; measure cold behavior separately when users experience it.

Collect the primary metric as a distribution, not only a mean. For services, normally include request rate, error rate, p50, p95, p99 or the relevant tail, and saturation. Separate successful, failed, retried, cached, uncached, warm, and cold paths when combining them would hide the problem.

Read [measurement and experiments](references/measurement.md) only when designing or interpreting profiles, benchmarks, load tests, statistical comparisons, budgets, or regression gates.

## Attribute The Bottleneck

Trace the critical path end to end and determine where elapsed time or resources are actually spent. Distinguish CPU execution, allocation or garbage collection, lock or scheduler delay, queueing, filesystem or network I/O, remote calls, database work, serialization, rendering, and client-side main-thread work.

Use the profiler or tracing tool that observes the suspected resource. Profiling identifies where work occurs; benchmarking measures how much and whether a change helped. Do not treat profiler timings as benchmark results, or a microbenchmark as proof of end-to-end improvement.

Static complexity analysis can expose scaling risks, but validate the suspected growth with representative input sizes. Do not optimize a cheap function merely because it looks inefficient if it contributes negligible total cost.

Read [bottleneck playbook](references/bottlenecks.md) only after evidence classifies the bottleneck as algorithmic, CPU, allocation, I/O, concurrency, database, cache, web, or capacity related.

## Run A Controlled Experiment

Form one falsifiable hypothesis that links a profile observation to the primary metric. Make the smallest change that can test it. Avoid unrelated refactoring so the effect remains attributable.

Do not skip required validation, reduce durability, weaken consistency, remove security checks, hide errors, lower output quality, or silently change semantics to win a benchmark. Treat batching, caching, concurrency, pooling, compression, denormalization, approximation, and precomputation as trade-offs that need explicit correctness and resource limits.

Use a real benchmark harness for hot-path microbenchmarks. Ensure the result is consumed, setup is outside the measured region, compiler elimination is prevented, warm-up is adequate, allocation and garbage collection behavior remain representative, and the benchmark process is isolated. A tiny benchmark is justified only after broader evidence identifies that code as material.

## Prove The Improvement

1. Run correctness and regression tests before comparing speed.
2. Compare baseline and candidate with the same representative workload and controlled environment. Interleave or randomize runs when environmental drift is plausible.
3. Repeat enough times to expose variance. Preserve raw samples or machine-readable results, not only a rounded summary.
4. Report baseline, candidate, absolute and relative change, percentiles or distribution, throughput, errors, resource use, sample count, variance, and environment.
5. Reject the change when the improvement is within noise, appears only in an irrelevant microbenchmark, shifts cost to an unmeasured resource, worsens tail latency or errors, or disappears at realistic scale.
6. Re-profile after the change. Confirm that the measured bottleneck moved or shrank and identify any new limiting resource.

When production behavior can differ materially, use a bounded canary, shadow workload, or real-user measurement only within existing authorization and safety controls.

## Prevent Regressions

Add a performance test or budget only when the workload is stable, representative, affordable, and sufficiently low-noise for automation. Prefer absolute user-facing budgets for requirements and relative comparisons for regressions. Use tolerance based on observed variance, not an arbitrary percentage.

Store the workload, dataset generator or fixture, command, environment metadata, and machine-readable baseline with the project when they are needed for repeatability. Do not make every microbenchmark a blocking CI gate. Periodic controlled benchmarks are often more reliable than noisy per-commit runs.

## Final Audit

Reject the optimization if any answer is no:

1. Is the target tied to a real user, business, capacity, or cost outcome?
2. Is the workload representative of the problem and large enough to expose its scaling behavior?
3. Does evidence identify this code or dependency as a material bottleneck?
4. Does the experiment change one attributable factor while preserving correctness?
5. Was the candidate compared with the baseline under equivalent conditions?
6. Is the improvement larger than measurement noise at the metric and percentile that matter?
7. Are errors, tail latency, allocations, CPU, memory, I/O, and downstream effects accounted for where relevant?
8. Can another engineer reproduce the result from the recorded command, workload, and environment?
