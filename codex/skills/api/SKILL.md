---
name: api
description: Design, implement, evolve, and validate HTTP, RPC, GraphQL, event, and webhook APIs against the actual protocol, versions, consumers, and operational constraints. Use for remote contracts, endpoints, schemas, integrations, SDKs, compatibility, and contract tests; do not use for internal functions with no remote interface.
---

# API

Build the smallest remote contract that expresses the required behavior and can evolve safely. Protocol semantics, consumer needs, and observable failure behavior outrank stylistic conventions.

## Establish the real contract

1. Identify the current implementation language and framework, protocol and transport, schema dialect and version, serializers, gateway or broker, authentication system, generated clients, supported client versions, and deployment topology. Use official documentation matching those versions.
2. Establish consumers, trust boundaries, use cases, business invariants, latency and payload limits, expected load, consistency, ordering, delivery, retention, compatibility, and deprecation commitments before choosing a style.
3. Inspect the existing routes or services, schemas, examples, SDKs, tests, telemetry, published documentation, and production behavior. Treat observable behavior used by supported consumers as part of the contract even when documentation is incomplete.
4. Preserve the user's requested scope and established API style unless evidence requires a change. Do not add a gateway, broker, federation layer, code generator, compatibility framework, or second protocol merely because it is common elsewhere.

## Choose the interaction style deliberately

1. Prefer resource-oriented HTTP when broad interoperability, web semantics, cacheability, and a uniform public interface matter.
2. Prefer RPC when the domain is operation-heavy, callers and servers share an interface definition, streaming or compact binary payloads matter, or low-latency internal communication justifies generated stubs.
3. Prefer GraphQL when materially different consumers need client-selected, graph-shaped reads and the team can operate schema governance, resolver authorization, batching, and demand controls.
4. Prefer events when producers and consumers require temporal decoupling, fan-out, buffering, or replay. Keep simple request-response workflows synchronous when they already satisfy the requirements.
5. A system may use more than one style at distinct boundaries, but each use case needs one authoritative semantic contract and explicit mappings between representations.

Read [interaction styles](references/styles.md) when selecting, modeling, or translating among HTTP, RPC, GraphQL, and event APIs, or when defining schemas and SDKs.

## Design a durable surface

1. Model consumer-visible domain resources and operations, not database tables, framework objects, or deployment internals. Give each field and operation one stable meaning.
2. Define request, response, error, and event schemas explicitly, including presence, nullability, defaults, formats, bounds, enum evolution, unknown-field behavior, and sensitive fields. Validate at the boundary and reject invalid input before side effects.
3. Bound every collection that can grow. Add pagination before release, use a deterministic order with a unique tie-breaker, and keep continuation tokens opaque and bound to the caller, filters, sort, and snapshot semantics.
4. Document supported filtering and sorting fields, operators, case rules, null behavior, cost limits, and ordering. Reject unsupported expressions instead of silently changing their meaning.
5. Prevent lost updates with a version, strong validator, or equivalent compare-and-set precondition when concurrent writers matter. Distinguish malformed input, failed preconditions, state conflicts, authentication failure, authorization denial, absence, throttling, and server failure.
6. Represent genuinely long-running work as an operation or job with a stable identifier, state, result or error, polling or notification contract, cancellation semantics, retention, and idempotent retrieval. Do not return completion before the promised state is observable.

## Preserve protocol semantics

1. For HTTP, use methods according to their defined meaning. `GET` and `HEAD` are safe, `PUT` replaces the selected resource and is idempotent, `DELETE` requests removal and is idempotent, `PATCH` applies a documented patch format, and `POST` performs resource-specific processing. Never hide a state-changing action behind a safe method.
2. Select status codes from the actual outcome. Use `201` only when a resource was created, `202` only when processing is accepted but incomplete, `204` only with no response content, `304` only for conditional retrieval, and `412` for a failed HTTP precondition. Preserve the distinction among client, authorization, conflict, throttling, and server failures.
3. Return a stable machine-readable error identifier and structured details. Human text may improve, localize, or vary and must not be the only programmatic signal. Do not expose stack traces, secrets, internal queries, or existence information that authorization policy intends to hide.
4. Define cache behavior deliberately with validators, freshness, `Vary`, and private or no-store controls as appropriate. Never allow shared caching of user-specific or sensitive representations without an explicit safe cache key and policy.

Read [reliability and verification](references/reliability.md) when handling authentication, errors, idempotency, retries, rate limits, webhooks, observability, compatibility, or contract testing.

## Evolve and prove the contract

1. Prefer additive, behavior-preserving evolution. Do not remove or repurpose fields, identifiers, enum values, protobuf tags, error codes, event meanings, defaults, or ordering while supported consumers may rely on them.
2. Introduce a new version only for a real incompatible contract that cannot be staged additively. Run old and new versions concurrently for the declared transition, publish migration guidance, measure usage, communicate deprecation, and separate deprecation from shutdown.
3. Keep the machine-readable contract synchronized with implementation and examples. Use the specification version supported by the project's current tooling; do not upgrade the dialect merely because a newer one exists.
4. Validate schema syntax, examples, generated clients, server conformance, compatibility against the last released contract, consumer expectations, and behavior over the real transport. Exercise invalid input, authorization, pagination boundaries, concurrent updates, duplicate requests, retries, timeouts, throttling, partial failures, and duplicate or reordered events where relevant.
5. Review the final diff for accidental surface expansion, undocumented behavior, unsafe retries, unbounded work, sensitive output, breaking schema changes, transport-semantic errors, and tests that only validate mocks instead of the provider.
