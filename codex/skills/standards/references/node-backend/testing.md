# Testing

Test application services with fake ports and deterministic clocks before testing the HTTP adapter.
Test malformed input, unknown fields, missing auth, wrong auth, and oversized payloads.
Test success, client errors, dependency failures, cancellation, timeout, and duplicate-send paths.
Test response shape and redaction, not only status codes.
Use an ephemeral port or in-process injection so tests can run in parallel.
Close servers, pools, timers, and consumers in teardown.
Use the stable `node:test` runner when another runner is not required. [N9]
Keep a small set of real integration tests for databases, queues, TLS, proxies, and serialization.
Run security, load, and shutdown tests in CI or an environment suited to their cost.
