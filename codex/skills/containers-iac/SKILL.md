---
name: containers-iac
description: Build and diagnose Docker and Compose images, Kubernetes manifests, Terraform or OpenTofu configuration, and OpenTelemetry pipelines. Use for container builds, orchestration, infrastructure state, or telemetry configuration.
license: MIT
---

# Containers and infrastructure as code

This skill covers Dockerfiles, BuildKit, Compose, Kubernetes, Terraform, OpenTofu, and OpenTelemetry. Release details in this skill are a dated reference snapshot. Check project pins, the installed CLI, cluster server version, and official documentation for the exact version before relying on a field or command.

## References

Open the full reference before the first step it covers, even when that step comes later in the task.

- [references/docker-details.md](references/docker-details.md): read when using Compose watch, cache mounts for apt or other package managers, the `gha` cache backend, Dockerfile flags such as `COPY --link`, `COPY --exclude`, `ADD --checksum` or `ADD --unpack`, or `healthcheck.start_interval`.
- [references/kubernetes.md](references/kubernetes.md): read when writing or reviewing Kubernetes manifests, Helm or Kustomize output, probes, Pod Security, or planning a cluster upgrade.
- [references/terraform-opentofu.md](references/terraform-opentofu.md): read when working on Terraform or OpenTofu configuration, state, modules, imports or tests.
- [references/opentelemetry.md](references/opentelemetry.md): read when adding OpenTelemetry instrumentation, setting `OTEL_*` variables or configuring a Collector.

## Check first

- Read what the project pins before writing syntax: the `# syntax=` line and `FROM` tags, `.dockerignore`, `compose.yaml` with its override files, and the Engine and Compose versions on the host that deploys, which can differ from the local ones.
- Kubernetes: the server minor in `kubectl version` decides which APIs and fields exist. Check a field with `kubectl explain <kind>.<path>` and validate with `kubectl apply --dry-run=server -f <file>`.
- Terraform or OpenTofu: read `required_version`, the provider hosts in `.terraform.lock.hcl` (`registry.opentofu.org` means OpenTofu), any `.tofu` files and the binary the CI job runs.
- OpenTelemetry: read SDK and instrumentation versions in the lockfile, every `OTEL_*` variable in the deployment config, and the Collector image name and tag.

## Dockerfiles

- Start every Dockerfile with `# syntax=docker/dockerfile:1`, so BuildKit pulls the newest stable 1.x frontend whatever the Engine version. Pin a minor such as `docker/dockerfile:1.29` when the file sets `# check=error=true`, because checks added later would start failing the build.
- Run `docker build --check .` to lint without building. It exits non-zero on violations, while a normal build only prints them as warnings. `SecretsUsedInArgOrEnv` flags names like `TOKEN` or `PASSWORD` in `ARG` and `ENV`.
- Write multi-line `RUN` steps as `RUN <<EOF` heredocs that begin with `set -eu`. Without it the step fails only when its last command fails.
- Use the exec form `CMD ["node", "server.js"]`. In shell form the process runs under `/bin/sh -c`, is not PID 1 and never receives the `SIGTERM` from `docker stop`, so it is killed after the grace period (10 seconds by default).
- For minimal non-root base images, Docker Hardened Images are free under Apache-2.0 at `dhi.io/<image>:<tag>` and need `docker login dhi.io` with a Docker account.

## Build secrets and cache

- Pass build secrets with `docker build --secret id=NPM_TOKEN` (reads the environment variable of that name) or `--secret id=npmrc,src=$HOME/.npmrc`, and consume them only through a mount. Set `required=true`, because the default `false` builds without the secret and fails later or silently:

```dockerfile
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc,required=true npm ci
RUN --mount=type=secret,id=NPM_TOKEN,env=NPM_TOKEN,required=true npm ci
```

- Never pass a secret through `ARG`, `ENV` or `--build-arg`. Their values stay in the image config and history, which anyone who can pull the image can read.
- Changing a secret's value does not invalidate the build cache, so a cached `RUN` keeps the result built with the old secret. Declare `ARG CACHEBUST` before that step and change its value together with the secret.
- Export CI cache with `--cache-to type=registry,ref=<repo>:buildcache,mode=max` plus the same ref in `--cache-from`. The default `mode=min` stores only the layers of the final image, so earlier stages of a multi-stage build always rebuild.
- Cache mounts (`RUN --mount=type=cache`) live only in the builder's local storage. `--cache-to` does not export them, so a fresh CI runner starts every build with empty cache mounts.

