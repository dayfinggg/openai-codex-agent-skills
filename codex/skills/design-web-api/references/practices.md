# API Practices

Use registered HTTP methods and status semantics consistently. Make contracts machine-readable where the project supports OpenAPI. Define compatibility at the consumer-visible schema and behavior level, not only at the route level.

Retries require bounded attempts and idempotent semantics. Authorization must be checked for the action and object, not inferred from a valid identity. Pagination needs a stable ordering and a cursor or offset contract suited to mutation and scale.

Primary sources:

- [HTTP Semantics, RFC 9110](https://www.rfc-editor.org/rfc/rfc9110)
- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html)
- [OWASP API Security Project](https://owasp.org/API-Security/)
- [Semantic Versioning](https://semver.org/)
