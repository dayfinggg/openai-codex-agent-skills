---
name: typescript-javascript
description: Work on JavaScript, TypeScript, or Node.js, including type models, module formats, runtime compatibility, and package or build tools across targets. Use react-next for App Router or React boundaries and frontend-ui for visual and accessibility work.
license: MIT AND Apache-2.0
metadata:
  source: "Includes material from Google Chrome Modern Web Guidance 1.0."
---

# JavaScript and TypeScript

Open only the reference for the part being changed. Use `react-next` for framework boundaries and `frontend-ui` for visual or accessibility work.

Read the package manifest, lockfile, runtime declarations, build and test scripts, and the relevant `tsconfig` inheritance chain. Follow the repository's package manager and module model. Compare each runtime target with the syntax and built-ins the code uses. TypeScript compilation and JavaScript transpilation do not necessarily add runtime built-ins.

Read [references/ecmascript.md](references/ecmascript.md) when selecting newer language features, runtime support, polyfills, or Temporal date and time types. Read [references/typescript.md](references/typescript.md) when compiler settings or a non-trivial type model changes. Read [references/node-and-packages.md](references/node-and-packages.md) for Node.js runtime behavior, module resolution, package managers, or TypeScript execution. Read [references/build-test-lint.md](references/build-test-lint.md) when project-wide build, test, lint, or formatting tools are configured or upgraded.

Treat the release details in the references as a dated snapshot. Check the project's installed versions and current official documentation before relying on any version-specific option, default, API, or migration claim. Verify the affected target with the project's type check and focused tests or build.
