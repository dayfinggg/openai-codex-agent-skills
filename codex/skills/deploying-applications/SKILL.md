---
name: deploying-applications
description: Prepare or change Docker, Compose, CI, hosting or runtime configuration. Executing a deployment or changing a live system requires authorization for that operation.
---

# Deploying applications

Distinguish writing configuration from executing it against an external system. Use the project's deployment, validation and recovery commands. Confirm the authorized environment and destination before a live change.

Read [docker.md](docker.md) for container work and [ci.md](ci.md) for CI work. Check installed versions and official release guidance when a command or configuration is version-sensitive.

Keep credentials outside source, images, build arguments and logs. Use the platform's secret store or protected environment configuration with least privilege and separate credentials per environment. Preserve existing configuration contracts. Update .env.example when new environment variables require it, without real values.

Use the platform's existing HTTPS, proxy, health-check and logging facilities. Add a reverse proxy or health endpoint only when the deployment needs one. Prefer structured standard-output logs for containers without rewriting unrelated logging.

Validate changed configuration locally where possible. A successful build is not proof of a successful deployment. After an authorized deployment, check the changed path and report any unverified live behavior.
