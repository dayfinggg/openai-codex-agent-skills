---
name: docker
description: "Containerize an application, write or optimize Dockerfiles and image builds, or configure and diagnose Docker Compose services."
---

Choose the Docker workflow from the state of the project and the requested change. Preserve the application's runtime and existing deployment choices.

Read [host integration](../.shared/host-integration.md) once for resource paths and shell handling.

| Task | Read |
|---|---|
| Add the project's initial Docker setup | [Project foundations](references/project/guide.md) |
| Change a Dockerfile, image build, cache strategy, or build-secret handling | [Image builds](references/build/guide.md) |
| Wire or diagnose services, health dependencies, networks, volumes, or overrides | [Compose](references/compose/guide.md) |

When first-time containerization also needs build and Compose work, start with project foundations and then load only the relevant additional procedure. Existing projects normally go directly to the procedure that owns the change.

Keep the complete scripts, templates, and verification checklists inside their procedure bundles. Run a helper from the application working directory specified by its usage, while resolving the helper's path from its bundle directory.

A configuration-only request does not authorize starting services or building arbitrary images. Perform the checks needed for the authorized outcome and preserve unrelated containers, images, and volumes.

