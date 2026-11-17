---
name: github-actions
description: Create, review, and debug GitHub Actions workflows and repository actions. Use for CI failures, workflow triggers and permissions, dependency pinning, OIDC, caches, publishing, untrusted pull requests, or AI agents in workflows.
license: MIT
---

# GitHub Actions

This skill covers GitHub Actions workflow security, correctness, and failed checks on GitHub.com. Its release, syntax, and platform details are a dated reference snapshot. Check the repository host, installed CLI and linter versions, runner image, and current GitHub documentation before using a version-dependent feature.

## References

Open the full reference before the first step it covers, even when that step comes later in the task.

- [references/ci-failures.md](references/ci-failures.md): read when a check fails on a pull request, before rerunning a run, when deciding whether a change caused a failure, or when a workflow or job did not run.
- [references/untrusted-triggers.md](references/untrusted-triggers.md): read when a workflow uses `pull_request_target`, `workflow_run` or `issue_comment`, gates fork code on a label or comment, checks out or downloads PR content, or when auditing workflow security.
- [references/ai-agents.md](references/ai-agents.md): read when a workflow runs claude-code-action, codex-action, run-gemini-cli, actions/ai-inference or a gh aw agentic workflow.

## Check first

- Inventory `.github/workflows/*.yml` and `*.yaml`, every `action.yml` (often under `.github/actions/`), `.github/workflows/actions.lock`, gh aw sources (`.github/workflows/*.md` next to `*.lock.yml`), `.github/dependabot.yml` and the `CODEOWNERS` lines for `.github/`.
- Confirm the host. Lockfiles exist on github.com and GHE.com, not on GitHub Enterprise Server. `$/` references, immutable OIDC subjects and the default `pull_request_target` block are github.com features.
- Self-hosted runners: `$/` needs runner 2.336.0 or later, Node 24 actions need 2.327.1 or later.
- Resolve a tag to its commit before pinning, never from memory: `gh api repos/OWNER/REPO/commits/v7.0.1 --jq .sha`. In `git ls-remote --tags` output take the `^{}` line, not the annotated tag object. Confirm the commit belongs to the action's own repository, not a fork.
- Lint with `zizmor .` (security audits, knows lockfiles and the 2026 syntax) and `actionlint` (expressions and types).

## Pinning and action versions

- Lock action dependencies: `gh extension install github/gh-actions-lock`, then `gh actions-lock` writes `.github/workflows/actions.lock` (GA 2026-10-28). Workflows keep readable tags and run the locked commits, including transitive actions. Rerun it after any `uses:` change, gate PRs on `gh actions-lock --verify`, and never edit the lockfile by hand. Dependabot regenerates the entries of onboarded workflows.
- The lockfile does not cover reusable workflow calls (`jobs.<id>.uses`) or container images. Pin reusable workflows to a full commit SHA and images to `@sha256:` digests. Local `./` actions block locking until you pass `--migrate-local-actions`, which rewrites them to `$/`.
- After onboarding, allowed-actions policies check the locked commit, so tag entries such as `actions/checkout@v7` in a policy stop matching.
- Without a lockfile, pin each third-party action to a 40-character SHA with a same-line `# v1.2.3` comment so Dependabot updates both. Dependabot raises no security alerts for SHA-pinned actions, only for semver references.
- Reference actions and reusable workflows from the same repository as `uses: $/.github/actions/build` (2026-07-30). It runs at the workflow's own commit, needs no checkout and takes no `@ref`. A `./` path resolves against whatever the workspace holds, so a fork checkout replaces it.
- Current majors: `actions/checkout@v7`, `actions/cache@v6`, `actions/upload-artifact@v7`, `actions/download-artifact@v8`, `actions/setup-node@v7`, `actions/setup-go@v7`, `actions/setup-python@v7`, `actions/github-script@v9`, `actions/create-github-app-token@v3`, `github/codeql-action@v4` (v3 is deprecated in December 2026).
- Node 20 left the runners on 2026-09-23. A JavaScript action declares `runs.using: node24`.

## Permissions, secrets and injection

