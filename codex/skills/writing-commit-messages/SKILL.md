---
name: writing-commit-messages
description: Writes git commit messages and pull request descriptions in the repository's convention, otherwise Conventional Commits. Use when creating or splitting commits or writing a pull or merge request.
---

# Writing commit messages

Create commits only when the user asks.

## Format

Read `git log --oneline -20` and look for commitlint, a CONTRIBUTING file, and a pull request template. When the repository has a convention, follow it exactly, including language, casing, prefixes, and issue references. Otherwise use Conventional Commits.

```
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

Types are `feat` for new behavior and a minor release, `fix` for a bug fix and a patch release, `refactor`, `perf`, `test`, `docs`, `build`, `ci`, `style` for formatting only, `revert`, and `chore` for maintenance that fits nothing else. The scope names the affected area in one word, as in `feat(auth)`. Mark a breaking change with `!` before the colon, with a `BREAKING CHANGE: <what breaks and how to migrate>` footer, or both. Footers use git trailer form, such as `Refs: #123`. Start the description in lowercase, which the commitlint conventional preset expects.

## Message

- The subject is imperative and completes the sentence "If applied, this commit will ...". It has about 50 characters, at most 72, and no trailing period.
- A blank line follows the subject, and the body wraps at 72 characters.
- The body explains what problem existed and why this solution was chosen, because the diff already shows how. It names side effects, limits, and follow-ups. Skip the body only when the subject says everything, as in a typo fix.

## Writing style

Commit messages and pull request texts use plain words and short sentences. They contain no em dash or en dash, no semicolons, no colon that introduces an explanation, and only straight double quotes `"`, never `«»` or `“”`. The repository's own convention takes precedence for the subject format, so the colon after a Conventional Commits type stays.

## Shaping commits

- One commit holds one logical change, and the build and tests pass at every commit so bisect works.
- Refactoring, behavior changes, and unrelated formatting go in separate commits.
- Stage specific files and review the staged diff. Secrets, credentials, local configuration, build output, and large generated files stay out.
- Sign commits when the repository's rules or branch protection require it, as NIST SP 800-204D recommends for source integrity. Turn on signing or change git configuration only when the user asks.
- A CHANGELOG stays written for people and is never a copy of the log. The writing-documentation skill covers it.

## Pull requests

The title follows the subject rules. The description is written for a reviewer who has not seen the work. Use the repository's template when one exists, otherwise this one.

```
## Summary
What the change does and why, in two or three sentences.

## Changes
- Main change

## Testing
How the change was verified.

## Notes
Risks, breaking changes, migrations, follow-ups, screenshots for UI.

Closes #123
```

Keep pull requests small enough to review in one sitting, and split large work into a series.
