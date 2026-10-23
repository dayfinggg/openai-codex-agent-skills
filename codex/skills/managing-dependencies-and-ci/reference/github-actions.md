# GitHub Actions hardening

The commit SHAs in the templates point at the release in each comment. Resolve the current release and its commit before copying them.

## Contents

- Permissions
- Pinning actions
- Untrusted input and privileged triggers
- Repository settings
- Secrets
- Pull request checks
- Hardened workflow template
- Dependabot template
- Scorecard audit list

## Permissions

- A job `permissions` block replaces the workflow block, and every scope it leaves out becomes `none`. Repeat `contents: read` in a job block when the job checks out code.
- CodeQL upload needs `security-events: write` and OIDC needs `id-token: write`. For other scopes, grant only what the action's documentation names.
- `permissions: {}` for a job that needs no token access.
- Set the repository's default workflow permissions to read-only.
- `actions/checkout` stores the token in the local git config, so pass `persist-credentials: false` unless a later step pushes with git.

## Pinning actions

- Resolve the commit with `git ls-remote --tags https://github.com/owner/repo.git`. For an annotated tag, take the line ending in `^{}`.
- Pin GitHub's own actions and reusable workflows the same way, and pin `container` and `services` images by digest.
- Read the source of a new third-party action, and prefer actions from the vendor of the wrapped tool.

## Untrusted input and privileged triggers

- Untrusted values include issue and pull request titles and bodies, comments, review text, branch names, commit messages, and author names. An inline `${{ }}` is pasted into the script before the shell runs, so its content becomes code. An action that takes the value as an input avoids the shell entirely.
- CodeQL with the `actions` language flags vulnerable workflows.
- `pull_request_target` runs regardless of fork approval settings. `actions/checkout` v7.0.1 checks out fork pull request code under these triggers only with `allow-unsafe-pr-checkout: true`, which stays unset.
- When a later step needs write access, run it in a separate `workflow_run` workflow that treats the first run's artifacts as untrusted data.

## Repository settings

- Under Actions, General, set "Approval for running fork pull request workflows from contributors" to "Require approval for all external contributors", and review `.github/workflows` changes before approving.
- `.github/CODEOWNERS` gets `/.github/workflows/ @owner/team`, with code owner review required on the default branch.
- Leave "Allow GitHub Actions to create and approve pull requests" off.
- Protect the default branch with required reviews and status checks, and block force pushes.
- Public repositories use no self-hosted runners. Where self-hosted runners are needed, make them ephemeral.

## Secrets

- Register derived values for masking with `::add-mask::`.
- Anyone with write access can read all repository secrets, so production secrets belong to an environment with required reviewers.
- After a leak, delete the log and rotate the secret.
- Repository push protection for secret scanning is off by default, so turn it on.

## Pull request checks

`actions/dependency-review-action` fails a pull request that introduces a vulnerable version and reports indirect changes in lockfiles. It runs on public repositories, and on private ones with GitHub Code Security or Advanced Security. Elsewhere, run the ecosystem's audit command.

## Hardened workflow template

`.github/workflows/ci.yml` for a Node.js project. Swap the install, lint, and test steps for the project's ecosystem.

```yaml
name: CI

on:
  pull_request:
  push:
    branches:
      - main

permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - uses: actions/setup-node@949feb2413d6458794dcd2491c4babbbce0c15c1 # v7.1.0
        with:
          node-version-file: .nvmrc
          cache: npm
      - run: npm ci
      - run: npm audit signatures
      - run: npm run lint
      - run: npm test

  dependency-review:
    if: github.event_name == 'pull_request'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - uses: actions/dependency-review-action@a1d282b36b6f3519aa1f3fc636f609c47dddb294 # v5.0.0

  codeql:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      security-events: write
    strategy:
      matrix:
        language:
          - actions
          - javascript-typescript
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - uses: github/codeql-action/init@24c54180a607b1449ed407dd24f251e4e9147c8d # v4.38.3
        with:
          languages: ${{ matrix.language }}
      - uses: github/codeql-action/analyze@24c54180a607b1449ed407dd24f251e4e9147c8d # v4.38.3
```

## Dependabot template

The default 3 day cooldown already applies to version updates, so there is no `cooldown` block.

```yaml
version: 2
updates:
  - package-ecosystem: npm
    directory: /
    schedule:
      interval: weekly
    groups:
      npm-minor-and-patch:
        patterns:
          - "*"
        update-types:
          - minor
          - patch
  - package-ecosystem: docker
    directory: /
    schedule:
      interval: weekly
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: weekly
    groups:
      github-actions:
        patterns:
          - "*"
```

## Scorecard audit list

| Check | Risk | What to look at |
|---|---|---|
| Dangerous-Workflow | Critical | Untrusted checkout under privileged triggers and script injection |
| Webhooks | Critical | Repository webhooks have a secret |
| Binary-Artifacts | High | No generated executables committed |
| Branch-Protection | High | Default and release branches require review and status checks and block force pushes |
| Code-Review | High | Changes are reviewed by a human before merge |
| Dependency-Update-Tool | High | Dependabot or Renovate is configured |
| Maintained | High | Recent commits and responses to issues |
| Signed-Releases | High | Release assets carry signatures or provenance, covered by the releasing-software skill |
| Token-Permissions | High | Read-only top-level permissions and writes only per job |
| Vulnerabilities | High | No open known vulnerabilities in the project or its dependencies, per OSV |
| Fuzzing | Medium | Fuzzing or property-based tests exist |
| Packaging | Medium | Packages are published from a workflow |
| Pinned-Dependencies | Medium | Workflows, Dockerfiles, and scripts pin dependencies by hash |
| SAST | Medium | A static analysis tool such as CodeQL runs on pull requests |
| SBOM | Medium | An SBOM exists in the repository or the release |
| Security-Policy | Medium | `SECURITY.md` explains how to report vulnerabilities |
| CI-Tests | Low | Tests run automatically on changes |
| CII-Best-Practices | Low | The project holds an OpenSSF Best Practices badge |
| Contributors | Low | Contributors come from more than one organization |
| License | Low | A license file is published |