- Start every workflow with `permissions: {}` or `contents: read` and grant scopes per job. Naming one scope sets every unnamed scope to `none`. `id-token` and `copilot-requests` take only `write` or `none`, `vulnerability-alerts` only `read` or `none`. Artifact metadata APIs need `artifact-metadata`, not `contents`.
- Pass event text through `env:` and quote it as `"$TITLE"` in `run:`. In `actions/github-script` read `process.env.TITLE`, because `script:` is JavaScript and `${{ }}` inside it is code injection. Any `with:` input is safe only when the action treats it as data.
- `actions/checkout` keeps the token available to later steps unless `persist-credentials: false`. Since v6 it lives in a file under `$RUNNER_TEMP` instead of `.git/config`, but every later step can still use it. Set it to `false` unless the job pushes.
- Redaction matches exact strings. Base64, URL-encoded, JSON-wrapped or sliced secrets print in clear text, so register derived values with `echo "::add-mask::$VALUE"`. The runner drops masked values from job outputs, so mint or fetch the secret in the job that uses it.
- Use `actions/create-github-app-token@v3` for cross-repository work or pushes that must trigger CI. App installation tokens are about 520 characters since 2026-10, so 40-character validators and short columns break.

## Triggers, caches and concurrency

- Build fork CI on `pull_request`. Do privileged follow-up in a separate `workflow_run` workflow that treats the upstream artifacts as untrusted data.
- From 2026-12-02 public repositories block `pull_request_target` unless an Actions event policy allows it (Settings, Actions, Policies, with workflow file targeting). Brownouts block it on 2026-11-09 and 2026-11-16 from 16:00 to 18:00 UTC. Private and internal repositories are not affected.
- Untrusted triggers that run in the default-branch scope (`pull_request_target`, `issue_comment`, `workflow_run` from forks and similar) get a read-only cache since 2026-06-26. Saves only log a warning. Warm caches from `push` or `schedule` and use `actions/cache/restore` in low-trust workflows.
- `cache-mode: read`, `write`, `write-only` or `none` at workflow or job level (GA 2026-09-10) limits cache access, and a caller's mode caps its reusable workflows. Declaring `write` on a low-trust trigger reopens cache poisoning.
- Turn off caching in release and publish jobs: `cache-mode: none`, or `package-manager-cache: false` on setup-node (which caches npm automatically when `package.json` names npm in `packageManager` or `devEngines.packageManager`) and `cache: false` on setup-go (default `true`).
- Serialize deploys without dropping runs. `queue: max` holds up to 100 pending runs in order and cannot be combined with `cancel-in-progress: true`. Without it a new run cancels the pending one.

```yaml
concurrency:
  group: ${{ github.workflow }}-production
  queue: max
```

## OIDC and publishing

- OIDC subjects are immutable for repositories created, renamed or transferred after 2026-07-15: `repo:octo-org@123456/octo-repo@456789:ref:refs/heads/main`. Older repositories keep `repo:octo-org/octo-repo:...` until someone opts in. Write the trust policy for the format the repository emits.
- Condition cloud roles on `sub` and `aud`. The `sub` suffix is `environment:NAME` when the job uses an environment, `pull_request` for pull request events, and `ref:refs/...` otherwise. For a central deploy workflow, put `job_workflow_ref` into the subject template. Organization-selected custom properties arrive as `repo_property_*` claims. A `sub` pattern ending in `:*`, such as `repo:octo-org/octo-repo:*`, admits every branch, pull request and environment.
- Dependabot OIDC tokens carry `event_name: dynamic`. Exclude it in trust policies meant only for workflows.
- Publish to npm with trusted publishing (`id-token: write`) from `push`, `release` or `workflow_dispatch` on a GitHub-hosted runner. npm rejects OIDC tokens from `pull_request_target` and `issue_comment`, and an unvalidated trusted publisher expires 48 hours after creation unless a publish succeeds. For a reusable workflow, register the calling workflow's file name and grant `id-token: write` in both.
- Keep `NODE_AUTH_TOKEN` and `_authToken` off the publish step. When the OIDC exchange fails, npm logs it only at verbose level and publishes with any configured token, which hides a broken trusted publisher. Direct publishing with granular tokens is planned to end in January 2027.

## Runners and syntax

