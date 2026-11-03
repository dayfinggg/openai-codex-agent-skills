---
name: code-review
description: "Review code changes, branches, or PRs against requirements and repository standards. Use when asked to review a diff, branch, or pull request or to check a change before merge, and select the general or the security-focused procedure by the requested task and risk. Not for implementing the fix."
---

Recover the requested review scope, verified baseline, requirements, and affected code. Preserve the distinction between a review and implementation work.

Read [host integration](../.shared/host-integration.md) once for the imported review procedures.

| Review task | Read |
|---|---|
| Check requirement coverage, scope, repository standards, and maintainability | [General review](references/general/guide.md) |
| Review security-sensitive changes, regressions in protection, or concrete attack paths | [Security-focused differential review](references/security/guide.md) |

Use the security procedure when the user requests that analysis or the changed trust boundary makes it necessary. An ordinary low-risk review does not require a complete security audit. Keep evidence for requirement failures and security findings distinct.

The report templates inside the security procedure are checklists of what to verify. Report the review in chat in the active response style unless the user asks for a file.

Perform the review directly with available tools. Confirm findings with affected code and behavior. A review request alone does not authorize edits, commits, publication, or new issue creation.

