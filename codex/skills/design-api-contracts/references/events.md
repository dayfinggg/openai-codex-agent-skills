# Event Contracts

Apply these checks to published events, commands, queue messages, and streaming records.

## Meaning and Ownership

- Name an event as an immutable fact that already occurred. Name a command as a requested action. Do not blur the two semantics.
- Identify the owning producer, intended consumers, source-of-truth entity, and business invariant represented by the message.
- Keep event payloads self-contained enough for the promised consumer behavior without copying unrelated entity state.
- Define whether sensitive fields may be published, retained, replayed, or exported.

## Envelope and Delivery

- Define message identifier, event type, schema version, producer, subject or aggregate identity, occurrence time, publication time, correlation identifier, causation identifier, and trace context only when each has operational meaning.
- State delivery semantics honestly. Treat at-least-once delivery as allowing duplicates and retries. Do not claim exactly-once behavior without an end-to-end guarantee visible to consumers.
- Define the ordering scope, such as per aggregate or partition. Do not imply global order from partition-local ordering.
- Specify partition-key semantics when they affect ordering, affinity, or scaling visible to consumers.
- Define retry, dead-letter, expiration, and poison-message outcomes as observable contract behavior where applicable.

## Idempotency and Evolution

- Give consumers a stable deduplication identity or a domain idempotency key when duplicate processing is possible. Define its uniqueness scope and retention expectation.
- Specify how consumers handle late, duplicate, out-of-order, and replayed messages.
- Prefer additive evolution and tolerant readers. Do not remove fields or change meaning until all retained messages and supported consumers are compatible.
- Define upcasting or parallel-version behavior when historical messages remain replayable.
- Validate schemas through the registry or repository tooling and test representative producer-consumer pairs, including duplicate and reordered delivery.
