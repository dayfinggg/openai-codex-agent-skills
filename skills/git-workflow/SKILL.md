---
name: git-workflow
description: Covers commits, branches, undoing changes and pull requests in a Git repository. Use when the user asks to commit, push, branch, merge, rebase, cherry-pick, tag, revert, undo, reset, amend, force push, stash, clean up history or open a pull request, when a working tree with mixed changes must be split into commits, and before any Git command that rewrites or discards work. Triggers before the first git commit, push, merge, rebase, tag, reset or stash in a task, also when the repository is on a server and the command runs over ssh or inside a script.
---

# Git workflow

Commit and push only when the user asked for it. The rules for commits apply once they did. The rules for undoing and for risky commands apply every time.

## Before a commit

Run `git status` and `git diff` and read both. Stage files by name. A blanket `git add -A` picks up build output, editor files and secrets. Read the staged diff with `git diff --cached` and check it for credentials, tokens, `.env` files and generated files before you commit. Run the project's own checks first when it has them.

Look at `git log --oneline -15` and follow the convention the repository already uses. Use the format below only when the history shows no convention.

## Commits

One commit holds one logical change that builds and passes on its own. A working tree with several unrelated changes becomes several commits. Stage the files of one change, commit it, and repeat. `git add -p` waits for input and does not work here, so to split one file, write the hunks of one change to a patch file and stage it with `git apply --cached <patch>`, which changes only the index.

Write the subject as `type(scope): description`, with a type such as `feat`, `fix`, `refactor`, `docs`, `test` or `chore`. Use the imperative mood, as in "add export command", with no period at the end. Aim for 50 characters and never pass 72. Leave one blank line, then a body wrapped at 72 characters that says what changed and why. The diff already shows how. Mark a breaking change with `!` before the colon or with a `BREAKING CHANGE:` footer.

When a hook rejects the commit, fix what it reports and commit again. A rejected commit was never created, so do not retry with `git commit --amend`, which would rewrite the previous commit.

## Undoing

Choose the command by whether the commit is shared. For a commit that others may have, use `git revert`, which adds a new commit. Reverting a merge needs `-m <parent>`, usually `-m 1` for the branch that was merged into. A later merge of the same branch then brings in only the commits made after the reverted merge, so tell the user before you revert a merge. For staged files, `git restore --staged <file>` unstages them and leaves the edits. For local commits that were never pushed, `git reset --keep <commit>` drops them and stops if it would lose local edits. A commit that seems lost is usually still reachable through `git reflog`, and `git branch <name> <sha>` brings it back.

## Needs the user's go-ahead

These commands rewrite shared history or discard work that Git cannot bring back. Ask before each one and name the exact command. The commands are a force push, `git reset --hard`, `git checkout -- .`, `git checkout -f`, `git switch -f`, `git restore .`, `git clean -fd`, `git stash drop` and `git stash clear`, `git worktree remove --force`, `git branch -D`, the deletion of a branch you did not create, a rebase or an amend of commits that were already pushed, and `--no-verify`. Never force push to the default branch. When a force push is approved, use `git push --force-with-lease --force-if-includes`.

## Branches and pull requests

Start a new branch when the work would otherwise land on the default branch. Name it with a type and a short description in kebab case, such as `fix/login-timeout`.

Open a pull request as a draft with `gh pr create --draft`. The title follows the commit subject format. The body says what changed, why, how it was checked and what carries risk, and it links the issue with `Closes #<number>`.

## Gotchas

`git commit --amend` after a push creates a second version of the commit, and the next push is then a force push.

`git stash` hides work that is easy to forget. Prefer a commit on a branch.

`git pull` stops with an error when the local and the remote branch have diverged and no way to reconcile them is configured. Check the repository's convention, then run `git pull --rebase` or `git pull --no-rebase` for that pull.

## Related skills

Load `verifying-work` before you commit changes that were not checked yet.
