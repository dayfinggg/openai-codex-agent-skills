---
name: security
description: Apply proportional secure-by-design safeguards to code, architecture, configuration, dependencies, and tests. Use automatically when a change crosses a trust boundary, handles identity, secrets or sensitive data, exposes an interface, processes untrusted input, performs privileged actions, or changes cloud and delivery infrastructure; use for explicit security reviews, but skip a broad audit for ordinary low-risk edits with no security-relevant surface.
---

# Security

Protect the requested behavior at the affected attack surface. Apply safe defaults as part of the implementation, not as unrelated hardening work. Every added control must answer a concrete threat, abuse case, policy, or data-protection need.

## Scale the work to the risk

Use focused security reasoning when a change touches authentication, authorization, sessions, tokens, personal or regulated data, secrets, cryptography, user-controlled content, file or URL handling, interpreters, databases, outbound requests, public APIs, payments, multi-tenancy, dependencies, build pipelines, cloud identities, networks, storage, or public exposure.

For an ordinary local edit outside those surfaces, preserve existing controls and check that the change does not weaken them. Do not add a threat-model document, scanner, dependency, security header, permission layer, or audit section without an applicable risk.

When the user requests a security review, examine the requested scope fully. For implementation work, repair security issues in the changed path and its necessary boundaries; report material unrelated findings without expanding the patch unless the user asks.

## Model the changed surface

1. Identify protected assets, actors, attacker-controlled inputs, privileges, trust zones, data flows, stores, external dependencies, and operations with financial, privacy, availability, or administrative impact.
2. Mark each boundary where identity, data, code, or control crosses into a different trust level. Treat clients, browsers, third-party APIs, queues, files, caches, webhooks, internal networks, and persisted data as untrusted until a verified control establishes otherwise.
3. Ask what an attacker could read, alter, invoke, replay, enumerate, exhaust, or bypass. Include legitimate-account abuse, cross-tenant access, workflow reordering, concurrency, and cost amplification when applicable.
4. Rank only material threats by impact, exploitability, exposure, and recoverability. Use the smallest control set that reduces those threats to an acceptable level.
5. Verify framework, protocol, platform, cloud, and library behavior against current official documentation for the versions in use. Do not design authentication, cryptography, sanitization, or policy syntax from memory.

Ask for a missing classification, trust decision, compliance requirement, or acceptable residual risk only when it can materially change the design. Do not invent regulatory obligations.

## Apply baseline defaults

- Enforce security decisions on the trusted server or service boundary. Client-side checks may improve usability but cannot establish authorization or integrity.
- Deny by default and grant the least privilege needed for the specific actor, action, resource, property, tenant, and condition. Recheck authorization for every request and state transition.
- Keep data separate from code. Use typed APIs, parameter binding, safe sinks, and structured arguments rather than concatenating untrusted values into queries, commands, templates, expressions, headers, or paths.
- Reject malformed, unexpected, oversized, deeply nested, or out-of-range input before expensive or privileged work. Bound request size, work, time, retries, concurrency, fan-out, storage, and monetary cost.
- Minimize sensitive data and secret exposure. Do not place credentials, tokens, keys, connection strings, or raw personal data in source, logs, errors, URLs, test fixtures, build artifacts, or client-readable storage.
- Use established security libraries and platform services. Do not create custom cryptographic algorithms, token formats, password hashing, random generators, sanitizers, or authentication protocols.
- Fail closed when authentication, authorization, validation, key retrieval, policy evaluation, or a required security dependency fails. Preserve a diagnosable internal signal without revealing sensitive details to the caller.
- Use authenticated protected transport and verify peer identity. Do not disable certificate, hostname, signature, or integrity verification to make an integration work.
- Keep defaults restrictive and make exposure, privilege, cross-origin access, long retention, and destructive behavior explicit.

## Load only relevant domain guidance

Before editing a triggered domain, read its reference. The baseline summary above is not a substitute for the domain-specific constraints.

1. Read [web and API security](references/web-and-api.md) when the change involves browsers, HTTP, authentication, authorization, sessions, OAuth or JWT, APIs, user content, uploads, outbound URLs, CORS, CSRF, XSS, or abuse controls.
2. Read [data and supply-chain security](references/data-and-supply-chain.md) when the change involves databases, sensitive data, secrets, cryptography, logging, dependencies, packages, build artifacts, or CI workflows.
3. Read [cloud and infrastructure security](references/cloud-and-iac.md) when the change involves cloud resources, infrastructure as code, workload identities, networks, containers, storage, state files, deployment pipelines, or public exposure.

Read multiple references only when the change crosses those domains. Do not load them for a low-risk edit whose security behavior is already fixed by adjacent code.

## Verify security properties

Map each material threat to a control and observable evidence. Prefer focused tests of security behavior over scanner output alone.

- Test unauthenticated, wrong-user, wrong-role, wrong-tenant, wrong-object, revoked, expired, replayed, malformed, oversized, duplicate, concurrent, and dependency-failure cases that apply.
- Verify allowed behavior as well as denial. Confirm the control acts at the trusted boundary, fails closed, and cannot be bypassed through alternate routes, methods, encodings, fields, or workflow order.
- Run existing compiler protections, linters, tests, secret scans, dependency review, static analysis, IaC policy checks, container scans, fuzzers, or dynamic security tests when they cover the changed risk.
- Add a new security tool only when the project lacks a necessary capability and the expected reduction in risk justifies its dependency, configuration, runtime, and false-positive cost.
- Protect test data and evidence. Use isolated credentials and synthetic data; do not copy production secrets or personal data into fixtures, logs, screenshots, or reports.
- Preserve useful security events for authentication, authorization, privilege, configuration, secret, and sensitive-data actions without recording the protected values.

For a confirmed vulnerability, add a regression test at the narrowest boundary that reproduces the exploit or violated invariant, then run the broader path needed to prove the mitigation.

## Final audit

Reject or revise the change if any answer is no.

1. Is the changed attack surface and every crossed trust boundary understood?
2. Does every new control mitigate a named, applicable threat without unrelated complexity?
3. Are authentication and authorization enforced at the trusted boundary with deny-by-default behavior?
4. Are untrusted values kept out of code contexts and privileged sinks through safe APIs rather than filtering alone?
5. Are sensitive data, credentials, keys, tokens, logs, and errors minimized and correctly protected across their lifecycle?
6. Are resource use, automation, replay, concurrency, and business-flow abuse bounded where material?
7. Do tests or other evidence demonstrate both permitted behavior and relevant denial or failure cases?
8. Did the patch avoid weakening existing controls, exposing a new public surface, or claiming security based only on a tool passing?
