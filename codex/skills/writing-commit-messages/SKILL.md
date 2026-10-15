---
name: writing-commit-messages
description: Writes git commit messages and pull request descriptions in the repository's convention, otherwise Conventional Commits. Use when creating a commit, splitting changes into commits, or writing a pull or merge request title and description.
---

# Writing commit messages

Commit history is documentation for future maintainers. A good message tells them what changed and why, so they can trust, revert, or bisect the change without reconstructing the reasoning from code. Create commits only when the user asks for them.

## Choose the format

1. Read recent history with `git log --oneline -20` and check for commitlint, a CONTRIBUTING file, or a pull request template.
2. If the repository has a convention, follow it exactly, including language, casing, prefixes, and issue references.
3. Otherwise use Conventional Commits.

## Conventional Commits

```
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

| Type | Use for |
|---|---|
| feat | New behavior for users, a minor release |
| fix | Bug fix, a patch release |
| refactor | Structure change without behavior change |
| perf | Performance improvement |
| test | Adding or fixing tests only |
| docs | Documentation only |
| build | Build system or dependencies |
| ci | CI configuration |
| style | Formatting with no code change |
| revert | Reverting an earlier commit |
| chore | Maintenance that fits nothing above |

- The scope names the affected area in a word, as in `feat(auth):`.
- Mark a breaking change with `!` before the colon, or with a `BREAKING CHANGE: <what breaks and how to migrate>` footer, or both.
- Footers use git trailer form, such as `Refs: #123` or `Reviewed-by: Name`.
- Start the description in lowercase, which is what the common commitlint conventional preset expects.

## Writing the message

- Write the subject in the imperative mood. It completes the sentence "If applied, this commit will ...", as in `fix(cart): keep total at zero for discounts over 100%`.
- Keep the subject to about 50 characters and never over 72, with no trailing period.
- Leave a blank line after the subject.
- Wrap the body at 72 characters.
- In the body explain what problem existed and why this solution was chosen. The diff already shows how.
- Mention side effects, limitations, and follow-ups when they exist.
- Skip the body only when the subject says everything, as in a typo fix.

## Shaping commits

- One commit holds one logical change, and the build and tests pass at every commit so bisecting works.
- Keep refactoring and behavior changes in separate commits.
- Stage specific files instead of everything, and review the staged diff before committing.
- Never commit secrets, credentials, local configuration, build output, or large generated files.
- Do not mix unrelated formatting changes into a functional commit.
- Sign commits when the repository's rules or branch protection require signed commits, as NIST SP 800-204D recommends for source integrity. Never turn signing on or change git configuration on your own initiative.
- When the project keeps a CHANGELOG, commit types help sort entries into its sections, but the changelog stays written for people, never a dump of the git log. The writing-documentation skill covers it.

## Pull request descriptions

The title follows the same rules as a commit subject. The description is written for a reviewer who has not seen the work.

```
## Summary
What the change does and why, in two or three sentences.

## Changes
- Main change
- Notable secondary change

## Testing
How the change was verified, such as tests added and manual steps.

## Notes
Risks, breaking changes, migrations, follow-ups, screenshots for UI.

Closes #123
```

Use the repository's pull request template when one exists. Keep pull requests small enough to review in one sitting, and split large work into a series.

## Checklist

- [ ] The format matches the repository's convention
- [ ] The subject is imperative, specific, and within the length limits
- [ ] The body explains why, not how
- [ ] Breaking changes are marked and explained
- [ ] The commit holds one logical change and the tests pass
- [ ] No secrets or unrelated files are staged

## Examples

```
feat(api): add cursor pagination to order list

Offset pagination returned duplicates when orders were created
while a client paged through results. Cursors are based on
createdAt and id, so pages stay stable under concurrent writes.

Refs: #482
```

```
refactor(billing): extract tax calculation into TaxPolicy

No behavior change. Prepares for per-country tax rules.
```

```
feat(auth)!: require email verification before login

BREAKING CHANGE: unverified accounts now receive 403 on login.
Clients must handle the new email_not_verified error type.
```
