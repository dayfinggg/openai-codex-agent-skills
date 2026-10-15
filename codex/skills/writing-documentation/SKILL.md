---
name: writing-documentation
description: Writes and updates documentation files such as README, CHANGELOG, guides, and API reference pages with Diátaxis and Keep a Changelog. Use when the user asks for documentation or a change affects a document the project keeps. Not for code comments.
---

# Writing documentation

Documentation lets a reader learn, do, look up, or understand something without asking the author. This skill writes and updates separate documentation files kept in version control. The writing-commit-messages skill owns commit and pull request text, the recording-architecture-decisions skill owns architecture decision records and C4 or arc42 notes, and the releasing-software skill owns version numbers and publishing. When the project has its own documentation conventions, templates, or style guide, follow them over this skill.

## Scope

- **Documentation files only.** This skill works on separate files such as `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, files under `docs/`, tutorials, how-to guides, API reference pages kept as separate files, and migration or upgrade guides. It never adds comments, docstrings, JSDoc, or any other doc comments to code, because code in this setup is written without comments. Reasoning that would once have gone into a comment belongs in a documentation file, a commit message, or an architecture decision record.
- **Requested or already kept.** Write or change a document when the user asks for documentation, or when the project already keeps that document and the change makes it wrong or incomplete. Do not create new documentation files on your own initiative.
- **Reference built from code.** When the project generates its API reference from doc comments, tell the user and leave the code unchanged.

## Choose the document type

Diátaxis sorts documentation by two questions. Does the content inform action or cognition? Does it serve the acquisition of skill, meaning study, or its application, meaning work?

| Content informs | Serves | Type |
|---|---|---|
| Action | Acquisition | Tutorial |
| Action | Application | How-to guide |
| Cognition | Application | Reference |
| Cognition | Acquisition | Explanation |

- Classify every page before writing it, and ask the two questions again for any paragraph that feels out of place.
- One page holds one type. When a page needs content of another type, link to a separate page instead of mixing, because blurred types make every page worse at its own job.
- A README is a landing page that links to pages of each type. CONTRIBUTING and migration guides are how-to guides. API reference pages are reference.
- Confirm the compass wording on diataxis.fr when in doubt, and read [references/diataxis.md](references/diataxis.md) for what each type contains and avoids.

## Changelog

- Keep `CHANGELOG.md` in the Keep a Changelog 1.1.0 format, unless the project already uses another format.
- Write entries for humans. Each entry states the effect a user notices, in a sentence, and never copies commit subjects or hashes. Commit history is only a list of candidates, and the writing-commit-messages skill owns the commits themselves.
- Put the newest version first, with its release date in ISO 8601 form (`YYYY-MM-DD`).
- Keep an `## [Unreleased]` section at the top, add entries there in the same change as the behavior, and move them under the new version heading at release.
- Group entries under Added, Changed, Deprecated, Removed, Fixed, and Security, and leave out empty groups.
- Always list deprecations, removals, and breaking changes, each with what to use instead.
- Give every version an entry and a link, and say in the header whether the project follows Semantic Versioning.
- Keep a pulled release in the file and mark it `[YANKED]`.

## README

No official README standard exists, so the outline in [references/changelog-and-readme.md](references/changelog-and-readme.md) is recommended practice, not a norm. Keep the README a landing page with the purpose, installation, a short quickstart, links into `docs/`, where to get help, how to contribute, and the license. Move long tutorials, option tables, and design discussion into their own pages.

## Style

Follow the highlights of the Google developer documentation style guide, and confirm the current list at developers.google.com/style/highlights before relying on a detail.

- Address the reader as "you", including in tutorials, and use active voice so it is clear who acts.
- Be conversational and friendly without being frivolous. Do not pre-announce features.
- Put conditions before instructions, as in "To preview the change, run ...".
- Use sentence case for titles and headings.
- Use numbered lists for sequences, bulleted lists for most other lists, and tables or description lists for pairs.
- Put code-related text such as commands, file names, flags, and values in code font, and UI elements in bold.
- Write link text that makes sense on its own, such as the target page title. Never use "click here", "this document", or a bare URL.
- Give every image alt text. Use unambiguous dates, standard American spelling, and serial commas, and write for a global audience.
- In procedures, use one action per step, start each step with an imperative verb, state the location before the action, mark optional steps with "Optional", and state the result after the action.

## Accuracy

- **Docs match the code.** Run every command and example before writing it, or check it against the code, the configuration, and the tool's `--help` output when it cannot run here. Copy names, flags, environment variables, and defaults from the source.
- **Real output.** Show output from an actual run, shortened where needed, never invented.
- **Current behavior only.** Describe what the code does now. Planned features stay out of the docs.
- **Say what was not run.** When a command could not be run, such as a production deploy, report that to the user.

## Location and maintenance

- Keep documentation next to the code in version control, in the format and folders the project already uses.
- Update documentation in the same change as the behavior it describes, including the `Unreleased` section, the README quickstart, reference pages, and migration guides.
- When a command, flag, option, or endpoint is renamed or removed, search the repository for every mention and update each one.
- Use relative links between files in the repository and check that every target exists.

## Workflow

1. Confirm that the task is a documentation file and that the user asked for it or the project already keeps it.
2. Read the existing docs, `CONTRIBUTING.md`, any style guide, and the docs site configuration to learn the conventions.
3. Classify the page with the compass and decide its file name and location.
4. Gather facts from the code and run the commands and examples you plan to show.
5. Write the page following its type and the style rules.
6. Check every link, run the examples again after editing, and read the rendered page where possible.
7. Review against the checklist.

## Checklist

- [ ] No comments, docstrings, or JSDoc were added to code
- [ ] The document was requested, or the project already keeps it
- [ ] Each page holds one Diátaxis type and links to the others
- [ ] Every command and example was run or checked against the code
- [ ] Changelog entries are human-written, grouped by the six types, newest first, with ISO 8601 dates and an `Unreleased` section
- [ ] Headings use sentence case and the text uses "you" and active voice
- [ ] Link text is descriptive, relative links resolve, and images have alt text
- [ ] Documentation changed in the same change as the behavior it describes

## Reference files

Read them before the first change, the Diátaxis file for any new page, the changelog and README file when either document is touched, and the examples file for every documentation task.

- [references/diataxis.md](references/diataxis.md) has the four document types, the compass, and what each type contains and avoids.
- [references/changelog-and-readme.md](references/changelog-and-readme.md) has the Keep a Changelog 1.1.0 rules with a template and the recommended README outline.
- [examples.md](examples.md) has before and after pairs for splitting a mixed README, rewriting a git log dump as a changelog, rewriting a vague how-to guide, and writing a migration guide.