## Next.js and Node images

- Build Next.js with `output: 'standalone'`. The runtime stage copies `.next/standalone` to the work directory, `.next/static` to `./.next/static` and `public` to `./public`, because `server.js` serves only what is copied there, then runs `node server.js` as `USER node` with `ENV HOSTNAME=0.0.0.0` and `PORT`.
- `next build` copies `.env` and `.env.production` into `.next/standalone`, so `COPY . .` puts them into the image. Keep `.env*` out of the build context with `.dockerignore` and pass runtime secrets as environment variables or Compose secrets.
- `NEXT_PUBLIC_*` values are inlined into the browser bundle at `next build`. Pass them as build arguments, rebuild to change them, and never put a secret in one.
- `node:<version>-slim` images remove `curl` and `wget` after installing Node, and distroless images have no shell. Health-check with Node itself:

```yaml
healthcheck:
  test: ["CMD", "node", "-e", "fetch('http://127.0.0.1:3000/api/health').then(r => process.exit(r.ok ? 0 : 1), () => process.exit(1))"]
  interval: 10s
  start_period: 30s
```

- Next.js finishes in-flight requests and pending `after()` callbacks on `SIGTERM`. Give it time with `stop_grace_period: 30s` in Compose, since the default is 10 seconds.

## Docker Compose

- Compose is v5 (5.0.0 shipped in December 2025, versions 3 and 4 were skipped) and hands builds to Buildx Bake. Name the file `compose.yaml` and drop the top-level `version:` key, which is obsolete and only prints a warning.
- Gate startup on readiness with long-form `depends_on` and a `healthcheck` on the dependency. Short-form `depends_on` waits only until the container starts. Use `service_completed_successfully` for one-shot setup services.

```yaml
depends_on:
  db:
    condition: service_healthy
    restart: true
```

- Run migrations and `chown` steps as `pre_start` (Compose 5.3+). Each step runs in its own short-lived container after `depends_on` is satisfied and before the service starts, and runs again only when its definition changes or the service is recreated. Use the `database` skill for migration design.
- Deploy with `docker compose up -d --wait` (add `--wait-timeout <seconds>`), which returns non-zero when a service does not become healthy, so a bad release fails the deploy script instead of passing it.
- Give credentials to services through top-level `secrets:` (`file:` or `environment:`), mounted read-only at `/run/secrets/<name>`, and to builds through `build.secrets`. Values in `environment:` show up in `docker inspect`.
- Publish ports behind a reverse proxy on the same host as `"127.0.0.1:3000:3000"`. Without a host IP Docker binds `0.0.0.0` and its rules bypass the host firewall, so a published port is open to the internet even when ufw denies it.

## Gotchas

- Docker Engine 29 lowered the default open-file limit in containers from 1048576 to 1024 (containerd 2.1.5). Databases and proxies then fail with "too many open files". Raise it per service with Compose `ulimits: nofile:` or `--ulimit nofile=65536:65536`.
- Compose interpolates `$VAR` everywhere in the file, including healthcheck commands. Write `$$` when the container shell must expand it, as in `pg_isready -U $${POSTGRES_USER}`. Use `${VAR:?message}` to fail fast when a required value is missing.
- In Compose, `environment:` overrides `env_file:` for the same key.
- `docker compose config` prints interpolated values, including secrets read from `.env`. Validate with `docker compose config --quiet`.
- Docker Engine 29 removed Docker Content Trust from the CLI. `docker trust` and `DOCKER_CONTENT_TRUST=1` no longer verify image signatures.
- Docker CLI 29 `docker image ls` prints a collapsed tree view and hides untagged images unless `--all` is set. Parse `docker image ls --format json` in scripts.
- The default `docker` build driver exports `registry`, `local` and `gha` caches only with the containerd image store. Fresh Engine 29 installs use it, upgraded daemons usually keep the classic store. Use `docker buildx create --driver docker-container --use` when the export fails.
- From Git Bash on Windows, `docker -v` and `docker exec` path arguments get rewritten, and CRLF scripts fail inside Linux containers. Read the `shell` skill before running Git Bash commands.

Related skills: use `$github-actions` for CI and cloud identity, `$react-next` for Next.js behavior, `$server-ops` before changing a remote host, `$database` for migrations, and `$shell` when shell-specific behavior matters.
