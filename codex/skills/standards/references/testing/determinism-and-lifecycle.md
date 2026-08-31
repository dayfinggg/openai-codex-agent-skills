# Determinism and lifecycle

- Control clocks, time zones, randomness, generated identifiers, locale, environment variables, filesystem roots, and schedulers when they affect the result.
- When concurrency ordering is under test, use barriers, latches, a controllable scheduler, or recorded event sequencing to reproduce the relevant interleaving.
- Do not use wall-clock sleeps to wait for asynchronous work. Await completion, drive a fake clock, or poll an observable condition with a short explicit deadline.
- Return or await every asynchronous test operation so the runner owns failures and cleanup.
- Give every resource created by a test an explicit teardown path, including files, ports, processes, subscriptions, tasks, database records, and temporary configuration.
- Keep tests independent of execution order and safe under the runner's configured parallelism.
- Reset only state the test owns. Global cleanup that sweeps unrelated data can hide coupling and damage parallel tests.
- Make retry behavior part of the system under test, not a blanket retry around flaky assertions.
