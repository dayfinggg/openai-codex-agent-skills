---
name: building-resilient-services
description: Makes service code survive slow and failing dependencies with timeouts, retries, circuit breakers, idempotent handlers, and graceful shutdown. Use when code calls other services or third-party APIs, uses queues or background workers, or sets up service startup, config, or health checks.
---

# Building resilient services

Every remote call can hang, fail for a moment, fail for an hour, or succeed twice, so code that crosses a network boundary bounds its waiting, retries only what is safe to repeat, and stops calling a dependency that is down. This skill owns timeouts, retries, circuit breakers, bulkheads, idempotent consumers, what liveness and readiness checks test and how they drive routing and restarts, and the Twelve-Factor rules for config, processes, and shutdown. The adding-observability skill owns logs, metrics, traces, alerting, and what health endpoints expose, the designing-http-apis skill owns the `Idempotency-Key` contract on endpoints, the working-with-databases skill owns queries and transactions, the writing-secure-code skill owns secrets, and the applying-design-patterns skill owns general object patterns. When the project already has a resilience library, policies, or conventions, follow them over this skill.

## Values and libraries

- **Never invent numbers.** The Azure, AWS, and Twelve-Factor guidance gives no universal values for timeouts, retry counts, backoff delays, breaker thresholds, or shutdown grace periods, and Azure calls choosing retry intervals the hardest part of the design. Take each value from the project's existing configuration first, then from the documented defaults of the library in use. When neither exists, add a named setting read from configuration and ask the user for its value instead of writing a number.
- **Make every value configurable.** Read timeouts, retry, backoff, and breaker settings from configuration at startup, not from literals scattered through the code, so operators can tune them without a code change.
- **Use the project's resilience library.** When a client SDK has built-in retry, configure that, as Azure recommends. Otherwise use the resilience library the project already has, and only then the standard library for the language in the libraries file. Never hand-write a retry loop, a backoff calculation, or a circuit breaker. Adding a new library falls under the managing-dependencies-and-ci skill.
- **Check what the library defaults to.** Library defaults are a source for numbers, not for strategy. Polly's plain retry and resilience4j's retry wait a constant interval by default, so switch them to exponential backoff with jitter while keeping the documented values.

## Remote calls

- **Every remote call has a timeout.** HTTP, gRPC, database, cache, queue, and SDK calls all get one. Many clients wait forever unless told otherwise, for example Python `requests` and a Go `http.Client` whose `Timeout` is zero. Pass the caller's deadline or cancellation downstream as a `context.Context`, `CancellationToken`, or `AbortSignal`.
- **Fit the total into the caller's deadline.** The attempt timeout times the attempts plus all backoff delays must stay inside the time the caller can wait. Use an overall timeout around the retries and a shorter timeout per attempt when the library offers both.
- **Retry only transient failures.** Retry connection failures, attempt timeouts, throttling, and responses such as 408, 429, 502, 503, and 504. Never retry validation errors, other 4xx responses, authentication failures, or business rule violations. Honour `Retry-After` when the response carries it.
- **Back off exponentially with jitter and stop.** Use a finite number of attempts, exponential backoff with random jitter so instances do not retry in step, at most one immediate retry, and never an endless loop.
- **Pair every retry with a circuit breaker.** Azure pairs Retry with Circuit Breaker "so that an application retries transient faults but stops retrying when a fault persists". The retry stops when the breaker reports it is open, and the caller then fails fast, serves a cached or default value, or degrades the feature. Skip the application breaker only when the platform or service mesh already breaks the circuit, or for a message consumer whose broker bounds redelivery and dead-letters the rest.
- **Retry in one layer only.** Stacked retries multiply, so three retries in two layers become nine calls to the dependency. When the SDK already retries, configure its policy instead of wrapping it, and let inner layers fail fast to the layer that owns the policy.
- **Retry only idempotent operations.** Reads, `PUT`, `DELETE`, upserts, and writes of absolute values are safe to repeat. A create, a payment, an increment, or a sent email is retried only when it carries an idempotency key that the receiver deduplicates. The .NET standard resilience handler retries every HTTP method by default, so call `DisableForUnsafeHttpMethods()` unless the unsafe calls carry a key.
- **Report retries without noise.** Record each retry and each breaker state change through the project's logger, retries as warnings and only the final failure as an error, as the adding-observability skill describes.

## Messages and background jobs

- **Handlers are idempotent.** Brokers deliver at least once, so a handler must give the same result when a message arrives twice. Prefer naturally idempotent effects such as an upsert keyed by a business identifier or a write of the new absolute state.
- **Deduplicate atomically.** When the effect is not naturally idempotent, store a stable deduplication key in the same transaction as the side effects, under a uniqueness constraint so concurrent duplicates lose, and acknowledge the message only after the commit. The key is the producer's message identifier or a business key, never a broker delivery identifier, a receive timestamp, or a correlation identifier shared by several messages. When several consumers share one store, key the record by consumer and message.
- **Effects outside the transaction.** For a third-party call that cannot join the transaction, record the key as in progress, make the call with the idempotency key passed along, then mark the record completed with its outcome.
- **Keep deduplication records long enough.** Retain them longer than the broker can redeliver, counting messages that operators resubmit from the dead-letter queue. Broker-side duplicate detection reduces duplicates but never replaces an idempotent handler.
- **Bound retries and dead-letter the rest.** A message that keeps failing goes to a dead-letter queue after a limited number of attempts instead of blocking the queue.
- **Undo multi-step work explicitly.** When a business operation spans several services and a later step fails for good, run a compensating transaction made of idempotent steps, and record progress so the compensation can resume. Retry first, compensate only when forward progress is impossible.
- **Make jobs reentrant.** A job can be killed at any moment, so wrap its results in a transaction or make it idempotent, and release any locks it holds when it stops.

