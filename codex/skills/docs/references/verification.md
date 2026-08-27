# Verification and Maintenance

## Docs-as-code workflow

1. Keep documentation changes reviewable beside the source, schema, configuration, or migration they describe. Use the repository's normal branch, review, ownership, and CI workflow.
2. Add or update documentation in the same change when a public or operator-visible behavior changes. A separate follow-up is acceptable only with explicit ownership and timing; do not knowingly merge misleading documentation.
3. Review both directions of drift: behavior changed without docs, and docs promise behavior the implementation never provided. Delete hidden drafts and abandoned future documentation instead of commenting them out.
4. Use the installed formatter, renderer, linter, and link checker. Do not replace project tooling or add heavy infrastructure for a narrow documentation edit.

## Commands and executable examples

1. Test examples at the layer readers will use: compile code, execute commands, validate configuration, call the API, or run a safe dry-run against the documented version.
2. Prefer examples imported from tested source, doctests, documentation tests, or repository fixtures. Ensure the rendered snippet and the executed source are the same bytes or are generated from one source.
3. Isolate credentials, mutable external services, clocks, randomness, generated identifiers, and network dependencies. Use deterministic local resources where possible and describe unavoidable environmental variance.
4. Validate setup and teardown from a clean state. Re-run the sequence to detect hidden prerequisites and non-idempotent behavior.
5. Keep expected output only when it helps readers verify progress. Capture it from the real command, remove secrets, and normalize volatile values without changing the meaning.

## Generated documentation

1. Locate the source of truth and generator version before editing. Change the schema, source comments, templates, or generator configuration, then regenerate through the established command.
2. Treat generated output as a build artifact. Check that regeneration is deterministic enough for review and that CI detects stale generated files when the project expects them committed.
3. Validate public visibility, names, types, defaults, links, deprecations, and examples in the rendered result. A generator can reproduce an inaccurate source perfectly.
4. Keep human guidance outside generated regions. Do not duplicate entire generated reference pages manually to gain editorial control.

## Versioning and lifecycle

1. Map documentation versions to actual supported behavior, not repository branches by habit. State the version where a command, option, API, screenshot, or workflow differs.
2. Add parallel versioned documentation only when readers actively use incompatible supported versions. Prefer conditional text or one maintained page for small compatible differences when the toolchain supports it clearly.
3. Mark deprecation with the affected surface, replacement, migration path, earliest removal point, and supported versions. Remove the old guidance only after its support window closes.
4. Preserve useful historical changelogs and accepted ADRs. Archive or redirect unsupported task and reference pages so search results do not silently lead readers to obsolete instructions.

## Links, navigation, and discoverability

1. Use concise descriptive link text that makes sense out of context. Link directly to the authoritative page or anchored section and explain unexpected downloads or external destinations.
2. Run the repository's internal and external link checks. Review redirects, anchors, version selectors, relative paths, generated URLs, case sensitivity, and links embedded in code comments or schemas.
3. Do not fix a broken link by pointing to a nearby but semantically different page. If the target no longer exists, update the statement, replace the source, or remove the obsolete claim.
4. Check that new content is reachable through the project's navigation, search metadata, README, index, or relevant cross-links without adding redundant links everywhere.

## Localization and accessibility

1. Write short, literal, unambiguous sentences with consistent terminology. Avoid idioms, humor, cultural assumptions, directional page language, concatenated fragments, and screenshots containing essential text.
2. Keep visible UI labels, commands, code, paths, and identifiers exact. Separate translatable prose from literals and preserve placeholders only in syntax definitions, never as fake runnable example values.
3. Use descriptive headings in a logical hierarchy, meaningful links, real lists, accessible tables only when appropriate, text alternatives for meaningful images and diagrams, and captions or transcripts for media.
4. Verify the rendered page with keyboard navigation, zoom or reflow, contrast, screen-reader structure, code-block scrolling and copy behavior, and required writing directions when the docs platform includes interactive or visual output.
5. Update source-language documentation first unless the project's localization workflow specifies otherwise. Preserve locale metadata and flag outdated translations rather than silently presenting them as current.

## Review and evidence

1. Run technical review against code, tests, schema, and actual output. Run editorial review for audience fit, structure, clarity, terminology, localization, and accessibility. Neither review substitutes for the other.
2. Use prose lint as a consistency signal, not an authority on truth or quality. Inspect warnings in context and avoid weakening useful project rules merely to make CI green.
3. Render and inspect every changed page, including callouts, tabs, generated reference, diagrams, tables, long lines, mobile width, and dark or alternate themes supported by the site.
4. Record commands and checks actually run. Separate verified facts, unexecuted examples, unavailable environments, known third-party limitations, and unrelated existing failures.
5. Review the final diff for duplicated facts, accidental promises, unsupported versions, invented output, placeholder values, stale screenshots, broken anchors, unfinished notes, promotional language, and paragraphs that do not help the defined reader.
