---
name: web-security
description: Review a web application or API change for reachable authorization, injection, CSRF, SSRF, unsafe redirects, browser-defense, or secret-handling flaws. Use when reviewing a web/API diff or triaging a specific code or scanner finding. For a broad codebase security audit, use security-audit; for CI, containers, or database controls, use the matching specialist skill.
license: MIT AND Apache-2.0
metadata:
  source: "Includes material from Google Chrome Modern Web Guidance 1.0."
---

# Web application security review

Keep the review defensive and within the user's scope. Inspect source code, configuration, tests, and approved local fixtures. Do not probe, exploit, or change a live system unless the user specifically authorized that activity.

Read the applicable reference before judging its area. Read [references/access-control.md](references/access-control.md) for object authorization, ownership, mass assignment, or tenant isolation. Read [references/frameworks.md](references/frameworks.md) when framework defaults affect a suspected issue. Read [references/browser-defenses.md](references/browser-defenses.md) for browser security headers, cookies, origin checks, Trusted Types, CSP, sanitization, or passkeys. Read [references/defaults-and-sinks.md](references/defaults-and-sinks.md) for fail-open behavior, credentials in serialization, or logging and tracing sinks.

Read the exact framework versions from the lockfile. Trace untrusted input from its entry point to its security-sensitive sink and inspect every intervening control and caller. A pattern is a finding only when the input is untrusted, the path is reachable in the delivered application, and an effective upstream control does not block it. Treat alerts and monitoring as evidence, not as enforcement.

Report a confirmed finding with the actor, entry point, route or operation, concrete local scenario, root cause, impact, severity basis, and file and line. Mark uncertainty and the exact check that would resolve it. Prefer the narrowest fix that enforces the needed policy in code, and add a regression check for behavior that the existing suite does not cover. Do not include unnecessary exploit instructions or sensitive values in the report.

For a whole-codebase threat model, many findings, or coordinated fixes, use `security-audit`. For a change limited to React or Next server-action boundaries, combine this skill with `react-next`.
