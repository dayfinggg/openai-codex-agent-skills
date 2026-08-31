# Boundary validation

- Treat HTTP responses, JSON, files, environment variables, message queues, DOM data, and plugin values as untrusted.
- Read unknown external values as `unknown`, validate structure and semantics, then construct a domain value.
- Put validation in a named adapter or parser instead of scattering casts through business code.
- Check required keys, optional-key presence, primitive types, ranges, formats, and cross-field invariants.
- Return a typed validation failure or throw a documented error according to the module's API contract.
- Keep validation errors useful by naming the boundary, field, received kind, and safe remediation context.
- Revalidate data after deserialization, even when a producer publishes a matching TypeScript type.
- Do not claim runtime safety because a value was assigned a TypeScript type.
- Use `satisfies` for compile-time checking of authored constants, not for untrusted runtime data. [S31]
- Test malformed, missing, extra, and semantically invalid input at every important boundary.
