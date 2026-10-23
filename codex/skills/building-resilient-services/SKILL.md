---
name: building-resilient-services
description: Adds timeouts, retries, circuit breakers, idempotent consumers, and graceful shutdown to service code. Use when code calls remote APIs, uses queues or workers, or sets up startup, config, or health checks.
---

# Building resilient services

The project's resilience library, policies, and settings win over this skill.

## Values and libraries

- Never invent a timeout, retry count, backoff delay, breaker threshold, or grace period. Take it from the project's configuration, then from the library's documented defaults. When neither exists, add a named setting and ask the user for its value.
- Use the SDK's built-in retry, else the project's resilience library, else the library in the libraries file. Never hand-write a retry loop, backoff, or breaker.
- Library defaults give numbers, not strategy. Polly and resilience4j retry at a constant interval by default, so switch them to exponential backoff with jitter.

## Remote calls

- Every remote call has a timeout, and the caller's cancellation goes downstream. An overall timeout wraps the retries and a shorter one bounds each attempt, so the whole fits the caller's deadline.
- Retry only connection failures, attempt timeouts, 408, 429, 502, 503, and 504, and honour `Retry-After`. Use finite attempts, exponential backoff with jitter, and at most one immediate retry.
- Put the retry around a circuit breaker so retries stop when it opens, then fail fast or degrade. Skip the breaker only when the platform or mesh already has one, or for a consumer whose broker bounds redelivery. A breaker never counts rejections from other policies, such as a full bulkhead.
- Retry in one layer only, because three retries in two layers make nine calls. When the SDK retries, configure it instead of wrapping it.
- Retry a create, payment, increment, or email only with an idempotency key the receiver deduplicates. The .NET standard resilience handler retries every method, so call `DisableForUnsafeHttpMethods()` unless the unsafe calls carry a key.
- Log retries as warnings and only the final failure as an error.

## Messages and jobs

Brokers deliver at least once, so handlers are idempotent. Prefer an upsert or a write of absolute state. Otherwise claim a dedup key in the same transaction as the side effects, under a uniqueness constraint, and acknowledge after the commit. The key is the producer's message ID or a business key, never a broker delivery ID, a receive timestamp, or a shared correlation ID. Bound the attempts and dead-letter the rest.

## Health and shutdown

Liveness checks no dependencies. Readiness checks give each dependency their own timeout and report optional ones as degraded, so one failing shared dependency cannot pull every instance out. On SIGTERM a web process stops accepting connections and drains in-flight requests within a configured grace period, and a worker finishes or requeues its current job.

## Tests

Inject timeouts, 429 and 503 responses, an open breaker, a duplicate message, and a SIGTERM during work.

## Reference files

- [reference/libraries.md](reference/libraries.md), read the language's section before configuring a policy.
- [reference/patterns.md](reference/patterns.md), read when changing a message handler, a multi-step workflow, a rate limit, or a probe.
- [examples.md](examples.md), read before writing a deduplicating message handler.
