# Protocols and replaceable components

- Define a small `Protocol` at the consuming boundary when code needs a capability rather than a concrete implementation.
- Let implementations satisfy a protocol structurally; do not require inheritance only to register conformance.
- Prefer a consumer-owned protocol containing only the methods that consumer calls. Avoid speculative "complete" interfaces for future implementations.
- Use an abstract base class when nominal membership, shared implementation, registration, or runtime construction checks are part of the contract.
- Do not assume a protocol validates objects at runtime. Use `@runtime_checkable` only for the limited attribute-presence checks it supports, not as a substitute for parsing or validation.
- Inject replaceable I/O, storage, and service dependencies through these narrow contracts while keeping the entry point responsible for choosing concrete implementations.
