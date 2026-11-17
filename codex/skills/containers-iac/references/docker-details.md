# Dockerfile and Compose details

Technical reference snapshot dated 2026-11-17. Check the pinned Dockerfile frontend and installed BuildKit, Engine, and Compose versions before applying a flag, cache behavior, or watch feature.

## Dockerfile flags by frontend version

With `# syntax=docker/dockerfile:1` every flag below is available. A pinned older frontend needs at least the version shown.

| Flag | Stable since | Note |
| --- | --- | --- |
| `COPY --chmod` | 1.2 | |
| `COPY --link`, `ADD --link` | 1.4 | |
| `RUN --mount=type=secret,env=NAME` | 1.10 | Mounts the secret as an environment variable instead of a file |
| `ADD --checksum` | 1.6, Git sources 1.16 | HTTP sources take `sha256:<hex>`, Git sources a commit SHA or its prefix |
| `ADD --unpack` | 1.17 | |
| `COPY --exclude` | 1.19 | Same pattern syntax as the source, Go `filepath.Match` rules |
| `COPY --parents` | 1.20 | Keeps the parent directories of each source |
| `RUN --device` | 1.27 | Needs BuildKit 0.20+ and the `device` entitlement (`--allow device` on the build) |

`FROM --reset`, `ENV --unset`, `LABEL --unset` and `VOLUME --unset` still need `# syntax=docker/dockerfile:1-labs`.

## ADD and COPY

- `ADD` unpacks local tar archives but downloads remote ones without unpacking. State `--unpack=true` or `--unpack=false` explicitly, and add `--checksum` to every remote `ADD` so the input is pinned.
- `COPY --link --chown` needs a numeric `UID:GID`. A linked layer is copied into an empty filesystem, so user and group names from earlier `RUN` steps cannot be resolved and the build fails.
- A numeric `--chown=1000` also sets the GID to 1000 without reading `/etc/passwd`.

## Cache mounts

- Debian and Ubuntu images delete downloaded packages through `/etc/apt/apt.conf.d/docker-clean`, which makes an apt cache mount useless. Remove that file, tell apt to keep packages, and lock both directories, because apt needs exclusive access:

```dockerfile
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends gcc
```

- Package manager cache targets for the root user in official Node images: `/root/.npm` for npm, `/usr/local/share/.cache/yarn` for Yarn and `/root/.local/share/pnpm/store` for pnpm.
- A cache mount on `/app/.next/cache` speeds up `next build`, but the cached fetch responses in `.next/cache/fetch-cache` then stay out of the image and are not available at runtime.
- To keep cache mounts across GitHub Actions runs, Docker documents the third-party `reproducible-containers/buildkit-cache-dance` action, which copies the mount data in and out of the Actions cache. Pin it like any third-party action.

## Cache backends in CI

- The `gha` backend uses `scope=buildkit` by default, so every image built in the repository overwrites one shared cache. Set `scope=<image-name>` on both `--cache-to` and `--cache-from`.
- `mode=max` applies to every backend except `inline`. `--cache-from` detects its parameters, so only `--cache-to` takes `mode`.

## Compose watch

- Run `docker compose up --watch`. Use `sync` for hot-reloaded source, `rebuild` for dependency manifests such as `package.json`, and `sync+restart` for config files. `sync+exec` and `restart` need Compose 2.32+, `include` patterns need 2.34+.
- Watch tracks only services with `build:`, not services that use a pre-built `image:`.
- The image needs `stat`, `mkdir` and `rmdir`, and the container `USER` must be able to write the sync target (`COPY --chown`). Distroless runtime stages therefore cannot use `sync`.
- `ignore` and `include` patterns are relative to the rule's `path`, not the project root. Quote patterns that start with `*`, since YAML reads `*` as an alias.
- `initial_sync: true` on a `sync` action brings the container up to date before watching starts.
- A rebuild leaves the previous image dangling, and Compose removes those images after each rebuild unless you run `docker compose watch --prune=false`.

## Healthchecks

- `start_interval` (default 5s in a Dockerfile `HEALTHCHECK`) sets how often the check runs during `start_period`, and needs Docker Engine 25 or later. Compose accepts it since 2.20.2.
- A check that passes during `start_period` marks the container started. Failures inside the start period do not count toward `retries`.
- `timeout` defaults to 30s in a Dockerfile. A check that runs longer is killed and counts as a failure.
