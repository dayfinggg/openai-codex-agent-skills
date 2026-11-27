---
name: operating-infrastructure
description: Gives safe procedures for servers and delivery, covering SSH sessions, deploys and rollbacks, Dockerfiles, Compose, GitHub Actions and other CI, systemd, nginx, cron, Kubernetes, Terraform and secrets. Use when running commands on a remote or production system, or changing a Dockerfile, pipeline, deploy script or server config. Load before the first command that reaches another machine through ssh, scp, rsync or a wrapper script, and before a deploy, rollback or server config change.
---

# Operating infrastructure

## Remote commands

Run ssh without prompts and with limits, as in `ssh -o BatchMode=yes -o ConnectTimeout=10 -o ServerAliveInterval=15 host 'cmd'`, and wrap a long command in `timeout`, such as `timeout 120 ssh ...`. BatchMode turns a password or host key prompt into an error instead of a hang. Start a job that takes minutes with `nohup` or a systemd unit writing to a log file, then read the log.

Use the access the user gave or pointed to, such as a host alias, a key or a wrapper script. Ask before using a credential you found elsewhere in the workspace.

## Before and during a change

Read the configuration, the service status and its recent logs first, and before a production write confirm the account, the environment and the exact target with a read-only check. Find the way back, the command or earlier release that restores the previous state, and name it to the user. Preview with `terraform plan`, `kubectl diff`, `docker compose --dry-run up` or a `--dry-run` or `-WhatIf` option, noting that `docker compose config` only resolves the file. Test a config before reloading, as with `nginx -t`, `systemd-analyze verify` or `sshd -t`.

Build once and promote the same artifact, so that a rollback switches to the previous release, and run migrations from the release they belong to. After a deploy, check the health endpoint and the logs.

## Needs the user's go-ahead

Besides live writes and setting changes, ask before deleting a resource or a volume, changing access rights, firewall rules or DNS, piping the network into a shell as in `curl | bash`, and switching off a CI check, naming the exact command and the way back. A change the user asked for needs no second approval. A change you chose yourself does, even a small improvement such as a memory limit, a timeout or a schedule of a running service, so finish the rest of the work and then ask.

## Secrets

Read secrets from the environment or the platform's secret store at run time, keeping them out of code, image layers, command lines and logs. To check that one is set, print its name or test it, as with `env | cut -d= -f1` or `test -n "$TOKEN"`, and read only the fields a task needs from a file or an output that holds secrets, so the values never reach the transcript. An exposed secret is revoked and reissued, since removing it from history leaves the copies others took. Give tokens the narrowest scope and shortest life that works.

## References

Read `references/docker.md` before changing a Dockerfile or a Compose file, and `references/github-actions.md` before changing a workflow.
