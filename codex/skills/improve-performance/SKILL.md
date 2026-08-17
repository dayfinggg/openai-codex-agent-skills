---
name: improve-performance
description: Diagnose and improve software performance and resource efficiency. Use for latency, throughput, memory, CPU, I/O, database, network, frontend responsiveness, capacity, or cost problems requiring measured optimization.
---

# Improve Performance

## Workflow

1. Define the user-visible metric, target, workload, environment, constraints, and correctness requirements.
2. Establish a reproducible baseline with representative data, warmup, variance, and resource measurements.
3. Profile, trace, inspect execution plans, or measure browser vitals to locate the dominant bottleneck. Separate evidence from hypotheses.
4. Choose the simplest change that addresses the measured cause. Consider algorithmic cost, I/O, batching, caching, allocation, concurrency, and data layout only as relevant.
5. Preserve correctness, ordering, consistency, security, and failure behavior. Bound caches, queues, parallelism, retries, and timeouts.
6. Repeat the same measurement and compare distributions, not an isolated best run. Check regressions under realistic load.
7. Add an appropriate performance guard and document the operating assumptions and tradeoffs.

Do not optimize from intuition alone or trade maintainability for an unmeasured gain. Read [performance practices](references/practices.md) for measurement guidance.
