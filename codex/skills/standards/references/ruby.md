# Ruby engineering reference

Use this reference for Ruby code when the repository does not state a more specific rule.
Read the repository's `README`, `AGENTS.md`, `CONTRIBUTING`, `Gemfile`, and CI scripts first.
Treat existing code and tests as evidence of local conventions, not as permission to copy defects.
Prefer a small, explicit change that preserves the public behavior and existing toolchain.

## Idiomatic Ruby

- Read a method as an expression and let its final expression provide the result when that is clear.
- Use `return` for an intentional early exit or to make a non-obvious branch explicit.
- Omit parentheses for no-argument calls, and use parentheses when arguments could be misread.
- Omit `self` for ordinary reads, but keep it for writer methods such as `self.status=`.
- Prefer guard clauses for invalid input and exceptional preconditions.
- Keep conditionals shallow, and avoid `unless` with an `else` branch.
- Use `&&` and `||` for boolean expressions; reserve `and` and `or` for deliberate control flow.
- Use `case` when it makes alternatives easier to scan than nested `if` statements.
- Use keyword arguments when several values have similar types or call-site names carry meaning.
- Avoid clever one-liners when the shorter form hides state, precedence, or side effects.
- Avoid mutation unless the receiver's ownership and the mutation's effect are obvious.
- Give mutating methods a clear contract, and use a `!` suffix only when the project convention supports it.
- Use `Hash#fetch` when a missing key is an error instead of silently converting absence to `nil`.
- Keep compatibility with the repository's supported Ruby versions; do not introduce newer syntax casually.
- Add `# frozen_string_literal: true` only when the project already uses it or has chosen it deliberately.

## Object boundaries

- Give each object one cohesive reason to change, expressed in terms of a domain responsibility.
- Expose a small set of messages and keep representation details behind private methods.
- Inject collaborators through an explicit constructor or factory instead of creating global clients inside methods.
- Make boundary inputs and outputs stable, and isolate I/O, persistence, clocks, and randomness at those boundaries.
- Prefer value objects for concepts with validation, comparison, formatting, or domain-specific invariants.
- Pass collaborators that support the needed messages rather than branching on their concrete classes.
- Avoid long chains such as `order.customer.account.plan`; delegate the question to the object that owns the knowledge.
- Use composition when behavior varies independently, and use inheritance only when the subtype contract is stable.
- Keep adapters at integration edges so vendor-specific names and errors do not leak through the domain.
- Do not create a wrapper class only to rename one call unless the wrapper establishes a meaningful boundary.
- A public method should tell a coherent story without requiring callers to know internal sequencing.
- Treat difficult setup, excessive stubbing, and tests that inspect internals as design warnings.
- Keep state ownership unambiguous; do not let several objects mutate the same collection without a contract.
- Let the caller that can recover from a failure own recovery; other layers should preserve useful context and propagate it.

## Modules, classes, and inheritance

- Use a module for a namespace or for a coherent mix-in protocol, not as a miscellaneous utility drawer.
- Give a mix-in a small API and document the host methods, state, and callbacks that it requires.
- Include a module only when the receiver genuinely satisfies the module's behavior, not merely because a helper is convenient.
- Prefer an object or a namespaced module over adding methods to `Object`, `Kernel`, or unrelated core classes.
- Do not reopen a class or module that the project does not own; use an adapter, decorator, or explicit refinement instead.
- Keep constants under the namespace that owns them, and avoid ambiguous top-level constants.
- Keep one primary class or module per file when the project layout permits it.
- Name a file with the snake-case form of its primary constant.
- Make visibility explicit when a method is part of an internal implementation.
- Keep public methods above private helpers unless the repository uses another consistent layout.
- Use `extend` for class-level behavior only when the module's class contract is intentional and tested.
- Avoid class variables and module-level mutable state because they blur ownership and inheritance behavior.
- Use inheritance to share a substitutable contract, not just to reuse a few lines of implementation.
- Prefer explicit delegation over callbacks that silently modify the host class.

## Naming and layout

