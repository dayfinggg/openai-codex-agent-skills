---
name: writing-secure-code
description: Writes and reviews code at trust boundaries by OWASP Top 10 and CWE Top 25 with safe-by-construction APIs. Use when code handles untrusted input, files, uploads, auth, sessions, tokens, secrets, crypto, shell commands, paths, URLs, or HTML, and for security reviews.
---

# Writing secure code

Secure code stays correct when every input is hostile and every dependency can fail. Remove whole classes of weakness by choosing APIs that keep data apart from code, check permissions on the server for every object, and fail closed. The rules follow the OWASP Top 10 Proactive Controls 2024, and each one names its OWASP Top 10 2025 category and its CWE numbers, so findings can cite them. The working-with-databases skill owns SQL and NoSQL injection, the designing-http-apis skill owns endpoint, property, and transport rules of an API, the securing-llm-features skill owns code that calls models, the managing-dependencies-and-ci skill owns packages and CI, the adding-observability skill owns logging, and the writing-clean-code skill owns general error style. When the project or its framework already has security controls, such as an authorization layer, CSRF middleware, or an escaping template engine, use them and follow the project's conventions over this skill.

## Ten rules

1. **Treat all external input as untrusted.** Requests, headers, cookies, uploaded and read files, queue messages, webhooks, responses from third-party APIs, and LLM output all cross a trust boundary. Parse them at that boundary into typed values and validate them against allow-lists of type, length, range, format, and permitted values. Reject what does not match instead of repairing it. Validation narrows input but never replaces a safe sink. (C3, A05 2025, CWE-20)
2. **Use a safe-by-construction API at every sink.** Pick the API from the sinks table that keeps data separate from code, commands, and paths, instead of escaping by hand. Never build HTML, shell commands, file paths, queries, or code by joining strings with input. (C3, A05 2025, CWE-79, CWE-78, CWE-77, CWE-94, and the CWEs in the sinks table)
3. **Authorize every object and every function on the server, and deny by default.** On each request check that the authenticated principal may perform this action on this specific record, in the use case or a policy it calls, not only in the UI, the router, or at login. Load records through queries scoped to the caller, such as by owner or tenant, and answer as if a record the caller may not see does not exist. Never trust identifiers, roles, prices, or ownership sent by the client. (C1, A01 2025, CWE-862, CWE-863, CWE-639, CWE-284)
4. **Use the framework's authentication and session handling.** Never write login, session, password reset, or token code yourself when the framework or a vetted library provides it. Hash passwords with an adaptive algorithm, Argon2id by default. Give session cookies `Secure`, `HttpOnly`, and `SameSite`, renew the session ID after login and every privilege change, and invalidate it on the server at logout. Turn on CSRF protection for state-changing requests that rely on cookies, and never change state on GET. Verify every JWT signature against a fixed list of expected algorithms and check `exp`, `iss`, and `aud`. Every function that changes data or reveals non-public data requires authentication unless it is deliberately public. (C7, A07 2025, A01 2025, CWE-306, CWE-352)
5. **Keep secrets out of code and use vetted cryptography.** Read secrets at runtime from a secret manager, or from the environment when the project has no secret manager, and never put them in source, committed configuration, container images, URLs, logs, or error messages. Ship no hardcoded or default credentials. Use the high-level API of the platform or a vetted library, AES-GCM for encryption, a cryptographically secure random generator for tokens, keys, and unguessable identifiers, and constant-time comparison for secrets and MACs. Never invent algorithms or protocols, and never use outdated algorithms or ECB mode. (C2, A04 2025, A07 2025, CWE-798, CWE-327, CWE-330)
6. **Ship secure defaults.** A fresh install is safe without extra configuration. Debug modes, stack trace pages, sample accounts, and admin or diagnostic endpoints are off outside development. Processes, service accounts, tokens, and files get the least privilege they need. Serve HTTPS only with HSTS, send a CSP and `X-Content-Type-Options: nosniff`, and allow CORS only for explicit origins. A missing or invalid security setting stops startup instead of falling back to an insecure mode. (C5, A02 2025, CWE-489, CWE-942)
7. **Fail closed and roll back partial work.** An error inside an authorization check, signature verification, policy lookup, or validation denies the request, and no catch block continues as if the check had passed. Wrap multi-step changes in one transaction, or undo completed steps with compensating actions, so a failure halfway leaves no partial state. Users see a generic message with a correlation ID, while stack traces, SQL, file paths, and internal names stay in the logs. A global handler is the backstop, not the plan. Log security events such as failed logins and access denials, and follow the adding-observability skill for what never to log. (C3, A10 2025, A09 2025, CWE-636, CWE-209, CWE-200)
8. **Limit size, rate, and time.** Nothing driven by input is unlimited. Cap request bodies, uploads, decompressed sizes, collection lengths, nesting depth, page sizes, and loop counts. Put a timeout on every outbound call, child process, and query, and rate-limit login, password reset, and expensive operations. Take the numbers from the project's configuration, and follow the building-resilient-services skill for timeout and retry policy. (A10 2025, CWE-770)
9. **Vet every dependency.** Follow the managing-dependencies-and-ci skill whenever a change adds, updates, or removes a package. (C6, A03 2025)
10. **Treat LLM output as untrusted input.** Validate and encode model output like any request field before it reaches a sink, and follow the securing-llm-features skill for everything else in code that calls models. (A05 2025, LLM05 2025)

