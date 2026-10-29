---
name: api-contract-change
description: "Implement or modify HTTP API contracts with validation, errors, authorization, and client-compatibility checks. Use for endpoint, request schema, response, or API middleware changes."
---

Preserve the API behavior that existing clients and integrations rely on.

1. Read the requested outcome, endpoint implementation, schema or OpenAPI definition, callers, middleware, and relevant tests. Establish method, route, payload, response, and accepted event types.
2. Identify untrusted inputs and validate at the owning boundary. Preserve distinctions among malformed input, authentication failure, authorization denial, not found, and internal failure where the contract exposes them.
3. Treat source authentication, user-access policy, and supported events as separate decisions. A signature or token fix does not authorize restricting users or dropping accepted event types.
4. Trace data transformations through application and persistence boundaries. Check content types, encoding, nullability, pagination, idempotency, and version compatibility only where the change touches them.
5. Implement the smallest compatible behavior. Keep internal exceptions and secrets out of client errors while retaining diagnostic context in the existing logging system.
6. Verify success and the material rejection or failure paths. Check status, headers, body shape, side effects, and the unchanged client behavior.
7. Update an existing API contract artifact when the requested behavior changes it. Do not create unrelated documentation or a new API version merely to record a local fix.

Use the relevant language and framework specialist. For schema or security mechanisms, read the actual installed framework's official documentation and the existing integration contract.

Finish when the requested contract is implemented and verified. Identify a genuinely incompatible change before applying dependent work if user intent cannot resolve it.

