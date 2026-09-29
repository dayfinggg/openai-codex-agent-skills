---
name: securing-applications
description: Implement or review security-sensitive authentication, authorization, sessions, uploads, payments, secrets or protected data. Use for the changed trust boundary, not every internet-facing edit.
---

# Securing applications

Apply controls relevant to the changed boundary without turning an ordinary fix into a security overhaul. Preserve the project's established authentication and authorization contracts. Check current authoritative guidance for version-sensitive security APIs or numeric policy thresholds.

Check authorization on the server for each protected operation and record. Hiding a control is not access control. Deny access by default where permissions are unspecified, and do not change state through GET.

Use the framework's password and session facilities. Never store plaintext passwords or invent cryptography. Protect cookies, rotate session identifiers on authentication or privilege changes and avoid revealing whether an account exists. Password, timeout and rate-limit policies belong to the product's actual security requirements, not an arbitrary universal setting.

Parse and validate external input at the boundary. Parameterize queries and allowlist dynamic identifiers. Encode output for its context, sanitize deliberately supported user HTML with established tools and use framework CSRF protection for relevant cookie-authenticated mutations.

For uploads, verify content as well as claimed type, bound size, generate safe storage names and prevent execution or unintended public access. Keep secrets out of source, generated assets and diagnostic output.

Use security headers and dependency updates appropriate to the deployment and supported clients. Do not silently rotate credentials, revoke access, upgrade unrelated packages or run an invasive security test. Explain a confirmed out-of-scope risk without performing unrequested changes.
