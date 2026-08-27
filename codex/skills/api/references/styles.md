# Interaction Styles

Read only the sections relevant to the boundary being designed. Preserve an established style when it satisfies the requirements; changing protocol is a migration, not a cleanup.

## Resource-oriented HTTP

Use resource-oriented HTTP for public or broadly consumed interfaces that benefit from standard clients, intermediaries, conditional requests, caching, content negotiation, and recognizable method semantics.

1. Identify resources from durable domain nouns, ownership, lifecycle, and authorization boundaries. A resource representation is a contract, not a serialization of an internal record.
2. Use collection and item resources consistently. Keep identifiers stable and opaque unless their structure is intentionally contractual. Avoid deeply nested paths when ownership or identity does not require them.
3. Use standard methods when their semantics fit. A custom operation is clearer than distorting `PUT`, `PATCH`, or `DELETE` to mean an unrelated business command. Model a command as a subordinate operation resource when clients need to observe, cancel, or retry its lifecycle.
4. Use `POST` when the server selects a new resource identifier or performs non-idempotent processing. Use `PUT` when the client addresses the complete target state. Use a documented patch media type for partial updates and define missing, null, and removal semantics.
5. Return links such as `Location` or typed `Link` relations when clients need a stable next action. Do not require clients to construct undocumented URLs or parse identifiers out of URLs.

## RPC

Use RPC for cohesive internal APIs or operation-heavy domains where an interface definition, generated clients, binary encoding, deadlines, and streaming are concrete advantages.

1. Design calls as remote, fallible operations rather than local methods. Keep request and response messages explicit even when initially empty, and set realistic client deadlines.
2. Choose unary, client-streaming, server-streaming, or bidirectional streaming from the actual data flow. Streaming adds cancellation, flow-control, retry, partial-delivery, and observability requirements; do not use it for novelty.
3. Use canonical status codes consistently and reserve retryable codes for transient conditions. A deadline or cancellation does not roll back side effects already committed.
4. For Protocol Buffers, never reuse field numbers, reserve deleted numbers and names, preserve wire types, and tolerate unknown fields. Use distinct API and storage messages so schema evolution is not coupled to persistence.
5. Add fields compatibly and make new behavior opt-in when old clients could observe a changed default. Verify both wire compatibility and generated source compatibility in every supported language.

## GraphQL

Use GraphQL when its client-selected response shape and graph traversal solve a demonstrated consumer problem. Do not adopt it solely to place all endpoints behind one URL.

1. Design the schema around domain capabilities and consumer language. Keep authorization in the business layer or resolvers, not in a separate endpoint assumption.
2. Add new fields and types instead of changing existing meanings. Use deprecation metadata and usage telemetry before removal. Choose non-null only when the server can uphold that guarantee across authorization, dependencies, and partial failures.
3. Paginate potentially large lists with opaque cursors and a consistent connection model. Keep ordering stable, cap page sizes, and do not expose unbounded nested lists.
4. Distinguish request errors from field execution errors and preserve GraphQL partial-response semantics. Use typed result data for expected domain outcomes only when clients benefit; do not hide infrastructure failure as successful business data.
5. Enforce demand controls appropriate to the trust model: trusted documents where feasible, argument validation, pagination, depth and breadth limits, batch limits, complexity budgets, timeouts, and rate limits. Prevent resolver fan-out with batching or joined access paths supported by measurements.

## Events and asynchronous messages

Use events when consumers need notification of a fact that already occurred and when delayed, duplicated, or reordered delivery is acceptable or explicitly handled.

1. Name events in the past tense and define producer, subject, event identity, occurrence time, schema version, payload, ordering scope, retention, and sensitivity. Prefer a standard envelope such as CloudEvents when ecosystem interoperability is useful.
2. State delivery semantics honestly. Most brokers and webhooks are at-least-once in practice, so consumers must deduplicate and process idempotently. Do not claim exactly-once business effects without proving every boundary involved.
3. Preserve event meaning. Add optional fields compatibly, tolerate unknown fields, and publish a new event type or version when semantics change incompatibly. Never reuse an old event name for a different fact.
4. Define ordering only within a key or partition that the transport can uphold. Consumers must not infer global ordering unless it is guaranteed and tested.
5. Include enough stable identifiers for consumers to retrieve authoritative state when payload snapshots become stale, but avoid forcing a synchronous callback for every event if the event is intended to decouple systems.

## Machine-readable contracts and SDKs

1. Use OpenAPI for HTTP, the GraphQL schema for GraphQL, Protocol Buffers or another supported IDL for RPC, and AsyncAPI plus message schemas for event channels when those formats match the actual toolchain.
2. Keep one authoritative contract and generate or validate documentation, examples, clients, and server bindings from it where that reduces drift. Generated artifacts do not replace behavioral tests.
3. Pin a dialect supported by the repository's validators and generators. Validate references, examples, security schemes, serialization, nullability, and formats with the same tools used in delivery.
4. Make SDKs idiomatic in each target language while preserving API terminology and semantics. Centralize authentication, transport, retries, pagination, errors, cancellation, and telemetry; expose escape hatches only for real advanced needs.
5. Generated SDK retries must follow operation idempotency and server signals. Iterators should hide routine page traversal without preventing callers from controlling page size, cancellation, deadlines, or raw responses when required.
