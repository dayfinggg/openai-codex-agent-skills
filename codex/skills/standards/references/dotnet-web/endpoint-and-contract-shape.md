# Endpoint and contract shape

- Use request and response DTOs rather than binding or returning persistence entities.
- DTOs prevent over-posting, hide server-only fields, stabilize the contract, and reduce payload size.
- Return the status code that describes the result, such as `201 Created` with a `Location` header after creation.
- Give endpoints stable names and explicit response metadata so generated OpenAPI describes real behavior.
- Bound list endpoints with filtering, ordering, and pagination instead of returning an unbounded collection.
