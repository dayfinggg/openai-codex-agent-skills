# Runtime and background work

## Execution and configuration

- Identify FPM/request isolation versus long-lived workers before choosing service lifetimes. Reset tenant/user context, per-job caches, ORM state, and transaction state between jobs. Avoid mutable static state that leaks across requests.
- Validate required configuration at startup without exposing secrets. Use the framework's configuration mechanism and understand cached configuration before changing environment reads. Keep development debugging and error display out of production responses.
- Measure latency, peak memory, query count, and external waits before tuning. OPcache stores compiled bytecode, not application results. Coordinate code deployment with its validation/invalidation settings and worker restart behavior. A CLI reset is not proof that FPM's cache was reset.
- Enable JIT or preloading only with representative performance evidence and a deployment plan. Do not assume CPU-oriented optimization improves database-bound requests.
- Use explicit network connect/read/overall deadlines as supported by the client. Retry only transient failures for operations safe to repeat, within a bounded total budget. Keep TLS verification enabled and validate user-controlled outbound destinations against the application's allowed targets.
- Emit structured logs with safe request/job correlation and stable event names. Track errors, latency, memory, queue lag, and retry/dead-letter counts relevant to the service. Exclude secrets and avoid user IDs as unbounded metric labels.

## Queues and workers

- Assume a message may be delivered more than once unless the transport contract proves otherwise. Deduplicate using a stable business-operation identifier and durable state when duplicate side effects are unacceptable.
- Acknowledge only after required effects succeed. Distinguish retryable infrastructure failures from permanent validation failures. Use bounded attempts/backoff and a recoverable failure destination rather than infinite poison-message loops.
- Set processing deadlines, visibility/lease timeouts, and shutdown grace periods together. Long jobs may need supported lease renewal. Stop intake on shutdown and finish or safely release current work using the worker framework's lifecycle.
- Keep message payloads small and versioned. Passing an ID and reloading reads current state; passing a snapshot preserves event-time state. Choose deliberately rather than serializing live entities by default.
- Do not introduce fibers or an async runtime for ordinary synchronous code. Fibers alone do not make blocking I/O nonblocking, and require PHP 8.1+. Verify extension/client/framework support before adding concurrency.
- Test redelivery, process interruption, failed external calls, transaction boundaries, and context isolation where the changed behavior depends on them.

Sources: [PHP OPcache configuration](https://www.php.net/manual/en/opcache.configuration.php) and [Symfony Messenger](https://symfony.com/doc/current/messenger.html). Use the installed worker/transport version for acknowledgement, retry, and reset APIs.
