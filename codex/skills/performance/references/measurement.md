# Measurement And Experiments

Read this reference only when designing or interpreting profiles, benchmarks, load tests, statistical comparisons, performance budgets, or regression gates.

## Choose Evidence By Question

Use production metrics and traces to find user impact and common expensive paths. Use a profiler to attribute CPU, allocation, blocking, I/O, query, or rendering cost. Use an end-to-end benchmark to measure a user flow. Use a microbenchmark only to isolate a previously proven hot path. Use a load test to characterize behavior as demand, concurrency, or duration changes.

Profilers add overhead and can distort timings. Use them to rank cost and call paths, then measure the candidate without profiling. Collect different high-overhead profiles separately when one profiler perturbs another.

## Control The Comparison

Keep baseline and candidate on the same code inputs, environment, build mode, runtime, dependencies, configuration, data, cache state, and resource limits. Use optimized release builds without a debugger. Record CPU model, core count, memory, storage, OS, power mode, container limits, compiler, runtime, and background load.

Account for JIT compilation, adaptive optimization, garbage collection, pool creation, filesystem and database caches, connection establishment, and CPU frequency changes. Warm up only when steady state is the target. Cold start, first request, cache miss, and recovery behavior require separate measurements.

Use multiple independent runs. Randomly interleave baseline and candidate when thermal, load, or time drift can bias one side. Preserve every run and report median, relevant percentiles, spread, and outliers. Do not assume a normal distribution or declare success from one favorable run.

For microbenchmarks, keep setup and teardown outside the timed region, consume outputs, prevent dead-code elimination and constant folding, use representative parameters, include allocation when production includes it, and ensure timer overhead is negligible. Do not extrapolate results across runtimes, architectures, operating systems, or data sizes that were not measured.

## Measure Latency Honestly

Means hide tail behavior. Use histograms or another aggregatable distribution with buckets suited to the requirement. Do not average percentiles or merge precomputed quantiles across instances. Track successful and failed latency separately.

Closed-loop load generators can stop issuing work while the system stalls and understate user latency through coordinated omission. When the real workload has an independent arrival rate, schedule requests from intended arrival times or use a tool and histogram that corrects this effect. Always verify that the load generator itself is not saturated.

## Select The Load Test

1. Run a smoke test to verify the script and correctness under minimal load.
2. Run an average-load test for the normal traffic mix and baseline.
3. Run a stress or breakpoint test to locate the saturation knee and failure mode.
4. Run a spike test for abrupt demand and recovery behavior.
5. Run a soak test long enough to expose leaks, fragmentation, queue growth, pool exhaustion, compaction, and thermal or storage degradation.

Model realistic arrival rate, concurrency, think time, payloads, authentication, data skew, retries, cache mix, and geographic latency. Observe the system under test and load generators together. Measure ramp-up, steady state, overload, recovery, and backlog drain. Stop before harming shared or production systems unless the user has explicitly authorized a controlled test.

## Budgets And Regression Gates

A budget must name a metric, scope, workload, environment, percentile, threshold, and enforcement point. Combine user-facing budgets with resource or asset budgets only when both influence the outcome.

Store machine-readable results and trend them. A regression gate needs a stable benchmark and tolerance derived from observed variance. Confirm a suspected regression with repeated controlled runs before blocking work. Revisit budgets when user expectations, hardware, workload, or product behavior changes.