- Use English names unless the domain requires a local term that the team has documented.
- Use `snake_case` for methods, local variables, instance variables, symbols, files, and directories.
- Use `CapitalCase` for classes and modules, while keeping established acronyms uppercase.
- Use `SCREAMING_SNAKE_CASE` for constants that are not classes or modules.
- End predicate methods with `?`, and make their truthy or falsey contract obvious from the name and tests.
- Use `=` methods for assignment-like writers, and preserve normal Ruby assignment semantics.
- Treat `!` as a warning that a method is dangerous or mutating; do not add it just to make a name sound stronger.
- Prefer names at the level of the domain rather than names that expose the current storage or algorithm.
- Name parameters for their meaning and units, such as `timeout_seconds` rather than `timeout`.
- Avoid vague names such as `data`, `thing`, `manager`, `helper`, and `util` when a domain name is available.
- Avoid unexplained abbreviations, except for established project or domain vocabulary.
- Keep a method name focused on one role; a name containing `and` often signals two responsibilities.
- Choose collection names that are plural and element names that are singular.
- Make negative predicates read naturally, and avoid double negatives at call sites.
- Keep comments for intent, constraints, and non-obvious tradeoffs; do not narrate syntax.

## Blocks and Enumerable

- Use `map` for a transformation, `select` or `filter` for selection, and `find` for the first match.
- Use `any?`, `all?`, `none?`, and `one?` when the question is a predicate rather than a count.
- Use `each` for side effects and do not hide side effects inside `map`.
- Use `reduce` for a clear fold and `each_with_object` when accumulating into a mutable result object.
- Use `flat_map` for one-level flattening instead of `map` followed by `flatten`.
- Use `size` for a collection size when that is the operation intended; `count` may traverse an `Enumerable`.
- Use a lazy enumerator for large or unbounded pipelines when eager materialization is unnecessary.
- Keep a chain of collection calls readable; extract a named method when a block needs its own explanation.
- Use `&:method` when the block consists only of that method call and the shorthand remains clear.
- Prefer `{ ... }` for a short single-line block and `do ... end` for a multi-line block.
- Use `yield` when a method only invokes its block, and capture `&block` when the block must be stored or forwarded.
- Return an enumerator from a no-block collection method when the API is intended to support both styles.
- Document whether a block is required, how many times it runs, and what it should return.
- Use `next` to skip an item and `break` to stop an iteration; do not use exceptions to control ordinary iteration.
- Do not mutate the collection being traversed unless the method explicitly promises that behavior.
- Keep resource-owning blocks responsible for closing or releasing the resource, even when the block raises.
- Implement `#each` before including `Enumerable`, and yield successive elements in the collection's natural order.
- Test both the yielded values and the return value when a custom collection implements `Enumerable`.

## Errors and recovery

- Raise a specific exception class that tells callers what went wrong.
- Define application errors under a domain namespace and inherit from `StandardError` unless process-level failure is intended.
- Prefer `raise ErrorClass, "message"` over `raise ErrorClass.new("message")` for ordinary errors.
- Prefer `raise` over `fail` so raising and re-raising use one vocabulary.
- Rescue the narrowest exception class that the code can handle, and keep the rescue scope small.
- Do not rescue `Exception`, because that also catches signals and process-control exceptions.
- Do not leave a rescue body empty; recover, translate, report, or document why the error is intentionally ignored.
- Do not use exceptions for expected branching when a predicate or explicit result communicates the case.
- Avoid modifier-form `rescue` when it would hide which expression is protected or which errors are caught.
- Translate dependency-specific errors at an integration boundary and preserve the original cause where the runtime supports it.
- Retry only when the operation is safe to retry, the cause can change, and the number of attempts is bounded.
- Use `ensure` for cleanup, and never return from `ensure` because it can hide an exception.
- Log an error once at the boundary that can act on it; avoid duplicate logs at every layer.
- Test the error class, relevant message context, and recovery behavior instead of only asserting that something failed.

## Sorbet and RBS when present

