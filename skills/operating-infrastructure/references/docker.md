# Docker

## Images

Pin the base image as `FROM image:<version>@sha256:<digest>`, because a tag such as `latest` moves. A pinned digest also stops security updates, so bump it on purpose.

Build in stages and copy only the result into a small final stage. Copy the dependency manifest and install before copying the source, so that the install layer stays cached. Add a `.dockerignore` for the version control directory, dependencies, build output and local environment files.

## Instructions

Run `apt-get update` and `apt-get install --no-install-recommends` with pinned versions in one `RUN`, and remove the package lists in the same layer.

Switch to a user that is not root with a fixed numeric id through `USER`.

Write `CMD` and `ENTRYPOINT` as JSON arrays, because the shell form wraps the process in a shell that does not pass signals on. An entrypoint script ends with `exec "$@"`.

Use `COPY` with named paths rather than `ADD` or a copy of the whole context. Add a `HEALTHCHECK` when the platform defines none.

## Secrets

`ENV` and `ARG` values stay in the layers and the image history. Pass a build secret with `RUN --mount=type=secret` and a run-time secret as a mounted file.

## Compose

Pin image versions, give each service a health check, and make dependants wait with `depends_on` and `condition: service_healthy`. Pass credentials through the `secrets` element, which mounts each under `/run/secrets`, and keep other values in an uncommitted environment file. Name the volumes that hold data. `docker compose down -v` deletes those volumes, so it needs the user's go-ahead.

## Check

Build the image, run the container and confirm that the process starts and answers. Lint with `hadolint` when installed.
