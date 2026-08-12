# Risk and Evidence

## Frame a threat

Capture only the facts needed to make a decision:

- The asset and threatened confidentiality, integrity, availability, authenticity, or privacy property.
- The actor, starting access, and capabilities that make the path plausible.
- The entry point and each trust or privilege boundary crossed.
- The protected action, sensitive object, or dangerous sink reached.
- Required preconditions and whether an attacker can satisfy them.
- The likely impact and blast radius, including tenant, account, host, or data scope.
- Existing preventive, detective, and recovery controls, with direct evidence for each.
- Unknowns that could change the conclusion and the cheapest safe way to resolve them.

Model normal flows and abuse flows. Include service identities, jobs, queues, caches, files, webhooks, administrative paths, recovery paths, and background workers when they participate in the decision. Treat data from an internal system as untrusted when another actor, tenant, service, or compromised component can influence it.

## Prioritize proportionally

Use the project's severity rubric when one exists. Otherwise compare findings qualitatively using:

- Reachability from the attacker's actual starting position.
- Complexity, timing, user interaction, and environmental preconditions.
- Privilege gained or policy bypassed.
- Sensitivity and volume of exposed or mutable assets.
- Cross-account, cross-tenant, host, fleet, or supply-chain blast radius.
- Strength and independence of current controls.
- Detection, containment, recovery, and persistence characteristics.
- Confidence in the evidence and the effect of unresolved assumptions.

Reserve the highest priority for plausible paths with severe impact and no effective control. Lower the priority when preconditions are narrow or independent controls materially reduce likelihood or impact. Do not lower it merely because exploitation was not attempted. Do not derive severity from a CWE label, scanner score, or vulnerable package version alone.

Use CVSS or another numeric scheme only when requested or required and enough environmental information exists. State the vector and assumptions so the score can be reproduced.

## Establish evidence

Prefer evidence in this order:

1. A safe reproducer or focused test showing the security property fails or holds.
2. A complete code and configuration path showing attacker influence, enforcement, and sink behavior.
3. Applicable runtime, framework, or vendor documentation for the exact supported version.
4. A scanner, advisory, or pattern match confirmed against reachability and effective configuration.

Do not treat a missing grep result as proof of absence. Check generated configuration, middleware composition, deployment manifests, identity provider settings, network policy, database policy, and platform defaults when the control can live outside application code. If those artifacts are unavailable, record the dependency as unknown.

For dependency findings, confirm the resolved version from a lockfile or build output, match the affected range and conditions in an official or vendor advisory, and determine whether the vulnerable behavior is reachable. A manifest declaration or package name alone is insufficient.

## Verify the control

Select tests from the threat, not from a generic checklist:

- Exercise allowed and denied identities, objects, tenants, roles, and state transitions.
- Cover empty, malformed, oversized, encoded, canonicalized, duplicated, and boundary values where input reaches a parser or sink.
- Test replay, fixation, expiration, revocation, stale authorization, race, retry, and partial-failure behavior when state or sessions are involved.
- Simulate dependency timeouts and failures to confirm the system does not bypass policy or expose sensitive diagnostics.
- Confirm secrets and sensitive data do not appear in responses, logs, telemetry, build output, caches, or persisted error records.
- Run relevant unit, integration, static, dependency, and configuration checks, but interpret each result in context.

## Communicate conclusions

For each material finding, provide the affected location, attack path, preconditions, impact, evidence, confidence, remediation, and verification method. Distinguish confirmed vulnerabilities from plausible risks, hardening opportunities, and unverified assumptions. Describe residual risk after remediation and avoid absolute claims such as "secure," "fully protected," or "no vulnerabilities."

For current baselines, prefer the applicable official framework and vendor security documentation. Use OWASP ASVS and Cheat Sheet Series for application-control coverage, CWE for weakness taxonomy rather than severity, NIST SSDF for lifecycle practices, and official ecosystem advisories for dependencies. Verify the current stable version and applicability before citing a requirement.
