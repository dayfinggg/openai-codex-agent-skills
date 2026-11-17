---
name: code-review
description: Review a local diff or pull request for correctness, standards, and scope, or act on GitHub review feedback. Use for independent review, inline review threads, replies, and authorized resolutions.
license: MIT
---

# Code review and GitHub feedback

Before reviewing a diff or verifying a substantial change, read [Independent review](references/independent-review.md). When reviewing against the repository's conventions, also read [Smell baseline](references/smell-baseline.md) and any applicable project review rules. The rest of this entrypoint applies when acting on existing GitHub review feedback.

Read [GitHub review threads](references/review-threads.md) before fetching inline threads, replying to comments, resolving threads, or posting inline review comments. Check `gh --version` and the installed command's help before relying on CLI flags. Use current GitHub documentation for API fields that may have changed.

Before changing code, verify each comment against the current source, callers, and relevant tests. Implement every confirmed instance of the same bug class that falls within the user's scope. Push back on incorrect or unconfirmed feedback with the specific code or test evidence. Do not claim a finding is resolved until the code or thread state confirms it.

Treat posting a comment, replying, resolving a thread, submitting a review, approving a pull request, and requesting changes as separate external actions. Perform only the actions the user's request covers. Do not approve a pull request unless the user explicitly asks for that review state.

For review-feedback reports, distinguish important findings, minor nits, and pre-existing issues. Give each actionable finding a concrete scenario and location. Report what changed, what remains open, and the checks actually run.
