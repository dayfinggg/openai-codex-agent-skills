# Reliability and Verification

## Validate and authorize at the boundary

1. Authenticate the caller and authorize the requested action on the specific resource or field. Use current platform-supported authentication standards and least-privilege scopes; do not invent a token format or authorization protocol.
2. Validate transport framing, content type, schema, types, bounds, formats, cross-field invariants, and authorization before side effects. Apply explicit size, depth, item-count, and processing-cost limits to untrusted input.
3. Treat identifiers, filters, sort expressions, callbacks, URLs, and file metadata as untrusted input. Prevent injection and server-side request forgery through structured APIs, allowlisted capabilities, canonical parsing, and network policy rather than string filtering alone.
4. Keep secrets and sensitive data out of URLs, error details, logs, trace baggage, analytics dimensions, and generated examples. Define redaction at ingestion rather than relying on every observer to remember it.

## Make failures actionable and stable

1. Use the transport's canonical status or error code for the broad class and a stable application code for programmatic handling. Include field-level violations and a correlation or occurrence identifier when useful.
2. For HTTP APIs without an established error envelope, use Problem Details where it fits. Keep the HTTP status and body status consistent, use a stable problem type, and make human detail corrective rather than diagnostic. Clients must not parse human prose.
3. Return only details safe for the caller. Log internal diagnostics under the same correlation context, with redaction and access control.
4. State which failures are retryable, whether the operation may already have committed, and what clients can inspect to determine the result.

## Idempotency, retries, and deadlines

1. Base retry behavior on the complete operation contract, not only the transport code. Retry automatically only when the operation is inherently idempotent or a server-enforced idempotency key makes identical repeats safe.
2. Scope an idempotency key to the caller and operation, bind it to a canonical request fingerprint, store the committed outcome for a documented retention period, reject key reuse with different input, and make concurrent duplicates converge on one result.
3. Use bounded retries with exponential backoff and randomized jitter. Respect `Retry-After`, rate-limit reset signals, caller cancellation, and an overall deadline. Never let layered SDK, proxy, and application retries multiply without a shared budget.
4. Do not retry permanent validation, authentication, authorization, or unsupported-operation failures. For ambiguous timeouts after a mutation, retrieve operation or resource state before issuing a new business action.
5. Propagate deadlines through downstream calls and stop work when cancellation is observed where safe. Cancellation does not imply rollback; document the resulting state and recovery path.

## Concurrency, pagination, and caching

1. Use strong validators with `If-Match`, a revision field, or an atomic compare-and-set for writes that must not overwrite newer state. Return a failed-precondition signal when the supplied version is stale.
2. Make page order deterministic with a unique tie-breaker. Continuation state must include or bind all query-shaping inputs and the authorization scope. Define whether pages are a snapshot or may reflect concurrent changes.
3. Cap page size and query cost server-side. A continuation token is not authorization and must not grant access to resources the caller can no longer read.
4. Set cache controls from data sensitivity and freshness requirements. Use `ETag` or `Last-Modified` for revalidation, include every representation-shaping request field in `Vary`, and avoid shared caching of authenticated data unless explicitly designed for it.

## Rate limits and overload

1. Rate-limit by the resource at risk and an appropriate caller or tenant key. Separate abuse prevention, fair-use quotas, concurrency limits, and downstream capacity controls because they have different recovery behavior.
2. Return `429` for caller-specific throttling and `503` for temporary service unavailability when those meanings fit. Include `Retry-After` when the server can provide a useful delay. Treat vendor or draft rate-limit fields as contractual only when the deployed platform documents them.
3. SDKs and consumers must stop or slow down on explicit server signals. Bound queues, concurrency, request size, and expensive query shapes so rejection occurs before exhaustion.

## Webhooks and event delivery

1. Send over TLS, sign the exact transmitted bytes, include a timestamp and delivery identifier, support secret rotation, and verify signature and freshness before parsing or processing. Preserve the raw body required by the signature algorithm.
2. Acknowledge receipt quickly and process durably in the background when work may exceed the provider timeout. Persist the delivery identifier before acknowledging if loss after acknowledgment would violate requirements.
3. Expect duplicates, retries, redelivery, and out-of-order events. Deduplicate by delivery or event identifier, make effects idempotent, and retrieve authoritative state when event order is insufficient.
4. Define retry schedule, maximum age, terminal failure handling, replay or redelivery controls, and observability for both sender and receiver. Subscribe only to events the consumer needs.

## Observe the contract

1. Propagate standard trace context across supported boundaries and create spans around remote calls, while treating incoming context as untrusted and excluding secrets or personal data from baggage and attributes.
2. Record operation name or route template, protocol status, application error code, latency, request and response size, retry count, throttling, and dependency outcome. Do not use raw identifiers or unbounded query text as metric dimensions.
3. Correlate logs, traces, metrics, webhook deliveries, and asynchronous operations with stable identifiers. Monitor compatibility errors, deprecated-surface usage, pagination abandonment, retry amplification, and authorization denials.

## Prove compatibility and behavior

1. Lint and validate the machine-readable contract with the repository's pinned tooling. Validate every example against its schema and every documented response against actual provider behavior.
2. Run a semantic compatibility diff against each supported released contract. Classify wire, source, behavioral, authentication, default, ordering, error, and performance changes; schema-additive does not always mean behavior-compatible.
3. Test the provider over the real transport, including serialization, headers or metadata, middleware, authentication, timeouts, and error mapping. Mocks prove client assumptions, not provider conformance.
4. Add consumer-driven contract tests when independent consumers have specific used interactions, and verify them against a locally controlled provider in delivery. Keep provider states deterministic and publish verification results before deployment.
5. Exercise duplicate and concurrent mutations, retry after an ambiguous failure, stale preconditions, pagination during change, malformed and oversized input, permission boundaries, throttling, deadline expiry, webhook signature failures, duplicate and reordered events, and old-client/new-server plus new-client/old-server combinations where supported.
6. Release incompatible changes through a staged migration with usage telemetry, dual-read or dual-write only when necessary, rollback or roll-forward criteria, and an explicit retirement gate for the old contract.
