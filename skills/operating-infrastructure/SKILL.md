---
name: operating-infrastructure
description: Covers safe work on infrastructure and delivery by an agent, including Dockerfiles and Compose files, CI pipelines such as GitHub Actions, deploys, servers, Kubernetes and Terraform changes, SSH sessions, systemd units, environment configuration and secrets. Use when the task is to write or change a Dockerfile, a pipeline, a deploy script or server configuration, to release or roll back, to handle credentials, or to run any command against a remote or production system. Triggers on the first command sent to another machine, such as ssh, scp, rsync or a remote wrapper script, and on work with crontab, nginx, systemd, Docker, a CI pipeline, a deploy or a rollback, also in the middle of another task such as a bug fix.
---

# Operating infrastructure

Infrastructure changes are hard to undo and reach beyond this machine. The rules below keep each change small, visible and reversible.

## Before you change anything

Read the current state first, which means the configuration in the repository, the status of the service, and the recent logs. Act on what they show.

Find the way back before you go forward. Know which command or which earlier release restores the previous state, and say so in the reply.

Preview the change where the tool can. `terraform plan`, `kubectl diff`, `docker compose --dry-run up` and the `--dry-run` or `-WhatIf` option of many tools show the effect without applying it. `docker compose config` shows the resolved file and does not compare it with what runs.

## Making the change

Change one thing at a time and verify it before the next. Keep configuration in the repository, where a change is reviewed and can be reverted.

Write scripts that are safe to run twice. Check whether a resource exists before you create it, and make a failed run safe to repeat.

Build once and promote the same artifact. A release is one build plus one configuration with its own identifier, and a rollback is a switch to the previous release. Run migrations and one-off scripts from the same release as the application.

After a deploy, check the health of the service and read its logs. Roll out to a small part first when the platform supports it.

## Needs the user's go-ahead

Ask before each of these, and name the exact command and the way back. They are a change to a production system that the request does not name, a data migration, the deletion of a resource or a volume, a change to access rights or DNS, a pipe from the network into a shell such as `curl | bash`, and switching off a check in CI.

A change that the user asked for needs no second go-ahead. A change that you decided on yourself needs one also when it is small, easy to undo and clearly an improvement, and when it would remove a problem that you found during the task. A setting of a running service is such a change, for example its persistence, its memory limit, a timeout or a schedule. Finish the rest of the work first, then ask.

## Secrets

Keep secrets out of the code, the image layers, the command line and the logs. Read them from the environment or from the platform's secret store at run time. Never print one to check it.

Check the staged diff for credentials before every commit. When a secret was exposed, revoke it first and then issue a new one. Removing it from the history is not enough.

Give every token the narrowest scope and the shortest life that does the job. Do not use a token or a credential that you found in the workspace and were not given for the task.

## Pinning

Pin what you depend on, and update on purpose. Base images are pinned by digest, third-party CI actions by full commit hash, and packages by the lockfile.

## References

Read `references/docker.md` before you write or change a Dockerfile or a Compose file. Read `references/github-actions.md` before you write or change a workflow.

## Related skills

Load `git-workflow` before a commit, and `verifying-work` before you report the change as done.
