# Docker

## Images

Pin the base image to a version and a digest, as in `FROM alpine:<version>@sha256:<digest>`. A bare tag such as `latest` changes under you. A pinned digest also stops security updates, so update it on purpose.

Use a multi-stage build. Compile in one stage and copy only the result into a small final stage.

Order the instructions from the least to the most often changed. Copy the dependency manifest and install before you copy the source, so that the install layer stays cached.

Add a `.dockerignore` that leaves out the version control directory, dependencies, build output and local environment files.

## Instructions

Put `apt-get update` and `apt-get install` in one `RUN`, pin package versions, add `--no-install-recommends`, and remove the package lists in the same layer.

Run as a user that is not root. Create it with a fixed numeric id and switch with `USER`.

Write `CMD` and `ENTRYPOINT` in exec form, as a JSON array. The shell form wraps the process in a shell that does not pass signals on. An entrypoint script ends with `exec "$@"`.

Prefer `COPY` to `ADD`. Copy named files and directories, and avoid a blanket copy of the build context.

Add a `HEALTHCHECK` when the platform does not define its own.

## Secrets

`ENV` and `ARG` values stay in the image layers and in its history. Pass a build-time secret with `RUN --mount=type=secret`, and a run-time secret as a mounted file. Environment variables are visible to every process in the container and often end up in logs.

## Compose

Pin image versions. Give each service a health check, and make dependants wait with `depends_on` and `condition: service_healthy`. Pass credentials with the `secrets` element, which mounts each one as a file under `/run/secrets`, and keep an uncommitted environment file for values that are not secret. Name the volumes that hold data, so that they are easy to find and back up. `docker compose down -v` deletes the named volumes, so it needs the user's go-ahead.

## Check

Build the image, run the container, and confirm that the process starts and answers. Lint the Dockerfile with `hadolint` when it is installed.
