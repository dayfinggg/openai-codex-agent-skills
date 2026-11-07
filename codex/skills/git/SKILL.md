---
name: git
description: Structures git workflow practices and pull request bodies. Use it when committing, branching, pushing, or resolving conflicts. Use it when splitting uncommitted work into clean atomic commits, or when organizing parallel streams of work. Use it when opening or writing a pull request (PR). Use it when cutting a release, choosing a semantic version bump, tagging, or writing a changelog. Use it for a commit message, a PR description, or a changelog entry. This holds even when the diff is pasted inline and the message looks easy to write.
---

<overview>
Git is your safety net. Treat commits as save points, branches as sandboxes, and history as documentation. AI agents generate code at high speed, so disciplined version control keeps changes manageable. It also keeps them reviewable and reversible.
</overview>

<core_principles>
<trunk_based_development>
Trunk-based development is the recommended default. Keep `main` always deployable. Work in short-lived feature branches that merge back within 1-3 days. Long-lived development branches are hidden costs, because they diverge, create merge conflicts, and delay integration. DORA research consistently shows that trunk-based development correlates with high-performing engineering teams.

This diagram shows `main` staying deployable while short-lived feature branches leave it and merge back within 1-3 days.

```
main ──●──●──●──●──●──●──●──●──●──
        ╲      ╱  ╲    ╱
         ●──●─╱    ●──╱
```

Teams that use gitflow or long-lived branches can adapt these principles to their branching model. The commit discipline (atomic commits, small changes, descriptive messages) matters more than the branching strategy.

- Dev branches are costs. Every day a branch lives, it accumulates merge risk.
- Release branches are acceptable when you need to stabilize a release while `main` moves forward.
- Small slices beat long branches. The coding instructions (`code_rules`) rule out feature flags, so keep branches short by merging small finished slices.
</trunk_based_development>

<commit_often>
Commit early and commit often. Commit and push only when the user asks, as Claude Code's instructions require. Once the user wants commits, each successful increment gets its own commit. Do not accumulate large uncommitted changes.

Work in a loop. Implement a slice, test it, verify it, commit it, and move to the next slice. Never implement everything at once, hope it works, and make one giant commit. Commits are save points. If the next change breaks something, you can revert to the last known-good state at once.
</commit_often>

<atomic_commits>
Each commit does one logical thing. In this good history, each commit is self-contained.

```
git log --oneline
a1b2c3d Add task creation endpoint with validation
d4e5f6g Add task creation form component
h7i8j9k Connect form to API and add loading state
m1n2o3p Add task creation tests (unit + integration)
```

This bad history mixes everything into one commit.

```
git log --oneline
x1y2z3a Add task feature, fix sidebar, update deps, refactor utils
```
</atomic_commits>

<descriptive_messages>
Commit messages explain why, not just what. This good message explains the intent.

```
feat: add email validation to registration endpoint

Prevents invalid email formats from reaching the database.
Uses Zod schema validation at the route handler level,
consistent with existing validation patterns in auth.ts.
```

This bad message describes what is obvious from the diff.

```
update auth.ts
```

Follow the convention the project's `git log` already shows. Without one, use [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/). A message there has a type, an optional scope, a description, an optional body, and optional footers.

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

The type sets the SemVer bump. A `fix` is a patch, and a `feat` is a minor. A `!` before the colon, as in `feat(api)!: drop v1 routes`, or a `BREAKING CHANGE:` footer makes a major. The spec itself defines only `feat` and `fix`. Six common types from the Angular convention cover most commits.

- `feat` for a new feature
- `fix` for a bug fix
- `refactor` for a code change that neither fixes a bug nor adds a feature
- `test` for adding or updating tests
- `docs` for documentation only
- `chore` for tooling, dependencies, and config
</descriptive_messages>

<separate_concerns>
Keep concerns separate. Do not combine formatting changes with behavior changes, or refactors with features. Each type of change goes in a separate commit, and ideally in a separate PR. These good commits keep the concerns apart.

```
git commit -m "refactor: extract validation logic to shared utility"
git commit -m "feat: add phone number validation to registration"
```

This bad commit mixes them.

```
git commit -m "refactor validation and add phone number field"
```

