# Schemas and validation

Define JSON Schema for route bodies, parameters, query strings, headers, and responses.
Fastify compiles schemas for validation and serialization, so schemas are application code and must be trusted. [F1]
Use shared `$id` schemas and `$ref` when the same contract is reused.
Keep validation deterministic, bounded, and independent of databases or remote services.
Perform asynchronous existence or authorization checks in `preHandler` or the handler after shape validation. [F1]
Keep `allErrors` disabled unless a measured and reviewed requirement justifies the denial-of-service tradeoff. [F1]
Set `bodyLimit` and content-type parsers explicitly for each upload or media path.
Reject unsupported media types and malformed `Content-Length` values.
Define response schemas to serialize only the intended fields and to prevent accidental data exposure. [F1]
Treat validation failures as 400 responses unless the API contract deliberately maps them otherwise.
Customize the validation error format when raw schema details are not safe for clients.
