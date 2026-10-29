---
name: github-actions-change
description: "Change GitHub Actions with event, permission, dependency, cache, artifact, and untrusted-input checks. Use for workflow YAML or repository action changes."
---

Preserve workflow coverage and trust boundaries while implementing the requested CI/CD behavior.

1. Read affected workflows, local or reusable actions, scripts, runner configuration, required checks, and current failures. Determine which events and branch contexts are intentionally supported.
2. Trace the origin of checked-out code, artifacts, caches, inputs, and expressions into every privileged job. Distinguish workflow code trust from permissions to trigger it.
3. Preserve required events and user-access behavior. Fix untrusted interpolation or checkout without removing supported events as an incidental security shortcut.
4. Inspect token permissions, secret exposure, environment restrictions, and dependency resolution. Respect an existing workflow dependency lockfile. Otherwise use supported immutable dependency references and verify their origin where the task changes them.
5. Separate caches from release artifacts. Check cache keys, restore trust, build inputs, and artifact provenance. A restored cache must not silently replace the artifact associated with the tested commit.
6. Validate YAML and action inputs using existing tooling, then run the relevant event path where authorized. Local YAML parsing alone does not prove GitHub event semantics.
7. Inspect the actual commit's jobs, skipped paths, test counts, and outputs. If PR work must wait on checks, use the host's supported PR watcher and obey its handback contract rather than polling.

Use the current [GitHub Actions secure-use reference](https://docs.github.com/en/actions/reference/security/secure-use) and [workflow syntax](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax). Do not add hooks, unrelated actions, or new approval stages merely because an external guide mentions them.

