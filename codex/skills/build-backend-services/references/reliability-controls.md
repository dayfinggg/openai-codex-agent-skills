# Reliability Controls

Use these controls according to the service's actual delivery, consistency, and failure model. Do not add machinery without a demonstrated failure mode.

## Deadlines and Cancellation

- Set finite operation deadlines at the outer boundary and propagate the remaining budget through downstream calls.
- Distinguish caller cancellation, deadline expiry, dependency rejection, and internal failure when the framework supports it.
- Stop cancellable work promptly, release resources deterministically, and prevent abandoned work from publishing a result after cancellation.
- Do not hide a timeout by increasing it without evidence. Measure the slow segment and address the cause or document the verified service-level constraint.

## Retries and Idempotency

- Retry only failures classified as transient by the dependency contract. Bound attempts and elapsed time, honor server retry guidance, and use backoff with jitter where supported.
- Retry an operation only when it is idempotent or protected by a verified idempotency mechanism. Do not infer safety from an HTTP method or function name alone.
- Give idempotency keys a defined scope, retention period, request-identity rule, and stored terminal outcome. Reject key reuse for a materially different request.
- Prevent multiplicative retries across layers. Choose one owner for retry policy and expose the final failure accurately.

## Transactions and Concurrency

- Put the invariant and its concurrency control in the same authoritative store or synchronization boundary.
- Choose optimistic checks, locking, serialization, or atomic operations from the expected contention and correctness requirement. Handle conflicts explicitly.
- Keep transaction scope small and deterministic. Arrange external effects with an established outbox, inbox, reconciliation, or compensation mechanism when atomic cross-system commit is unavailable.
- Define ownership for shared mutable state. Bound queues and parallelism, provide backpressure, and avoid detached work whose result or failure has no owner.

## Workers and Shutdown

- Make message acknowledgement follow durable completion. Define duplicate and redelivery behavior, poison-message handling, and maximum retry or quarantine policy.
- On shutdown, stop accepting new work, signal cancellation, drain or checkpoint bounded in-flight work, flush required telemetry, and close resources in dependency order.
- Make startup and readiness reflect actual dependency requirements. Keep liveness checks local enough to avoid cascading restarts.

## Failure Mapping and Observability

- Classify failures once near their source, preserve the cause internally, and translate them at the public boundary according to the existing contract.
- Emit structured events with stable names and correlation context. Record latency, throughput, saturation, and failures only where they support an operational decision.
- Avoid duplicate logging at every layer. Log at the layer that owns the outcome and never include credentials, tokens, sensitive payloads, or unbounded user data.
- Keep telemetry failure from corrupting the business outcome unless audit durability is itself a verified requirement.

## Security Boundaries

- Authenticate and authorize independently where the contract requires both. Bind authorization to the requested resource and action before side effects.
- Apply size, shape, rate, and resource limits at untrusted boundaries. Use safe parsers, parameterized data access, allowlisted destinations, and least-privilege identities.
- Treat outbound destinations, redirects, deserialization, file paths, templates, and command arguments as trust boundaries when user-controlled data can reach them.
- Return stable public errors without leaking stack traces, internal topology, query text, secrets, or sensitive record existence.
