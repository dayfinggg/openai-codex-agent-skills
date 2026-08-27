# Data And Messaging

Read this reference only when architecture decisions cross data ownership or consistency boundaries, or introduce transactions, events, queues, CQRS, or event sourcing.

## Ownership And Transactions

Assign every authoritative fact and invariant to one boundary. Only its owner writes authoritative state. Other boundaries use a contract, event, or maintained read model. Logical ownership does not require a separate database product or server for every module; one physical database can host encapsulated schemas with exclusive write ownership.

Keep an invariant inside one local transaction when it must be atomically true. Routine distributed atomic transactions usually indicate an incorrect boundary. Use a distributed transaction only when every participant supports the protocol, blocking and availability trade-offs are acceptable, and cross-boundary atomicity is mandatory. Otherwise model explicit eventual consistency and recovery.

For cross-boundary workflows, name every user-visible intermediate state. Use a saga only when the workflow has defined local transactions, compensation or forward recovery, an irreversible pivot, and observable progress. Compensation is business behavior, not a generic database rollback.

Use a transactional outbox or equivalent atomic mechanism when one operation must persist state and publish a message. Avoid uncoordinated dual writes.

## Delivery Contract

Assume at-least-once delivery unless the complete processing boundary proves a stronger guarantee. Consumers must tolerate redelivery with idempotent operations or durable deduplication. Acknowledge a message only after the durable side effect it confirms.

Any exactly-once claim must name its scope. Broker-local transactions do not make external APIs, emails, payments, or arbitrary databases exactly once.

For every asynchronous channel, define:

1. Message identity, producer, consumer, owner, schema, and compatibility policy.
2. Ordering scope, partition key, stale-message behavior, version checks, and gap detection.
3. Retry limit, timeout, backoff, acknowledgement, idempotency, and deduplication.
4. Poison-message handling, dead-letter policy, replay procedure, and retention.
5. Backpressure, concurrency, capacity, maximum acceptable backlog age, monitoring, and alerts.

Do not use a queue when the caller requires an immediate strongly consistent result. Do not leave retries, fan-out, backlog, or in-flight work unbounded.

## Advanced Data Patterns

Use CQRS only when read and write behavior has materially different scale, security, model complexity, or performance needs. Messaging is not required merely because reads and writes are separated.

Use event sourcing only when durable history, auditability, temporal reconstruction, or domain intent justifies event evolution, projection, replay, snapshot, debugging, and operational costs. Traditional current-state persistence remains the default.

Before accepting an asynchronous design, verify duplicate delivery, reordering, consumer outage, broker outage, schema evolution, replay after a bug, and recovery from a partially completed workflow.
