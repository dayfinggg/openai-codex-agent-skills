# Docker and Compose

## Dockerfile

- Start from `docker init` when the project has no Dockerfile yet, then adjust.
- Multi-stage builds: dependencies and build in one stage, a minimal runtime image in the last.
- Official base images pinned to a specific version tag, or to a digest for reproducible builds. Never `latest`.
- Copy the manifest and lock file first, install dependencies with a cache mount (`RUN --mount=type=cache,target=/root/.npm npm ci`), then copy the source.
- `COPY` for local files. `ADD` only for remote artifacts with a checksum.
- Create and switch to a non-root user with `USER` before the final command.
- `CMD` and `ENTRYPOINT` in exec form: `CMD ["node", "server.js"]`.
- One process per container.
- A `HEALTHCHECK`, or a Compose health check, that calls the health endpoint.
- A `.dockerignore` that excludes `.git`, `node_modules`, `.env`, build output and local data.
- Build secrets with `RUN --mount=type=secret,id=...`, never through `ARG` or `ENV`.

## Compose

- The file is `compose.yaml` with no top-level `version` key. Run it with `docker compose`, never `docker-compose`.
- Start dependent services only when the dependency is healthy:

```yaml
services:
  app:
    depends_on:
      db:
        condition: service_healthy
  db:
    image: postgres:18
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      retries: 10
```

- Secrets through the top-level `secrets` key, mounted at `/run/secrets/<name>`.
- Development-only services behind `profiles`, and live reload with `develop.watch` and `docker compose up --watch`.
