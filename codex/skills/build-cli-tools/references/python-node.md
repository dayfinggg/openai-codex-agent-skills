# Python and Node.js CLI fit

**Reviewed:** 2026-08-11
**Scope:** Current Python `argparse`, Node.js `util.parseArgs`, and npm package binary documentation. Resolve runtime and library versions from the project.

## Python

- Preserve package and module naming in importable `snake_case`. Use the project's existing console-script or module entry point rather than adding a second mechanism.
- Define parser errors, help, defaults, subcommands, types, and destination names as a stable external contract. Runtime validation remains necessary after parsing.
- Keep import-time behavior side-effect free. Put execution behind the established entry point and return an exit status that the wrapper exposes.
- Stream files and stdin, use context managers for resources, and handle expected exceptions without swallowing the cause.
- Test invocation through the installed console script or `python -m` path actually supported by the package.

## Node.js

- Preserve the package `bin` mapping, module system, runtime support, loader, and transpilation contract.
- Use the existing parser. If `util.parseArgs` is available for the supported version, verify strictness, token handling, repeated options, and negative-option behavior rather than assuming another version.
- Keep library imports side-effect free. Set process exit status after cleanup instead of terminating before streams and telemetry flush, unless immediate termination is required.
- Respect stream backpressure and handle broken pipes, abort signals, child-process lifecycle, and rejected promises.
- Test both repository invocation and the packaged executable shim on every supported operating system.

## Official sources

- [Python argparse](https://docs.python.org/3/library/argparse.html)
- [Python command-line interface libraries](https://docs.python.org/3/library/cmdline.html)
- [Node.js util.parseArgs](https://nodejs.org/api/util.html#utilparseargsconfig)
- [Node.js process](https://nodejs.org/api/process.html)
- [npm package bin](https://docs.npmjs.com/cli/configuring-npm/package-json#bin)
