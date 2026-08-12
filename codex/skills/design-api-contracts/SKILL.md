---
name: design-api-contracts
description: Design or revise REST, RPC, GraphQL, event, or queue contracts, including schemas, errors, compatibility, and tests. Use for consumed interface changes; exclude backend implementation, architecture, and database design.
---

# Design API Contracts

## Workflow

1. Locate the authoritative contract artifacts, repository conventions, generated outputs, and compatibility tooling. Identify producers, consumers, trust boundaries, supported client versions, and release constraints.
2. Define consumer outcomes and domain invariants before choosing transport details. Record each operation's preconditions, state transition or result, side effects, and observable guarantees.
3. Model requests, responses, and messages explicitly. Specify field meaning, ownership, source of truth, type, format, units, requiredness, nullability, defaults, mutability, sensitivity, and validation constraints.
4. Define collection behavior, error semantics, retry behavior, idempotency, and concurrency controls where applicable. Resolve the difference between absent, null, empty, and default values.
5. Apply only the matching transport guidance from the references below. Preserve established repository and organization conventions unless they conflict with correctness or compatibility.
6. Classify every change as backward compatible, conditionally compatible, or breaking for each known consumer. Prefer additive evolution. Define migration, deprecation, and removal conditions for any incompatible change.
7. Change the authoritative schema or interface source and focused contract tests. Regenerate derived artifacts with the repository's generator instead of editing generated files.
8. Run schema validation, compatibility checks, generated-client compilation, and contract tests supported by the repository. Include representative boundary and failure cases.

## Contract Rules

- Design from consumer semantics and invariants, not from framework routes, resolver shapes, service methods, or persistence tables.
- Give every operation and field one stable meaning. Do not reuse a field for a different meaning or silently strengthen validation.
- Use precise bounded types. Define timestamp zones and precision, identifier stability, numeric units and ranges, money currency, string formats, and enum unknown-value behavior.
- Expose the minimum contract required by current consumers. Do not add speculative fields, generic extension bags, unused versions, or premature flexibility.
- Keep transport representations independent of internal storage and implementation details. Expose an internal constraint only when consumers must observe it.
- Define stable machine-readable error codes separately from human-readable messages. State whether each failure is retryable and whether partial work can occur.
- Make pagination ordering deterministic. Specify cursor stability, page-size bounds, filtering, sorting, and behavior under concurrent updates.
- Require idempotency only for operations that can be retried or duplicated. Define key scope, request equivalence, retention window, and replay response.
- Define concurrency behavior explicitly when updates can conflict. Prefer observable preconditions or version tokens over undocumented last-write-wins behavior.
- Treat examples as executable fixtures or explanatory supplements, never as substitutes for schemas and invariants.
- Stop at contract-relevant artifacts. Do not invent application architecture, backend logic, or database changes to complete a contract design.

## Compatibility Review

Check changes against every supported consumer, including older deployed clients and independently released services. Examine renamed or removed fields, new required input, changed defaults, narrower validation, enum additions, ordering changes, altered error codes, pagination changes, and delivery guarantees. A syntactically additive change can still be behaviorally breaking.

Define deprecation with an alternative, discoverable signal, adoption evidence, and removal criterion. Do not claim compatibility without a schema diff, consumer analysis, or an equivalent repository-specific check.

## Validation Evidence

Prefer evidence from the repository's existing contract toolchain. Validate schema syntax and lint rules, positive and negative examples, request and response round trips, provider behavior, consumer expectations, compatibility against the last released contract, and generated bindings when present. Report untested consumers or guarantees as unknown rather than inferred.

## Transport References

- Read [REST contracts](references/rest.md) for HTTP resources, methods, status codes, caching, conditional requests, and pagination.
- Read [GraphQL contracts](references/graphql.md) for schema nullability, inputs, connections, mutations, errors, and deprecation.
- Read [RPC contracts](references/rpc.md) for typed operations, status models, deadlines, retries, and protobuf-compatible evolution.
- Read [event contracts](references/events.md) for event semantics, envelopes, delivery guarantees, ordering, deduplication, and schema evolution.
