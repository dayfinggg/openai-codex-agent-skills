---
name: tanstack-versioned-skills
description: "Load version-matched TanStack package skills for Query, Router, Start, Form, or Table changes. Discover installed guidance without hooks, configuration injection, or version upgrades."
---

Load guidance shipped with the installed TanStack library before changing its behavior.

1. Read package manifests and lockfiles to identify TanStack packages, exact versions, and the package manager. Distinguish the installed version from the manifest range.
2. Locate relevant skills in the installed package and its metadata. Use the project's existing Intent list and load commands when available. Read the selected SKILL.md and only the references needed for the task.
3. If Intent is unavailable, read the package-owned skill files directly. Do not invoke floating npx @tanstack/intent@latest or install a dependency solely to locate instructions.
4. If a package is not installed, establish the locked or explicitly selected version before obtaining its guidance. If no packaged skill exists, use that version's documentation. Do not substitute the latest release's instructions. Missing skills do not block a verifiable documentation-based fix.
5. For Query, inspect query keys, freshness, retention, invalidation, and optimistic rollback. For Router or Start, inspect parameters, loaders, client/server boundaries, SSR, and state transfer. Load only the profile relevant to the change.
6. Preserve the framework, package version, and existing configuration. Do not install hooks, edit gates, or managed AGENTS.md blocks. Load applicable skills using the host's ordinary file-reading capabilities.
7. Verify types, builds, and the affected data path. Where SSR or mutations change, verify failure, navigation, and repeat-request behavior.

Check exact discovery and command semantics against [TanStack Intent](https://tanstack.com/intent/latest/docs/overview) and the chosen library's documentation. Guidance must match the package version.

