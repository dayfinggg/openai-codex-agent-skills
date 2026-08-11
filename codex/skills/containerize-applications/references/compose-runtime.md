# Compose runtime decisions

**Reviewed:** 2026-08-11
**Scope:** Current Docker Compose Specification and Docker production guidance. Resolve the installed Compose implementation and supported fields first.

## Rendered contract

- Evaluate the complete merged configuration, profiles, interpolation, environment precedence, and relative paths. Do not review one fragment as if it were the effective model.
- Validate with the installed Compose parser and inspect rendered output without leaking resolved secrets.
- Keep service names, networks, volumes, configs, secrets, and dependency relationships stable for supported consumers.

## Runtime behavior

- Use health checks for actual readiness and liveness signals. Startup ordering alone does not prove a dependency is ready or will stay available.
- Give services bounded retry and reconnection behavior because containers and dependencies can restart independently.
- Define restart policy, stop signal and grace period, init or child reaping, resource constraints, logging, and read-only or temporary filesystem needs.
- Keep internal networks private and publish only required ports. Treat host mounts as privileged access to host data.
- Define persistence, ownership, backup, restore, migration, and deletion for named volumes. Never remove volumes as a cleanup probe.

## Environments

- Use separate reviewed overrides or deployment inputs when development and production behavior materially differs. Do not bake secrets or environment-specific endpoints into the shared image.
- Treat remote context use, environment creation, image pull, service start, and volume changes as external effects requiring authority.

## Official sources

- [Compose Specification](https://docs.docker.com/reference/compose-file/)
- [Compose production guidance](https://docs.docker.com/compose/how-tos/production/)
- [Compose configuration rendering](https://docs.docker.com/reference/cli/docker/compose/config/)
- [Compose startup order](https://docs.docker.com/compose/how-tos/startup-order/)
