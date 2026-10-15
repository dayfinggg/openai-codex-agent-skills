# GitHub Actions hardening

Project conventions and the GitHub documentation win over this file. The commit SHAs in the templates were resolved from each action's release tags when this file was written. Look up the current release and its commit before you copy them.

## Contents

- Permissions
- Pinning actions
- Script injection
- Privileged triggers
- Contributors and governance
- Secrets and OIDC
- Checks on every pull request
- Hardened workflow template
- Dependabot template
- Scorecard audit list

## Permissions

- **Read-only at the top.** Every workflow starts with `permissions: contents: read`. A job that needs a write scope gets its own `permissions` block.
- **Job blocks replace, not add.** When a `permissions` block lists any scope, every unlisted scope becomes `none`. Repeat `contents: read` in a job block whenever the job also checks out code.
- **Known grants.** CodeQL upload needs `security-events: write`. OIDC needs `id-token: write`. For any other scope, read the action's documentation and grant only what it names.
- **No token at all.** Use `permissions: {}` for a job that needs no access through the token.
- **Repository default.** Set the repository's default workflow permissions to the read-only option, so a workflow without a `permissions` block gets no write access.
- **Checkout credentials.** `actions/checkout` writes the token into the local git config by default. Pass `persist-credentials: false` unless a later step pushes with git.

## Pinning actions

- **Full SHA with a version comment.** Write `uses: owner/repo@<40-character-sha> # vX.Y.Z`. GitHub calls a full-length commit SHA the only way to use an action as an immutable release, and Dependabot rewrites the comment together with the SHA when the comment sits on the same line.
- **Resolve the commit yourself.** Run `git ls-remote --tags https://github.com/owner/repo.git` and take the commit for the release tag. For an annotated tag, use the line ending in `^{}`, which is the commit the tag points to.
- **Every action from another repository.** Pin GitHub's own actions and reusable workflows the same way, so one rule covers the whole file. GitHub offers repository and organization policies that require SHA pinning.
- **Images too.** Pin `container` and `services` images by digest.
- **Look before adopting.** Read the source of a new third-party action, and prefer actions from the vendor of the tool they wrap.

## Script injection

- **Untrusted values.** Issue and pull request titles and bodies, comments, review text, branch names, commit messages, and author names are written by whoever opens the issue or pull request.
- **Through `env`, never inline.** Assign an expression such as `${{ github.event.pull_request.title }}` to an environment variable such as `TITLE` on the step and use `"$TITLE"`, quoted, in the script. An inline `${{ }}` is pasted into the script before the shell runs, so its content becomes code.
- **Prefer an action with inputs.** An action that receives the value as an input argument avoids the shell entirely.
- **Scan for it.** CodeQL with the `actions` language flags vulnerable workflows.

## Privileged triggers

- **What makes them dangerous.** `pull_request_target` and `workflow_run` run in the context of the base repository with its token and secrets. `pull_request_target` runs regardless of fork approval settings.
- **Never run pull request code there.** Do not check out, build, install, or execute code from the pull request in these workflows. `actions/checkout` v7.0.1 checks out fork pull request code under these triggers only with `allow-unsafe-pr-checkout: true`, which you never set.
- **Split the work.** Build and test contributions with `pull_request`, which gives fork pull requests a read-only token and no other secrets. When a later step needs write access, run it in a separate `workflow_run` workflow that treats the artifacts of the first run as untrusted data.

## Contributors and governance

- **Approval for outside contributors.** In the repository settings under Actions, General, set "Approval for running fork pull request workflows from contributors" to "Require approval for all external contributors". Review every change under `.github/workflows` before approving a run.
- **CODEOWNERS.** Add `/.github/workflows/ @owner/team` to `.github/CODEOWNERS` and require code owner review on the default branch.
- **No self-approval by bots.** Leave "Allow GitHub Actions to create and approve pull requests" off.
- **Branch protection.** Protect the default branch with required reviews and required status checks, and block force pushes.
- **Runners.** Do not use self-hosted runners for public repositories. Where self-hosted runners are needed, make them ephemeral.

## Secrets and OIDC

- **OIDC for cloud access.** The deploy job gets `id-token: write` and exchanges the token for short-lived cloud credentials, valid for that job only. No cloud access keys go into secrets.
- **One secret per value.** Never store a JSON, YAML, or XML blob as a secret, because masking works on exact values. Register any derived value for masking with `::add-mask::`.
- **Scope.** Anyone with write access to a repository can read all its secrets. Put production secrets in an environment with required reviewers, and reference them only from the job that deploys.
- **Leaks.** If a secret reaches a log, delete the log and rotate the secret.
- **Scanning.** Enable secret scanning and push protection for the repository. Repository push protection is off by default.

## Checks on every pull request

- **Tests and linters** for every language in the repository.
- **SAST.** CodeQL for the repository's languages plus `actions`.
- **Dependency review.** `actions/dependency-review-action` fails a pull request that introduces a vulnerable version and reports changes to indirect dependencies in lockfiles. It runs on public repositories, and on private repositories with GitHub Code Security or GitHub Advanced Security. Elsewhere, run the ecosystem's audit command.
- **Required status checks.** Mark these jobs as required in branch protection so a failing check blocks the merge.

## Hardened workflow template

`.github/workflows/ci.yml` for a Node.js project. Replace the install, lint, and test steps with the commands for the project's ecosystem.

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

`.github/dependabot.yml` covering the application ecosystem, the base image, and the workflows. Version updates wait 3 days after a release by default and security updates do not wait, so no `cooldown` block is needed.

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

Use the OpenSSF Scorecard checks as the audit list for a repository, highest risk first.

| Check | Risk | What to look at |
|---|---|---|
| Dangerous-Workflow | Critical | Untrusted checkout under privileged triggers and script injection in workflows |
| Webhooks | Critical | Repository webhooks have a secret |
| Binary-Artifacts | High | No generated executables committed to the repository |
| Branch-Protection | High | Default and release branches require review and status checks and block force pushes |
| Code-Review | High | Changes are reviewed by a human before merge |
| Dependency-Update-Tool | High | Dependabot or Renovate is configured |
| Maintained | High | Recent commits and responses to issues |
| Signed-Releases | High | Release assets carry signatures or provenance, which the releasing-software skill covers |
| Token-Permissions | High | Read-only top-level permissions and writes only per job |
| Vulnerabilities | High | No open known vulnerabilities in the project or its dependencies, per OSV |
| Fuzzing | Medium | Fuzzing or property-based tests exist |
| Packaging | Medium | The project publishes packages from a workflow |
| Pinned-Dependencies | Medium | Workflows, Dockerfiles, and scripts pin dependencies by hash |
| SAST | Medium | A static analysis tool such as CodeQL runs on pull requests |
| SBOM | Medium | An SBOM exists in the repository or the release |
| Security-Policy | Medium | `SECURITY.md` explains how to report vulnerabilities |
| CI-Tests | Low | Tests run automatically on changes |
| CII-Best-Practices | Low | The project holds an OpenSSF Best Practices badge |
| Contributors | Low | Contributors come from more than one organization |
| License | Low | A license file is published |
