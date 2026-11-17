# Codemods and version upgrades

Version snapshot checked 2026-11-17. Check the project lockfile, installed tool, and version-matched docs before using these examples.

## Contents

- Before a run
- Choosing an engine
- Running a transform
- ast-grep
- jscodeshift
- ts-morph
- LibCST
- OpenRewrite and the Codemod registry
- Version upgrades

## Before a run

These examples describe tools, not permission to fetch packages or run remote transformations. Prefer the version declared by the project, and check the official registry, package version, and project dependency policy before adding a tool or running one from a registry.

- Start from a clean working tree, so `git diff` after a run shows only what the tool wrote.
- Look for the official migration path before writing a transform: the upgrade guide of every version between the current and the target, and the project's own codemod. Each stack's official codemods are in its language skill (`typescript-javascript`, `python`, `php`, or `rust`).
- Use the project's declared ast-grep version. Do not make `npx`, `uvx`, or another package runner download a tool unless the task and dependency policy allow it. When a package is already installed, check its own help for the supported executable.

## Choosing an engine

- Syntax alone decides the match, any language: ast-grep, `run -p ... -r ...` for one pattern, `scan` with YAML rules for several.
- TypeScript or JavaScript symbols and types decide it (rename an export everywhere, follow imports, aliases and re-exports, find calls on one type): ts-morph.
- A framework ships a jscodeshift transform: run that transform with jscodeshift.
- Python: LibCST, run as `python -m libcst.tool codemod <module.Class> <paths>`.
- PHP: Rector. `vendor/bin/rector <paths> --dry-run` prints the diff, and the same command without `--dry-run` writes it.
- JVM: OpenRewrite. `mvn rewrite:dryRun` writes a patch file under `target/rewrite/` and leaves sources alone. No recipe runs unless it is listed in `activeRecipes` (`-Drewrite.activeRecipes=<name>`).

## Running a transform

- Count the sites first: `ast-grep run -p '<pattern>' -l <lang> --json=stream` prints one match per line. Compare that count with what the run changed and with what is left.
- Give every transform three fixtures: a matching input with its expected output, an input that must stay unchanged, and an edge case. For ast-grep rules, write `valid` and `invalid` cases in a directory listed under `testConfigs` in `sgconfig.yml` and run `ast-grep test`.
- Run the transform again on its own output and expect no change. A second pass that edits again is a bug.
- OpenRewrite's rule fits every engine: "If your recipe cannot determine that a change is safe, it should make no changes rather than making a potentially wrong change." Skip such sites and list them for hand review.
- Apply in shards, one package or directory each, that each build, pass their tests and can be committed. Commit the generated change apart from hand fixes, with the exact command in the commit message so a reviewer can rerun it and compare.
- Run the project's formatter on the changed files only.
- After the run, search the old form as plain text with `git grep -n '<old>'`. Strings, docs, config, generated code and other languages still hold it, and a pattern that stops matching proves only that the pattern stops matching.
- When every caller has moved, delete the old path. Keep an alias, shim or fallback only for a named contract: a public API, CLI, config or stored data, a tagged release, a security boundary or observed production state. Tests alone are not a contract.

## ast-grep

- On Linux `sg` is the `setgroups` command, and ast-grep itself deprecated `sg` in 0.45.0. Call `ast-grep`.
- `--lang ts` covers `.ts`, `.cts` and `.mts` only. Run `.tsx` again with `--lang tsx`. `--lang js` includes `.jsx`, `.cjs` and `.mjs`. Without `--lang` the language follows each file's extension.
- ast-grep skips hidden and gitignored files, such as `.github/` and generated code. Pass `--no-ignore hidden --no-ignore vcs` when they are in scope.
- `run -r` and `scan` with a `fix` print a diff and change nothing until you add `-U` (`--update-all`).
- `ast-grep run` exits 0 when something matched and 1 when nothing did. `scan` exits 1 only when a rule with severity `error` matched, so a gate needs `severity: error` in the rule or `--error` on the command line.
- A pattern matches the syntax as written, not the resolved symbol. `env::var($X)` does not match `std::env::var("X")`, and a call through an alias or re-export never matches. Run every spelling, or use the compiler (ts-morph, the language server) when names resolve through imports.
- `has` and `inside` look only one level down or up. Add `stopBy: end` to search the whole subtree or every ancestor.
- A metavariable is one whole node, so `use$HOOK` is literal text. Match `$HOOK($$$ARGS)` with `constraints: { HOOK: { regex: '^use' } }`.
- In a fix, `$VARName` reads as the metavariable `$VARN` followed by `ame`, and a metavariable the rule did not capture becomes an empty string, so `bar($A, $MISSING)` writes `bar(1, )`. Build new names with a `transform`.
- A pattern must parse on its own. `"key": $V` fails as a JSON pattern, so give the parser context and select the node: `pattern: { context: '{"key": "$V"}', selector: pair }`. A `kind` next to a `pattern` is a second rule, not a parse hint.
- Rule keys apply in no fixed order, and the first rule that captures a metavariable fixes its value. Put rules that share a capture under `all:` in the order they must run.
- `--json` line numbers start at 0. Inspect a pattern that matches nothing with `--debug-query=pattern`, which needs `--lang` set.

