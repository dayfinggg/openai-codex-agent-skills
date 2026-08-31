# Validation and persistence

- Flask has no built-in form-validation framework, so choose WTForms, Flask-WTF, or an explicit JSON schema library. [L10] [L11]
- Validate types, lengths, formats, content types, file sizes, and cross-field rules before calling application code.
- Treat request validation as shape and feedback handling; enforce durable invariants in application code and the database.
- Add CSRF tokens for cookie-authenticated state changes and test rejection of missing or invalid tokens. [L10]
- Flask does not include an ORM; choose SQLAlchemy or a maintained extension deliberately. [L5]
- Keep persistence sessions scoped to the application context and remove or close them on teardown. [L5] [L12]
- Use parameterized SQL, never interpolate user input into query text, and review raw SQL as security-sensitive. [L12]
- Use the selected ORM or query toolkit directly for ordinary CRUD and query composition.
- Add a repository only for a real persistence boundary, multiple stores, or a testable adapter contract.
- Keep query helpers near the capability that owns their meaning, and measure query count before optimizing.
- Add a service function when one use case writes multiple records or coordinates external effects.
