---
name: devops
description: Build, change, and validate software delivery and production operations using the project's existing CI/CD, artifact, infrastructure, platform, and recovery systems. Use for builds, pipelines, containers, infrastructure as code, deployments, secrets, supply chain, rollbacks, backups, disaster recovery, operational readiness, and cost; do not use for application code changes with no delivery or operational impact.
---

# DevOps

Ship one verified artifact through the smallest reliable pipeline that fits the existing platform. Automation must remove a measured source of delay, inconsistency, or risk; configuration that only appears sophisticated is a liability.

## Start from the actual delivery system

1. Identify the repository layout, build tool and version, lockfiles, CI provider, runners, artifact store, container tooling, infrastructure as code, environments, deployment platform, identity system, secret store, observability, backup system, and every supported version. Use official documentation matching those versions.
2. Inspect current workflows, scripts, manifests, infrastructure state and plans, release history, deployment failures, rollback records, incidents, runbooks, cost data, and ownership. Preserve working platform conventions and authorization boundaries.
3. Establish the deployable unit, consumers, service-level objectives, availability and maintenance constraints, recovery time and recovery point objectives, data migrations, compliance, delivery frequency, expected scale, operational staffing, and budget.
4. Trace source to build, test, package, publish, promote, deploy, verify, and recover. For each transition, identify the immutable input and output, identity, permissions, trust boundary, evidence, timeout, retry behavior, concurrency rule, and stop condition.
5. Do not replace the current CI service, cloud, artifact format, infrastructure tool, runtime, or deployment platform unless the requested outcome requires it. Avoid a second deployment path that can drift from the first.

## Build the minimum complete pipeline

1. Build once from a specific source revision and pinned dependency and toolchain inputs. Produce an immutable, content-addressed artifact and promote that exact digest through environments; never rebuild separately for production.
2. Keep pull-request feedback fast and release validation complete. Every gate must detect a named failure mode or enforce a real policy. Remove duplicate jobs, ceremonial approvals, copied shell fragments, and reports nobody uses.
3. Keep substantive build, test, migration, and deployment logic in versioned scripts or tools that can run outside the CI service. Let workflow configuration orchestrate rather than become the only implementation.
4. Treat caches as disposable acceleration, not evidence or a source of truth. Key them from all behavior-changing inputs, separate trusted and untrusted writers, and prove that a clean build succeeds without cache state.
5. Record artifact digest, source revision, toolchain, dependency lock, platform target, and verification results. Add provenance, signatures, attestations, and a software bill of materials when the distribution or threat model benefits, and verify them at the consumption boundary.
6. Keep environment-specific configuration and secrets outside the artifact. Use the same deployment process in every environment, with explicit differences in configuration, capacity, credentials, and protection rules.

Read [delivery mechanics](references/delivery.md) when changing builds, CI/CD, artifacts, containers, infrastructure as code, environments, migrations, rollout strategies, or feature flags.

## Make production changes safely

1. Store infrastructure definitions, deployment configuration, migrations, and operational scripts in version control. Preview and review the exact change that will be applied, serialize writers to shared state, retain audit evidence, and detect drift.
2. Select recreate, rolling, blue-green, or canary delivery from downtime tolerance, state, capacity, traffic control, compatibility, and risk. Progressive delivery is useful only when a representative cohort and decisive health signal exist.
3. Define preconditions, readiness checks, smoke tests, health signals, observation windows, automatic stop thresholds, rollback or roll-forward actions, and the person or system authorized to proceed before deployment begins.
4. Coordinate database and message changes with every application version that may run during the rollout. Prefer expand, migrate, verify, and contract. Keep backfills bounded, resumable, idempotent, observable, and separately controllable.
5. Do not equate application rollback with data rollback. For each destructive or irreversible step, declare the last safe rollback point, backup or copy, validation, forward-repair path, and recovery owner.
6. Use feature flags to separate deployment from release only when staged exposure, rapid disablement, or experimentation is required. Give every flag an owner, safe default, telemetry, removal condition, and expiry; flags do not replace compatibility or rollback planning.

## Protect the delivery path

1. Separate untrusted validation from privileged publication and deployment. Grant each job, runner, service account, and workload only the permissions and secrets needed for that stage.
2. Prefer workload identity and short-lived credentials over stored cloud keys. Restrict trust by repository, workflow, branch or tag, environment, audience, and subject, and require protected environments for sensitive deployment credentials.
3. Pin third-party actions, build images, modules, and tools to immutable versions or digests where supported. Review updates deliberately and verify downloaded artifacts before execution.
4. Keep secrets in the platform's supported secret store, encrypted in transit and at rest, scoped narrowly, rotated, auditable, and absent from source, images, caches, state output, command arguments, logs, and build artifacts.
5. Containerize only when packaging or runtime isolation benefits the deployment. Use a minimal runtime image, exclude build tools and credentials, define a non-root identity where supported, and set explicit health and resource behavior.

Read [operations and recovery](references/operations.md) when choosing Kubernetes or serverless, managing secrets and supply-chain controls, defining operational readiness, backups, disaster recovery, runbooks, or cost controls.

## Prove readiness and recovery

1. Rebuild in a clean environment and compare the artifact identity or explain every intentional source of variation. Verify provenance and signatures against an explicit trusted identity and policy, not merely their presence.
2. Validate workflow syntax, manifests, infrastructure configuration, policies, migrations, and generated plans with the repository's pinned tooling. Test the narrowest changed stage first, then the complete promotion path.
3. Deploy the same artifact with the same automation to a representative non-production environment, then use the selected production rollout. Verify application health, dependencies, telemetry, capacity, security boundaries, and user-visible behavior.
4. Exercise failure before relying on recovery: cancel or fail a deployment, roll back a compatible release, rehearse the irreversible recovery path, restore backups into isolation, and confirm recovery objectives with measured results.
5. Require an owner, support path, actionable alerts, dashboards, dependency and quota inventory, capacity limits, runbooks, incident access, backup evidence, recovery contacts, and cost attribution before declaring operational readiness.
6. Review the final change for mutable artifact references, rebuild-per-environment behavior, secret exposure, excessive privileges, concurrent deploys, unbounded work, platform-specific lock-in without benefit, missing stop conditions, untested recovery, orphaned resources, and configuration whose purpose cannot be stated.
