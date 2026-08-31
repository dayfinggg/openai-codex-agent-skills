# Validation and representation

Validate path, query, header, cookie, and body data before application work.
Validate types, ranges, lengths, formats, relationships, and allowed values.
Reject unknown fields when the endpoint contract is closed.
Do not confuse compile-time types with runtime validation.
Keep one authoritative schema or validator for each external contract.
Validate output shape when the response is a public or versioned contract.
Serialize an allowlisted response object rather than spreading internal entities.
Do not perform expensive or stateful checks before cheap shape validation.
Return a stable error shape with a request identifier and application code.
Keep detailed validation data in logs only when it is safe to retain.
