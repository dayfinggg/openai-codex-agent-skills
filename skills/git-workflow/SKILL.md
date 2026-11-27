---
name: git-workflow
description: Gives safe steps and commands for commits, branches, undoing changes and pull requests in Git. Use when the user asks to commit, push, branch, merge, rebase, cherry-pick, revert, undo, reset, amend, stash or force push, to open a pull request, or to split mixed changes into separate commits. Load before the first Git command that changes the index, the working tree, branches or history, and before opening a pull request.
---

# Git workflow

Do the Git step the user asked for and stop there. A commit goes on the current branch, and a push happens only when the user asks for it.

## Commits

Read `git status` and `git diff`, then stage files by name, because `git add -A` also picks up build output, editor files and secrets. Read `git diff --cached` for credentials, `.env` files and generated files before committing.

Follow the message style of `git log --oneline -15`. With no visible style, use `type(scope): description` in the imperative, at most 72 characters, and a body that says what changed and why.

Give each logical change its own commit. `git add -p` waits for input that this environment cannot give, so to split one file, write the hunks of one change to a patch file and stage it with `git apply --cached <patch>`, which touches only the index.

When a hook rejects a commit, fix what it reports and run the same `git commit` again. The rejected commit never existed, so `--amend` would rewrite the previous one.

## Undoing

Use `git revert` for a commit others may have. Reverting a merge needs `-m 1`, and a later merge of the same branch then brings in only newer commits, so tell the user before reverting a merge. `git restore --staged <file>` unstages and keeps the edits. `git reset --keep <commit>` drops unpushed commits and stops rather than lose edits. A commit that seems lost is usually in `git reflog`, and `git branch <name> <sha>` brings it back.

## Needs the user's go-ahead

These rewrite shared history or discard work that Git cannot restore, so name the exact command and ask first. They are a force push, `git reset --hard`, `git checkout -- .`, `git checkout -f`, `git switch -f`, `git restore .`, `git clean -fd`, `git stash drop`, `git stash clear`, `git worktree remove --force`, `git branch -D`, deleting a branch you did not create, a rebase or amend of pushed commits, and `--no-verify`. Leave the default branch without force pushes, and run an approved force push elsewhere as `git push --force-with-lease --force-if-includes`.

## Branches and pull requests

Name a branch with a type and a kebab-case description, such as `fix/login-timeout`. Open a pull request as a draft while the work is unfinished, and link the issue with `Closes #<number>`.

## Gotchas

Amending a pushed commit makes the next push a force push, so add a new commit instead. `git pull` stops when the branches have diverged and no reconcile mode is set, so check the repository's convention and pass `--rebase` or `--no-rebase` for that pull.
