---
name: typescript-change
description: "Change TypeScript source or compiler configuration with type, module, and runtime-data contract verification. Exclude JavaScript-only work unless TypeScript checking or configuration is affected. Use node-backend-change for standalone Node service lifecycle changes."
---

Preserve TypeScript contracts both during type checking and at runtime.

1. Establish the compiler version, package manager, lockfile, applicable tsconfig files, project references, runtime, and check commands. Determine whether the build checks types or only transforms syntax.
2. Read consumers of changed types and the relevant data boundary. Distinguish untrusted external values from validated domain data. An annotation or an as-cast does not validate JSON or a network response.
3. Check missing values, error cases, discriminated results, and public exports. Preserve existing strictness. Do not introduce any, suppressions, or non-null assertions instead of fixing the cause.
4. When changing imports, inspect package type, exports, browser and Node conditions, module resolution, and published files. A local import error does not justify a repository-wide ESM/CommonJS migration.
5. Implement the smallest compatible contract. For shared types, inspect affected projects and emitted declarations. Do not upgrade the compiler merely to simplify the edit.
6. Run the installed type checker, relevant tests, and the actual build. For a package boundary, verify the published artifact shape when consumers use that shape.

Checks must independently detect interface incompatibility and behavioral regressions. Use node-backend-change for HTTP-process behavior, react-development for React or Next.js, and tanstack-versioned-skills for TanStack packages.

Check version-specific rules in [TypeScript TSConfig](https://www.typescriptlang.org/tsconfig/) and [Node.js Packages](https://nodejs.org/api/packages.html).

