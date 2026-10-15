---
name: recording-architecture-decisions
description: Records architecture decisions as ADRs in the repository's format or MADR and draws C4 diagrams as text. Use when asked for an ADR or architecture diagram, or when a change adds a framework, data store, or integration style, or changes module boundaries.
---

# Recording architecture decisions

An architecture decision record (ADR) lets a future reader retrace why the system looks the way it does, which options were weighed, and what the choice costs. Code in this setup carries no comments, so the ADR is where the reasons go. The planning-implementation skill settles decisions with the user, the applying-clean-architecture skill owns layers and dependency direction, the managing-dependencies-and-ci skill vets a dependency before it is added, the writing-documentation skill owns README, CHANGELOG, and other docs, and the writing-commit-messages skill owns commit text. When the repository already has an ADR format, folder, or architecture documentation convention, follow it over this skill.

## When to write an ADR

- **Write one** for a decision that is costly to reverse or shapes several modules. Typical cases are a new framework or a dependency the code is built around, a data store, an integration style such as synchronous HTTP, events, or a message broker, a cross-cutting concern such as authentication, authorization, messaging, caching, or observability, a change to module or service boundaries, and a deliberate trade-off between quality characteristics.
- **Skip it** for choices inside one module that are cheap to change, bug fixes, version updates within the same major version, and anything an existing accepted ADR already decides.
- **Default test.** When in doubt, the decision is significant if undoing it later would touch many files, need a data migration, or change what other teams or services depend on.
- **Initiative.** In a repository that already keeps ADRs, write the ADR in the same change as the decision. Otherwise propose one in a single sentence and write it when the user agrees, or right away when the user asked for it.
- **Plans.** When a plan from the planning-implementation skill contains a significant decision, add a step to record the ADR. The plan's decisions, the options compared, and the user's answers become the context, considered options, and outcome.

## Find the existing format

- Look for an ADR folder before writing, such as `docs/decisions`, `docs/adr`, `doc/adr`, `docs/architecture/decisions`, or `doc/arch`, and for files with `adr` or `decision` in the name.
- When one exists, copy its template, file name pattern, number width, status format, front matter, heading style, and list marker, and add the new record to any index file the folder keeps. If formats differ across files, follow the newest records.
- When none exists, use MADR 4.0.0 in `docs/decisions/`. Copy the template from [references/madr-template.md](references/madr-template.md) instead of writing headings from memory.

## Write the record

- **File name.** `NNNN-title-with-dashes.md`, lowercase, with the next number after the highest one anywhere in the decision folder and its subfolders. Never reuse a number, including those of rejected or superseded records. If a merge brings in another record with the same number, renumber the one not yet merged.
- **Title.** A short phrase naming the problem and the solution, as in `Use a PostgreSQL table for background jobs`, without the number in the heading.
- **Sections.** Start from the minimal set, meaning title, context and problem statement, considered options, and decision outcome. Add decision drivers when forces compete, consequences in almost every record, confirmation when compliance can be checked by a test, an architecture rule, or a review, and pros and cons of the options when the options are close.
- **Context.** State facts neutrally in two or three sentences, end with the question being decided, and link the issue or plan that raised it.
- **Options.** List the options that were really viable, including keeping the current state when that is possible. Do not invent weak alternatives to make the choice look obvious. When only one option meets a hard constraint, say that in the justification.
- **Drivers.** Name qualities with the ISO/IEC 25010 2023 characteristics, which are functional suitability, performance efficiency, compatibility, interaction capability, reliability, security, maintainability, flexibility, and safety. Make each driver concrete and measurable where possible, and cite the quality scenario when the project keeps one.
- **Consequences.** List the bad consequences as well as the good ones, including new operational work, cost, and follow-up decisions.
- **Front matter.** Set `status` and `date` in `YYYY-MM-DD` form for the last update. Fill `decision-makers`, `consulted`, and `informed` only with people the user or the repository names, and leave them out otherwise. Never invent names.
- **Facts only.** Take versions, limits, and measurements from the code, the configuration, or a source you checked, and mark estimates as estimates.
- **Length.** Keep a record to about one screen. Put long analysis in More Information or a linked document.

## Statuses and superseding

The MADR statuses are `proposed`, `rejected`, `accepted`, `deprecated`, and `superseded by ADR-NNNN`.

