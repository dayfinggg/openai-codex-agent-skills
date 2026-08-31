# Validation and serialization

Use DTOs or the project's chosen schema pipe for body, path, query, and header validation.
Nest's `ValidationPipe` can validate request properties and transform plain payloads into DTO instances. [Nst6]
Set `whitelist: true` to strip properties without validation decorators.
Set `forbidNonWhitelisted: true` when unknown properties must reject the request instead of being stripped. [Nst6]
Use explicit parse pipes when implicit conversion would hide a contract mistake.
Disable detailed validation messages in production when they could reveal internal rules. [Nst6]
Validate output DTOs or serialization rules for public responses.
Return allowlisted views rather than persistence entities with sensitive fields.
Keep validation deterministic and do not perform database lookups in the initial shape check.
Use consistent status, code, detail, and request identifier fields in error responses.
