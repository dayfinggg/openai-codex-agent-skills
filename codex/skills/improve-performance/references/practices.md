# Performance Practices

Use percentiles and distributions for latency, and record throughput, concurrency, resource use, dataset, hardware, versions, warmup, and variance. Compare before and after under the same conditions. A microbenchmark cannot establish end-to-end improvement by itself.

Optimization is complete only when correctness and operational behavior remain valid. Caches require ownership, bounds, invalidation, and failure behavior. Parallelism requires limits, cancellation, ordering rules, and evidence that coordination cost does not erase the gain.

Primary sources:

- [Google Benchmark user guide](https://google.github.io/benchmark/user_guide.html)
- [PostgreSQL Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html)
- [web.dev Core Web Vitals](https://web.dev/articles/vitals)
- [Google SRE service-level objectives](https://sre.google/sre-book/service-level-objectives/)
