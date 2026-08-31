# HTTP, persistence, and session boundaries

- Treat `$_GET`, `$_POST`, `$_COOKIE`, `$_FILES`, `$_SERVER`, decoded JSON, headers, and route values as untrusted transport data. Normalize them once into explicit request or domain values.
- Validate syntax and size at the request boundary, then enforce authorization, ownership, and business invariants in the application or domain layer.
- Escape output for the destination context at render time. HTML text, HTML attributes, URLs, JavaScript, CSS, SQL, and shell arguments require different handling.
- Use a template engine with context-aware auto-escaping when available. For direct HTML text or quoted attributes, use `htmlspecialchars` with an explicit UTF-8 contract and appropriate flags, but do not treat it as a universal encoder.
- Keep SQL structure static and bind values with prepared statements. Parameters cannot safely substitute table names, column names, keywords, or arbitrary sort expressions, so allowlist those separately.
- Wrap changes that must succeed or fail together in a transaction, and account for driver-specific isolation, savepoint, and implicit-commit behavior.
- Store passwords with `password_hash`, verify them with `password_verify`, and use `password_needs_rehash` to upgrade parameters after successful authentication.
- Configure session cookies with `Secure`, `HttpOnly`, and an intentional `SameSite` policy, enable strict session mode, and keep session identifiers out of URLs and logs.
- Regenerate the session identifier when authentication state or privilege changes, while preserving a safe transition for concurrent requests.
- Protect state-changing browser requests against CSRF. SameSite cookies are defense in depth, not a replacement for an application or framework CSRF mechanism.
- Release PHP's session lock as soon as a request no longer needs to mutate session state, especially before slow network or streaming work.
- Treat uploaded names, media types, paths, and file contents as untrusted. Enforce size and type policy, generate server-side names, store outside executable or public roots when possible, and move files only through the upload-aware API.
- Keep browser concerns, HTTP translation, persistence, and domain rules in separate boundaries even when a small application keeps them in one deployable package.
