# Binding and validation

- Echo binding can read path parameters, query parameters, headers, and request bodies.
- Use explicit binding tags and choose one source when precedence could change the result.
- Bind into a dedicated DTO and map fields explicitly into a business or persistence type.
- Never bind directly into a struct that contains protected fields such as IsAdmin.
- Require the documented Content-Type and reject unsupported media types explicitly.
- Wrap the request body with http.MaxBytesReader before binding JSON, multipart, or uploads.
- Return 413 for an exceeded body limit and 400 for malformed syntax.
- Validate ranges, lengths, enums, cross-field constraints, and authorization after binding.
- Keep domain invariants in the application service so all callers share the rules.
- On a Go 1.27 toolchain, evaluate encoding/json/v2 for new JSON; duplicate names and invalid UTF-8 are rejected by default, while unknown-member rejection is opt-in.
- For legacy encoding/json, use Decoder.DisallowUnknownFields when unknown fields are not part of the contract and reject trailing values.
- Return safe field-level errors without echoing secrets or complete request bodies.
