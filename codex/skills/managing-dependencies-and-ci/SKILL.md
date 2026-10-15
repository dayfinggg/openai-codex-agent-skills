---
name: managing-dependencies-and-ci
description: Adds, updates, and removes dependencies and hardens CI with maintained packages, committed lockfiles, pinned images and actions, and least-privilege permissions. Use when changing package manifests, lockfiles, Dockerfile base images, CI workflows, or Dependabot and Renovate config.
---

# Managing dependencies and CI

Every dependency and every CI step runs code you did not write with the access you give it, so add packages only after checking them, install exactly what the lockfile records, and give pipelines the least access that works. Publishing packages and images, provenance, SBOMs, and version bumps belong to the releasing-software skill. Secrets in application code belong to the writing-secure-code skill, test content to the writing-tests skill, and commit and pull request text to the writing-commit-messages skill. When the project already has conventions for package managers, registries, or pipelines, follow them over this skill.

## Before adding a dependency

AI assistants suggest packages that do not exist. The OpenSSF guide for AI code assistant instructions cites a study where 19.7% of proposed packages did not exist, and attackers register such names. Check every new package before you install it.

- **Need.** Use the standard library or a dependency the project already has when it covers the task. A few lines of your own code beat a package for a trivial helper.
- **Existence and exact name.** Look the package up on the official registry (npmjs.com, pypi.org, pkg.go.dev, crates.io, Maven Central, nuget.org) under the exact name you will install. If a more popular package has a similar name, suspect typosquatting and stop. Confirm the registry entry links to the project's real source repository and is not a fork.
- **Maintenance.** A release within the last 12 months, recent commits, and more than one maintainer. Treat a leading 0, alpha, or beta version as unstable.
- **Reputation.** Check its OpenSSF Scorecard score and known vulnerabilities on deps.dev.
- **License.** The package has a license, preferably a widely used OSI license, compatible with the project.
- **Install scripts and weight.** Read any install or postinstall scripts and look for downloads, obfuscation, or exfiltration. Notice how many indirect dependencies it pulls into production.
- **Ask when unsure.** If a check fails or cannot be done, tell the user what you found and let them decide instead of installing.

Add the package with the ecosystem's package manager, never by editing the lockfile or copying code from the registry by hand.

## Versions and lockfiles

- **Applications commit the lockfile.** Libraries declare version ranges in the manifest, because consumers resolve their own graph. Whether a library commits its lockfile follows the ecosystem's rule, so Go always commits `go.sum`, while NuGet advises against committing `packages.lock.json` for libraries.
- **CI installs from the lockfile without changing it.** Use `npm ci`, `pnpm install --frozen-lockfile`, `yarn install --immutable`, `uv sync --locked`, `cargo build --locked`, `dotnet restore --locked-mode`, or the equivalent in [references/ecosystems.md](references/ecosystems.md). A build that would rewrite the lockfile must fail.
- **Never float.** No `latest`, `*`, or open-ended ranges for applications, and no mutable image tags. Pin container base images by digest, keeping the tag for readability, as in `python:3.13-slim@sha256:...`.
- **Cooldown.** Take a release that fixes no known vulnerability only after it has been public for about 3 days, because such a cooldown counters most malicious releases. The OpenSSF Concise Guide recommends this, and Dependabot applies the same cooldown to version updates by default. Security fixes go in at once.
- **Install scripts get no secrets.** Run dependency installation in a step that has no access to deployment credentials.
- **Private packages stay private.** Keep internal packages under a reserved scope or namespace mapped to the internal registry, and never let the client fall back silently to the public registry for those names.

## Updating and removing

- Update through the package manager or an update bot so the manifest and lockfile change together, then run the full test suite.
- Read the changelog for breaking changes before a major update.
- When removing a package, remove its imports and configuration too, then regenerate the lockfile so no orphan entries remain.
- Remove dependencies the code no longer uses whenever you notice them, and mention it in the change.

## CI pipelines

The hardening rules below are written for GitHub Actions, and the same ideas apply to other CI systems. The full rules and a hardened template are in [references/github-actions.md](references/github-actions.md).

