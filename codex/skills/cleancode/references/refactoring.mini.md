These rules come from Refactoring by Martin Fowler. A refactor changes structure in small steps and keeps observable behavior the same.

<when_to_use>
Use them when the user asks for a refactor or cleanup, or when you review one. Also use them when a requested feature or fix needs a preparatory refactor.
</when_to_use>

<primary_bias>
Refactoring is design work in small steps that preserve behavior. Cleanup must not turn into a rewrite, a hidden feature change, or speculative architecture.
</primary_bias>

<decision_rules>
- Preserve observable behavior during a refactor. Keep behavior changes apart from structural changes. Never disguise a feature, migration, or redesign as cleanup.
- Work in small steps that stay reversible, buildable, and testable. Group related refactorings, and split a patch that is too large to reason about locally. Do not rename, move, redesign, and change logic in one patch.
- Before a risky refactor, find or build a safety net. Use characterization tests for unclear behavior. Update tests only to match intended behavior.
- Around feature work, find what makes the requested change awkward. Reshape that local structure first when it makes the change safer or simpler. Then make the behavior change, and clean up the debt that change added.
- Refactor the smell that blocks the current change, not every smell in sight. Typical blockers are duplication, long functions, long parameter lists, globals, divergent change, and shotgun surgery. Others are feature envy, primitive obsession, repeated conditionals, temporary fields, middle men, and speculative generality.
- Prefer the simplest named move that helps. Rename, extract, inline, move, split a variable with two meanings, or introduce a parameter object or value object. Other moves encapsulate a field or collection, decompose a conditional, add guard clauses, or substitute a clearer algorithm.
- Make names and functions reveal intent. Rename first when bad names block understanding. Keep each function coherent and at one level of abstraction, with tight variable scope and separate phases.
- Put behavior and state with the concept that owns them. Split a class or module that has several reasons to change. Keep business policy apart from formatting, transport, persistence, I/O, frameworks, and integration code.
- Keep data, mutation, and call contracts explicit. Avoid boolean flags that switch behavior, confusing argument order, and parameter reassignment. Also avoid exposed mutable collections, needless setters, public fields, and duplicated state-transition logic.
- Simplify conditionals honestly. Guard clauses, extracted predicates, lookup tables, and merged duplicate fragments help. Use state, strategy, polymorphism, or null objects only when they remove repeated branching or clarify real variation.
- Remove pass-through layers, vague utilities, middle men, unused hierarchy, and just-in-case interfaces. The deletion test in the `design` skill shows which ones to remove.
- Preserve error semantics unless the behavior change is intended. Refactor error handling so the main path shows, and merge duplicate validation, cleanup, and recovery code.
- Stop when the requested change is easy and the blocking smell is gone. Also stop when the next cleanup would be speculative.
</decision_rules>

<trigger_rules>
- When you add behavior, first ask what structural friction blocks the change. Refactor first only when that makes the feature safer or simpler.
- When you fix a bug in unclear code, characterize the current failure first. Refactor only enough to make the fix visible, then change the behavior.
- When tests are absent or weak, make the smallest possible structural move. Improve testability before any broader cleanup.
- When a function mixes responsibilities, abstraction levels, phases, or hidden side effects, fix that before you add logic. Rename, extract, split phases, or isolate side effects.
- When one change forces edits across many files, centralize the knowledge or draw a clearer boundary.
- When repeated conditionals or type codes grow, decompose the intent first. Introduce polymorphism, state, strategy, or a table only when the variation is real.
- When UI and domain behavior mix, move the rules toward domain objects. Then verify that the presentation still stays in sync.
- When a rewrite tempts you, choose the next small transformation that preserves behavior and recovers control.
</trigger_rules>

<final_checklist>
- Is observable behavior preserved?
- Are structural changes, behavior changes, and test updates separate where practical?
- Is the safety net in place, or is the verification gap stated in the report?
- Did the change remove at least one real source of friction?
- Are names, responsibilities, control flow, data ownership, and interfaces clearer?
- Is the patch still reviewable and runnable?
- Did cleanup stop before speculative abstraction or a rewrite took over?
</final_checklist>
