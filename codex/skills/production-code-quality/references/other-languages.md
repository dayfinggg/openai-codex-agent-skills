# Other languages and DSLs

Do not project conventions from a listed language onto an unlisted language, data format, query language, configuration language, template language, or domain-specific language.

## Shared resolution

Identify the exact language and version, runtime or interpreter, parser or compiler, package and build tools, formatter, linter, analyzer, type and error model, compatibility promise, generated boundaries, and native validation tools. Resolve form from scoped repository instructions, canonical filenames, closest configuration, declared tool versions, repository commands, and neighboring files in that order. A repository's parser, formatter, schema, or controller gate replaces every local fallback below in its scope.

For every group below, use [code shape and naming](code-shape-and-naming.md) as the sole source of fallback function, class or primary-type, file, nesting, cyclomatic or cognitive complexity, and parameter thresholds. Use its line-width row whenever the language section does not define a narrower configured or ecosystem rule. Apply fallbacks only to new or materially reshaped retained code, not as a demand to rewrite legacy, generated output, migrations, or data files.

## SQL

Resolve the engine and dialect, version, templater, migration tool, and database naming contract before formatting. If SQLFluff is already configured, run `sqlfluff lint path/to/query.sql` with its discovered dialect and configuration. Use its `format` command only for an authorized rewrite. Do not assume ANSI mode for engine-specific SQL, and do not add SQLFluff to manufacture a gate.

SQL has no universal indentation or identifier style. With no repository or formatter policy, use this local fallback: four-space indentation, spaces rather than tabs, uppercase reserved keywords, and lowercase `snake_case` for newly owned internal identifiers. Preserve quoted, public, persisted, ORM-mapped, or vendor-defined identifiers exactly. Use lowercase `snake_case.sql` for ordinary query files. Migration and seed filenames remain tool-defined.

## POSIX shell, Bash, and related shells

Honor the shebang, selected shell dialect, repository `shfmt` flags or EditorConfig, and ShellCheck configuration. If `shfmt` is selected, run the repository command. With no configured flags, use `shfmt -d -i 2 path/to/script.sh` as this skill's local check, then run `shellcheck path/to/script.sh` when ShellCheck is already available. Do not run a script merely to validate its layout.

With no policy, indent with two spaces and no tabs. Use lowercase `snake_case` for functions and local variables, and `UPPER_SNAKE_CASE` for exported environment variables and constants. Preserve conventional external environment names and command contracts. For a new script with no external filename contract, use lowercase kebab-case and the repository's extension policy. Keep sourced libraries, executable commands, and test-discovery names distinct.

## PowerShell

Honor the supported PowerShell edition, module manifest, PSScriptAnalyzer settings, and repository formatter command. Run `Invoke-ScriptAnalyzer -Path path/to/module -Recurse -Settings path/to/settings.psd1` when those settings exist. `Invoke-Formatter` returns formatted text, so compare its result with the source or use a repository wrapper rather than assuming it is a non-mutating file check.

With no policy, indent with four spaces and no tabs. Use approved `Verb-Noun` names for exported functions and cmdlets, `PascalCase` for parameters, classes, enums, and public members, and `camelCase` for local variables. Use `Verb-Noun.ps1` for a single exported command and a matching `PascalCase.psm1` or `PascalCase.psd1` module stem only when no module precedent exists. Preserve case-insensitive public names and module discovery contracts.

## YAML

Resolve the consuming schema, provider, parser version, canonical filename, and configured formatter or linter before generic YAML style. Run the repository's schema validation and its selected Prettier, yamlfmt, or yamllint command. A YAML parse alone does not validate provider semantics.

YAML 1.2 forbids tabs in indentation. With no configured width or indentation size, use spaces only, two spaces per nesting level, and the shared line-width gate. Keys and values belong to the consuming schema, so do not recase them. Preserve canonical tool filenames. Otherwise use descriptive lowercase kebab-case with the repository's `.yaml` or `.yml` extension precedent.

## Dockerfile

Honor the selected Dockerfile syntax, escape directive, build context, canonical ignore files, configured Hadolint policy, and repository build wrapper. When the installed Docker or BuildKit version supports it and the context is safe to inspect, run `docker build --check -f path/to/Dockerfile path/to/context`. This validates built-in checks, not runtime image behavior. Dockerfile has no universal formatter.

With no policy, put parser directives and instructions at column one, use uppercase instruction keywords, indent continuation lines with four spaces, and do not use tabs for layout. Preserve shell or JSON-form semantics inside instruction arguments. Use the canonical `Dockerfile`. Use `Dockerfile.purpose` variants only when repository build commands discover them.

## NGINX

Resolve the installed NGINX version, compiled modules, template expansion, include graph, runtime prefix, and deployment-owned paths. When the environment permits reading every referenced file, run `nginx -t -c path/to/nginx.conf`. Use `nginx -T` only when dumping the effective configuration is authorized and cannot expose secrets. These commands validate syntax and referenced files, not formatting or live traffic behavior.

NGINX publishes syntax but no universal formatter. With no repository policy, put top-level directives at column one, indent block contents with four spaces, use no tabs, and keep one simple directive per line. Directive names and parameters are syntax-owned. Use lowercase `snake_case` for newly owned internal upstream, map, or zone names only when those names are not public contracts. Preserve `nginx.conf` and use descriptive lowercase kebab-case `.conf` include files when no loader convention exists.

## Unlisted retained languages

Use ecosystem-standard safe APIs and project-native validation. If authoritative guidance is unavailable or conflicting, state the uncertainty, preserve the nearest coherent project precedent, apply only the shared local fallback, and avoid changing a public or persisted contract by assumption. Never claim production compatibility without identifying and running the relevant toolchain or reporting why that evidence is unavailable.

Primary references: [SQLFluff configuration](https://docs.sqlfluff.com/en/stable/configuration/setting_configuration.html), [`shfmt`](https://github.com/mvdan/sh), [PSScriptAnalyzer](https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/using-scriptanalyzer), [YAML 1.2.2](https://yaml.org/spec/1.2.2/), [Dockerfile reference](https://docs.docker.com/reference/dockerfile), [Docker build checks](https://docs.docker.com/reference/build-checks/), [NGINX command-line parameters](https://nginx.org/en/docs/switches.html), and [NGINX configuration syntax](https://nginx.org/en/docs/beginners_guide.html).
