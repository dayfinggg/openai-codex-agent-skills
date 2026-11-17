# GitHub repository rules

Read this when a check is missing, a merge is blocked, or a change depends on branch rules. GitHub Enterprise Server and GitHub.com can differ, and repository settings can change, so inspect the current repository configuration and official documentation before choosing a fix.

- Evaluate all applicable rulesets and classic branch protection rules together. A repository, organization, or enterprise can set different rules on the same branch.
- Verify that required status checks come from the expected application and that workflows needed by a merge queue run for the merge-group revision, not only the pull request head.
- Check required merge methods, signed-commit rules, approval dismissal, and queue requirements before changing branch settings. Do not bypass required checks or use an administrator merge to hide a failed rule.
- CODEOWNERS is read from the pull request's base branch. Check the applicable file, the final matching pattern, and whether the named owners can review the repository.
- Make repository rule changes only when the user asks for them. Otherwise report which rule blocks the requested operation and the smallest required decision.
