---
name: secure-application
description: Design, implement, or review application security. Use for trust boundaries, authentication, authorization, input handling, secrets, dependencies, data protection, abuse resistance, security tests, and changes involving sensitive data or privileged actions.
---

# Secure Application

## Workflow

1. Identify assets, actors, trust boundaries, entry points, privileges, sensitive data, and plausible abuse cases in scope.
2. Validate untrusted input at trusted boundaries and encode output for its destination. Parameterize database queries, commands, and templates.
3. Authenticate securely and authorize every protected action and object server-side. Deny by default and apply least privilege.
4. Protect secrets and sensitive data in storage, transit, logs, errors, caches, backups, and generated artifacts.
5. Apply relevant controls for sessions, CSRF, CORS, SSRF, file handling, deserialization, redirects, webhooks, rate limits, and resource exhaustion.
6. Review dependencies, build provenance, deployment configuration, and failure defaults. Patch supported versions without speculative upgrades.
7. Add negative and boundary tests, run appropriate analysis, and report residual risk and unverified scope accurately.

Do not claim a complete security audit from limited evidence. Read [application security practices](references/practices.md) for current primary standards.
