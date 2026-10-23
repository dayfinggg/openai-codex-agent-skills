---
name: managing-dependencies-and-ci
description: Vets, adds, updates, and removes dependencies and hardens CI pipelines. Use when changing package manifests, lockfiles, Dockerfile base images, CI workflows, or Dependabot and Renovate config.
---

# Managing dependencies and CI

Project conventions for package managers, registries, and pipelines win over this skill. Publishing belongs to the releasing-software skill.

## Vetting a new package

AI assistants suggest packages that do not exist, and attackers register those names. Before installing a package, confirm that

- no standard library module or existing dependency covers the need
- it exists on the official registry under the exact name, links to its real source repository, and is no lookalike of a more popular name
- it had a release in the last 12 months and has more than one maintainer, with 0.x, alpha, and beta counted as unstable
- its OpenSSF Scorecard score and deps.dev vulnerabilities are acceptable, and its license fits the project
- its install scripts do no downloads, obfuscation, or exfiltration

When a check fails or cannot be done, report it and let the user decide. Add packages only through the package manager.

## Versions and lockfiles

- Applications commit the lockfile and pin exact versions. Libraries declare ranges and follow the ecosystem's lockfile rule.
- CI installs with the ecosystem's frozen command, so a build that would change the lockfile fails.
- Base images are pinned by digest with the tag kept, as in `python:3.13-slim@sha256:...`.
- A release that fixes no known vulnerability waits 3 days after publication, as the OpenSSF Concise Guide recommends. Security fixes go in at once.
- Dependency installation runs in a step without deployment credentials.
- Internal packages sit under a reserved scope mapped to the internal registry, with no public fallback.
- Removing a package removes its imports and configuration and regenerates the lockfile. Remove unused dependencies you notice, and mention it in the change.

## GitHub Actions

- Workflows start with `permissions: contents: read`, and only the job that needs a write scope gets it.
- Actions from other repositories are pinned to the full SHA of their current release, with the version in a trailing comment, as in `uses: actions/checkout@<sha> # v7.0.1`. This comment is YAML configuration, outside the no-comments rule for code, and Dependabot updates it.
- Untrusted event values such as titles, bodies, branch names, and commit messages reach `run` scripts only through `env`, as a quoted `"$VAR"`.
- `pull_request_target` and `workflow_run` hold the base repository's secrets, so they run no pull request code. Contributions build under `pull_request`.
- `.github/workflows` has a CODEOWNERS entry, and external contributors' runs need approval.
- Dependabot or Renovate covers the app ecosystem, `docker`, and `github-actions`, because Dependabot alerts skip SHA-pinned actions.
- Pull requests run tests, linters, SAST such as CodeQL, and a transitive dependency scan as required checks.
- Cloud access uses OIDC, with `id-token: write` on the deploying job only. Each secret holds one value, because masking matches exact values, and production secrets sit in an environment with required reviewers.

For a supply chain audit, use the OpenSSF Scorecard checks, report each finding with its file and fix, and change repository settings only when the user asks.

## Reference files

- [reference/ecosystems.md](reference/ecosystems.md) for the lockfile, frozen install, cooldown setting, and audit command of the package manager at hand.
- [reference/github-actions.md](reference/github-actions.md) before writing or reviewing a workflow, for finer rules, templates, and the Scorecard table.
- [examples.md](examples.md) when passing event values through `env` or replacing stored cloud keys with OIDC.
