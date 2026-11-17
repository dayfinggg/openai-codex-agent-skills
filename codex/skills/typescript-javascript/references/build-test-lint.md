# JavaScript build, test, lint, and formatting tools

This reference is a diagnostic guide only. Check the installed tool versions and their official release notes before applying migration instructions.

## Diagnose first

- Read the lockfile, package scripts, tool configuration, runtime requirements, and exact error output before changing the toolchain.
- Distinguish a compiler/type-check failure from a bundler transform or runtime error. A tool that runs TypeScript does not necessarily type-check it.
- Use the repository's existing formatter and test runner. Avoid configuring two formatters to rewrite the same files.

## Vite and bundlers

Check the installed bundler's transformation, target, CommonJS, CSS, worker, plugin, and TypeScript-path support. Renamed options may be deprecated for several releases before removal. Confirm that an alias resolves in the source files the config includes, not only in an editor.

When a bundler migration changes its underlying engine, check plugins and generated formats against the new engine's compatibility notes. Test both development and production builds if the change affects both paths.

## Test runners

Verify test discovery, peer dependency requirements, config lookup, mock lifecycle, assertion awaiting, browser provider, and output location before changing a test command. Use explicit test selection that the installed package manager actually passes through to the test runner.

## Linters and formatters

Check the installed major version and config format. A new flat-config loader or parser option can change which files are linted or how TypeScript is checked. Confirm the changed source is covered by the intended configuration.

Keep one formatter for a file type unless the repository documents a safe division of responsibility. Review automated migration diffs before applying them broadly.
