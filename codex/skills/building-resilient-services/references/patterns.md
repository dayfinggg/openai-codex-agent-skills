# Resilience patterns

One entry per pattern, summarized from the Azure Architecture Center Cloud Design Patterns catalog and the Azure Well-Architected Framework guide to transient faults. Azure asks to choose a pattern "based on the problem you need to solve, not the technology you want to use", so start from the failure the code must survive. None of these pages gives universal numbers, so every timeout, attempt count, delay, and threshold comes from the project's configuration or the library's documented defaults.

## Contents

- Timeout
- Retry
- Circuit Breaker
- Bulkhead
- Idempotent Consumer
- Rate Limiting
- Health Endpoint Monitoring
- Compensating Transaction
- Queue-Based Load Leveling
- Combining patterns

## Timeout

The Azure catalog has no separate Timeout pattern. The transient fault guide defines a timeout as the maximum time to wait for an operation before treating it as failed, and the Circuit Breaker page explains why a missing or long timeout ties up threads, memory, and connections.

- **Use when.** Always, for every call that leaves the process, including database, cache, queue, and SDK calls.
- **Shape.** A timeout per attempt, plus an overall timeout around all retries when the library offers one, so the attempt timeout times the attempts plus the delays stays within the caller's own deadline or service level objective.
- **Watch for.** A timeout so long that a circuit breaker cannot protect the caller, and a timeout close to the retry interval, which starts the next attempt at once.
- **Not when.** Never skip it. When a call must wait long, as for a large export, make the long value explicit and configured, or move the work to a queue.
- **Source.** [Recommendations for handling transient faults](https://learn.microsoft.com/en-us/azure/well-architected/design-guides/handle-transient-faults) and [Circuit Breaker pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker)

## Retry

Handle anticipated, temporary failures by transparently retrying the failed operation after a delay.

- **Use when.** A remote call can hit short-lived faults such as a dropped connection, a busy service, or throttling, and a repeat is likely to succeed.
- **Shape.** Retry only errors the dependency documents as transient. Use a finite number of attempts and exponential backoff with jitter, at most one immediate retry, and no regular short interval at scale. Use the SDK's built-in retry when it has one. Keep the policy in configuration in one place.
- **Idempotency.** Retry only operations that are idempotent or protected by an idempotency key, because a request can succeed on the server while its response is lost.
- **One layer.** Do not stack retries in nested calls. Let the lower layer fail fast and the layer with the full context retry.
- **Not when.** The fault is long lasting, the error comes from business logic or invalid input, or frequent busy errors show the dependency needs scaling instead.
- **Source.** [Retry pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/retry)

## Circuit Breaker

Block calls to a dependency after failures reach a threshold, fail fast while it recovers, then let a limited number of trial calls through.

- **Use when.** Faults may take a variable and possibly long time to fix, and continued calls would waste resources, cascade failures, or slow down the recovering dependency.
- **Shape.** Closed counts recent failures in a time window. Open fails at once, optionally returning a cached or default value. Half-open lets a few trial calls through and closes after enough successes. Wrap the retry around the breaker so the retry stops when the breaker reports a fault that is not transient. Use separate breakers for independent resources, such as separate shards or hosts.
- **Watch for.** Breaking too fast or too slow for the dependency's real recovery pattern, a breaker that counts rejections from other policies such as a full bulkhead, and missing visibility of state changes.
- **Not when.** Guarding local in-memory resources, replacing business exception handling, message-driven consumers that already rely on bounded redelivery and a dead-letter queue, or when the platform or service mesh already breaks the circuit.
- **Source.** [Circuit Breaker pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker)

## Bulkhead

Isolate parts of an application into pools so that one failing part does not take down the rest.

- **Use when.** A consumer calls several dependencies and one slow dependency could exhaust a shared connection pool or thread pool, or critical consumers must be isolated from standard ones.
- **Shape.** A connection pool, semaphore, or concurrency limit per dependency, a queue per message type, or separate processes or containers per service. Prefer built-in platform controls over re-creating them in application code, and combine bulkheads with retry, circuit breaker, and throttling.
- **Not when.** The less efficient use of resources is not acceptable, or the added complexity is not needed.
- **Source.** [Bulkhead pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/bulkhead)

## Idempotent Consumer

Process a message more than once with the same effect as processing it once, because brokers deliver at least once.

- **Use when.** Consuming from a broker with at-least-once delivery, where a repeat would duplicate records, charges, or notifications, especially with competing consumers on one channel.
- **Shape.** Prefer naturally idempotent effects such as an upsert or a write of absolute state. Otherwise take a stable key from the producer's message identifier or a business key, record it in the same transaction as the side effects under a uniqueness constraint, and acknowledge after the commit. For effects that cannot join the transaction, record the key as in progress, perform the call, then mark it completed. Keep records longer than the broker's redelivery window and pass the idempotency key to downstream calls.
- **Watch for.** Keys that change on redelivery, such as broker delivery identifiers or receive timestamps, a shared correlation identifier used as the key, a check-then-set race in a cache, and relying on broker duplicate detection alone.
- **Not when.** The effects are already naturally idempotent, or occasional duplicates are harmless and cost less than the deduplication store.
- **Source.** [Idempotent Consumer pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/idempotent-consumer)

## Rate Limiting

Control the rate at which the application sends requests to a throttled service, so it stays within the service's limits instead of retrying rejected requests.

- **Use when.** A dependency throttles by requests, data volume, or cost per time window, and naive retry on error multiplies traffic, as in large batch or ingestion jobs.
- **Shape.** Send work through a durable queue and let consumers dequeue at the allowed rate, releasing small amounts often rather than large bursts. Gate every workstream that uses the same dependency through the same limiter or reserved capacity. Still handle throttling errors, coordinate retries with the limiter, and honour `Retry-After` on 429 responses.
- **Not when.** The operation needs immediate synchronous completion with very low latency, or the bottleneck is concurrency or CPU rather than request rate.
- **Source.** [Rate Limiting pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/rate-limiting-pattern)

## Health Endpoint Monitoring

Expose endpoints that monitoring tools, load balancers, and orchestrators call to learn whether an instance can serve requests.

- **Use when.** An application or shared service must be verified as available and working, or traffic routing and restarts depend on instance health.
- **Shape.** A shallow liveness endpoint that only confirms the process responds, and a deep readiness endpoint that checks initialization and required dependencies, each check with its own timeout. Exclude optional dependencies or report them as degraded. Keep checks read-only and cheap, cache expensive results with a short time to live, allow for startup time, and protect detailed output with authentication or network rules.
- **Watch for.** A deep probe on a slow shared dependency that marks every instance unhealthy and turns a partial outage into a full one.
- **Not when.** The component exposes no health interface a tool can reach, a meaningful check would itself degrade the application, or a platform transport probe already answers the only question.
- **Source.** [Health Endpoint Monitoring pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring)

## Compensating Transaction

Undo the completed steps of an eventually consistent operation when a later step fails and cannot recover.

- **Use when.** A business operation spans several services or data stores without one atomic transaction, and undoing work needs business rules such as cancelling a reservation or issuing a partial refund.
- **Shape.** Record each completed step and how to undo it, retry transient step failures first, and compensate only when forward progress is impossible. Make every compensation step idempotent, record its progress so it can resume, put irreversible steps after all critical validations, and raise an alert with details when manual intervention is needed.
- **Not when.** Steps are safe to retry and most failures are transient, or the system cannot tolerate temporary inconsistency and needs a real atomic transaction.
- **Source.** [Compensating Transaction pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/compensating-transaction)

## Queue-Based Load Leveling

Put a durable queue between a task and the service it calls, so the service processes work at its own pace through demand peaks.

- **Use when.** Intermittent spikes overwhelm a downstream service, or request intake must be decoupled from processing throughput.
- **Shape.** Use a durable queue, bound the consumers' total rate toward the downstream dependency, monitor queue depth, make consumers idempotent, send poison messages to a dead-letter queue, and do not assume ordering unless the broker provides it.
- **Not when.** The caller needs a low-latency synchronous response, or the load is low and stable.
- **Source.** [Queue-Based Load Leveling pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/queue-based-load-leveling)

## Combining patterns

The catalog names these pairings.

- Retry with Circuit Breaker, so transient faults are retried and persistent ones stop the retries.
- Queue-Based Load Leveling with Competing Consumers, to buffer load and then scale its processing.
- Saga built on Compensating Transaction, to keep data consistent when a distributed operation fails partway through.

The [Cloud Design Patterns catalog](https://learn.microsoft.com/en-us/azure/architecture/patterns/) lists the remaining patterns, and the applying-design-patterns skill covers patterns inside a single process.
