---
name: dependencies
description: Guides adding, upgrading, and auditing third-party packages in any ecosystem. Use it before you add a package or a version number to a manifest, run an install or an upgrade, run a tool straight from a registry, write the version of a container image or a CI action, or act on a vulnerability report. Use it when a package manager refuses an install because of a release age or an install script.
---

<overview>
A dependency is other people's code that runs with the project's rights. A package name from memory can be wrong or invented, a version from memory is stale, and a release from the last few days can be a compromised one. The `code_rules` block of the coding instructions decides whether a new dependency is allowed at all. This skill covers how to add, upgrade, and audit one.
</overview>

<references>
One reference file holds the settings and commands of each package manager, which this file does not repeat. Read [package-managers.md](references/package-managers.md) whole before you look a package up in a registry, change a release-age or install-script setting, write an install step for CI, or run an audit. It lists what npm, pnpm, Yarn, Bun, uv, pip, Composer, Cargo, Go, Dependabot, and Renovate each offer for these jobs.
</references>

<names_and_versions>
- Look the package up in its registry before you install it. Confirm the exact name, the repository it links to, and that its publish history fits the library you mean. A model can name a package that no registry holds, and an attacker can register that name. In a [2025 study](https://www.usenix.org/conference/usenixsecurity25/presentation/spracklen) of 576,000 code samples, at least 5.2 percent of the packages that commercial models named did not exist.
- Write no version number from memory. Let the package manager resolve the current version, as `npm install <pkg>`, `uv add <pkg>`, `composer require <pkg>`, and `cargo add <pkg>` do, or read the version from the registry. The same holds for a container image tag, a CI action, and a script URL on a CDN.
- Before you add a version, check in the package's own metadata that it supports the project's runtime and framework versions.
</names_and_versions>

<install>
- Install with the project's package manager, and keep the lockfile change together with the manifest change. In CI, install from the lockfile only.
- Keep the manager's protections on. Current managers can refuse a version that is younger than a minimum release age, and they can block the install scripts of dependencies. When one of them stops an install, choose an older version, or name the one package that needs an exception and let the user decide. Turning the protection off for the whole project is the user's decision.
- A command that runs a tool straight from a registry, such as `npx`, `pnpm dlx`, `bunx`, `uvx`, or `pipx run`, executes that package's code at once. Use it only for a name you verified, with the version pinned.
- Read an install script before you pipe it into a shell, and prefer the package manager where it offers the same tool.
</install>

<upgrades>
- Upgrade the packages the task names. A broad update command rewrites the whole lockfile, so its effect cannot be reviewed.
- For a major version, read the migration guide and the changelog first, as the `research` skill describes. Move one major version at a time, and run the project's checks after each step.
- For a security fix, take the smallest version that closes the advisory.
</upgrades>

<audit>
Run the manager's audit command after you add or upgrade a package, and when the user asks about vulnerabilities. For each finding, report the package, the advisory, the version that fixes it, and whether the project reaches the vulnerable code. A forced fix, such as `npm audit fix --force`, can install a breaking major version, so it waits for the user's word.
</audit>
