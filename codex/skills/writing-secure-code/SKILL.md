---
name: writing-secure-code
description: Secures code at trust boundaries by OWASP Top 10 and CWE Top 25. Use for code handling untrusted input, uploads, auth, sessions, tokens, secrets, crypto, shell, paths, URLs, or HTML, and security reviews.
---

# Writing secure code

The rules follow the OWASP Top 10 Proactive Controls 2024 and cite OWASP Top 10 2025 categories and CWE numbers for findings. Reuse the project's or framework's existing controls. SQL and NoSQL injection belong to working-with-databases, endpoint rules to designing-http-apis, model calls to securing-llm-features, packages and CI to managing-dependencies-and-ci, and logging to adding-observability.

## Rules

1. Parse every external input at its trust boundary into typed values checked against allow-lists of type, length, range, format, and values, and reject what does not match. Headers, cookies, files, queue messages, webhooks, third-party responses, and LLM output count as external. Validation never replaces a safe sink. (C3, A05, CWE-20)
2. At every sink use the safe-by-construction API from the sinks reference instead of escaping by hand or joining strings with input. (C3, A05, CWE-79, CWE-78, CWE-77, CWE-94)
3. Authorize every object and function on the server, in the use case or a policy, and deny by default. Load records through queries scoped to the caller's owner or tenant, and answer as if a forbidden record does not exist. Identifiers, roles, prices, and ownership from the client are untrusted. (C1, A01, CWE-862, CWE-863, CWE-639, CWE-284)
4. Use the framework's authentication, session, and CSRF handling with the settings in the auth reference. Every function that changes data or reveals non-public data requires authentication unless deliberately public. GET never changes state. (C7, A07, A01, CWE-306, CWE-352)
5. Read secrets at runtime from a secret manager, or the environment when the project has none. Code, committed configuration, images, URLs, logs, and errors hold no secrets, and nothing ships with default credentials. Use vetted high-level crypto per the auth reference. (C2, A04, A07, CWE-798, CWE-327, CWE-330)
6. A fresh install is safe. Debug modes, stack trace pages, sample accounts, and admin endpoints are off outside development, with least privilege everywhere. Serve HTTPS only with HSTS, a CSP, and `X-Content-Type-Options: nosniff`, and allow CORS only for explicit origins. An invalid security setting stops startup. (C5, A02, CWE-489, CWE-942)
7. Fail closed. An error in an authorization check, signature verification, policy lookup, or validation denies the request. Multi-step changes run in one transaction or are undone by compensating actions. Users see a generic message with a correlation ID, and details stay in the logs. Log failed logins and access denials. (C3, A10, A09, CWE-636, CWE-209, CWE-200)
8. Cap bodies, uploads, decompressed sizes, collection lengths, nesting depth, page sizes, and loop counts. Every outbound call, child process, and query has a timeout, and login, password reset, and expensive operations are rate-limited, with numbers from the project's configuration and policy from building-resilient-services. (A10, CWE-770)
9. Follow managing-dependencies-and-ci for every package change. (C6, A03)
10. Validate and encode LLM output like any request field before it reaches a sink. (A05, LLM05 2025)

## Tests and reviews

Add tests for denied access to another user's object and to privileged functions, for malicious input at each sink, and for rollback after a failure halfway. Run the project's security linters, static analysis, and secret scanning when they exist. In a security review, report each finding with its location, OWASP category, CWE, and a concrete fix, most severe first.

## Reference files

- [reference/sinks.md](reference/sinks.md) has the safe default per sink, the safe APIs for Python, JavaScript and TypeScript, Java, C#, and Go, and the rules for C, C++, and unsafe Rust. Read it whenever code reaches a sink or is written in a memory-unsafe language.
- [reference/auth-and-crypto.md](reference/auth-and-crypto.md) has password hashing parameters, session and cookie settings, CSRF, JWT validation, secrets, and cryptography choices. Read it whenever a change touches login, sessions, tokens, secrets, or cryptography.
- [examples.md](examples.md) has before and after pairs for an IDOR, shell command injection, fail-open authorization, partial writes with leaked errors, and JWT validation. Read it before a security review.
