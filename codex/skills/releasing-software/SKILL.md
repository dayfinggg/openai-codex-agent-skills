---
name: releasing-software
description: Versions and publishes software by SemVer with trusted publishing, provenance, and SBOMs. Use when bumping a version, tagging, changing a release workflow, publishing to a registry, or signing artifacts.
---

# Releasing software

A project's existing release process, tag format, or release tool wins over this skill. General CI hardening belongs to the managing-dependencies-and-ci skill.

## Outside effects

Publishing, pushing a tag or image, creating a release, and running a release workflow cannot be cleanly undone. Prepare the bump, workflow, and notes, and run those steps only when the user asks. Before one, state the package, version, registry, tag, and environment, and run the registry's dry run, such as `npm publish --dry-run`. Registry and repository settings such as trusted publishers and token policies belong to the user, so tell them exactly what to set.

## Versions

- Derive the bump from commits since the last release tag. `!` or `BREAKING CHANGE:` means MAJOR, `feat` MINOR, `fix` PATCH, and other types change nothing. Moving from 0.y.z to 1.0.0 is the user's decision.
- A released version is never changed or re-published, so any fix is a new version. npm refuses a name and version that ever existed, even after unpublish. Release tags stay where they are.
- With the user's agreement, enable GitHub immutable releases, and create each release as a draft, attach every asset, then publish.
- An accidental breaking change in a minor or patch is fixed by a release that restores compatibility, and the bad version is deprecated or yanked when the user asks.
- A feature is deprecated in at least one minor release before a major release removes it.
- Keep the format of existing tags (`git tag --list`), and build metadata after `+` never tells releases apart.

## Publishing

- Publish from CI only, from a fresh checkout of the tagged commit, with OIDC trusted publishing wherever the registry supports it and no registry token in secrets. Otherwise use the narrowest package-scoped token in the gated environment, and tell the user.
- `id-token: write` sits only on the job that publishes or attests.
- The build job builds and tests read-only and uploads artifacts. The publish job downloads them and does not build, except on crates.io and RubyGems, whose publish commands package the source.
- The publish job runs in a GitHub environment with required reviewers, and the trusted publisher is restricted to it.
- After the first trusted publish, ask the user to disallow token publishing, revoke old tokens, and delete the old secret.

## Provenance and SBOM

- Keep registry provenance on. npm adds it with trusted publishing for a public package from a public repository, and the PyPA publish action uploads attestations by default.
- Attest other release artifacts with `actions/attest`, which replaces `actions/attest-build-provenance` for new workflows. That gives SLSA Build Level 2, and an isolated reusable build workflow gives Level 3. Frequent test builds get no attestation.
- Deploy jobs and consumers run `gh attestation verify` against the expected repository or signer workflow, because an attestation proves origin, not safety.
- Generate the SBOM from the built artifact in the format the project or its consumers use, CycloneDX or SPDX, then attach and attest it. When nothing is set, ask the user.
- Outside GitHub Actions, sign with Sigstore keyless signing (cosign).

## Build once and promote

Build each artifact once and promote its digest through every environment, as OWASP Top 10 2025 A03 asks, because a rebuild ships untested bytes. Deploy images by digest, read configuration from the environment at deploy time, and verify the attestation before production. Re-resolve the action SHAs in this skill's files before use.

## Reference files

- [reference/registries.md](reference/registries.md) before writing a publish workflow, for each registry's trusted publishing setup.
- [reference/provenance-and-sbom.md](reference/provenance-and-sbom.md) before adding attestations, signing, or an SBOM.
- [examples.md](examples.md) for fixing a broken npm release, an npm workflow split into build and publish, and an image pipeline that promotes one digest.
