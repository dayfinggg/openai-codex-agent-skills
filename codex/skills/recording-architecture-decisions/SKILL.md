---
name: recording-architecture-decisions
description: Writes ADRs in the repository's format or MADR, and C4 diagrams as text. Use when asked for an ADR or diagram, or when a change adds a framework, data store, integration style, or module boundary.
---

# Recording architecture decisions

Code in this setup carries no comments, so the ADR is where the reasons go. A repository's own ADR format and conventions win over this skill.

## When to write one

Write an ADR for a decision that is costly to reverse or shapes several modules, such as a core framework or dependency, a data store, an integration style, a cross-cutting concern like authentication or caching, a module or service boundary, or a deliberate quality trade-off. When unsure, it counts if undoing it would touch many files, need a data migration, or change what other teams depend on. Skip choices cheap to change inside one module, bug fixes, same-major updates, and anything an accepted ADR already decides.

In a repository that keeps ADRs, write the record in the same change as the decision. Otherwise propose one in a sentence and write it when the user agrees.

## Format and file

- Look for an existing folder such as `docs/decisions`, `docs/adr`, `doc/adr`, or `docs/architecture/decisions`, and copy its template, file names, number width, status format, and index, following the newest records when they differ. Without one, use MADR 4.0.0 in `docs/decisions/`.
- Name the file `NNNN-title-with-dashes.md` in lowercase, with the next number after the highest in the folder and its subfolders. Numbers are never reused, and on a merge clash the record not yet merged is renumbered.
- The heading holds only the title, naming problem and solution, as in `Use a PostgreSQL table for background jobs`.

## Content

- Start from context ending in the question decided, considered options, and decision outcome. Add drivers when forces compete, consequences almost always, and confirmation when a test, architecture rule, or review can check compliance.
- List only options that were really viable, including the current state.
- Name drivers with the ISO/IEC 25010:2023 characteristics, which are functional suitability, performance efficiency, compatibility, interaction capability, reliability, security, maintainability, flexibility, and safety, and make them measurable.
- Consequences include the costs, such as new operational work.
- Fill `decision-makers`, `consulted`, and `informed` only with people the user or repository names. Mark estimates as estimates, and keep a record to about one screen.

## Status

- A record stays `proposed` until the user approves the decision, for example by approving the plan that contains it.
- An accepted ADR changes only for typos and broken links. When code drifts from it, tell the user and propose fixing the code or superseding the ADR.
- To supersede, write a new ADR whose context says what changed and which links back under More Information. In the old record change only the status to `superseded by ADR-NNNN`, the date, and a link forward under More Information, and update the index in the same change.
- `deprecated` marks a decision that stopped applying with no successor, with the reason. `rejected` records stay, so the option is not proposed again without new facts.

Tell the user the file path and status, and ask for acceptance when the record is proposed.

## Diagrams

Draw a C4 system context and container diagram by default, a component diagram only when it adds value, and a deployment diagram per environment for clustering or failover. Use the repository's diagram tool, otherwise Mermaid C4 inside the Markdown file. Draw what the code and deployment files show, and mark planned parts as planned. A diagram for one decision goes under that ADR's More Information, and whole-system diagrams go in the architecture docs folder, or `docs/architecture/`.

Use arc42 only when the project already does. Section 9 then links to the ADR files and to section 4 for decisions summarized there, and ADR drivers cite the quality scenarios of section 10.

## Reference files

- [reference/madr-template.md](reference/madr-template.md) for every new MADR record.
- [reference/c4.md](reference/c4.md) before drawing a diagram, for notation rules and Mermaid and Structurizr syntax.
- [examples.md](examples.md) for a filled ADR and a Mermaid C4 container diagram.
