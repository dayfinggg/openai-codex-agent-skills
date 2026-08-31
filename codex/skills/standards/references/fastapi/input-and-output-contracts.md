# Input and output contracts

- Declare request bodies with Pydantic models and constrain path, query, header, cookie, and form values at the boundary. [F3]
- Treat Pydantic validation as input parsing, not as a replacement for authorization or cross-record business rules.
- Reject or explicitly handle unknown fields when the API contract is closed.
- Declare return types or `response_model` for every public operation. [F4]
- Use output models to validate and document responses and to filter fields that must not leave the service. [F4]
- Use different input and output models for passwords, tokens, internal IDs, audit fields, and write-only data. [F4]
- Keep ORM or persistence objects internal and map them to response schemas.
- Never merge arbitrary request data into a persistence object or return a persistence object without an output contract.
- Keep status codes, pagination, error shapes, and OpenAPI metadata stable once clients depend on them.
- Test malformed input, boundary values, missing fields, response filtering, and serialization failures.
