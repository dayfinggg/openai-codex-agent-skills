# Delivery Mechanics

## Reproducible builds

1. Define the build input as source revision, submodules, dependency locks, toolchain and plugins, target platform, build flags, locale, time zone, environment variables, network inputs, and relevant host properties. Pin or record every input that can change the output.
2. Prefer a hermetic build that does not depend on undeclared host software or mutable remote state. When full hermeticity is impractical, capture the environment and external inputs precisely enough to rebuild and diagnose differences.
3. Remove nondeterminism from current time, random values, file order, absolute paths, archive metadata, locale, and parallel generation where the toolchain supports it. Use a source-derived timestamp such as `SOURCE_DATE_EPOCH` only when compatible with the actual build tools.
4. Run release tests against the packaged artifact, not a separately compiled tree. Preserve the artifact, checksums, logs, test results, dependency lock, and build metadata for the supported rollback and audit period.
5. A reproducible build establishes a relationship between declared inputs and bytes; it does not prove that the source or artifact is safe. Keep security, testing, provenance, and review as separate signals.

## CI and workflow design

1. Use one canonical path from source to release artifact. Pull requests may stop after validation, but merges and tags should reuse the same scripts, versions, and packaging rules.
2. Order jobs by cheap, high-signal feedback before expensive or slow checks. Run independent checks in parallel, but serialize publication, state mutation, migrations, and deployments per target environment.
3. Give every job a concrete output: validated source, test evidence, artifact, attestation, plan, deployment, or verified environment. Remove jobs that only restate another result or generate unactioned metadata.
4. Keep workflow expressions and inline shell small. Put reusable behavior in checked-in scripts with strict error handling, deterministic inputs, explicit outputs, and local testability.
5. Cancel obsolete validation runs when safe, set bounded timeouts, retain enough diagnostics for failures, and prevent automatic retries from duplicating non-idempotent publication or deployment.
6. Treat contributions, forked pull requests, dependency code, workflow commands, and self-hosted runners as untrusted. Do not expose privileged tokens or persistent workspaces to unreviewed code.

## Artifacts and containers

1. Publish immutable artifacts under a digest or unique version. Tags and channels may point to a digest for convenience, but deployment records and rollback targets must retain the digest.
2. Promote an existing artifact by reference. A production deployment must not rerun compilation, dependency resolution, image assembly, or code generation.
3. For containers, use multi-stage builds to leave compilers and temporary credentials out of the runtime image. Start from a trusted minimal base, pin its digest when repeatability requires it, and update the pin through reviewed automation.
4. Keep images portable through OCI-compatible formats when the platform supports them. Record the intended operating system, architecture, entrypoint, user, health behavior, ports, writable paths, and resource expectations.
5. Create provenance and signatures in the trusted build system, bind them to the artifact digest and expected build identity, and verify identity, issuer, source, and claims before deployment. An unchecked signature is decoration.
6. Generate a software bill of materials from the release artifact or resolved dependency graph where consumers or policy need it. Preserve the format version and bind it to the same artifact digest.

## Infrastructure as code and environments

1. Use the infrastructure tool already adopted by the project. Pin the CLI, providers, modules, and policy versions, and use official documentation for those exact versions.
2. Keep remote state encrypted, access-controlled, backed up, and locked when the tool supports state. State can contain secrets even when outputs are marked sensitive; never commit it or expose it as ordinary CI output.
3. Generate the plan from the reviewed revision and apply that exact plan when the tool supports it. Recheck freshness before apply, serialize changes to one state, and stop on unexpected replacement, deletion, privilege, network, or cost changes.
4. Detect out-of-band drift and reconcile it into the declared source or revert it. Emergency changes must not remain permanent undocumented exceptions.
5. Create modules only for a stable, repeated boundary with a clear interface. Prefer flat composition over deep wrapper hierarchies and avoid abstracting provider capabilities merely to claim portability.
6. Isolate environments by credentials, state, data, quotas, and failure domain as required. Keep their topology similar enough to validate deployment behavior, while scaling non-production capacity and cost to its purpose.

## Migrations and rollouts

1. Version migrations as immutable deployment artifacts. Validate their history and checksums, test from every supported starting version with production-like data volume, and prevent multiple writers from applying the same migration concurrently.
2. Use additive schema and protocol changes before new code depends on them. Deploy compatible readers and writers, backfill and verify, switch behavior, then remove old structures only after usage proves they are unused.
3. Separate long backfills from schema locks and application startup. Make them bounded, resumable, idempotent, throttled, observable, and safe beside live traffic.
4. Use rolling delivery when old and new instances can coexist and ordinary replacement is sufficient. Use blue-green when rapid traffic switching justifies duplicate capacity. Use canary when traffic can be partitioned and objective metrics can distinguish the candidate from control.
5. Set deployment progress deadlines and stop automatically on failed readiness, elevated errors, latency, saturation, data inconsistency, or a service-level objective burn signal. Do not continue a rollout merely because the automation can.
6. Roll back only to an artifact and configuration known to be compatible with current data and dependencies. Otherwise stop, contain impact, and execute the defined roll-forward or recovery procedure.

## Feature flags

1. Keep release flags separate from long-lived product configuration and permission checks. A flag must not weaken authorization or data integrity.
2. Define typed values, safe defaults for unavailable flag infrastructure, deterministic targeting, evaluation telemetry, and privacy limits for targeting context.
3. Test both states and transition behavior. For a kill switch, verify the disabled path under production-like load before it is needed.
4. Remove a temporary flag, dead branch, targeting rule, and obsolete telemetry after rollout. Expired flags are operational debt and hidden state.
