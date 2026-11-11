---
name: git
description: Structures git workflow and pull request bodies. Use it when committing, branching, pushing, resolving conflicts, splitting uncommitted work into atomic commits, opening a pull request (PR), or cutting a release with a version bump, a tag, or a changelog. Use it for a commit message, a PR description, or a changelog entry, even when the diff is pasted inline and the message looks easy to write.
---

<overview>
The project's own convention wins over every default in this skill. Read it first from `git log`, the existing branch and tag names, and the project's contribution notes. Commit and push only when the user asks, as the base instructions require.
</overview>

<pull_requests>
Before you write a pull request body, read [pull-requests.md](references/pull-requests.md) whole and follow it. This file does not repeat its rules.
</pull_requests>

<commits>
Each commit holds one logical change that can be reviewed and reverted alone. A formatting change, a refactor, a behavior change, and an unrelated fix each get their own commit. Once the user wants commits during a longer task, commit each increment when its check passes, so a later mistake costs one step and not the whole task.

Write the message the way `git log` shows, including its language, prefixes, and suffixes. Without a convention, use [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/), where a message is `<type>[optional scope]: <description>` with an optional body and footers. The spec defines `feat` for a minor bump and `fix` for a patch, and a `!` before the colon or a `BREAKING CHANGE:` footer marks a major. Other common types are `refactor`, `test`, `docs`, and `chore`. The subject names the change and the body gives the reason, because the diff already shows what the code does.

Run these checks before each commit.
1. Stage the files of this change by path, and read `git diff --staged`. Work of the user or of another task stays out of the commit. An agent has no interactive prompt, so split the changes inside one file by staging a patch with `git apply --cached`, not with `git add -p`.
2. Search the staged diff for secrets. `git diff --staged -i -G'password|secret|api_key|token' --name-only` lists the files to read again.
3. Leave out build output, dependency folders, environment files, and keys. Commit a generated file only where the project tracks its kind, such as a lockfile or a migration.
4. Run the project's checks as the `verification` block of the coding instructions requires. A failing hook is a finding, so fix its cause, and skip a hook with `--no-verify` only when the user asks for that.
</commits>

<branches>
Follow the branching model the history shows. When it shows commits made directly on the default branch, commit there. Otherwise branch from the default branch, name the branch by its kind and subject, as in `fix/duplicate-tasks`, keep it short-lived, and delete it after the merge.
</branches>

<discarding_work>
Some commands discard work that no commit holds, or rewrite history that others already pulled. They include `git reset --hard`, `git checkout -- <path>`, `git restore`, `git clean`, `git stash drop`, `git branch -D`, `git push --force`, and `git rebase` or `git commit --amend` on pushed commits. Before you run one, inspect the staged and unstaged changes and the commits it would drop. Run it only when everything it discards belongs to this task, or after the user confirms. Never force-push a branch that other people use, and on your own branch use `git push --force-with-lease`.

`git restore --source=HEAD --staged --worktree <path>` discards the staged and unstaged changes of one path, which is the narrow way back to the last commit after a failed step.
</discarding_work>

<conflicts>
Resolve a conflict by intent, not by side. Read both versions and the commits that produced them, with `git log --merge -p -- <path>` during a merge, and write the result that keeps what each side meant. Taking one side wholesale, as `git checkout --ours` or `-X theirs` does, drops the other side's work, so do it only when that work is superseded, and say so in the report. During a rebase the sides swap, so `--ours` is the branch you rebase onto. Afterward search for leftover conflict markers and run the project's checks, because a merge without conflicts can still break the build.
</conflicts>

<releases>
A release follows the project's convention too. Read from the history where the version number lives, how the tags are named, and how the changelog is kept, and do the same. Change every file that carries the version in one commit, so the manifest, the tag, and the changelog agree.

Without a convention, these defaults apply to anything that has consumers.
- The version is `MAJOR.MINOR.PATCH` under [SemVer 2.0.0](https://semver.org/). A breaking change raises the major, a backward-compatible feature or a deprecation raises the minor, and a backward-compatible fix raises the patch. Major version zero is initial development, where anything may change. When you cannot tell whether a change breaks consumers, treat it as breaking.
- Each release gets an annotated tag, as in `git tag -a v1.4.0 -m "Release 1.4.0"`, pushed with `git push origin v1.4.0`. The `v` prefix belongs to the tag, and the version itself is `1.4.0`.
- The changelog follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/). The newest version comes first with an ISO 8601 date, and entries are grouped as Added, Changed, Deprecated, Removed, Fixed, and Security. Write each entry for the consumer, about the effect and not the internal mechanics, under `Unreleased` in the same change that causes it. A breaking change gets a migration note.

This changelog collects upcoming entries under `Unreleased` above the last release.

```markdown
## [Unreleased]
### Changed
- Task list loads 50 items per page instead of 20

## [1.4.0] - 2026-06-12
### Added
- Bulk task import via CSV
### Deprecated
- `GET /v1/tasks/all`, replaced by the paginated `GET /v1/tasks` (removal in 2.0)
```
</releases>
