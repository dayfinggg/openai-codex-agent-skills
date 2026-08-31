# Validations

- Validate user-facing and domain input before persistence with the smallest clear validator.
- Remember that `save`, `create`, and `update` return failure information, while bang variants raise `RecordInvalid`.
- Add a unique database index for every uniqueness rule that must hold under concurrent writes.
- Match scoped uniqueness validations with the same composite unique index in the database.
- Treat validation as a friendly preflight, not a substitute for database constraints or authorization.
- Identify every write path that can bypass validations before relying on a model rule.
- Use custom validators for domain rules that need names, reuse, or more precise error messages.
- Keep validators deterministic and local; do not make network calls or mutate unrelated records during validation.
- Use conditional validation only when the condition is part of the domain and is easy to understand.
- Test both valid and invalid states, including boundary values and database constraint failures.
