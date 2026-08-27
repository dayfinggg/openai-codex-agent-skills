---
name: docs
description: Write, update, review, and validate engineering documentation from the repository's actual code, contracts, versions, and operations. Use for README files, tutorials, how-to guides, reference, API docs, changelogs, ADRs, runbooks, diagrams, and doc comments, or when a code, configuration, API, or behavior change would otherwise leave existing documentation inaccurate; do not add documentation for unchanged behavior merely to summarize code.
---

# Documentation

Create the smallest documentation change that lets a defined reader complete a task, understand a decision, or use a contract correctly. Accuracy, usefulness, and maintainability outrank coverage and polish.

## Establish the documentation delta

1. Identify the affected audience, their goal, assumed knowledge, supported product versions, operating environment, and consequence of an error. Do not write for an abstract "developer" when the real reader is an operator, integrator, contributor, administrator, or end user.
2. Inspect applicable repository instructions, existing documentation structure and terminology, manifests and lockfiles, public interfaces, configuration, examples, tests, release process, generators, and documentation tooling before editing.
3. Trace every proposed statement to current code, configuration, schema, test behavior, command output, an accepted decision, or official version-matched documentation. Distinguish verified behavior from a design proposal or known limitation.
4. Determine whether the change makes existing documentation inaccurate, incomplete for a required task, or newly necessary for a public contract. If behavior and reader obligations did not change, do not create documentation that merely narrates the diff or restates implementation.
5. Preserve the project's established information architecture, voice, markup dialect, versioning scheme, terminology, and generation workflow unless the request explicitly changes them or they prevent correctness.

## Choose one reader need per document

1. Use a tutorial for a guided learning experience that produces an early success and teaches by doing.
2. Use a how-to guide for a reader who already has context and needs the shortest reliable route to a specific outcome.
3. Use reference for precise, complete, scannable facts about a contract, command, schema, option, or API.
4. Use explanation for concepts, rationale, tradeoffs, and relationships that help the reader form a mental model.
5. Keep these purposes distinct even when they link to one another. Do not interrupt a procedure with an essay, turn reference into a tutorial, or hide required task steps inside conceptual prose.

Read [document types](references/types.md) when creating or restructuring a README, tutorial, how-to guide, reference, API documentation, changelog, ADR, runbook, or diagram.

## Write only verified, useful content

1. State the reader's outcome early, then provide prerequisites, ordered actions or facts, expected results, failure handling, and relevant limits. Omit background that does not change the reader's action or understanding.
2. Use the same names as the product, code, command, API, and user interface. Define necessary terms once. Prefer direct literal language, active voice, concrete verbs, and complete sentences.
3. Remove marketing claims, generic reassurance, artificial enthusiasm, vague benefits, ornamental introductions, repeated conclusions, and text that could be pasted unchanged into another project.
4. Do not claim that a task is easy, secure, fast, production-ready, supported, backward compatible, or verified unless the repository evidence establishes the exact claim and scope.
5. Explain the public behavior, constraints, inputs, outputs, errors, compatibility, and operational consequences. Do not paraphrase obvious code line by line or expose internal structure that callers do not need.
6. Keep one authoritative home for each fact. Link with descriptive text instead of copying whole procedures, schemas, option lists, or policy statements into several pages.

## Make examples executable evidence

1. Use the exact language, runtime, library, command, configuration, and API versions supported by the project. Derive imports, flags, paths, fields, defaults, and output from the actual repository and current official documentation.
2. Provide the smallest complete example that demonstrates real behavior. Use real APIs and safe deterministic example values; never use pseudocode, ellipses, omitted branches, dummy returns, TODO items, placeholder logic, or comments that stand in for implementation.
3. Keep explanations outside code blocks. Code must be clean, comment-free, copyable, and ready to run in the stated environment.
4. Run commands and examples in the narrowest faithful environment. Verify exit status, produced files, side effects, cleanup, and representative output. Normalize unstable values only when the text explains what varies.
5. Never invent output or say an example was tested when it was not. If execution is impossible, verify syntax and contracts with available tooling and state the precise unverified boundary in the final report.
6. Prefer executable documentation facilities, repository examples used by tests, or generated snippets from checked source when they reduce drift. Do not add a framework solely to test one small document.

## Keep documentation coupled to truth

1. Store source documentation, diagrams, examples, and generation configuration in version control when the project follows docs-as-code. Review documentation with the behavior it describes whenever practical.
2. Generate factual API surface, signatures, fields, and defaults from the authoritative schema or source when established tooling supports it. Add human-written task context, examples, failure behavior, and rationale around generated facts; never hand-edit generated output.
3. Version documentation only when supported product versions have materially different user behavior and readers need parallel guidance. Avoid multiplying nearly identical copies for every patch release.
4. Write changelogs for people, not as commit dumps. Record notable user-visible additions, changes, deprecations, removals, fixes, and security changes with version and date; put migration instructions in a stable guide and link to them.
5. Keep accepted ADRs immutable and supersede them with a new decision. Keep runbooks owned, rehearsed, and synchronized with the commands and platform they operate.
6. Delete obsolete content, examples, redirects after their support window, and diagrams that no longer answer a maintained question. Do not hide unfinished or future documentation in comments.

## Validate the rendered result

1. Build or render the documentation with the repository's pinned toolchain. Run existing format, style, spelling, schema, accessibility, and link checks, and inspect the changed pages rather than judging source alone.
2. Execute or compile every changed command and code sample that can run safely. Verify API examples against the actual server, schema, generated client, or contract tests when that behavior matters.
3. Check headings, navigation, anchors, cross-references, code language tags, tables, images and alternatives, diagrams and text equivalents, responsive layout, keyboard access, contrast, and copy behavior where the output format supports them.
4. Verify version selectors, deprecation notices, redirects, and links from older supported documentation. Check that examples and screenshots belong to the documented version and interface.
5. Review the change as the target reader: follow the task from a clean starting state, note every unstated prerequisite or ambiguous choice, and remove instructions that do not affect the outcome.
6. Request technical review from an owner of the behavior for consequential reference, migrations, security guidance, architecture decisions, and operations. Editorial lint cannot establish technical truth.

Read [verification and maintenance](references/verification.md) when validating examples, generated documentation, links, localization, accessibility, versioning, drift prevention, or review evidence.

## Final audit

Reject or revise the documentation if any applicable answer is no:

1. Is the audience, task, version, prerequisite, outcome, and limitation explicit?
2. Does every factual claim match the current authoritative implementation or source?
3. Is each page recognizably a tutorial, how-to, reference, explanation, or another justified artifact rather than a mixture?
4. Can a reader run every command and example as written without invented logic, placeholder data, or missing steps?
5. Does the document explain public behavior instead of retelling implementation or adding promotional filler?
6. Are generated and hand-written sources separated with one owner for each fact?
7. Did rendering, links, examples, versions, accessibility, and the complete reader task receive proportionate verification?
