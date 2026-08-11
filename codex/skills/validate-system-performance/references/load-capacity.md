# Load, stress, soak, and capacity testing

**Reviewed:** 2026-08-11
**Scope:** k6 concepts and general service-capacity experiments. Resolve the installed tool and target protocol versions locally.

## Experiment types

- Use load testing around expected operating conditions and service objectives.
- Use stress testing to find saturation and failure behavior within authorized safety limits.
- Use spike testing for abrupt arrival changes and recovery.
- Use soak testing for leaks, queue growth, resource drift, credential expiry, rotation, and background maintenance over a justified duration.
- Use capacity testing to relate workload to resource and scaling limits. Do not turn an uncontrolled production load into a capacity test.

## Workload and generator

- Choose an open or closed workload model from how users or upstream systems actually generate work.
- Define operation mix, pacing, data distribution, cache state, authentication, write uniqueness, cleanup, and dependency behavior.
- Verify load-generator CPU, memory, network, sockets, and clock. A saturated generator can make the target look faster or cap throughput.
- Use more than one generator only when identity, synchronization, aggregation, and network placement remain controlled.

## Thresholds and results

- Set thresholds from service objectives and safety limits before the run.
- Separate protocol, application, validation, timeout, throttling, and generator errors.
- Preserve raw results, scenario source, environment, revisions, timestamps, and telemetry queries needed to reproduce the run.
- Compare repeated runs under the same workload. Report tail latency and saturation rather than averages alone.

## Official sources

- [k6 documentation](https://grafana.com/docs/k6/latest/)
- [k6 test types](https://grafana.com/docs/k6/latest/testing-guides/test-types/)
- [k6 workload models](https://grafana.com/docs/k6/latest/using-k6/scenarios/concepts/open-vs-closed/)
- [Google SRE monitoring distributed systems](https://sre.google/sre-book/monitoring-distributed-systems/)
