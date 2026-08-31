# Parsing and validation

Apply `express.json()`, `express.urlencoded()`, `express.raw()`, or `express.text()` only where each parser is needed. [E1]
Set parser limits and accepted media types explicitly.
Mount raw-body parsing before JSON parsing for signed webhook endpoints.
Validate route parameters, query values, headers, cookies, and parsed bodies at the route boundary.
Reject unknown fields when the endpoint contract is closed.
Use a runtime schema library or validator because TypeScript annotations do not validate incoming data.
Validate response shape and serialize an allowlisted object rather than returning an ORM entity directly.
Return a stable error body with status, application code, and request identifier.
Do not put database lookups in a parser or cheap shape-validation middleware.
Keep validation errors safe to expose and log only the minimum detail needed to diagnose them.
