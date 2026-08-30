# General software design principles

Use this reference when a change raises questions about duplication, boundaries, abstractions, or structure.
The universal rules and verification workflow live in `SKILL.md`; this file adds rationale, tradeoffs, and source-backed heuristics.
Treat every principle as a decision aid rather than a mechanical rule.

## Use and precedence

Follow explicit requirements, repository instructions, compatibility contracts, and configured checks before applying these heuristics.
When principles conflict, protect correctness and public behavior first, then reader understanding, then changeability and cost.
Prefer evidence from tests, usage, dependency impact, and measurements over personal preference.
Record a deliberate exception when it changes a public contract, hides a tradeoff, or is likely to be revisited.

## KISS: keep the design simple

- Choose the simplest complete design that satisfies current behavior and nonfunctional constraints.
- Simple means easy to explain, test, modify, and operate; it does not mean fewest characters or files.
- Prefer direct control flow and explicit data over clever indirection.
- Prefer a meaningful boundary over a chain of wrappers that only forwards calls.
- A substantial implementation can still be simple when it hides complexity from callers.
- Do not simplify by deleting required validation, error handling, observability, or compatibility behavior.
- Fowler's summary of Beck's simple-design rules puts passing tests, revealed intent, no duplicated logic, and few unnecessary elements ahead of cosmetic brevity.
- Refactor toward clarity when a simpler design becomes visible; do not preserve a poor design because it took effort to write.

## DRY: remove duplicated knowledge

- DRY means one authoritative representation of each piece of knowledge, not zero repeated text.
- Centralize a rule when its changes must happen together and callers need the same invariant.
- Generate derived artifacts from one source when generation is safer than synchronization.
- Extract stable common behavior and pass real variation explicitly.
- Do not combine code merely because its shape looks alike; coincidental similarity creates accidental coupling.
- Keep semantic duplicates separate when policies, versions, owners, or release schedules differ.
- Repeated test setup can be useful when a shared fixture would hide the behavior under test.
- A repeated literal may be harmless when it represents two independent facts; a repeated business rule is a drift risk.
- Fowler's [Avoiding Repetition](https://martinfowler.com/ieeeSoftware/repetition.pdf) separates common parts from variation and warns that some repetition is coincidental.

## YAGNI: build what is needed now

- Do not implement an imagined feature, extension point, option, or abstraction before a real requirement calls for it.
- State the current requirement and the evidence that the extra capability is needed now.
- Future-proofing that adds no complexity is different from speculative behavior that complicates today's path.
- Tests, refactoring, observability, and reversible boundaries make later change safer; they are not future features.
- Security, compatibility, migration, durability, and accessibility work is current scope when the contract requires it.
- Revisit a deferred capability when a real caller, cost threshold, or irreversible decision makes it current.
- Fowler's [YAGNI](https://martinfowler.com/bliki/Yagni.html) defers presumptive features and future-flexibility abstractions that add present complexity.

## Cohesion and coupling

- Cohesion is the degree to which a module's data, behavior, and decisions belong to one concept or change together.
- Put an invariant beside the data and operations that own it.
- One responsibility means one coherent reason to change, not one method or one arbitrary file.
- High cohesion reduces the places a reader must inspect for one behavior.
- Coupling is the knowledge and coordination one module requires from another.
- Minimize coupling by hiding representation, policy, lifecycle, and failure details behind a small contract.
- Do not pursue zero coupling; collaboration is normal, but callers should depend on stable meaning rather than implementation detail.
- A dependency is healthy when its contract is clear, its direction is intentional, and its change impact is predictable.
- Ousterhout's [modular-design notes](https://web.stanford.edu/~ouster/cgi-bin/cs190-winter18/lecture.php?topic=modularDesign) favor independent modules, information hiding, and interfaces simpler than implementations.
- Splitting a cohesive module can increase coupling through pass-through calls, shared state, and duplicated knowledge.

## Abstraction timing

