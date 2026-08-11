# Supply-chain integrity

**Reviewed:** 2026-08-11
**Scope:** SLSA 1.2 and provider-native provenance capabilities. Apply only the assurance level and artifact types required by the project.

## Sources and dependencies

- Inventory source revision, build instructions, dependencies, external actions or includes, base images, package registries, and runner or builder identity.
- Prefer maintained primary distributions and immutable identifiers with an explicit update mechanism.
- Verify signatures or checksums through a trusted channel when the ecosystem and policy support them. Do not execute downloaded installers as an audit probe.

## Build and provenance

- Isolate builds from untrusted mutation and keep secrets out of build outputs.
- Produce an immutable artifact and record its digest, source revision, builder identity, parameters, and dependencies needed by the required provenance level.
- Generate SBOM or attestations from the artifact-producing workflow where required, then verify them before promotion.
- Protect signing keys through short-lived or hardware-backed mechanisms where available. Do not expose private keys to untrusted jobs.
- Preserve notices and licenses for redistributed content according to project policy.

## Verification

Verify artifact digest across build and promotion, provenance subject and source, builder identity, signatures, dependency policy, and deployment consumption. A generated attestation is not useful if no consumer verifies it.

## Official sources

- [SLSA Specification 1.2](https://slsa.dev/spec/v1.2/)
- [NIST Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final)
- [GitHub artifact attestations](https://docs.github.com/en/actions/security-for-github-actions/using-artifact-attestations)
- [OCI Image Format Specification](https://github.com/opencontainers/image-spec)
