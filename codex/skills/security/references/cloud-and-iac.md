# Cloud and infrastructure security

Read this reference only for cloud resources, infrastructure as code, workload identities, networks, containers, storage, state, pipelines, or public exposure.

## Identity and exposure

- Use separate human and workload identities. Prefer federation and temporary credentials; do not share users or embed long-lived cloud keys in applications, images, variables, or CI configuration.
- Grant each workload the smallest actions, resources, conditions, and duration it needs. Separate deployment, runtime, administration, break-glass, and read-only roles. Review cross-account and public access explicitly.
- Make resources private by default. Require an explicit reason, owner, protocol, source, destination, and protection for every public endpoint, ingress rule, egress path, shared resource, and cross-tenant trust.
- Segment trust zones and constrain both ingress and egress. An internal subnet, cluster, service mesh, or private endpoint does not make callers trustworthy; authenticate service identities and authorize operations.

## Resource defaults

- Use provider-managed encryption, key management, identity, logging, and policy controls when they meet the requirement. Keep encryption keys and administrative access separate from protected data and ordinary workload identities.
- Enable audit and security telemetry needed to detect identity, policy, network, secret, data, and configuration changes. Centralize protected logs with appropriate retention and alert routing.
- Configure backups, versioning, recovery, immutability, and deletion protection according to data value and recovery needs. Test restoration instead of treating backup configuration as proof.
- Reduce attack surface: disable unused ports, services, public IPs, default accounts, debug interfaces, metadata access, privileged execution, interactive administration, and broad outbound network access.
- For containers, use trusted minimal images, fixed digests where policy requires them, non-root execution, dropped capabilities, read-only filesystems, resource limits, isolated secrets, and image or manifest scanning when supported.

## Infrastructure as code

- Treat plans, state, outputs, caches, and logs as potentially sensitive. Marking a value sensitive may only hide display; verify whether the tool still stores it.
- Keep state in an approved remote backend with encryption, locking, least-privileged access, versioning or recovery, and audit logs. Never commit state or plan files containing infrastructure data or secrets.
- Avoid embedding secrets in configuration. Use ephemeral or write-only inputs when supported, or resolve secret references at runtime. Restrict outputs to non-sensitive identifiers.
- Pin provider, module, image, chart, and action versions according to project policy. Review generated plans for public exposure, permission expansion, destructive replacement, secret disclosure, and drift before applying.
- Encode security baselines as reusable modules, policy checks, and deployment guardrails when the project already has that operating model. Do not duplicate platform policy with inconsistent local checks.

## Delivery and operation

- Separate low-trust pull-request validation from privileged release and deployment jobs. Never execute untrusted code with production secrets, cloud credentials, signing keys, writable caches, or repository write tokens.
- Give CI jobs explicit minimal permissions and short-lived cloud identity. Protect environment approvals and deployment branches according to impact. Keep build and deployment artifacts traceable to reviewed source.
- Apply changes through reviewed automation rather than manual consoles when feasible. Detect drift and emergency changes, and feed them back into code without erasing the audit trail.
- Roll out security-sensitive infrastructure changes incrementally. Validate policy, identity, network reachability, logging, recovery, and rollback in a lower-risk environment before wider exposure.
- Protect cloud metadata and control-plane endpoints from application-originated requests through workload identity design, egress filtering, hop or token protections, and SSRF defenses.
- Monitor for permission growth, public exposure, disabled logging, failed secret rotation, vulnerable images, unsigned or unexpected artifacts, and configuration drift. Route actionable alerts to an owned response process.