Separate refactoring from feature work. A refactoring change and a feature change are two different changes, so submit them separately. Each change is then easier to review, revert, and understand in history. A small cleanup, such as renaming a variable, can join a feature commit at the reviewer's discretion.
</separate_concerns>

<change_size>
Target about 100 lines per commit or PR. Split changes over about 1000 lines into vertical slices, as the `planning` skill describes.

| Size | Effect |
|---|---|
| About 100 lines | Easy to review and easy to revert |
| About 300 lines | Acceptable for a single logical change |
| About 1000 lines | Split into smaller changes |
</change_size>
</core_principles>

<branching_strategy>
Each feature or fix gets its own branch from `main`. This tree shows two feature branches in parallel and one bug-fix branch.

```
main
  │
  ├── feature/task-creation
  ├── feature/user-settings
  └── fix/duplicate-tasks
```

- Branch from `main` or from the team's default branch.
- Keep branches short-lived and merge within 1-3 days, because long-lived branches are hidden costs.
- Delete branches after merge.

A branch name is its type prefix and a short description, such as `feature/<short-description>`. The four prefixes are `feature/`, `fix/`, `chore/`, and `refactor/`, as these names show.

```
feature/task-creation
fix/duplicate-tasks
chore/update-deps
refactor/auth-module
```
</branching_strategy>

<worktrees>
Git worktrees let parallel agents run several branches at the same time. Each worktree is a separate directory with its own branch, so agents do not interfere. These commands create two new branches from `main`, each in a worktree next to the main checkout. Without `-b`, the branch must already exist.

```bash
git worktree add -b feature/task-creation ../project-feature-a main
git worktree add -b feature/user-settings ../project-feature-b main
```

The parent directory then holds `project/` on the main branch and one directory per feature branch. When the work is done, merge it and remove the worktree.

```bash
git worktree remove ../project-feature-a
```

Worktrees bring four benefits.

- Several agents can work on different features at the same time.
- No branch switching is needed, because each directory has its own branch.
- If an experiment fails, you delete its worktree and lose nothing.
- Changes stay isolated until someone merges them explicitly.
</worktrees>

<save_points>
Each passing change becomes a save point. In this flow, the agent commits after each passing test and investigates each failing one.

```
Agent starts work
    │
    ├── Makes a change
    │   ├── Test passes? → Commit → Continue
    │   └── Test fails? → Investigate → Fix, or restore the last commit
    │
    ├── Makes another change
    │   ├── Test passes? → Commit → Continue
    │   └── Test fails? → Investigate → Fix, or restore the last commit
    │
    └── Feature complete → All commits form a clean history
```

Before restoring a path, inspect both staged and unstaged changes. Restore it only when all changes belong to this task and the user authorized discarding them. Preserve user edits and other tasks' changes. This command discards both staged and unstaged changes in the named path.

```bash
git restore --source=HEAD --staged --worktree <path>
```

A command that discards other work, such as `git reset --hard`, needs the user's confirmation first.
</save_points>

<change_summaries>
Report what changed in the format the output style sets.
</change_summaries>

<pre_commit_hygiene>
Before every commit, review what you are about to commit.

```bash
git diff --staged
```

Then make sure the diff has no secrets. This command lists only the names of matching files, and any output means you review them.

```bash
git diff --staged -i -G'password|secret|api_key|token' --name-only
```

Then run the project's checks as the `verification` block of the coding instructions requires.
</pre_commit_hygiene>

<generated_files>
Three rules cover generated and local files.

- Commit generated files only if the project expects them, such as `package-lock.json` or Prisma migrations.
- Do not commit build output (`dist/`, `.next/`), environment files (`.env`), or IDE config. Shared IDE config such as `.vscode/settings.json` is the exception.
- Keep a `.gitignore` that covers `node_modules/`, `dist/`, `.env`, `.env.local`, and `*.pem`.
</generated_files>

<git_debugging>
`git bisect` finds the commit that introduced a bug. Git checks out midpoints, and a test at each one narrows the range. With `git bisect run`, git runs the test itself, and exit code 0 marks a commit good. `git bisect reset` returns to the original branch afterward.

```bash
git bisect start
git bisect bad HEAD
git bisect good <known-good-commit>
git bisect run npm test
git bisect reset
```

