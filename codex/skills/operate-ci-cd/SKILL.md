---
name: operate-ci-cd
description: "Use as primary whenever creating, repairing, reviewing, or hardening CI/CD pipelines, workflow files, GitHub Actions, runners, artifacts, releases, or deployment automation, including read-only security audits. Pair $secure-code when needed."
---

# Operate CI/CD

Use this as the primary workflow for pipeline and release-automation creation, repair, or review. Pair `$secure-code` for material attack-path analysis without transferring pipeline ownership. Build pipelines that are predictable under failure, safe across trust boundaries, and verifiable from source to deployed artifact. Treat pipeline review as read-only unless the user authorizes edits.

## Establish the operating context

1. Classify the request as creation, repair, review, or release preparation. Editing pipeline configuration never grants authority to run a deployment, publish a release, promote an artifact, or change protected settings.
2. Inspect the repository instructions, pipeline files, called scripts, lockfiles, build manifests, container definitions, deployment manifests, and relevant failure logs. Inspect platform settings when access exists. Do not infer settings, secrets, permissions, or environment protections that are not visible.
3. Identify the CI platform, event triggers, supported runners, target branches and tags, required checks, release artifact, deployment environments, and rollback constraints. Preserve repository conventions unless they cause the reported failure or violate a verified requirement.
4. Determine which behavior is encoded in the repository and which depends on external platform settings. State required external configuration precisely without claiming it was applied.
5. Verify essential deployment API and CLI contracts, workflow and toolchain manifests, runner capabilities, and immutable action, image, or tool revisions before writing executable changes. If a required fact cannot be verified, do not invent a version or emit commit-ready executable configuration or commands; report the blocker or provide clearly labeled non-executable structure.

## Model trust before changing syntax

Map each path through the pipeline:

`trigger -> actor and source ref -> checked-out code -> runner -> token and secrets -> cache and artifacts -> environment`

Apply these controls:

1. Treat forked changes, external contributors, event payload fields, branch and tag names, commit data, downloaded files, caches, artifacts, and command output as untrusted until their origin and integrity are established.
2. Keep untrusted validation isolated from privileged jobs. Never execute attacker-controlled code in a job that can read secrets, mint credentials, write to the repository, modify caches used by trusted jobs, or access a protected environment.
3. Grant token permissions at the narrowest platform-supported boundary. In GitHub Actions, set `GITHUB_TOKEN` permissions at workflow or job level, not step level; isolate write scopes in a dedicated job when practical. On other platforms, use the narrowest supported workflow, stage, job, or step scope.
4. Prefer short-lived workload identity federation over stored cloud credentials. Bind identity claims to the expected repository, workflow, ref, actor, audience, and environment as narrowly as the provider permits.
5. Pin external actions, reusable workflows, plugins, images, and tools to immutable revisions or digests when the platform supports them. Verify the publisher and source, and retain a deliberate update mechanism.
6. Prefer provider-native identity and credential helpers. Expose each secret only to the exact minimum step and lifetime, and pass it through standard input or an inherited file descriptor when supported. Never place secrets in command arguments, logs, caches, build artifacts, debug traces, or generated configuration. If a private temporary credential file is unavoidable, create it with restrictive permissions, exclude it from caches and artifacts, and guarantee cleanup on success, failure, and cancellation. Do not fabricate secret names or values.

## Design the pipeline

1. Run inexpensive deterministic checks first. Order later stages by dependency and cost, such as compile or package, integration tests, security checks, publication, and deployment.
2. Define runtimes, toolchains, package sources, lockfiles, shells, working directories, and build inputs explicitly. Use clean runners or clean workspaces and repository-owned commands that developers can run locally.
3. Build a releasable artifact once. Record its immutable identifier and promote the same artifact through later environments instead of rebuilding it. Add checksums, provenance, attestations, signatures, or an SBOM when required by the project or supported release policy.
4. Use artifacts for outputs that must cross jobs or survive a run. Set intentional retention and access. Use caches only as an optimization for regenerable data, never as the source of release truth.
5. Key caches with relevant trust domain, operating system, architecture, toolchain, lockfile, and build configuration inputs. Isolate trusted and untrusted writers, avoid sensitive content, prefer exact keys, and ensure a cold cache still succeeds.
6. Add matrices only for supported combinations that need independent evidence. Give jobs explicit timeouts. Retry only transient, idempotent operations with bounded attempts. Do not conceal failures with broad ignore or continue-on-error behavior.
7. Keep required-check names stable and unambiguous. Avoid duplicate executions caused by overlapping triggers unless each run has a distinct purpose.

## Control deployment

1. Separate validation, artifact publication, and deployment. Restrict deployment to verified refs and immutable artifacts.
2. Use protected environments, narrowly scoped credentials, and external approval or policy gates appropriate to the environment risk. Make approval occur before privileged credentials become available.
3. Define concurrency per deployment target. Choose queueing, cancellation, or rejection deliberately, and prevent an older run from overwriting a newer deployment.
4. Add pre-deployment checks, bounded rollout behavior, and post-deployment verification against observable acceptance criteria. Fail closed when a required gate or verification signal is unavailable.
5. Define rollback in terms of a known previous artifact and verified commands. Account for schema and state changes with backward-compatible sequencing. Never claim an irreversible migration has an automatic rollback.

## Implement or repair

1. Make the smallest coherent change that fixes the verified problem. Preserve unrelated workflow behavior and platform-specific syntax.
2. Prefer repository scripts over divergent inline command copies. Introduce reusable jobs or workflows only for proven repetition with a stable shared contract.
3. Choose the shell explicitly where behavior differs. Quote values correctly, pass untrusted data through environment variables or files instead of generated shell source, preserve exit status, and make cleanup safe after partial failure.
4. Keep pipeline configuration complete. Do not add placeholders, dummy credentials, disabled gates, empty jobs, or release steps that only appear to succeed.
5. Do not weaken tests, protections, permissions, or verification merely to obtain a green run. Fix the cause or report the unresolved dependency.

## Validate without releasing

1. Run the narrowest available parser, schema validator, linter, or provider validation for every changed pipeline file.
2. Run the repository commands invoked by changed validation and build jobs when the local environment supports them. Use a dry run, disposable target, or non-production environment only when it is authorized and safe.
3. Inspect the final diff for trigger expansion, token permissions, secret reachability, untrusted interpolation, immutable dependency references, cache boundaries, artifact lineage, environment gates, concurrency, timeouts, and rollback assumptions.
4. Reason through representative pull request, fork, push, tag, scheduled, retry, and manual events that the configuration accepts. Verify which jobs run and what authority each receives.
5. Distinguish configuration validation from an actual pipeline run. Report inaccessible settings, missing logs, unavailable credentials, and unexecuted deployment checks as unknowns rather than evidence of success.

## Review findings

Report actionable findings in severity order. For each finding, identify the exact location, the failure or abuse path, the concrete consequence, the smallest safe correction, and the evidence needed to verify it. Avoid style-only findings unless they materially affect correctness, security, maintainability, or operator understanding.

## Respect boundaries

Never start a live deployment, publish or promote a release, execute a rollback, rotate credentials, alter branch or environment protections, or delete pipeline artifacts without explicit authority for that exact action. Keep general project scaffolding, application feature work, and service-level observability outside this skill unless a minimal integration change is directly required by the authorized pipeline task.