- **Least privilege.** Set `permissions: contents: read` at the top level of every workflow and grant writes per job, only to the job that needs them.
- **Pin third-party actions to a full commit SHA** with the version in a trailing YAML comment, as in `uses: actions/checkout@<sha> # v7.0.1`. A tag can be moved, a SHA cannot. The comment is configuration, not code, so the no-comments rule for code does not apply, and Dependabot updates it when it sits on the same line.
- **Untrusted context goes through `env`.** Never put `${{ github.event.* }}` values such as titles, bodies, branch names, or commit messages directly into a `run` script. Assign them to an environment variable and quote the variable in the script.
- **No pull request code in privileged triggers.** Workflows on `pull_request_target` or `workflow_run` never check out or run code from the pull request. Use `pull_request` for building and testing contributions.
- **Outside contributors need approval.** Require approval for workflow runs from external contributors, and review changes under `.github/workflows` before approving.
- **Protect the pipeline definition.** Add a CODEOWNERS entry for `.github/workflows`, and keep GitHub Actions from creating or approving pull requests.
- **Keep actions updated.** Configure Dependabot or Renovate for the `github-actions` ecosystem, because Dependabot alerts do not cover actions pinned to a SHA.
- **Checks on every pull request.** Run tests, linters, SAST such as CodeQL, and a dependency scan that covers transitive dependencies, following NIST SP 800-204D. Make them required status checks.

## Secrets in CI

- Use OIDC federation to cloud providers instead of long-lived access keys stored as secrets. Grant `id-token: write` only to the job that deploys.
- Store one secret per value, never a JSON or YAML blob, and give each job only the secrets it uses. Prefer environment secrets with required reviewers for production.
- Never print secrets, never commit `.npmrc`, `.pypirc`, or similar files with credentials, and rotate any secret that reached a log.
- Enable secret scanning with push protection on the repository.

## Auditing a repository

When asked to review a repository's supply chain, use the 20 OpenSSF Scorecard checks as the audit list, starting with Dangerous-Workflow, Token-Permissions, Pinned-Dependencies, Dependency-Update-Tool, Branch-Protection, Code-Review, Vulnerabilities, and SAST. Each check maps to a concrete file or setting, listed in [references/github-actions.md](references/github-actions.md). Report findings with the file and the fix, and change settings only when the user asks.

## Workflow

1. Identify the package manager, its version, the lockfile, the registry, and the CI system from the repository, not from assumptions.
2. Before adding a package, run the checks in "Before adding a dependency" and report anything doubtful.
3. Change dependencies with the package manager, then run the lockfile-respecting install, the tests, and the audit command from [references/ecosystems.md](references/ecosystems.md).
4. For CI changes, start from the template in [references/github-actions.md](references/github-actions.md), look up the current release and its commit SHA for each action you add, and pin it.
5. Make sure dependency updates for the app ecosystem, Docker, and `github-actions` are configured.
6. Review the diff against the checklist.

## Checklist

- [ ] Every new package exists on the official registry under the exact name and passed the evaluation checks
- [ ] The manifest and lockfile changed together through the package manager
- [ ] CI installs with the lockfile-respecting command and fails if the lockfile would change
- [ ] No floating versions, and base images are pinned by digest
- [ ] Non-security updates respect the 3 day cooldown
- [ ] Workflows set `permissions: contents: read` at the top and grant writes per job
- [ ] Third-party actions are pinned to full commit SHAs with version comments
- [ ] No `${{ }}` expression with untrusted input appears inside a `run` script
- [ ] No pull request code is checked out under `pull_request_target` or `workflow_run`
- [ ] Cloud access uses OIDC, and no credentials are committed or printed
- [ ] Pull requests run tests, linters, SAST, and a transitive dependency scan
- [ ] Dependabot or Renovate covers the app ecosystem, Docker, and `github-actions`

## Reference files

Read them before the first change, the ecosystem section for the package manager at hand, the GitHub Actions file for any workflow change, and the examples file.

- [references/ecosystems.md](references/ecosystems.md) has the lockfile, the CI install command, the audit command, and pinning notes for npm, pnpm, Yarn, pip, uv, Poetry, Go, Cargo, Maven, Gradle, NuGet, and container images.
- [references/github-actions.md](references/github-actions.md) has the GitHub Actions hardening rules, a hardened workflow template, a dependabot.yml template, and the Scorecard audit list.
- [examples.md](examples.md) has before and after pairs for workflow hardening, script injection, `pull_request_target`, OIDC, lockfile-respecting CI steps for Go and .NET, dependabot.yml, and a Dockerfile base image.
