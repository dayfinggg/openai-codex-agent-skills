# Context, validation, and JSON

- Take context.Context as the first parameter of service, repository, and client methods.
- Start request work from r.Context and preserve it through database and outbound HTTP calls.
- Derive a narrower timeout for each slow dependency and always call its cancel function.
- Use http.NewRequestWithContext for outbound calls so dialing, headers, and body reads share the deadline.
- Stop loops and goroutines when ctx.Done closes.
- Do not store a context in a struct, pass nil contexts, or use values for ordinary parameters.
- Validate method, route values, query values, headers, media type, body size, syntax, and domain invariants separately.
- Parse numeric, time, enum, and identifier values with typed parsers and reject overflow or trailing junk.
- Use dedicated input DTOs with allowlisted fields instead of binding into business or persistence structs.
- Require the documented media type and reject unsupported Content-Type values explicitly.
- Decode one JSON value and then require end-of-input so concatenated values are not silently accepted.
- Use Decoder.DisallowUnknownFields for legacy encoding/json DTOs when unknown fields are not part of the contract.
- When the toolchain includes Go 1.27 encoding/json/v2, prefer it for new JSON where compatible.
- encoding/json/v2 rejects duplicate object names and invalid UTF-8 by default, but unknown-member rejection remains opt-in with RejectUnknownMembers.
- Return field-level validation details without echoing secrets or full attacker-controlled payloads.
