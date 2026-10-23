# Changelog and README

## Changelog rules

These follow Keep a Changelog 1.1.0 at keepachangelog.com/en/1.1.0.

- Entries are written for humans. Each states in a sentence the effect a user or integrator notices, and commit history is only a list of candidates.
- The newest version comes first, with its release date in ISO 8601 form `YYYY-MM-DD`.
- `## [Unreleased]` stays at the top, gets entries in the same change as the behavior, and its entries move under the version heading at release.
- Groups are Added, Changed, Deprecated, Removed, Fixed, and Security. Empty groups are left out.
- Every deprecation, removal, and breaking change is listed with what to use instead, because a changelog that mentions only some changes can be as dangerous as none.
- Every version has an entry and a link, and the header says whether the project follows Semantic Versioning.
- A pulled release stays in the file, marked `[YANKED]`.

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

- Link definitions point each version to a comparison with the previous tag, and `Unreleased` to the latest tag compared with `HEAD`, in the URL form of the project's hosting service.
- The file is `CHANGELOG.md`. An existing name such as `HISTORY`, `NEWS`, or `RELEASES` stays.
- Start each entry with the affected feature, command, endpoint, or setting, with identifiers in code font. For a breaking change, link the migration guide when one exists.
- Leave out changes nobody outside the team notices, such as refactoring, tests, and CI.

## From commits to entries

When the project uses Conventional Commits, read the history since the last tag as a list of candidates and rewrite each relevant commit by hand. Merge several commits about one feature into one entry. This mapping is a starting point, not part of either convention.

| Commit type | Usual changelog type |
|---|---|
| `feat` | Added, or Changed when it alters existing behavior |
| `fix` | Fixed, or Security when it closes a vulnerability |
| `!` or a `BREAKING CHANGE` footer | Changed or Removed, always with migration steps |
| `perf` | Changed, when users notice the difference |
| `refactor`, `test`, `ci`, `build`, `style`, `chore`, `docs` | Usually no entry |

## Releasing

1. The releasing-software skill chooses the version number.
2. Move the entries under `Unreleased` to a heading such as `## [1.5.0] - 2026-10-20`, and leave an empty `## [Unreleased]` above it.
3. Update the link definitions for the new version and for `Unreleased`.

A yanked release keeps its heading with the tag, as in `## [0.0.5] - 2014-12-13 [YANKED]`. Add missing releases and missing breaking change notes when you find them.

## README outline

No official README standard exists, so this outline is recommended practice. It follows what GitHub's documentation says a README typically covers. GitHub shows a README from `.github/`, the repository root, or `docs/`, in that order of priority.

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

- Add a section such as supported versions or a security policy link only when the project needs it, and skip sections that would be empty.
- The quickstart ends in visible output. Option tables and API details go to reference pages.
- Use relative links for repository files, which GitHub recommends because they keep working in clones and on other branches.
- Keep only badges the project maintains and that tell the reader something current.
- Run the install and quickstart commands in a clean environment before writing them.