## Isolation and load

- **Bulkheads.** Give each dependency its own connection pool, concurrency limit, or queue, so one slow dependency cannot exhaust the threads and connections every other call needs. Use the library's bulkhead or the platform's limits rather than writing them in application code.
- **Rate limit outbound calls.** When a dependency throttles, pace calls below its documented limit, coordinate retries with that pace, and send bursts of work through a durable queue that consumers drain at the allowed rate.
- **Level load with a queue.** When spikes overwhelm a dependency and callers do not need a synchronous answer, put a queue in front of it, bound the consumers' total downstream rate, and watch the queue depth.

## Health endpoints

- **Split the two concerns.** This section decides what liveness and readiness check and how they affect availability. The adding-observability skill decides what the endpoints expose and how they are watched.
- **Keep probes from causing outages.** A deep readiness check against a slow or failing shared dependency can mark every instance unhealthy and turn a partial outage into a full one. Give each dependency check its own timeout, let it respect the dependency's circuit breaker, and report optional dependencies as degraded rather than failed.
- **Let probes drive recovery.** Liveness lets the platform restart a stuck process and readiness takes an instance out of rotation, so keep liveness free of dependency checks and report not ready until startup work is done.

## Process rules from Twelve-Factor

- **Config from the environment.** Everything that varies between deploys, such as URLs, credentials, timeouts, and retry settings, comes from environment variables, read once at startup into a typed settings object in the composition root, as the applying-clean-architecture skill describes. Validate it at startup and refuse to start when a required value is missing. Do not bundle settings into named environments inside the code.
- **Logs go to stdout.** Each process writes its log events as a stream to stdout and never manages log files, as the adding-observability skill describes in full.
- **Processes are stateless.** Keep nothing in memory or on local disk between requests except a brief single-request cache, store durable state in a backing service, and never rely on sticky sessions.
- **Start fast.** Keep startup short and move slow warm-up behind the readiness signal.
- **Shut down gracefully on SIGTERM.** A web process stops accepting new connections, lets in-flight requests finish within a configured grace period, then closes its pools. A worker stops taking new jobs and finishes or returns its current job to the queue. Both exit before the platform's kill deadline, and both survive sudden death because work is reentrant.

## Recovery

- **Recover automatically.** Retries, breakers, liveness restarts, and dead-letter queues let the system repair transient faults without a person. AWS asks for recovery triggered by measures of business value, not only technical signals.
- **Test the failure paths.** Add tests that inject timeouts, connection drops, 429 and 503 responses, an open breaker, a duplicate message, and a SIGTERM during work, and assert the bounded, idempotent behavior. The writing-tests skill covers how to write them.

## Workflow

1. Find every remote call, message handler, background job, and process entry point the change touches, and how the project already handles timeouts, retries, configuration, health checks, and shutdown.
2. For each call, decide whether it is idempotent, which errors are transient, and how long its caller can wait.
3. Configure the timeout, retry, and circuit breaker with the project's library or the SDK, taking every value from configuration or library defaults.
4. Make message handlers idempotent and give failing messages a dead-letter path.
5. Wire configuration, health endpoints, and SIGTERM handling in the composition root.
6. Add tests that inject the failures above, then review against the checklist.

## Checklist

- [ ] Every remote call has a timeout and the total time with retries fits the caller's deadline
- [ ] Retries cover only transient failures, are finite, back off exponentially with jitter, and sit behind a circuit breaker
- [ ] Only idempotent or key-protected operations are retried, and in one layer only
- [ ] Resilience comes from the project's library or the SDK, not a hand-written loop
- [ ] No timeout, retry, backoff, threshold, or grace period value was invented
- [ ] Message handlers deduplicate atomically and failing messages reach a dead-letter queue
- [ ] A slow dependency cannot exhaust pools or threads that other calls need
- [ ] Health probes cannot turn one dependency's outage into restarts or removal of every instance
- [ ] Config comes from the environment and is validated at startup
- [ ] Logs go to stdout and processes keep no state between requests
- [ ] SIGTERM stops intake, drains in-flight work, and returns unfinished jobs
- [ ] Tests inject timeouts, transient errors, duplicates, and shutdown

## Reference files

Read them before the first change, the patterns file when choosing or reviewing a pattern, the section of the libraries file for the language at hand, and the examples file for every change.

- [references/patterns.md](references/patterns.md) has Timeout, Retry, Circuit Breaker, Bulkhead, Idempotent Consumer, Rate Limiting, Health Endpoint Monitoring, Compensating Transaction, and Queue-Based Load Leveling, each with when to use it, when not to, and its Azure Architecture Center page.
- [references/libraries.md](references/libraries.md) has the standard resilience library for C#, Java, Python, TypeScript, and Go, with the defaults and calls to check, and the timeout behavior of common clients.
- [examples.md](examples.md) has illustrative before and after pairs for a timeout, a retry loop replaced by a library policy, an HTTP client pipeline, an idempotent message handler, and graceful shutdown.
