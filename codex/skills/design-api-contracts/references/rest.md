# REST Contracts

Apply these checks only to HTTP resource-oriented contracts.

## Resources and Operations

- Use stable resource identities and noun-oriented paths. Model a command as an action endpoint only when it is not a natural resource-state transition.
- Match HTTP method semantics: GET and HEAD are safe, PUT and DELETE are idempotent, and PATCH semantics depend on the selected patch media type.
- Define supported request and response media types. State content negotiation and unsupported-media behavior when multiple representations exist.
- Separate resource identifiers from mutable display names. Avoid leaking storage keys unless they are the promised public identity.

## Responses and Failures

- Select status codes by observable outcome, not by handler convenience. Distinguish malformed input, failed validation, missing authentication, insufficient permission, absence, conflict, failed precondition, throttling, and transient failure.
- Define the response body and headers for successful creation, asynchronous acceptance, empty success, and conditional requests.
- Use one structured error envelope with a stable code, optional field violations, correlation identifier, and safe message. Do not expose stack traces or internal exception names.
- Define retry guidance through status, documented error code, and `Retry-After` where appropriate.

## Collections and Concurrency

- Prefer opaque cursors when data changes during traversal. Define a stable tie-breaker and whether inserts or deletes can cause gaps or duplicates.
- Bound page size and define default order. Make filter and sort fields explicit rather than accepting arbitrary storage expressions.
- Use ETags or explicit version tokens for observable optimistic concurrency. Define weak versus strong comparison and the response to a failed precondition.
- State cacheability and validators for read operations whose freshness matters to consumers.

## Evolution Checks

- Treat path, method, status, media type, field meaning, validation, and default changes as contract changes.
- Preserve unknown response-field tolerance only when consumers are documented to support it. Do not assume all clients ignore new fields or enum values.
- Prefer a compatible endpoint evolution over embedding version numbers preemptively. Introduce a new version only for an unavoidable incompatible contract.
