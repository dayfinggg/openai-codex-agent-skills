# Changelog and README

The changelog rules follow Keep a Changelog 1.1.0 at keepachangelog.com/en/1.1.0, which is a published convention. The README outline is recommended practice, because no official README standard exists.

## Contents

- Keep a Changelog principles
- Changelog template
- Writing entries
- From commits to entries
- Releasing and yanking
- README outline
- README rules

## Keep a Changelog principles

- Changelogs are for humans, not machines.
- Every version has an entry.
- Changes of the same type are grouped.
- Versions and sections are linkable.
- The latest version comes first.
- Each version shows its release date.
- The file says whether the project follows Semantic Versioning.
- The file is called `CHANGELOG.md`. Some projects use `HISTORY`, `NEWS`, or `RELEASES`, and an existing name stays.

The six types of change are these.

| Type | Use for |
|---|---|
| Added | New features |
| Changed | Changes in existing functionality |
| Deprecated | Features that will be removed soon |
| Removed | Features removed in this version |
| Fixed | Bug fixes |
| Security | Fixed vulnerabilities |

## Changelog template

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Export of invoices as CSV from the invoice list.

## [1.4.0] - 2026-10-02

### Changed

- Search results are sorted by relevance instead of by date.

### Fixed

- Login no longer fails for email addresses that contain a plus sign.

[unreleased]: https://github.com/example-org/example-app/compare/v1.4.0...HEAD
[1.4.0]: https://github.com/example-org/example-app/compare/v1.3.0...v1.4.0
```

- Version headings use the form `## [1.4.0] - 2026-10-02`, with the date in ISO 8601 order of year, month, and day.
- Link definitions at the bottom point each version to a comparison with the previous tag, and `Unreleased` to a comparison of the latest tag with `HEAD`. Use the comparison URL form of the project's hosting service.
- Leave out type headings that have no entries.

## Writing entries

- Describe the effect on a user or integrator, not the implementation. "Search results are sorted by relevance" helps, "Refactor SearchService" does not.
- Start with the affected feature, command, endpoint, or setting, and put identifiers in code font.
- For a breaking change, state what breaks and what to do instead, and link the migration guide when one exists.
- List every deprecation and removal. A changelog that mentions only some changes can be as dangerous as none at all.
- Leave out changes nobody outside the team notices, such as refactoring, test changes, and CI changes.
- Add the entry under `Unreleased` in the same change as the behavior, so the release needs no reconstruction from memory.

## From commits to entries

Commit log diffs are full of noise, so never paste `git log` output into the changelog. When the project uses Conventional Commits, read the history since the last tag as a list of candidates and rewrite each relevant one by hand. This mapping is a starting point, not part of either convention.

| Commit type | Usual changelog type |
|---|---|
| `feat` | Added, or Changed when it alters existing behavior |
| `fix` | Fixed, or Security when it closes a vulnerability |
| `!` or a `BREAKING CHANGE` footer | Changed or Removed, always with migration steps |
| `perf` | Changed, when users notice the difference |
| `refactor`, `test`, `ci`, `build`, `style`, `chore`, `docs` | Usually no entry |

Merge several commits about one feature into one entry. The writing-commit-messages skill owns the commit messages themselves.

## Releasing and yanking

1. Choose the new version number. The releasing-software skill owns that decision.
2. Move the entries under `Unreleased` to a new heading with the version and the release date, and leave an empty `## [Unreleased]` above it.
3. Update the link definitions at the bottom for the new version and for `Unreleased`.

A release pulled because of a serious bug or security issue stays in the file with the `[YANKED]` tag, as in `## [0.0.5] - 2014-12-13 [YANKED]`, so readers notice it.

Improving an existing changelog is welcome. Add missing releases and missing notes on breaking changes when you find them.

## README outline

GitHub's documentation lists what a README typically covers, namely what the project does, why it is useful, how to get started, where to get help, and who maintains and contributes to it. GitHub shows a README from `.github/`, the repository root, or `docs/`, in that order of priority. The outline below turns this into a default order.

```markdown
# Project name

One or two sentences on what the project does and who it is for.

## Install

The shortest supported install command and the requirements it needs.

## Quickstart

The smallest working example, with its real output.

## Documentation

Links to tutorials, how-to guides, reference, and explanation pages.

## Get help

Where to ask questions and report bugs.

## Contributing

A link to CONTRIBUTING.md.

## License

The license name with a link to the LICENSE file.
```

Add a section only when the project needs it, such as supported versions or a security policy link. Skip sections that would be empty.

## README rules

- The README is a landing page. It holds only what a reader needs to get started and to find the rest, and longer material moves to its own page under `docs/`.
- The quickstart is a short tutorial path that ends in visible output. Option tables and API details go to reference pages.
- Use relative links for files in the repository, which GitHub recommends because they keep working in clones and on other branches.
- Badges are optional. Keep only those the project maintains and that tell the reader something current.
- Run the install and quickstart commands in a clean environment before writing them.