## Sinks

| Sink | Safe default | CWE |
|---|---|---|
| HTML | The template engine's contextual autoescaping, `textContent` in the DOM, and DOMPurify for markup that must stay HTML, behind a strict CSP. Never pass untrusted data to `innerHTML`, `dangerouslySetInnerHTML`, `v-html`, or a template's raw output | CWE-79 |
| Links and redirects | Only `https` and `http` schemes in links built from input, and redirects only to relative paths or allow-listed hosts | CWE-601 |
| Processes | A library call instead of a process when one exists. Otherwise a fixed program with an argument array, no shell, and `--` before untrusted operands where the program supports it | CWE-78, CWE-77 |
| File paths | Names generated by the application. For a name from input, resolve it against a fixed base directory, canonicalize it, and open it only if the result stays inside the base | CWE-22 |
| Uploads | Allow-listed extensions, a type check that ignores the client's `Content-Type`, a size limit, a generated name, and storage outside the web root | CWE-434 |
| Dynamic code | No `eval`, `exec`, `new Function`, or templates compiled from input. Map input to an allow-list of operations | CWE-94 |
| XML | A parser with DTDs disabled, or with external entities and external DTD loading turned off | CWE-611 |
| Deserialization | JSON or another data-only format into explicit types. Never native object deserialization of untrusted data | CWE-502 |
| Outbound URLs | Scheme and host from an allow-list in configuration, redirects off, a timeout, and a response size limit. When any public host must be reachable, resolve the name, reject internal and metadata addresses, and connect to the checked address | CWE-918 |
| SQL and NoSQL | Bound parameters and allow-listed identifiers, as the working-with-databases skill describes | CWE-89 |

## C, C++, and unsafe code

These rules cover CWE-787, CWE-125, CWE-416, CWE-120, CWE-121, CWE-122, and CWE-476.

- **Language choice.** For a new component whose language the project does not dictate, choose a memory-safe language such as Rust, Go, Java, C#, or Python, as the CISA and NSA guidance of June 2025 urges. Never rewrite existing C or C++ on your own initiative. Suggest it at module boundaries, starting with network-facing and parsing code.
- **Bounds.** In C++ use `std::vector`, `std::string`, `std::array`, and `std::span` instead of raw arrays and pointer arithmetic, own memory through `std::unique_ptr` or `std::shared_ptr` instead of `new` and `delete`, and never pass an array as a single pointer (C++ Core Guidelines I.13). In C pass a length with every buffer and check every index and size before a read or copy.
- **Unsafe Rust and FFI.** Keep `unsafe` blocks small, wrap them in a safe API, and run their tests under Miri.
- **Build and test.** Turn on the compiler options of the OpenSSF Compiler Options Hardening Guide, run unit tests under AddressSanitizer and the other sanitizers the toolchain offers, and fuzz parsers and every function that reads external data.

## Workflow

1. List the trust boundaries the change touches, meaning where input enters, which sinks it reaches, which permissions apply, and which secrets it uses.
2. Find the security controls the project already has, such as authentication middleware, an authorization policy, CSRF protection, template escaping, and a secret store, and reuse them.
3. Validate input at the boundary, use the safe API at each sink, and add the authorization check in the use case.
4. Add tests for denied access to another user's object and to privileged functions, for malicious input at each sink, and for rollback after a failure halfway. The writing-tests skill covers how.
5. Run the project's security linters, static analysis, and secret scanning when they exist, and fix what they report.
6. Review the diff against the checklist. In a security review, report each finding with its location, OWASP category, CWE, and a concrete fix, most severe first.

## Checklist

- [ ] Every external input is validated at its trust boundary against an allow-list
- [ ] Each sink uses its safe API, and no markup, command, path, query, or code is built from input strings
- [ ] Every object access and privileged function checks authorization on the server and denies by default
- [ ] Authentication, sessions, cookies, CSRF, and JWT checks come from the framework and match the reference
- [ ] No secret or default credential appears in code, committed configuration, logs, or error messages
- [ ] Cryptography uses vetted high-level APIs and a secure random generator
- [ ] Defaults are secure, and invalid security configuration stops startup
- [ ] Errors deny access, roll back partial work, and show users no internals
- [ ] Sizes, rates, and durations driven by input are bounded
- [ ] LLM output and third-party responses are handled as untrusted input
- [ ] Tests cover denied access, malicious input, and rollback

## Reference files

Read them before the first change, the language section of the sinks file whenever code reaches a sink, the authentication file whenever a change touches login, sessions, tokens, secrets, or cryptography, and the examples file for every security task.

- [references/sinks.md](references/sinks.md) has safe patterns per sink for Python, JavaScript and TypeScript, Java, C#, and Go, with links to the OWASP cheat sheets.
- [references/auth-and-crypto.md](references/auth-and-crypto.md) has password hashing parameters, session and cookie settings, CSRF defenses, JWT validation, secrets handling, and cryptography choices, with links to the OWASP cheat sheets.
- [examples.md](examples.md) has before and after pairs for an IDOR, shell command injection, path traversal, SSRF, a fail-open handler, partial writes with leaked errors, and JWT validation.
