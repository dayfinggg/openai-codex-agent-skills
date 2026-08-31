# Security

- Treat request data, URLs, DOM values, files, environment variables, messages, plugin output, and package metadata as untrusted until validated.
- Never pass untrusted strings to `eval`, `Function`, dynamic code loaders, or equivalent implicit evaluation. [J24][J5]
- Keep dynamic import specifiers on an allowlist. Do not turn user input into a module path.
- Render untrusted browser data as text with `textContent`, `value`, or other safe sinks. Avoid `innerHTML`, `document.write`, and event-handler attributes. [J25][J26]
- If user-authored HTML is required, sanitize it with a maintained, reviewed sanitizer and do not modify the sanitized result afterward. [J25]
- Parse and validate URLs, allow only intended protocols and hosts, and do not construct `javascript:` or executable URLs from input. [J25]
- Use `spawn` or `execFile` with an argument array for Node subprocesses. Do not interpolate untrusted input into shell commands or use synchronous child processes on request paths. [J27]
- Resolve file paths against an allowed root and reject traversal, unexpected schemes, and symlink escapes where the threat model requires it.
- Bound input size, regular-expression complexity, recursion depth, and concurrency to reduce denial-of-service risk. [J17]
- Keep secrets out of source, logs, errors, snapshots, and client bundles. Review dependency changes and lockfile diffs.
