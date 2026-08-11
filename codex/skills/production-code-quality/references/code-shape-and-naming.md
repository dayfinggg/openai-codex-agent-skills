# Code shape and naming

Use this reference for new or materially changed retained code, and whenever the repository leaves a code-shape metric undefined. These thresholds are operational fallbacks for this skill. They are not claims that one shape is optimal for every language.

## Resolution and scope

1. Apply the repository's configured formatter, linter, analyzer, compiler, generator, and accepted style before any value below. A configured rule is the hard gate for its scope, including its counting semantics and exclusions.
2. Apply a framework or language's mechanically required form next. Do not use a fallback to break a route name, ABI, generated contract, protocol identifier, or official file convention.
3. Apply the table only to a metric still unresolved. Never replace a configured value with the fallback merely because the fallback is stricter.
4. Apply the fallback to new declarations and files and to changed units whose responsibility or control flow is materially reshaped. For a narrow edit in a pre-existing over-threshold unit, do not widen scope only to reduce a count. Do not worsen the metric, and record the baseline and exception if the hard threshold remains exceeded.
5. Exclude vendored and reproducibly derived generated output. Treat scaffold-generated source as retained code after the project takes ownership. Treat migrations, snapshots, fixtures, schemas, and data tables through the exceptions below rather than excluding them silently.

## Fallback measurement

- Measure width in visible columns after expanding tabs with the repository setting or four columns when none exists.
- Measure function, class, and file size as physical lines containing a code token or literal, excluding blank and comment-only lines. Include signatures, annotations, and nested declarations within the measured range.
- Measure nesting as executable control-flow depth. Ignore namespace, module, type, and function containers. Keep an `else if` at its corresponding `if` depth and do not add a level merely for a `switch` or `match` arm.
- When no analyzer is available, approximate fallback cyclomatic complexity as `1 + decision points`, counting conditionals, loops, catches, non-default cases or match arms, conditional expressions, and short-circuit Boolean branches.
- When no compatible cognitive-complexity analyzer is available, use a fallback cognitive score. Add one for each branch, loop, catch, jump, recursion edge, or mixed Boolean sequence, then add the current control-flow nesting depth for each nested break in linear flow. Report the score as this skill's fallback, not as a Sonar result.
- Count caller-visible parameters, including optional and named parameters. Exclude an implicit receiver such as `self`, `this`, or `cls` and compiler-synthesized parameters.

## Fallback gates

A review trigger requires inspection of cohesion, control flow, call-site clarity, and testability. Refactor only when a named boundary improves one of them. A hard fallback gate blocks completion until the unit is below the threshold or a bounded exception is recorded with compensating evidence. Crossing either number is not by itself proof of a defect.

| Metric | Review trigger | Hard fallback gate | Source and rationale |
| --- | ---: | ---: | --- |
| Line width | `>100` columns | `>120` columns | PEP 8, Black, Prettier, and Google Java cluster between 79 and 100 while Go has no fixed maximum. `120` is a local buffer for unconfigured code, not a language standard. |
| Function or method size | `>50` source lines | `>100` source lines | ESLint defaults to 50 and Checkstyle to 150. The 100-line hard process gate is a conservative local midpoint, with semantic exceptions rather than a claim of optimal size. |
| File size | `>300` source lines | `>1000` source lines | ESLint defaults to 300 and Checkstyle to 2000. The lower value starts responsibility review. The local 1000-line hard gate prevents an extreme unreviewed unit while allowing explicit data-oriented exceptions. |
| Class or primary type size | `>300` source lines | `>500` source lines | PMD removed raw excessive-class-length rules in favor of structural measures. These local values force cohesion review and a stronger exception because line count alone is weak evidence. |
| Control-flow nesting | `>3` levels | `>4` levels | ESLint's `max-depth` default is 4. The review trigger starts one level earlier so a fifth level cannot arrive without an explicit decision. |
| Cyclomatic complexity per function | `>10` | `>20` | The lower value is an early investigation threshold. ESLint's classic-complexity default of 20 supplies the hard fallback boundary. Do not compare it with cognitive complexity or NPath. |
| Cognitive complexity per function | `>15` | `>25` | Sonar commonly uses 15 and uses 25 for C-family defaults. This skill treats them as review and hard process thresholds, not interchangeable language limits. |
| Caller-visible parameters | `>3` | `>7` | ESLint defaults to 3 and Checkstyle to 7. The range exposes call-site ambiguity without forcing parameter objects into framework or compatibility contracts. |

The tool defaults and their different semantics are documented by [ESLint size and complexity rules](https://eslint.org/docs/latest/rules/), [Checkstyle size checks](https://checkstyle.org/checks/sizes/), [PEP 8](https://peps.python.org/pep-0008/#maximum-line-length), [Black](https://black.readthedocs.io/en/stable/the_black_code_style/current_style.html#line-length), [Prettier](https://prettier.io/docs/options.html#print-width), [Google Java Style](https://google.github.io/styleguide/javaguide.html#s4.4-column-limit), [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments#line-length), [PMD 7 release notes](https://pmd.github.io/2024/03/22/PMD-7.0.0/), [Sonar metric definitions](https://docs.sonarsource.com/sonarqube-cloud/digging-deeper/metric-definitions), and Sonar's [default-threshold rationale](https://community.sonarsource.com/t/s3776-reason-for-the-current-default-value-of-15/127103).

## Exceptions

Record the metric, baseline and candidate value, reason literal decomposition would reduce correctness or comprehension, affected scope, and compensating evidence. Do not add a suppression or code comment unless repository policy requires it.

- Width exceptions include non-breakable URLs, imports or package declarations, commands, identifiers, text blocks, generated literals, and snapshot data.
- Size exceptions include cohesive linear protocols, parsers, state machines, validators, decision tables, schema adapters, migrations, fixtures, snapshots, registries, and tables whose split would hide ordering or one invariant.
- Nesting and complexity exceptions include tree traversal, resource-lifetime scopes, protocol dispatch, and irreducibly branch-heavy algorithms. Require exhaustive focused tests or another branch-sensitive gate.
- Parameter exceptions include overrides, framework callbacks, dependency-injection or serialization constructors, FFI, mathematical functions, stable public APIs, and measured hot paths. Do not create an untyped `Options` bag only to lower a count.

## Semantic naming and comments

- Follow repository and language morphology before general advice. Do not impose `camelCase`, `snake_case`, PascalCase, or dot suffixes across ecosystems.
- Name a variable for its domain role, state, or unit. Use a one-letter name only for an established mathematical symbol or a tiny obvious index scope.
- Make a Boolean read as a predicate or state without confusing double negation. Name a function or method for its action, calculation, or question at the caller's level.
- Name a type or class for a domain concept, value, role, or stable responsibility. Use `Manager`, `Helper`, `Util`, or `Processor` only when that word states the actual contract rather than hiding mixed responsibilities.
- Name a module or file for its primary responsibility and ecosystem role. Preserve public, serialized, protocol, framework-defined, and widely imported names unless the task includes their migration. Do not shorten a precise name merely to meet line width.
- Follow the repository's abbreviation vocabulary. Do not invent an abbreviation or expand an established domain term without a compatibility reason.
- Do not add comments, docstrings, or explanatory prose unless the user, public API, language, or repository contract requires them. When required, document non-obvious intent, invariant, constraint, ownership, unit, rationale, compatibility, side effect, or error behavior. Preserve directives, license headers, generation markers, and valid existing comments. Update a comment that the change would otherwise make false.
