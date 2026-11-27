# GitHub Actions

## Permissions and secrets

Set `permissions` at the top of the workflow to the least it needs, usually `contents: read`, and raise it per job, because without the key the token may get write access to the repository. Use OpenID Connect for a cloud provider that supports it, with a long-lived key in a secret as the fallback.

Map `${{ secrets.NAME }}` into `env` for the one step that needs it. When a secret reaches a log, delete the log and replace the secret.

## Actions and input

Pin a third-party action to its full commit hash with the version in a trailing comment that Dependabot reads, since a tag can be moved.

Issue titles, branch names and comment bodies are written by others. Pass `${{ github.event.* }}` values through `env` and quote the variable in the script instead of placing them inside `run`. A `pull_request_target` workflow runs with the base repository's secrets, so it checks out and runs base code only.

## Reliability

Set `timeout-minutes` on every job. Add a `concurrency` group from the workflow and the branch, with `cancel-in-progress: true` on test jobs and off on deploy jobs, where a cancelled run can leave a system half changed. Key caches on the lockfile hash and install with `npm ci`, `composer install` or the ecosystem's lockfile command. Let failures fail, because `continue-on-error` or `|| true` makes a check that cannot fail.

## Check

Validate with `actionlint` when installed. After a push, read the run with `gh run watch` or `gh run view --log-failed` and fix the cause.
