---
name: releasing-software
description: Versions and publishes software by SemVer with trusted publishing, provenance, and SBOMs. Use when bumping a version, tagging a release, changing a release workflow, publishing to a package or container registry, or signing artifacts.
---

# Releasing software

A release is a promise to everyone who installs it. Consumers must be able to trust that a version number means what SemVer says, that the artifact came from the tagged source through a known build, and that the same bytes run in every environment. The managing-dependencies-and-ci skill owns dependency rules and general CI hardening such as top-level permissions, SHA pinning, and secrets in workflows, the writing-documentation skill owns changelog and release notes text, and the writing-commit-messages skill owns commit types. When the project already has a release process, tag format, or release tool, follow it over this skill.

## Actions with outside effects

- **Only on request.** Publishing a package, pushing a tag or an image, creating a release, and running a release workflow change state outside the repository and cannot be cleanly undone. Prepare the version bump, workflow, and notes, then publish, tag, or push only when the user asks for that step.
- **Confirm the target.** Before such a command, state the package name, version, registry, tag, and environment, and run the registry's dry run where it has one, such as `npm publish --dry-run`.
- **Registry settings belong to the user.** Configuring a trusted publisher, disallowing tokens, and revoking secrets happen in the registry or repository settings. Tell the user exactly what to set instead of guessing that it is done.

## Versions

- **SemVer 2.0.0.** MAJOR for incompatible API changes, MINOR for backward-compatible features, PATCH for backward-compatible fixes.
- **Derive the bump from the commits** since the last release tag. A breaking change marked with `!` or a `BREAKING CHANGE:` footer means MAJOR, `feat` means MINOR, and `fix` means PATCH. Other commit types have no effect on the version unless they carry a breaking change.
- **0.y.z is initial development**, where anything may change. Moving to 1.0.0 is the user's decision.
- **Pre-releases** such as `2.0.0-rc.1` rank below `2.0.0`. Build metadata after `+` is ignored for precedence, so never use it to tell releases apart.
- **A released version is never changed or re-published.** Any fix, even a one-line packaging mistake, is a new version. npm refuses a name and version that ever existed, even after unpublish.
- **Never move or delete a release tag.** Enable GitHub immutable releases where the user agrees, and create the release as a draft, attach every asset, then publish it.
- **An accidental breaking change in a minor or patch release** is fixed by a new release that restores compatibility. The bad version is documented and, when the user asks, deprecated or yanked with the registry's own command.
- **Deprecate before removing.** Ship at least one minor release that deprecates a feature before a major release removes it.
- **One source of truth for the version.** Change it in the manifest the project uses, such as `package.json`, `pyproject.toml`, `Cargo.toml`, a `.csproj`, or `pom.xml`, and keep the tag format of existing tags (`git tag --list`).

## Publishing

- **Publish from CI, never from a workstation**, and only from a tagged commit checked out fresh, so the package contains only content from version control.
- **Use OIDC trusted publishing instead of stored tokens** wherever the registry supports it. No registry token goes into repository or environment secrets.
- **`id-token: write` only on the job that publishes or attests.** Keep it off the workflow level and off jobs that only build or test, as the managing-dependencies-and-ci skill requires for all write permissions.
- **Separate build and publish.** The build job runs the build and tests with read-only permissions and uploads the artifacts. The publish job downloads them, does no build of its own, and holds the OIDC permission. crates.io and RubyGems are the exception, because their publish commands package the checked-out source themselves.
- **Gate the publishing job with a GitHub environment**, such as `npm`, `pypi`, or `release`, with required reviewers, and restrict the trusted publisher on the registry to that environment.
- **Disallow tokens afterwards.** Once the first trusted publish succeeds, ask the user to disallow token publishing where the registry offers it, revoke old tokens, and delete the old secret.
- **Registry specifics change.** Before writing a publish workflow, confirm the current requirements on the registry's trusted publishing page, such as the minimum npm CLI and Node versions. The registries file lists what was confirmed per registry.
- **Without trusted publishing**, use the narrowest token the registry offers, scoped to the package, stored as a secret of the gated environment, and say so to the user.

