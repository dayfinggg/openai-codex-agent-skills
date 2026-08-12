# RPC Contracts

Apply these checks to typed request-response or streaming RPC contracts.

## Operations and Messages

- Name operations by domain behavior and define their preconditions, side effects, idempotency, and streaming lifecycle.
- Use explicit request and response messages even when initially empty so the contract can evolve without changing the operation shape.
- Distinguish field absence from a scalar default when presence affects behavior. Use the schema system's supported presence mechanism.
- Bound repeated fields and payload sizes where clients must account for limits.

## Failures and Control Flow

- Map failures to stable status codes and structured details. Keep transport failure separate from domain rejection.
- State which codes are retryable and whether retrying requires an idempotency key. Never imply safety from a generic unavailable or timeout result alone.
- Define deadline, cancellation, and partial-result behavior for unary and streaming calls.
- Specify authentication and authorization failures without leaking protected resource existence.

## Protobuf-Compatible Evolution

- Never reuse removed field numbers or names. Reserve them in the message definition.
- Do not change field types merely because the wire encoding is technically compatible when generated APIs or semantics change.
- Verify oneof additions, enum additions, map changes, packed encoding, and required-presence changes against every supported language runtime.
- Prefer additive fields with safe defaults. Do not depend on a new field being present until all required producers or consumers have migrated.
- Run the repository's wire-compatibility checker and compile supported generated clients before claiming compatibility.