- `ubuntu-latest` moves to Ubuntu 26.04 between 2026-10-19 and 2026-11-19. Pin `ubuntu-24.04` when the build depends on preinstalled tools. `macos-latest` is macOS 26, `macos-14` was retired on 2026-11-02, `windows-latest` is Windows Server 2025, and `windows-2025-vs2026` adds Visual Studio 2026. `ubuntu-slim` is an unprivileged 1 vCPU container without Docker-in-Docker.
- Set `defaults.run.shell: bash`. A step without `shell:` runs `bash -e {0}` without pipefail, while `shell: bash` adds `-o pipefail`.
- Use `case(cond1, val1, cond2, val2, default)` instead of `cond && 'a' || 'b'`, which yields `'b'` whenever `'a'` is falsy.
- YAML anchors and aliases work. The workflow docs do not cover merge keys (`<<:`), so do not rely on them.
- Run steps concurrently with `background: true` plus `wait: id`, `wait-all:` or `cancel: id`, or group them under `parallel:`. At most 10 run at once, their outputs and env changes appear only after the `wait`, and composite actions cannot declare them.

## Gotchas

- A required check whose workflow is skipped by `paths`, `branches` or `[skip ci]` stays on "Waiting for status to be reported" and blocks the merge. Run required workflows on every PR and filter inside, because a job skipped by `if:` reports success.
- A job skipped because a job in its `needs` failed counts as passing. Gate merges on one aggregator job:

```yaml
  ci-ok:
    if: always()
    needs: [lint, test]
    runs-on: ubuntu-slim
    steps:
      - if: contains(needs.*.result, 'failure') || contains(needs.*.result, 'cancelled')
        run: exit 1
```

- Required workflows must also trigger on `merge_group` (`types: [checks_requested]`), which takes only `branches` filters. Otherwise the queue never gets the check.
- In an unquoted YAML value, a space followed by `#` starts a comment. `run-name: ${{ format('PR #{0}', inputs.pr) }}` is cut off, the expression never closes, and no job starts. Double-quote any value that holds `${{ }}` together with `#` or `: `.
- `if: ${{ github.event_name }} == 'push'` is a non-empty string and always true. Keep the whole condition inside one `${{ }}` or omit the braces.
- An `if:` without a status function gets an implicit `success()`, so a report or cleanup step with `if: matrix.os == 'linux'` skips after a failure. Use `if: ${{ !cancelled() && matrix.os == 'linux' }}`, not `always()`, which also runs after cancellation.
- Expression comparisons ignore case. Step outputs are strings, so compare with `'true'` or wrap them in `fromJSON()`.
- Events made with `GITHUB_TOKEN` start no workflows, except `workflow_dispatch` and `repository_dispatch`. Pull requests it opens or updates create `pull_request` runs that wait for approval. Use an App token when CI must start unattended.
- `GITHUB_ENV`, `GITHUB_PATH` and `GITHUB_OUTPUT` take effect from the next step. A fixed heredoc delimiter such as `EOF` lets an untrusted multi-line value inject extra variables. Write arbitrary data to a file instead.
- Workflow-level `env` does not reach a called reusable workflow, and the callee's `env` does not come back. Use `inputs`, `secrets` and `outputs`. Nesting stops at 10 levels and 50 unique reusable workflows per caller.
- Dependabot PR runs get a read-only token and only Dependabot secrets.
- In `dependabot.yml` only `directories` accepts globs such as `/packages/*`, not `directory`.
- `schedule`, `workflow_run` and `issue_comment` start only when the workflow file is on the default branch. Scheduled workflows in public repositories turn off after 60 days without activity.
- Environment branch rules match `refs/pull/N/merge` for `pull_request` events and the default branch for `pull_request_target` (since 2025-12-08). Old patterns that matched the head branch no longer unlock the environment.
- `upload-artifact` skips files and folders starting with `.` unless `include-hidden-files: true`, and a second upload with the same name in one run fails without `overwrite: true`. `download-artifact@v8` fails on a digest mismatch.
- actionlint 1.7.12 (2026-03-30) predates `$/`, `cache-mode`, `background`, `parallel`, `wait` and `queue`, so it can report them as errors. Check the workflow syntax docs before rewriting valid YAML. zizmor 1.32 parses them.

Related skills: use `$git` for repository history and merging, `$containers-iac` for container builds, `$debugging` for CI-only failures, and `$codebase-analysis` for mechanical changes across workflows.