## Provenance, signing, and SBOM

- **Keep registry provenance on.** npm generates provenance automatically with trusted publishing for a public package from a public repository, and the PyPA publish action uploads attestations by default. Never disable either.
- **Attest other release artifacts** such as binaries, archives, and container images with `actions/attest`. This gives SLSA Build Level 2. GitHub's route to Build Level 3 is running the build in an isolated reusable workflow.
- **Sign releases, not every build.** Attest what consumers are expected to verify, and skip frequent test builds.
- **An attestation proves origin, not safety.** Consumers and deploy jobs still check it with `gh attestation verify` against the expected repository or signer workflow.
- **Produce an SBOM in the format the project or its consumers already use**, CycloneDX or SPDX, with a standard generator run on the built artifact. Attach it to the release and attest it. When nothing is set, ask the user which format their consumers need.
- **Outside GitHub Actions** sign with Sigstore keyless signing (cosign), which binds a short-lived certificate to the CI identity so no signing key is stored.

## Build once and promote

- **Build each artifact once**, record its digest, then test, attest, and promote that same digest through staging and production. OWASP Top 10 2025 A03 asks to promote artifacts rather than rebuild them for each environment, because a rebuild ships bytes that were never tested.
- **Deploy images by digest** (`ghcr.io/org/app@sha256:...`), never by a mutable tag such as `latest` or `staging`.
- **Keep environment differences out of the artifact.** Configuration comes from the environment at deploy time, never from build arguments per environment.
- **Deploy only artifacts from the trusted build**, and verify their attestation before a production deploy.

## Workflow templates

- Confirm the current major version and name of every action you put in a template, such as `actions/attest`, which replaces `actions/attest-build-provenance` for new workflows, and `pypa/gh-action-pypi-publish`.
- Pin each action by full commit SHA with a version comment, as the managing-dependencies-and-ci skill requires. Re-resolve the SHAs shown in this skill's files before use, because newer releases follow.

## Workflow

1. Read the current release setup, meaning manifests, existing tags, the changelog, release workflows, registries, and any release tool already configured.
2. List the commits since the last release tag with `git log <last-tag>..HEAD` and derive the bump.
3. Update the version, and hand the changelog entry to the writing-documentation skill.
4. Write or change the release workflow with trusted publishing, attestations, an SBOM, and a single build promoted by digest.
5. Tell the user the registry and repository settings they must make, such as the trusted publisher, the environment reviewers, and disallowing tokens.
6. Present the version, tag, and target, and publish, tag, or push only when the user asks.
7. After a release, verify it with the registry page or `gh attestation verify`, and review against the checklist.

## Checklist

- [ ] The version bump matches the commits under SemVer 2.0.0, and no released version or tag was changed
- [ ] Nothing was published, tagged, or pushed without the user asking
- [ ] Publishing uses OIDC trusted publishing, and no registry token sits in secrets
- [ ] `id-token: write` appears only on jobs that publish or attest, and publishing runs in a gated environment
- [ ] Build and publish are separate jobs, and the publish job does not rebuild
- [ ] Registry provenance is on, and other release artifacts are attested
- [ ] An SBOM in the project's format is attached to the release
- [ ] One digest is promoted through all environments and deployed by digest
- [ ] Every action is pinned by a freshly resolved full SHA with a version comment
- [ ] The user knows which registry settings to change, including disallowing tokens

## Reference files

Read them before the first change, the registries file before writing any publish workflow, the provenance file before adding attestations, signing, or an SBOM, and the examples file for every release task.

- [references/registries.md](references/registries.md) has the confirmed trusted publishing setup for npm, PyPI, crates.io, RubyGems, and NuGet, and what is unconfirmed for Maven Central.
- [references/provenance-and-sbom.md](references/provenance-and-sbom.md) has SLSA build levels, GitHub artifact attestations, Sigstore signing, verification commands, and SBOM generation.
- [examples.md](examples.md) has before and after pairs for an npm publish workflow, a PyPI publish workflow, and a container deploy pipeline changed to promote one digest.