- Inspect for `sorbet/config`, `sorbet/`, `.rbi`, `sig/`, `Steepfile`, `rbs_collection*.yaml`, and type-checker entries in the `Gemfile`.
- Follow the repository's existing checker and version rather than introducing a second typing system without a migration plan.
- Keep Sorbet file sigils, method `sig` declarations, and RBI files synchronized with the Ruby implementation.
- Treat `T.untyped` and `T.unsafe` as narrow, documented escape hatches rather than routine fixes for type errors.
- Raise Sorbet strictness deliberately and incrementally; do not weaken a file merely to make a change pass.
- Run the repository's normal `bundle exec srb tc` or binstub after changing Sorbet code, signatures, or generated RBI files.
- Commit generated Sorbet interface files when the repository treats them as source-controlled artifacts.
- Keep RBS declarations in the configured signature directory, commonly `sig/`, and align them with visibility and overload behavior.
- Model nilability, block types, keyword arguments, and unions explicitly instead of hiding uncertainty in `untyped`.
- Treat `rbs prototype` output as a starting point that requires human correction, not as an authoritative contract.
- Run the repository's configured `rbs validate` and `steep check` commands when those tools are present.
- Use RBS type assertions or the project's equivalent when an API's runtime behavior needs signature coverage.
- Keep dynamic DSLs and generated methods represented in the project's RBI or RBS mechanism so callers see the real interface.
- Prefer `void` in RBS when a return value is intentionally discarded, and use `bool` for Ruby truth-value semantics when appropriate.
- Update type declarations in the same change as a public API change, and test the runtime behavior separately.

## RuboCop and project configuration precedence

- Inspect the nearest `.rubocop.yml`, parent configurations, `.rubocop_todo.yml`, `inherit_from`, `inherit_gem`, and any project binstub.
- RuboCop searches from the inspected file's directory upward, then project `.config` locations, global configuration, and defaults.
- An explicit `--config` path replaces that search, so record it when reproducing a CI or editor result.
- For command options, explicit CLI options override `RUBOCOP_OPTS`, which overrides the `.rubocop` options file.
- Within inherited configuration, `inherit_gem` loads first, `inherit_from` files follow in listed order, and local directives win last.
- Child configuration overrides inherited values, while hashes merge and arrays normally replace unless `inherit_mode` says otherwise.
- Check `TargetRubyVersion` and the repository's `.ruby-version`, gemspec, lockfile, or CI matrix before accepting a syntax offense.
- Run RuboCop through Bundler when the repository locks the gem, such as `bundle exec rubocop` or `bin/rubocop`.
- Read the cop documentation before disabling or autocorrecting a rule, especially for unsafe corrections.
- Treat a TODO exclusion as debt with a reason and scope, not as evidence that the rule is irrelevant.
- Prefer a narrow per-file or per-cop exception over a global disable when legacy code requires an exception.
- Apply the project's configured style before the generic Ruby Style Guide when the two differ.
- Review autocorrect diffs manually because formatting changes can alter heredocs, semantics, or generated files.
- Run the same RuboCop command and target paths that CI runs before claiming style compliance.
- Keep style changes separate from behavior changes when that separation makes review and rollback clearer.

## Testing

- Test public behavior and observable contracts rather than private helper calls or incidental instance variables.
- Add a focused regression test for a confirmed bug before changing the implementation when a cheap test target exists.
- Keep unit tests close to pure domain logic and use integration tests at database, network, filesystem, and framework boundaries.
- Prefer real small collaborators over extensive mocks; mock only an external boundary or an intentionally isolated protocol.
- Give each test one clear reason to fail and name the behavior and relevant condition.
- Keep tests deterministic by controlling time, randomness, environment, ordering, and external services.
- Isolate state between tests and avoid tests that depend on execution order or shared mutable fixtures.
- Assert useful output, state transitions, emitted messages, and error contracts rather than implementation call counts.
- Test both normal and boundary inputs, including empty collections, nilability, invalid arguments, and repeated calls.
- Test block APIs for no-block behavior, yielded arguments, yield count, and exception-safe cleanup.
- Use the test framework already adopted by the project, whether Minitest, RSpec, or another documented runner.
- Run the smallest relevant test first, then the full project command before delivery.
- Run type checks and lint checks that CI treats as required; a passing unit suite is not sufficient evidence by itself.
- Keep snapshots and fixtures small, named, and reviewed when they encode an intentional contract.
- Delete tests that assert no useful behavior only when the replacement coverage is explicit and stronger.
- Treat hard-to-write tests as feedback about object boundaries, dependency direction, or hidden state.

## Size and cohesion heuristics

