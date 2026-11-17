# Stacked pull requests

Read this when the user asks to create or update a stack of dependent pull requests. Support and command behavior depend on the GitHub service, CLI version, extension version, and repository rules. Check current official documentation and installed help before running stack commands.

- Model a stack as a linear chain. Each pull request targets the branch below it, and the bottom request targets the project base. Identify every affected branch and pull request before changing the stack.
- Make and test changes on the branch that owns them. After rebasing one layer, check the dependent layers and their base references before pushing.
- Read the stack tool's exact merge semantics before merging. Some tools merge the selected request and all lower requests, not just the selected one. Name that scope before any merge and never bypass required reviews, checks, or queues.
- Confirm how required checks and CODEOWNERS apply to each layer, including whether a merge queue tests the combined revision.
- If a sync or rebase conflicts, stop before pushing. Resolve against the intent of every branch, then verify each pull request's final diff and base. Do not assume an apparently successful sync updated the remote.
- Use a supported, documented method to remove a layer or finish the stack. Stacked branches can be closed or retargeted together, so verify their state afterward.
