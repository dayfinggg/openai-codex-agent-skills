---
name: starting-projects
description: Set up a genuinely new app, service or library in an empty destination. Use for initial stack selection and scaffolding, not adding a feature to an existing project.
---

# Starting projects

Inspect the destination and the user's stack choices before scaffolding. Preserve existing files. Choose the smallest stack that serves the product, including a framework only when its routing, rendering or other facilities are needed.

Check current official setup documentation and generator options for the chosen stack. Prefer an official generator where it produces useful defaults. Use its confirmed noninteractive options when possible. A small standalone script or package may need only a manifest rather than a full framework skeleton.

Use the user's or repository's package manager and install into the project rather than globally unless global installation is requested. Let the package manager maintain dependency versions and lockfiles.

Follow framework conventions. For substantial features, establish responsibility, state ownership and resource lifetime before growing the entry point. Select additional architecture or design guidance from the current descriptions when needed. Include the ecosystem's ignore file and required runtime configuration. Add language resources when localization is part of the interface. Do not add a README, CI pipeline, test framework or tooling stack solely to satisfy a generic checklist.

Configure and run the checks appropriate to the project's deliverable and dependencies. Start its real entry point once when practical. A scaffold that exists but cannot run is not a completed application.