- Use size as a signal to investigate, not as a universal pass or fail threshold.
- Follow Sandi Metz's practical direction to make smaller objects and methods that know as little about one another as possible.
- Split a method when it mixes abstraction levels, unrelated side effects, or several independent branches.
- Split a class when its methods use disjoint state, serve different actors, or change for unrelated reasons.
- Extract a concept with a domain name, not an arbitrary fragment whose only purpose is to reduce line count.
- Prefer a short public method that composes meaningful messages over many tiny methods with no cohesive story.
- Watch for repeated conditionals on type or role because they often indicate a missing polymorphic boundary.
- Watch for broad constructors with many collaborators because they often indicate misplaced orchestration.
- Watch for long parameter lists and hashes that hide required fields; introduce a value object when the data has a contract.
- Use test setup size, dependency count, branching, and change frequency as stronger signals than raw lines alone.
- Use complexity metrics as comparative evidence across revisions, not as a target to game.
- Do not mechanically extract every expression; preserve locality when extraction would make the design harder to follow.
- Revisit a boundary after the behavior is covered, because a safe refactor is easier to judge with executable examples.

## Sources

### Official Ruby documentation and maintainer tooling

- [Ruby Documentation](https://docs.ruby-lang.org/en/master/index.html) provides the official language and library index.
- [Ruby method syntax](https://docs.ruby-lang.org/en/master/syntax/methods_rdoc.html) documents names, return values, and block arguments.
- [Ruby modules and classes](https://docs.ruby-lang.org/en/master/syntax/modules_and_classes_rdoc.html) documents namespaces, mix-ins, inheritance, and the warning about reopening code you do not own.
- [Ruby exception handling](https://docs.ruby-lang.org/en/master/syntax/exceptions_rdoc.html) documents rescue scope, specific exception classes, retry, and ensure.
- [Ruby Enumerable](https://docs.ruby-lang.org/en/master/Enumerable.html) documents `#each`, collection protocols, predicates, transformations, and enumerators.
- [Ruby Style Guide](https://rubystyle.guide/) documents naming, control flow, exceptions, blocks, and collection idioms.
- [RuboCop configuration](https://docs.rubocop.org/rubocop/latest/configuration.html) documents config lookup, `--config`, target Ruby versions, and defaults.
- [RuboCop inheritance](https://docs.rubocop.org/rubocop/latest/configuration/inheritance.html) documents `inherit_from`, `inherit_gem`, child precedence, and `inherit_mode`.
- [RuboCop style cops](https://docs.rubocop.org/rubocop/latest/cops_style.html) provides the authoritative cop behavior and correction guidance.
- [RBS README](https://github.com/ruby/rbs/blob/master/README.md) is the maintained GitHub example for RBS structure, prototypes, and CLI use.
- [RBS by Example](https://github.com/ruby/rbs/blob/master/docs/rbs_by_example.md) shows Ruby APIs beside precise RBS signatures.
- [RBS signature best practices](https://github.com/ruby/rbs/wiki/Writing-Signatures-Best-Practices) covers `void`, `nil`, `bool`, and signature precision.
- [Sorbet adoption guide](https://sorbet.org/docs/adopting) documents `srb tc`, RBI files, gradual adoption, and source control.
- [Sorbet static checks](https://sorbet.org/docs/static) documents file strictness levels, `sig`, and the cost of disabling checks.
- [Steep README](https://github.com/soutaro/steep) is a maintained GitHub example for `Steepfile`, `sig`, `steep check`, and `rbs prototype`.
- [Minitest README](https://github.com/minitest/minitest) is a maintained GitHub example for unit tests, assertions, and test discovery.

### Community tools and practitioner material

- [RSpec documentation](https://rspec.info/documentation/) documents public APIs, examples, expectations, and test doubles.
- [Sandi Metz's 99 Bottles sample](https://sandimetz.com/99bottles-sample-ruby) directly discusses names, small methods, design, and tests.
- [Sandi Metz's speaking page](https://sandimetz.com/speaking) describes her talks on small objects, object boundaries, and testing.
- [RubyEvents transcript of All The Little Things](https://www.rubyevents.org/talks/all-the-little-things-ruby-on-ales-2014) provides the recorded talk and its practical object-design guidance.
