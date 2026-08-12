# Control Catalog

Read only the sections relevant to the identified attack paths. Adapt controls to the language, framework, deployment model, and current official guidance.

## Trust boundaries and privilege

- Define which actor may perform each action on which object and under which state; deny unspecified behavior.
- Derive identity, tenant, and privilege from a trusted authentication context, not request-supplied identifiers.
- Enforce least privilege for processes, service identities, data stores, queues, files, and network access.
- Revalidate policy after every boundary crossing and before a privileged side effect; do not rely on a gateway as the only control when internal callers can bypass it.

## Input, output, and injection

- Validate type, length, range, structure, and allowed values after decoding and canonicalization. Reject invalid input rather than repairing ambiguous values.
- Use parameterized query and command APIs. When launching a process is necessary, use a fixed executable and structured argument array; avoid shell interpretation.
- Use context-specific output encoding and safe template APIs for HTML, URLs, JavaScript, CSS, headers, logs, and other interpreters.
- Remove dynamic evaluation and unsafe reflection where untrusted data can influence code, queries, templates, regular expressions, or directives.
- Bound parsing depth, collection sizes, decompression, regex work, and execution time to resist resource exhaustion.

## Authentication and account recovery

- Prefer established identity providers and framework middleware; verify issuer, audience, signature, validity window, and intended token type where tokens are accepted.
- Make recovery, enrollment, privilege elevation, and administrative authentication at least as strong as the primary flow.
- Use uniform external errors and abuse controls without relying on throttling as the sole protection.
- Protect credential changes with recent authentication when the risk warrants it, and invalidate affected sessions after compromise or reset.

## Authorization and tenant isolation

- Authorize every protected action server-side and bind object access to the authenticated subject and tenant.
- Check authorization on the final object selected, not only on list, route, or UI visibility.
- Centralize policy semantics while keeping enforcement adjacent to the protected operation; test default and error paths for denial.
- Prevent time-of-check/time-of-use gaps with transactions, atomic operations, immutable decisions, or revalidation immediately before the side effect.

## Sessions and request integrity

- Use framework-managed, unpredictable session identifiers and encrypted transport; never expose identifiers in URLs, logs, or diagnostics.
- Set cookie attributes and scope for the actual browser flow, rotate sessions after authentication and privilege changes, and enforce expiration and revocation.
- Protect state-changing cookie-authenticated requests against cross-site request forgery and validate origins where appropriate.
- Avoid browser storage for bearer credentials when a protected server-managed session or backend-for-frontend design is available.

## Secrets and key material

- Load secrets at runtime from an approved secret store or protected platform facility; never embed them in source, artifacts, images, fixtures, or client bundles.
- Scope credentials narrowly, rotate and revoke them, and separate environments and purposes.
- Prevent disclosure through exceptions, logs, traces, telemetry, command output, crash data, caches, and support tooling.
- Treat a discovered secret as compromised until rotation is confirmed; deleting it from the latest revision is not sufficient remediation.

## Cryptography

- Use maintained high-level libraries and approved protocols; do not design algorithms or compose primitives ad hoc.
- Use authenticated encryption when confidentiality and integrity are required, cryptographically secure randomness for security values, and adaptive password hashing per current platform guidance.
- Define key generation, storage, access, rotation, versioning, recovery, and destruction before adding encryption.
- Keep keys separate by purpose and environment. Never disable certificate or hostname validation to restore connectivity.

## Deserialization and parsing

- Prefer data-only formats with explicit schemas, strict types, bounded sizes, and rejection of unknown or dangerous constructs.
- Do not deserialize native object graphs or enable polymorphic type resolution for attacker-influenced data.
- Treat signatures and encryption as integrity or confidentiality controls, not substitutes for a safe parser, schema validation, or authorization.
- Run complex document, archive, media, and compiler parsers with minimal privileges and resource limits when isolation is practical.

## SSRF and outbound requests

- Avoid accepting arbitrary destinations. Use stable identifiers mapped to server-controlled endpoints when possible.
- If destinations are configurable, allow only required schemes, hosts, and ports; canonicalize and resolve names before enforcing policy.
- Block private, loopback, link-local, metadata, and other prohibited networks at both application and network layers; account for IPv4, IPv6, alternate encodings, DNS rebinding, and redirects.
- Revalidate every redirect and resolved destination, and bound connection time, response size, redirect count, and protocol behavior.

## Paths, files, and uploads

- Prefer opaque identifiers mapped to server-selected paths. Resolve the final path and verify containment within an approved root before access.
- Account for absolute paths, alternate separators, encoded traversal, case rules, symlinks, junctions, and race conditions on the target platform.
- Generate storage names, restrict file type and size using trusted inspection, store uploads outside executable or public roots, and isolate risky processing.
- Use least-privilege file permissions and atomic operations; do not trust an extension or client-provided content type.

## Dependencies and supply chain

- Minimize dependencies and review the resolved transitive graph, lockfile, source, maintenance state, license, and integrity or provenance mechanism.
- Confirm advisories against the exact resolved version, affected configuration, and reachable behavior; upgrade to a supported fixed version when feasible.
- Pin and verify build inputs where reproducibility matters, protect publishing credentials, and keep generated artifacts traceable to reviewed source.
- Do not add a security package whose operation, placement, configuration, and verification are not understood.

## Logging, privacy, and errors

- Record security-relevant successes and failures with enough context for investigation, but exclude credentials, tokens, cryptographic material, unnecessary personal data, and sensitive payloads.
- Use structured logging, neutralize untrusted control characters, restrict log access, define retention, and preserve useful timestamps and correlation identifiers.
- Minimize data collection and retention by purpose; verify deletion, export, redaction, and access paths where privacy requirements apply.
- Return generic external errors while retaining protected diagnostic detail internally; avoid account, object, stack, path, query, and configuration disclosure.

## Safe failure and resilience

- Deny access when authentication, authorization, policy, or integrity checks fail or become unavailable unless an explicitly approved risk model requires another behavior.
- Keep transactions and security state consistent across cancellation, retry, timeout, rollback, and partial dependency failure.
- Bound memory, CPU, concurrency, queues, request bodies, retries, and downstream work; apply backpressure before exhaustion.
- Remove debug modes and insecure fallbacks from production paths. Make recovery behavior preserve the same trust boundaries as normal operation.
