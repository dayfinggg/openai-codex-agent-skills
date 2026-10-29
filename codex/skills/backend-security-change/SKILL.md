---
name: backend-security-change
description: "Secure changed backend boundaries while preserving access policy and accepted events. Use for authentication, authorization, webhooks, uploads, external requests, or security-sensitive API changes."
---

Fix the requested security boundary using the existing integration contract.

1. Establish the concrete threat or requested protection, affected entry points, framework versions, current trust model, and accepted users and events. Identify the evidence behind the problem.
2. Separate proving request origin, deciding user access, and accepting event types. Do not introduce an allowlist or drop events merely because source authentication is being repaired.
3. Read the official framework or provider documentation for the actual mechanism. For signed requests, inspect raw-body requirements, canonicalization, timestamp handling, replay rules, and comparison semantics.
4. Trace untrusted data into queries, commands, file paths, templates, outbound destinations, deserialization, and logs only where the changed path reaches them. Prefer supported APIs over invented validation.
5. Preserve intended error behavior and avoid exposing secrets. Reject malformed or unauthenticated input at the appropriate boundary without breaking legitimately supported requests.
6. Verify authorized success, material rejection cases, and unchanged access behavior. Use isolated fixtures for security tests. Do not run destructive probes against live services merely to demonstrate exploitation.
7. Review callers and integration consumers for contract regressions and complete the project's existing security checks.

For security-focused change analysis, read the [security review procedure](../code-review/references/security/guide.md) when that analysis is actually needed. Do not turn every backend edit into a repository-wide audit.

Consult [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/) and the exact mechanism's primary documentation. Report confirmed defects separately from conditional suspicions and avoid inventing stylistic findings.

