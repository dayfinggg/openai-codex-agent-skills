# Node.js and JavaScript package tooling

Release schedules, package-manager defaults, and runtime features change. Verify them using the repository's pinned versions and official documentation.

## Node.js and TypeScript execution

- Determine the runtime from `engines`, version files, CI, containers, and deployment configuration. Do not assume the interactive shell matches production.
- Node.js type stripping is not a type check and does not apply every `tsconfig` transformation. Confirm which TypeScript syntax, extensions, aliases, and module mode the installed Node.js accepts.
- Use the project's declared runner for TypeScript when it needs compiler transforms or aliases. Run a separate type check when correctness depends on types.
- Read or cancel HTTP and SDK response bodies according to the installed API. For streams, use pipeline APIs that propagate errors and close destinations correctly.
- Avoid process-wide mutable state for per-request data in a server handling concurrent requests.

## Package-manager selection

- Take the package manager from the lockfile, `packageManager`, and repository scripts. Use one manager for the task.
- Read the pinned version and exact `--help` or official migration guidance before using unfamiliar flags, especially for major upgrades.
- Review install scripts and binary build steps before approving them. Package-manager allowlists, release-age controls, and script policies may block or alter installation.
- Preserve the lockfile. Do not replace it with another manager's lockfile or regenerate it for unrelated dependency changes.
- Before adding a package, check whether the project's runtime or existing dependency already provides the needed feature. Verify the package and release in its official registry.

## Async and tests

Await test subcases and all promises the test runner must observe. Use the project's documented test command and explicit patterns when its discovery rules omit a file. Do not assume a test runner executes TypeScript with the same configuration as the application build.