## jscodeshift

- Every file is parsed with `--parser=babel` unless the transform exports `parser`, and that parser fails on TypeScript. Run `--extensions=ts --parser=ts` and `--extensions=tsx --parser=tsx` as separate passes, because the tsx parser rejects `<T>value` assertions.
- Parse errors still exit 0 unless `--fail-on-error` is set.
- It transforms `node_modules` and gitignored output under the paths it gets. Pass `--gitignore` and `--ignore-pattern='**/node_modules/**'`, or feed `git ls-files` output through `--stdin`.

## ts-morph

- `rename()` turns `{ a }` into `{ b }`, which changes the object's key, and renames the exported name in `export { a }`. Pass `{ usePrefixAndSuffixText: true }` to get `{ a: b }` and `export { b as a }`. Comments and strings keep the old name unless `renameInComments` and `renameInStrings` are set.
- Nothing is written until `project.save()`.
- `replaceWithText()` forgets the replaced node, and `insertText()`, `replaceText()` or `removeText()` on a node forgets every descendant you navigated to. A forgotten node throws when used, so navigate to it again. Collect everything that needs the type checker before the first edit, since every edit resets the program.
- ts-morph 28 bundles TypeScript 6.0.2 and ignores the project's `typescript` package.

## LibCST

- `leave_*` methods must build on `updated_node`. A change made to `original_node` throws away every edit already applied to its children.
- Pass `config=module.config_for_parsing` to `parse_statement()` and `parse_expression()`, or inserted code can get other line endings and indentation than the module.
- Without a `.libcst.codemod.yaml`, `libcst.tool codemod` pipes each result through `black -` and counts the file as failed when black is missing or cannot parse the syntax. Pass `--no-format` and run the project's formatter. Preview with `-u` (`--unified-diff`) placed after the paths.
- `libcst.tool codemod` skips files marked `@generated` unless `--include-generated` is set.
- LibCST 1.9.0 (2026-07-29) parses Python 3.15 `lazy import` into the new nodes `LazyImport` and `LazyImportFrom`. A transform that visits only `Import` and `ImportFrom` misses them, and older LibCST fails to parse the file. 1.8.4 added t-strings.

## OpenRewrite and the Codemod registry

- Maven Central stops at rewrite-recipe-bom 3.38.0 (2026-08-26) and rewrite-maven-plugin 6.46.1 (2026-08-12). Newer OpenRewrite recipes and the `org.openrewrite.rewrite` Gradle plugin come from the Code Genome Project repository `https://artifacts.codegenomeproject.org/maven`, which needs a username and a download token in `settings.xml` or `~/.gradle/gradle.properties`. Ask the user for the token, and keep it out of committed files.
- On that repository, 401 means a missing or revoked token and 403 means the account lacks the entitlement (Moderne Source Available and proprietary recipes are for customers only). A 404 on the repository root is normal.
- `npx codemod search <terms> --format json` searches the Codemod registry, and `npx codemod <package> -t <path>` runs a package. A package run has no dry-run flag, so run it on a clean tree and read `git diff`.
- The Codemod CLI sends telemetry to PostHog and Scarf by default, with the account email for logged-in users. Pass `--disable-analytics` or set `DISABLE_ANALYTICS=1`.

## Version upgrades

- List the breaking and behavioral changes between the two versions, then keep only what this code uses, each with `file:line`. Only changes in that intersection matter.
- Mark each change mechanical (a codemod applies it) or judgment. A change that compiles and runs but returns a different result (defaults, encoding, locale, serialization, time zones, security defaults) gets a characterization test before any edit.
- Split a move across several majors, or of two things at once such as a runtime and a framework, into hops that each build and pass their tests before the next starts, such as Java 8, 11, 17, 21. Upgrade one component at a time: runtime, build tool, compiler, framework, then libraries.
- Record the old version's per-test results before the first edit. The upgraded code must reproduce them test by test, not only end green.
- Migrate one representative module first, not the easiest one. Add every surprise it shows to the change list, then batch the rest.
- Check test and build tooling against the target before the bump. Testcontainers, MockK, bytecode instrumentation and coverage tools often lag platform upgrades.
- A migration tool that is installed but could not restore or build the project found nothing. Report that coverage as missing, not as clean.