- **Proposed by default.** Write `proposed` unless the user has already approved the decision, for example by approving the plan that contains it. Never mark a record `accepted` on your own.
- **Proposed records can change.** Edit them freely while the decision is open.
- **Accepted records stay.** Never edit an accepted ADR in substance. Fixing a typo or a broken link is fine. Changing the context, options, outcome, or consequences is not.
- **Supersede in one change.** Write a new ADR with the next number whose context says what changed, and link back with `Supersedes [ADR-NNNN](NNNN-title.md).` under More Information. In the old ADR, change only the status to `superseded by ADR-NNNN`, update its date, and add a link to the new record under More Information. Update the index in the same change.
- **Deprecated.** When a decision stops applying and nothing replaces it, set `deprecated` and say why under More Information.
- **Rejected.** Keep a declined proposal with status `rejected`, so the same option is not proposed again without new facts.
- **Code that drifts.** When the code no longer matches an accepted ADR, do not adjust the record to fit. Tell the user and propose either fixing the code or a superseding ADR.

## arc42

- Use arc42 only when the project already documents its architecture with it, and do not introduce it uninvited.
- Section 9, Architectural Decisions, holds important decisions unless they are recorded elsewhere. When ADR files exist, section 9 links to them instead of repeating them, and it refers to section 4, Solution Strategy, for decisions already summarized there rather than writing them twice.
- Section 10, Quality Requirements, holds the quality tree and specific, measurable quality scenarios. ADR drivers cite those scenarios by name or ID.

## Diagrams

- **Levels.** Draw a C4 system context diagram and a container diagram by default. Add a component diagram only when it adds value, never draw the code level by hand, and use a deployment diagram per environment for clustering, replication, or failover. Read [references/c4.md](references/c4.md) for the levels and syntax.
- **Text in version control.** Use the diagram tool the repository already uses. Otherwise write Mermaid C4 inside the Markdown file that needs the diagram, since GitHub renders `mermaid` code blocks in Markdown files. The Mermaid documentation marks C4 as experimental, so keep to the basic elements and check that the diagram renders. For a model with several views that lives long, use Structurizr DSL.
- **Location.** Put a diagram for one decision under that ADR's More Information, and diagrams of the whole system in the project's architecture docs folder, or `docs/architecture/` when none exists.
- **Notation.** Give every diagram a title with its type and scope. Give every element its type and a short description, and every container a technology. Every line points one way and carries a specific label, with the protocol on lines between containers. Add a key that explains the shapes and colours when the tool does not draw one, explain acronyms, and keep colours consistent across diagrams.
- **Truth.** Draw what the code, the configuration, and the deployment files show, and mark planned parts as planned.

## Workflow

1. Decide whether the decision is significant, using the test above.
2. Find the existing ADR folder and format, and read the records related to the topic so nothing already decided is decided again.
3. Gather the context, options, drivers, and the user's answers from the code, the plan, and the conversation.
4. Write the record with the next number and the right status.
5. When it replaces an earlier decision, update the old record's status and links in the same change.
6. Update the index, the arc42 section 9 links, and any diagram the decision changes.
7. Check every relative link, preview the rendered Markdown and diagrams where possible, and review against the checklist.
8. Tell the user the file path and status, and ask for acceptance when the record is proposed.

## Checklist

- [ ] The decision is significant and no accepted ADR already covers it
- [ ] The record follows the repository's format, or MADR 4.0.0 in `docs/decisions/`
- [ ] The file name is lowercase with dashes and the number is the next unused one
- [ ] Context, considered options, and decision outcome are present, with real options only
- [ ] Drivers use ISO/IEC 25010 terms and are measurable where possible
- [ ] Consequences list costs and risks as well as benefits
- [ ] Status is `proposed` unless the user approved the decision, and no names were invented
- [ ] No accepted ADR was changed in substance, and a superseded one points to its successor
- [ ] Index, arc42 links, and diagrams are updated, and every relative link resolves
- [ ] Diagrams render, and have titles, a key, typed and described elements, technologies, and labelled one-way lines

## Reference files

Read them before the first change, the template file for every new record and the examples file for every task, and the C4 file before drawing a diagram.

- [references/madr-template.md](references/madr-template.md) has the MADR 4.0.0 full and minimal templates as published, with notes on naming, statuses, and links between records.
- [references/c4.md](references/c4.md) has the four C4 levels, the supplementary diagrams, the notation rules, and small Mermaid C4 and Structurizr DSL examples.
- [examples.md](examples.md) has a filled minimal ADR, a superseding ADR with the status change on the old record, and a C4 container diagram in text.
