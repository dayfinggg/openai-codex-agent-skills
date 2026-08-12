---
name: secure-code
description: Design, implement, or review material security controls for a concrete attack path or security-specific assessment. For CI/CD security, pair with and defer primary workflow ownership to $operate-ci-cd. Exclude routine secure defaults, penetration testing, compliance, and generic code review.
---

# Secure Code

## Apply the security lens

- Follow repository conventions and general engineering skills for code structure, style, and maintainability; use this skill for security-specific analysis and controls.
- Base decisions on reachable attack paths, deployment context, data sensitivity, attacker capabilities, and observed controls.
- Distinguish observed facts, supported inferences, and unknowns. Never invent controls, configuration, test results, or guarantees.
- Prefer maintained framework and platform primitives. Avoid custom authentication, session handling, cryptography, parsers, sanitizers, and policy engines unless established primitives cannot meet the requirement and evidence justifies the exception.
- Make the smallest complete change that closes the evidenced attack path. Do not add unrelated speculative hardening or weaken an existing control to preserve compatibility.
- Verify version-sensitive guidance against current official framework, runtime, standard, and vendor sources before relying on it.
- Obtain explicit authorization before intrusive scanning, exploit attempts, credential use, or testing outside a local or designated test environment.

## Select the work mode

- For design, identify assets, boundaries, abuse cases, required controls, and verification evidence before choosing architecture.
- For implementation, trace each untrusted or privileged flow to its protected action or sink, then place controls at the earliest trusted enforcement point.
- For review, remain read-only unless changes were requested. Report only findings with an explainable attack path; label defense-in-depth observations and uncertainties separately.

## Follow the workflow

1. Establish scope: identify protected assets and security properties, actors and privileges, entry points, trust boundaries, sensitive data, deployment assumptions, and attacker-reachable components.
2. Trace flows: follow untrusted data from source to parser, transformation, and sink; follow identity and tenant context from authentication to every protected action and object lookup.
3. Prioritize: rank realistic abuse paths by reachability, preconditions, exploitability, impact, blast radius, existing control strength, and uncertainty. Read [risk-and-evidence.md](references/risk-and-evidence.md) for the assessment and evidence rules.
4. Choose controls: read only the relevant sections of [control-catalog.md](references/control-catalog.md). Prefer prevention at a trusted boundary, default denial, least privilege, safe libraries, and centralized policy enforcement.
5. Implement: keep authorization adjacent to the protected operation, preserve security invariants across retries and failures, and avoid silent insecure fallbacks. Add no control that depends only on client behavior or undocumented infrastructure.
6. Verify adversarially: test expected behavior plus malformed, boundary, unauthorized, cross-tenant, replay, concurrency, dependency-failure, and resource-exhaustion cases that apply. Treat scanners as leads, not proof; inspect the path and confirm the effective control.
7. Report precisely: state what was observed, changed, and executed; include evidence and residual uncertainty. If verification was unavailable, say what remains unverified and why. Never state that code is secure solely because tests or scanners pass.

## Preserve evidence quality

- Demonstrate a finding with the shortest safe source-to-sink or identity-to-action path, including preconditions and the ineffective or missing control.
- Use non-destructive reproductions in authorized environments. Prefer focused tests over weaponized payloads.
- Re-check generated code, defaults, middleware order, deployment configuration, and external enforcement instead of assuming they operate as named.
- Keep severity and confidence separate. Align severity with the project's rubric; otherwise use qualitative labels and explain the factors rather than inventing numerical precision.
- Close each material finding with a concrete remediation and a verification method. Record accepted or unresolved risk without presenting it as fixed.