These commands show what changed recently.

```bash
git log --oneline -20
git diff HEAD~5..HEAD -- src/
```

`git blame` shows who last changed each line of a file.

```bash
git blame src/services/task.ts
```

`git log --grep` searches commit messages for a keyword.

```bash
git log --grep="validation" --oneline
```
</git_debugging>

<release_and_versioning>
Commits are how you track change, and a version is how your consumers track it. Something may depend on your code, such as another team, a published package, or a deployed client. Then "latest on main" no longer answers "what am I running, and is it safe to upgrade?" A version number and a changelog are the contract that answers it.

<semantic_versioning>
Version anything with consumers as `MAJOR.MINOR.PATCH` under [SemVer 2.0.0](https://semver.org/), and let the number carry meaning. Major version zero is initial development, where anything may change. Marking public API as deprecated takes a minor bump.

| Part | Change | Upgrade |
|---|---|---|
| MAJOR | Breaking change | Consumers must change their code to upgrade |
| MINOR | New functionality, backward-compatible | Safe to upgrade |
| PATCH | Bug fix, backward-compatible | Safe to upgrade |

The number is a promise, so make the code match it. A patch that changes behavior consumers relied on is a disguised major change (Hyrum's Law). When you are unsure whether a change is breaking, assume it is. A surprise major is far cheaper than a broken consumer.
</semantic_versioning>

<release_tags>
Tag each release, and let the tag be the source of truth. A release is an immutable point in history, not a moving branch. The `v` prefix is a tag convention, and the version itself is `1.4.0`. These commands tag a release so it can always be reproduced.

```bash
git tag -a v1.4.0 -m "Release 1.4.0"
git push origin v1.4.0
```

Derive the version from the tag instead of hand-editing it in scattered files. Then the artifact, the tag, and the changelog can never disagree.
</release_tags>

<changelog>
Keep a changelog written for humans. A changelog is not `git log`. It is the curated answer for consumers to "what changed and do I care?" [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) groups entries as Added, Changed, Deprecated, Removed, Fixed, and Security. The newest version comes first, with ISO 8601 dates. Phrase every entry around user impact, not internal mechanics. This changelog collects upcoming entries under Unreleased above the last release.

```markdown
## [Unreleased]
### Changed
- Task list loads 50 items per page instead of 20

## [1.4.0] - 2025-06-12
### Added
- Bulk task import via CSV
### Fixed
- Timezone drift in recurring task due dates
### Deprecated
- `GET /v1/tasks/all`, replaced by the paginated `GET /v1/tasks` (removal in 2.0)
```

Write the entry under Unreleased in the same change that makes the change, while the impact is fresh. At release time, those entries move into the new version section. Breaking changes get a migration note and a deprecation window.
</changelog>
</release_and_versioning>

<pull_requests>
For a pull request body, follow [pull-requests.md](references/pull-requests.md).
</pull_requests>

<red_flags>
These signs show that the git workflow has gone wrong.

- Large uncommitted changes accumulate.
- Commit messages say "fix", "update", or "misc".
- Formatting changes are mixed with behavior changes.
- The project has no `.gitignore`.
- Someone commits `node_modules/`, `.env`, or build artifacts.
- Long-lived branches diverge significantly from `main`.
- Someone force-pushes to shared branches.
- A breaking change ships under a minor or patch version bump.
- A release has no tag, or its version number is hand-edited out of sync with the tag.
- A user-facing release has no changelog entry, or the changelog is just dumped commit messages.
</red_flags>

<verification>
Every commit passes six checks.

- [ ] The commit does one logical thing.
- [ ] The message explains why and follows the project's commit convention.
- [ ] Tests pass before the commit.
- [ ] The diff has no secrets.
- [ ] Formatting-only changes are not mixed with behavior changes.
- [ ] No build output, dependency folder, or `.env` file is staged.

Every release of anything with consumers passes three checks.

- [ ] The version bump matches the change. Breaking means major, additive means minor, and a fix means patch.
- [ ] The release is tagged, and the version comes from the tag instead of a hand edit.
- [ ] The changelog has a curated, human-readable entry for this version, grouped by impact.
</verification>

<attribution>
Read [credits](references/credits.md) when checking source attribution or redistribution terms.
</attribution>
