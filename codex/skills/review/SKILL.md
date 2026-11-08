---
name: review
description: Review a branch, pull request, or uncommitted diff for bugs, standards, and requirement gaps.
---

Pin the requested comparison base and inspect the actual diff. For uncommitted work, include staged, unstaged, and relevant untracked files.
Find the originating request or spec and the repository's applicable standards, including REVIEW.md when present.
Check correctness, documented standards, and specification coverage separately.
For each bug, identify a concrete failing input or scenario, consequence, and file with line number.
Confirm findings against callers and tests before reporting. Mark pre-existing issues separately.
Treat code smells as judgment calls, not hard violations. Skip checks already enforced by tooling.
Use independent reviewers only when delegation is authorized. Otherwise perform the same checks yourself.
Report actionable findings first and state the limits of the review. Do not edit code unless asked.
For a follow-up review, inspect new changes and unresolved findings without repeating fixed issues.
