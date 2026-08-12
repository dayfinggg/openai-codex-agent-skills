# Measurement and Benchmarking

Use this reference to design measurements that can support a performance decision.

## Define the performance question

Specify one primary outcome and the workload that produces it. Include input sizes and distributions, concurrency, request mix, dataset state, cache state, duration, and arrival pattern where relevant. Record hard constraints such as memory limits, response-time objectives, compatibility, correctness, and cost ceilings.

Choose a metric that represents the requested outcome:

| Concern | Primary evidence | Useful supporting evidence |
| --- | --- | --- |
| Latency | elapsed-time distribution; p50, p95, or p99 | CPU time, wait time, queue depth |
| Throughput | completed work per unit time | utilization, saturation, errors, backpressure |
| Memory | peak or steady resident/working set | retained heap, allocation rate, GC pauses |
| I/O | bytes or operations per unit time and wait time | syscall, disk, network, cache, and queue counters |
| Startup | time to usable state | import, initialization, class loading, parsing, and connection phases |
| Cost | cost per successful request, job, or data unit | compute time, storage, transfer, external calls |

Use current provider prices when cost depends on an external service. State the price date and separate measured resource consumption from the price calculation.

## Control the experiment

- Build and run the same artifact type, optimization level, runtime, configuration, dependency set, dataset, and service tier before and after the change.
- Isolate unrelated load where possible. Record unavoidable background activity, shared infrastructure, power mode, thermal behavior, and autoscaling.
- Decide whether the target workload is cold, warm, or steady state. Do not hide startup or cache-fill cost when users experience it.
- Warm up runtimes with JIT compilation, lazy initialization, adaptive optimization, or caches until behavior stabilizes, unless cold behavior is the target.
- Run enough independent trials to expose normal variation. Randomize or alternate before/after order when drift could bias results.
- Preserve raw results and the exact invocation. Prefer repository-native benchmark tools and machine-readable output.

## Compare results

Report the baseline and changed result in the original units. Include the absolute difference and relative percentage, but do not substitute percentages for scale. Use medians and relevant percentiles for skewed latency data; include dispersion or confidence intervals when the tool supports them.

Inspect the distribution rather than selecting the fastest trial. Treat overlapping noisy results as inconclusive. Investigate outliers instead of deleting them unless a documented external cause invalidated the run.

For microbenchmarks, confirm that the compiler or runtime cannot eliminate the measured work and that setup cost is either intentionally included or kept outside the timed region. Use end-to-end measurements to verify that a microbenchmark improvement affects the user-visible workload.

## Set regression controls

Create a performance test only when it is reproducible in its execution environment. Select a threshold above observed noise and below the smallest regression that matters. Prefer relative comparisons against a local baseline when shared hosts make absolute timing unstable. Keep slow load or soak tests in an environment designed for them rather than making ordinary unit tests flaky.

Record the workload, environment, sample count, warm-up policy, metric, threshold, and failure interpretation beside the regression control. A failed performance threshold is evidence to investigate, not proof of a specific cause.
