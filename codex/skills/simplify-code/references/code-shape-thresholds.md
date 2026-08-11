# Code-shape thresholds

Use this reference to interpret a configured size, nesting, complexity, parameter, or formatting rule. It is self-contained so that a simplification decision does not require importing another skill's policy.

## Order of authority

1. Apply the closest repository instruction and the exact configured formatter, linter, analyzer, compiler, generator, and test rule.
2. Use the rule's installed version, metric variant, counting semantics, scope, exclusions, and suppressions.
3. If no rule is configured, treat code shape as a review signal. Do not invent a pass or fail threshold.
4. Refactor only when the change improves a current responsibility, cohesion, information hiding, control flow, testability, or change safety without degrading behavior, locality, performance, traceability, or compatibility.

Raw length is not a responsibility boundary. A parser, state machine, protocol dispatch, cohesive table, generated binding, migration, fixture, snapshot, registry, or measured hot path may be clearer when kept together. A short wrapper or class can still be needless if it has no independent contract or consumer.

## Tool-scoped defaults

The values below are defaults of named tools or standards, not universal limits. They become gates only when the repository enables or adopts the corresponding rule without overriding the value.

| Scope | Default | Meaning when enabled | Outside that scope |
| --- | ---: | --- | --- |
| ESLint `max-lines-per-function` | 50 lines | Apply its options for comments, blank lines, and IIFEs | JS or TS review signal only |
| ESLint `max-lines` | 300 lines | Apply its configured exclusions and counting | JS or TS review signal only |
| ESLint `max-depth` | 4 levels | Use the parser and rule's nesting semantics | JS or TS control-flow review signal only |
| ESLint `complexity` | 20 | Classic cyclomatic threshold unless another variant is configured | Do not compare with Cognitive Complexity or NPath |
| ESLint `max-params` | 3 parameters | Apply configured TypeScript and `this` handling | Do not force an `Options` object solely for the count |
| Checkstyle `MethodLength` | 150 lines | Default of the enabled module, including its token and line semantics | Not a Java-wide limit |
| Checkstyle `FileLength` | 2000 lines | Default of the enabled module | Not a Java-wide limit |
| Checkstyle `LineLength` | 80 columns | Default of the enabled module with its pattern exceptions | Not a portable hard width |
| Checkstyle `ParameterNumber` | 7 parameters | Default of the enabled module with configured exceptions | Preserve required overrides and framework signatures |
| PEP 8 | 79 code, 72 prose | Python style defaults when adopted | A team may use a compatible documented alternative |
| Black | 88 columns | Formatter target when Black uses its default | Output can exceed the target for unbreakable constructs |
| Prettier `printWidth` | 80 columns | Printer preference when not overridden | It is not a hard maximum |
| Google Java Style | 100 columns | Style limit when that guide is adopted | Its documented exceptions still apply |

## Review without a configured numeric gate

For a function or method, inspect independent tasks, mixed abstraction levels, hidden state transitions, branching, nesting, resource lifetime, and whether an extracted responsibility has a precise name and current consumer. Do not split a linear operation with one invariant merely to shorten it.

For a file or class, inspect independent reasons to change, owner boundaries, clusters of state and methods, public surfaces, dependency direction, and whether a proposed unit can hide a real volatile detail. Do not create equal-sized fragments, a package, or a service without a responsibility boundary.

For parameters, inspect call-site clarity, same-type ambiguity, shared lifetime, and whether the group is a stable domain concept. Preserve public APIs, overrides, serialization constructors, dependency injection, FFI, callbacks, and measured hot paths unless the task explicitly changes them.

For nesting and branch complexity, prefer a guard, named operation, phase split, or table only when the resulting control flow is more direct. Keep explicit structure and exhaustive focused tests for irreducibly branch-heavy parsers, validators, state machines, and protocol dispatch.

## Naming and layout

Before creating, moving, or renaming retained source, identify the package root, language, framework and version, generator, module resolution, test discovery, and two or three nearby files with the same role. Preserve mechanically required names such as framework routes, package entry points, Python packages, Go test suffixes, applied migrations, generated outputs, public import paths, and serialized fields.

Use role suffixes only in ecosystems where the installed framework and repository establish them. Do not transfer NestJS or Angular dot suffixes into Python, Go, Java, C#, Ruby, React, or Next.js. Prefer a coherent local precedent. If precedents conflict, use the official generator or documented default for the installed version and keep the change local.

## Decision record

When a threshold or signal influences the refactor, record the exact metric, tool and version, scope, status as gate or review signal, observed value, exception if any, and verification command. If those fields cannot be stated, do not present the number as a requirement.
