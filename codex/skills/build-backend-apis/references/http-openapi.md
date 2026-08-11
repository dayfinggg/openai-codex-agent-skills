# HTTP and OpenAPI contracts

**Reviewed:** 2026-08-11
**Scope:** HTTP Semantics RFC 9110, Problem Details RFC 9457, and OpenAPI 3.2.0. Use the contract version already adopted by the project unless an upgrade is requested.

## HTTP decisions

- Select a method from its defined semantics, including safety and idempotency. Application retries do not make a non-idempotent operation safe automatically.
- Use status codes and headers to describe the actual outcome. Preserve cache validators, conditional requests, content negotiation, redirects, and range behavior where consumers rely on them.
- Make pagination order stable. Treat cursors as opaque, integrity-protected when needed, and scoped to the same filters and authorization context.
- For idempotent create or command APIs, define key scope, request fingerprint, retention, concurrent duplicate handling, stored outcome, and retry response.
- Define request, header, body, decompression, response, and execution bounds before accepting untrusted traffic.

## Errors and contracts

- Use a stable machine-readable error media type. Problem Details members must not expose stack traces, credentials, internal SQL, or sensitive resource existence.
- Keep error identifiers and validation paths stable enough for supported clients. Do not turn human detail text into a parsing contract.
- Keep OpenAPI as an intentional source or derived artifact according to repository policy. Validate the document and compare generated clients or contract tests after a change.
- Treat external references, examples, Markdown, and schema patterns as untrusted data. Pin or bound reference resolution and avoid fetching arbitrary URLs during build or validation.
- Express runtime validation separately from TypeScript or other compile-time types.

## Official sources

- [RFC 9110 HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html)
- [RFC 9457 Problem Details](https://www.rfc-editor.org/rfc/rfc9457.html)
- [OpenAPI Specification 3.2.0](https://spec.openapis.org/oas/v3.2.0.html)
- [JSON Schema Draft 2020-12](https://json-schema.org/draft/2020-12)
- [OWASP API Security Top 10](https://owasp.org/API-Security/)
