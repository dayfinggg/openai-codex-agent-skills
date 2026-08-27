# Operations and Recovery

## Choose only the platform the workload earns

1. Prefer the current managed application platform, virtual machines, or simple container service when it satisfies availability, scaling, isolation, networking, and deployment requirements. Operational familiarity is a real constraint.
2. Choose Kubernetes only when multiple workloads materially benefit from its scheduling, service discovery, rollout, policy, resource, or portability model and the team can own cluster upgrades, access control, networking, storage, observability, capacity, backup, and incident response. Prefer a managed control plane when those tradeoffs fit.
3. Choose serverless functions for event-driven, stateless, bursty, or intermittent work when execution, payload, networking, concurrency, startup, observability, and vendor limits fit. Model duplicate delivery, idempotency, downstream capacity, quotas, and cost before adoption.
4. Do not introduce an orchestrator, service mesh, GitOps controller, policy engine, secret operator, progressive-delivery controller, or custom platform until a named requirement exceeds the current platform and the ownership and failure modes are accepted.
5. Avoid artificial cloud neutrality. Isolate provider-specific code at real boundaries, keep data and artifact exports possible, and document exit costs, but use managed capabilities when their operational benefit exceeds lock-in risk.

## Identity, secrets, and supply chain

1. Give humans, CI validation, artifact publication, infrastructure mutation, deployment, and runtime separate identities. Scope permissions by environment and resource, deny by default, and review unused access.
2. Prefer short-lived federated credentials tied to immutable workflow claims. When static secrets are unavoidable, store them centrally, rotate them, restrict readers, audit access, and support overlap during rotation.
3. Prevent secrets from entering command-line arguments, debug traces, crash dumps, shell history, caches, artifacts, images, plans, state output, or logs. Test redaction against transformed and encoded values rather than trusting masking blindly.
4. Pin and review third-party workflow actions, container bases, modules, plugins, and installers. Restrict network egress for privileged builders where practical and separate untrusted builds from release builders.
5. Define an artifact admission policy from risk: allowed source and builder identities, expected provenance, signatures, digest, vulnerability or license thresholds, and exception ownership. Attestations provide verifiable history, not automatic safety.

## Operational readiness

1. Assign a service and deployment owner, on-call or support path, escalation contacts, dependency owners, and an explicit maintenance responsibility for every production component.
2. Define service-level objectives and user-visible health signals. Alert on actionable symptoms and exhaustion risks, not every internal event. Link alerts to the relevant dashboard, runbook, recent changes, and escalation path.
3. Inventory dependencies, quotas, certificates, domains, licenses, storage growth, queues, scheduled jobs, third-party limits, data retention, and capacity ceilings. Give expiring or exhaustible resources a monitored owner.
4. Verify readiness, liveness, startup, graceful shutdown, connection draining, retry budgets, queue bounds, resource requests and limits, and overload behavior on the actual platform.
5. Keep an audit trail that connects source revision, artifact digest, configuration, infrastructure plan, migration, approver, deployment, feature exposure, and observed result.

## Runbooks and drills

1. Write a runbook for a routine or high-risk operation only when it makes execution safer and repeatable. Include purpose, owner, prerequisites, permissions, inputs, exact procedure, expected signals, validation, stop conditions, rollback or recovery, escalation, and last rehearsal date.
2. Write a diagnostic playbook around observable symptoms, decision points, containment, evidence preservation, and escalation. Do not encode an unverified list of random remediation commands.
3. Make commands safe to rerun or state explicitly when they are not. Guard destructive steps with target verification and a declared irreversibility boundary.
4. Rehearse deployment failure, credential rotation, dependency outage, capacity exhaustion, backup restoration, and disaster failover in an isolated or controlled environment. Update the procedure from measured results.

## Backups and disaster recovery

1. Derive backup frequency, retention, replication, and recovery design from business-approved recovery point and recovery time objectives. High availability, replication, snapshots, and backups solve different failures.
2. Back up authoritative data plus the configuration, keys or recovery material, artifact references, infrastructure definitions, and dependency information needed to restore service. Protect against operator error, corruption, credential compromise, and loss of the primary failure domain.
3. Encrypt backups, restrict deletion and restore access separately, use immutability or an independent account or location where the threat model requires it, monitor backup jobs, and test retention expiration.
4. A backup is not proven until restored into isolation and checked through application-visible invariants. Measure restore time and data loss, record the artifact and infrastructure versions used, and compare the result with recovery objectives.
5. Select backup-and-restore, pilot light, warm standby, or active-active only from business impact, recovery objectives, consistency, operating ability, and cost. Do not buy multi-region complexity without a recovery requirement it satisfies.

## Cost and lifecycle

1. Give every material resource an owner, environment, product or service, and cost-allocation identity. Track shared costs explicitly instead of forcing misleading precision.
2. Estimate recurring, burst, data-transfer, storage, observability, support, backup, disaster-recovery, and engineering costs before a platform change. Include the operational labor of Kubernetes, custom controllers, and self-managed services.
3. Measure utilization and unit cost where it supports decisions. Right-size from representative telemetry, schedule non-production resources to their needed hours, set budgets and anomaly alerts, and remove orphaned environments, artifacts, snapshots, addresses, disks, and feature infrastructure.
4. Optimize cost without violating availability, performance, security, retention, or recovery objectives. A cheaper system that cannot meet its verified requirements is not an optimization.
