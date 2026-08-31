# Binding and validation

- Prefer ShouldBind, ShouldBindJSON, or another ShouldBind variant when the service owns the error response.
- The Bind family aborts with a 400 automatically, which can conflict with a JSON error contract or a desired 422 mapping.
- Use a dedicated input DTO with explicit json, form, uri, and header tags.
- Never bind directly into a business or persistence struct because client fields could set protected state.
- Require the documented Content-Type and choose the binder explicitly when ambiguity would change behavior.
- Wrap the request body with http.MaxBytesReader before binding JSON, multipart, or uploads.
- Return 413 for an exceeded body limit and 400 for malformed syntax.
- Validate ranges, lengths, enums, cross-field rules, and authorization after binding.
- Keep domain validation in the application service so non-HTTP callers receive the same rules.
- On a Go 1.27 toolchain, evaluate encoding/json/v2 for new APIs; it rejects duplicate names and invalid UTF-8 by default, while unknown-member rejection remains opt-in.
- For legacy encoding/json, use Decoder.DisallowUnknownFields when unknown fields are not allowed and reject trailing JSON values.
- Return safe field errors and never echo passwords, tokens, or complete request bodies.