- Start with the smallest concrete design that exposes the real requirement.
- Let multiple real uses reveal what is invariant, what varies, and what callers need.
- Treat duplication as a signal to investigate, not an automatic command to extract.
- A useful abstraction has a precise name, a coherent responsibility, a stable contract, and a cost justified by current callers.
- A speculative abstraction predicts future variation before the domain supplies evidence.
- Warning signs include flags, mode parameters, caller-specific branches, unused options, and names that need long explanations.
- If callers need incompatible behavior, split or inline the abstraction, remove irrelevant branches, and then extract any common concept that remains.
- Sandi Metz's [The Wrong Abstraction](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction) argues that temporary duplication is cheaper than preserving a condition-heavy abstraction that no longer represents one concept.
- Kent Beck's [Canon TDD](https://newsletter.kentbeck.com/p/canon-tdd) calls duplication a hint rather than a command and places implementation refactoring after a passing behavior.
- Design a boundary early when current requirements already have multiple implementations, a costly migration, or a safety and compatibility constraint.

## Readable APIs

- A caller should understand what an operation does, costs, mutates, returns, and can fail from its name, signature, and focused documentation.
- Name behavior rather than a private mechanism, and distinguish local work from network, disk, blocking, caching, or destructive work.
- Prefer explicit result values and structured options over hidden output mutation and positional booleans.
- Use domain types or enums when primitives would permit invalid states or make a call ambiguous.
- Keep public visibility narrow and hide representation so implementations can change without forcing callers to change.
- Document preconditions, postconditions, side effects, ownership, errors, panics, and cancellation when they are not obvious.
- Keep naming and word order consistent with the surrounding ecosystem because consistency makes APIs predictable.
- Use a test or example call site as a design probe for awkward names and accidental implementation dependencies.
- The [Google C++ Style Guide](https://google.github.io/styleguide/cppguide) favors return values, clear parameter meaning, focused functions, and usage-oriented API comments.
- Google's [Go naming decisions](https://google.github.io/styleguide/go/decisions.html) relate name length to scope and reject meaningless package names and ambiguous abbreviations.
- The [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/) treat naming, predictability, documentation, type safety, and future-proofing as interoperability concerns.

## File, module, and function sizing

- Choose a file boundary around one cohesive concept, ownership area, or change reason.
- Split when unrelated responsibilities, review noise, navigation cost, or independent lifecycle make the boundary clearer.
- Keep a larger file when splitting would create shallow wrappers, scatter one invariant, or force readers across many files for one operation.
- Choose a function boundary around a meaningful operation with a clear input, output, and failure story.
- Split when control flow, state, dependencies, or failure paths become hard to read, test, debug, or reuse.
- Keep a longer function when its steps form one coherent algorithm and extraction would hide necessary relationships.
- Treat line counts as investigation signals, never universal acceptance criteria.
- Google recommends small focused functions, sets no hard length limit, and suggests reconsidering a function at about 40 lines when splitting would preserve structure.
- Ousterhout notes that long methods can be valid when their pieces are relatively independent and that module depth matters more than making every class tiny.
- Avoid one-line wrappers, pass-through methods, and files that exist only to satisfy a number.
- A short function can still be complex if it invokes many abstractions, branches on hidden state, or needs non-local knowledge.

## Avoid duplication without overengineering

- Remove duplicated knowledge first, then check whether the proposed abstraction increases coupling or hides intent.
- Prefer visible semantic repetition over a generic framework with unused hooks.
- Do not add factories, plugin registries, dependency containers, or directory hierarchies without a current problem they solve.
- Do not add a dependency for a trivial operation when its weight, lifecycle, or API cost exceeds its benefit.
- Do not optimize a suspected hotspot before measuring it unless a hard budget or safety requirement already proves the constraint.
- Evolutionary design means making small changes, checking behavior, and refactoring when evidence supports a better boundary.
- Fowler's [Is Design Dead?](https://martinfowler.com/articles/designDead.html) connects simplicity, testing, refactoring, and gradual architecture instead of speculative flexibility.
- Ousterhout's [strategic-programming notes](https://web.stanford.edu/~ouster/cgi-bin/cs190-winter18/lecture.php?topic=working) distinguish continual design investment from tactical shortcuts that accumulate complexity.

## Decision rules

- If two pieces must change together, seek one source of truth; if they change independently, keep them separate.
- If a second use is almost the same, compare semantics and change reasons before extracting; a third confirming use often supplies better evidence.
- If an abstraction needs a flag or branch for each caller, stop adding parameters and reassess the boundary.
- If a module exposes internal decisions, move those decisions behind the module and simplify the contract.
- If a split creates pass-through methods or duplicated state, undo the split or move the boundary.
- If a function is hard to test, identify the dependency or responsibility causing the difficulty before merely shortening it.
- If performance is suspected, measure the relevant path, isolate the hotspot, change only that path, and remeasure.
- If an API is hard to call correctly, improve its types, names, result shape, or documentation before adding convenience wrappers.

## Counterexamples

- Duplicate test setup can make each scenario self-contained and easier to understand.
- Separate transport, domain, cache, and persistence representations can be correct when their contracts or lifecycles differ.
- A component or handler can contain trivial local state; move logic when coupling or test difficulty appears, not because a slogan demands a new file.
- A large cohesive module can be better than many shallow modules that leak the same decisions.
- A general abstraction can be correct when current requirements already need several implementations; YAGNI does not forbid necessary design.
- A measured optimization can justify less obvious code, but the benchmark and constraint must remain visible.
- Full test coverage is not the same as useful confidence; prioritize behavior and risk.

## Verification

- Follow the repository's configured formatter, linter, compiler or type checker, build, tests, and documentation checks.
- Inspect the final diff for duplicated knowledge, new public surface, dependency direction, hidden behavior, and unrelated churn.
- Exercise public APIs from a caller's perspective and verify error and side-effect documentation.
- Use a profiler or relevant performance tool for performance claims and compare before and after measurements.
- Ask a second reader to review a non-obvious boundary or abstraction.
- Prefer a change that measurably improves code health over cosmetic perfection, consistent with Google's [code-review standard](https://google.github.io/eng-practices/review/reviewer/standard.html).

## Sources

### Practitioner and original guidance

- [Martin Fowler: YAGNI](https://martinfowler.com/bliki/Yagni.html)
- [Martin Fowler: Is Design Dead?](https://martinfowler.com/articles/designDead.html)
- [Martin Fowler: Avoiding Repetition](https://martinfowler.com/ieeeSoftware/repetition.pdf)
- [Kent Beck: Canon TDD](https://newsletter.kentbeck.com/p/canon-tdd)
- [Sandi Metz: The Wrong Abstraction](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction)
- [John Ousterhout: CS 190 introduction](https://web.stanford.edu/~ouster/cgi-bin/cs190-winter21/lecture.php?topic=intro)
- [John Ousterhout: Modular Design](https://web.stanford.edu/~ouster/cgi-bin/cs190-winter18/lecture.php?topic=modularDesign)
- [John Ousterhout: Working Isn't Good Enough](https://web.stanford.edu/~ouster/cgi-bin/cs190-winter18/lecture.php?topic=working)

### Official engineering guidance

- [Google C++ Style Guide](https://google.github.io/styleguide/cppguide)
- [Google Go style decisions](https://google.github.io/styleguide/go/decisions.html)
- [Google: The Standard of Code Review](https://google.github.io/eng-practices/review/reviewer/standard.html)
- [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
- [Rust API Guidelines: Naming](https://rust-lang.github.io/api-guidelines/naming.html)
- [Rust API Guidelines: Documentation](https://rust-lang.github.io/api-guidelines/documentation.html)
- [Rust API Guidelines: Predictability](https://rust-lang.github.io/api-guidelines/predictability.html)
- [Rust API Guidelines: Future proofing](https://rust-lang.github.io/api-guidelines/future-proofing.html)
