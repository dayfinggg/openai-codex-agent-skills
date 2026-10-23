---
name: writing-documentation
description: Writes and updates README, CHANGELOG, guides, and API reference files by Diátaxis and Keep a Changelog. Use when asked for docs or a change affects a kept document. Not for code comments.
---

# Writing documentation

## Scope

This skill writes separate files such as `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, pages under `docs/`, and migration guides. It adds no comments, docstrings, or JSDoc to code, because code in this setup is written without comments. Reasoning that would have gone into a comment belongs in a document, a commit message, or an ADR. Write a document only when the user asks, or when the project keeps it and the change makes it wrong or incomplete. When the API reference is generated from doc comments, tell the user and leave the code unchanged. Commit and pull request text belong to writing-commit-messages, ADRs to recording-architecture-decisions, and version numbers to releasing-software. Project conventions come first.

## Document types

Classify every page with the Diátaxis compass before writing it.

| Content informs | Serves | Type |
|---|---|---|
| Action | Acquisition of skill | Tutorial |
| Action | Application of skill | How-to guide |
| Cognition | Application of skill | Reference |
| Cognition | Acquisition of skill | Explanation |

One page holds one type and links to the others. A README is a landing page with the purpose, installation, a short quickstart, links into `docs/`, help, contributing, and the license.

## Changelog

Use Keep a Changelog 1.1.0 unless the project already uses another format. Each entry states the effect a user notices, never a commit subject or hash, and goes under `## [Unreleased]` in the same change as the behavior.

## Style

Follow the Google developer documentation style guide highlights, and confirm a detail at developers.google.com/style/highlights before relying on it. Address the reader as "you", also in tutorials, in active voice. Put conditions before instructions, as in "To preview the change, run ...". Headings use sentence case. Commands, file names, flags, and values go in code font, UI elements in bold. Link text names the target instead of "click here" or a bare URL. Images get alt text. Use unambiguous dates, American spelling, and serial commas. In a procedure each step holds one action, starts with an imperative verb, names the location first, marks an optional step with "Optional", and ends with the result. Write plain words and short sentences, with no em dash or en dash, no semicolons, and no colon that introduces an explanation. Quotes are straight double quotes `"`, never `«»`, `„“` or `“”`. Older lines of the document are not a model, so every line you add or change follows these rules even where the rest of the file does not.

## Accuracy and maintenance

Run every command and example before writing it down, or check it against the code, the configuration, and `--help` when it cannot run here. Copy names, flags, variables, and defaults from the source, show real output, and describe only current behavior. Tell the user which commands you could not run. Update documentation in the same change as the behavior. When a command, flag, option, or endpoint is renamed or removed, update every mention in the repository. Relative links point to files that exist.

## Reference files

- [reference/diataxis.md](reference/diataxis.md) has what each type contains and avoids, the type of common files, and how to split a mixed page. Read it before writing a new page.
- [reference/changelog-and-readme.md](reference/changelog-and-readme.md) has the changelog rules and template, commit-to-entry mapping, release steps, and the README outline. Read it when either file changes.
- [examples.md](examples.md) has before and after pairs for a README that mixes types and a git log dump turned into a changelog. Read it before rewriting either file.
