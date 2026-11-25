# GitHub Actions

## Permissions

Set `permissions` at the top of the workflow to the least it needs, usually `contents: read`, and raise it per job. Without the key, the token can get write access to the whole repository.

Use short-lived credentials through OpenID Connect for a cloud provider when it supports them. A long-lived key in a repository secret is the fallback.

## Third-party actions

Pin an action to its full commit hash, and keep its version in the trailing comment that update tools such as Dependabot read. A tag can be moved to different code.

## Untrusted input

Values such as the title of an issue, the name of a branch or the body of a comment are written by other people. Never place `${{ github.event.* }}` inside a `run` script. Pass the value through `env` and quote the variable in the script.

`pull_request_target` runs with the secrets of the base repository. Do not check out or run code from the pull request in such a workflow.

## Secrets

Read a secret through `${{ secrets.NAME }}` into `env` for the single step that needs it. Never echo one. When a secret reaches a log, delete the log and replace the secret.

## Reliability

Set `timeout-minutes` on every job. Add a `concurrency` group built from the workflow and the branch, and set `cancel-in-progress: true` on test jobs so that a new push cancels the older run. Leave it off for a deploy job, where a cancelled run can leave a system half changed. Key a cache on the hash of the lockfile. Install with the command that respects the lockfile, such as `npm ci` or `composer install`.

Do not hide a failure with `continue-on-error` or `|| true`. A check that cannot fail checks nothing.

## Check

Validate the file with `actionlint` when it is installed. After a push, read the result of the run with `gh run watch` or `gh run view --log-failed`, and fix the cause of a failure.
