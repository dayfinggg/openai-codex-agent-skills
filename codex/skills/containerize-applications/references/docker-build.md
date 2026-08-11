# Docker build and OCI image decisions

**Reviewed:** 2026-08-11
**Scope:** Current Docker Build documentation and OCI Image Format. Resolve Dockerfile frontend, BuildKit, engine, and target registry capabilities first.

## Context and stages

- Keep the build context minimal with the repository-owned `.dockerignore`. Confirm ignored files do not remove required sources or include secrets.
- Separate dependency resolution, compilation, tests where appropriate, and runtime contents into stages based on actual artifact flow.
- Copy dependency manifests before source only when it preserves correctness and improves cache reuse. Never let a stale cache bypass a required generated or compiled input.
- Use cache and bind mounts with exact BuildKit semantics. Use secret and SSH mounts for authorized transient access and ensure material does not persist in layers or output.

## Reproducibility and provenance

- Resolve base tags to trusted immutable identities according to project update policy. Digest pinning improves identity but requires an intentional refresh process.
- Keep package versions in native lockfiles and use non-interactive deterministic install modes supported by the package manager.
- Record source revision, build platform, base identities, labels, SBOM or attestations where required, and the exact produced digest.
- Do not mutate an already published image tag and call it the same release artifact.

## Runtime contents

- Use the minimal runtime that still provides required certificates, time zone data, libraries, users, and diagnostics mandated by operations.
- Remove compilers, package caches, credentials, and unused package metadata from the final stage.
- Inspect configuration and history. Also inspect filesystem contents with available trusted tools when secrets or supply-chain integrity are material.

## Official sources

- [Docker build best practices](https://docs.docker.com/build/building/best-practices/)
- [Docker build secrets](https://docs.docker.com/build/building/secrets/)
- [Docker multi-stage builds](https://docs.docker.com/build/building/multi-stage/)
- [OCI Image Format Specification](https://github.com/opencontainers/image-spec)
- [Docker build attestations](https://docs.docker.com/build/metadata/attestations/)
