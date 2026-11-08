These rules come from Code Complete by Steve McConnell. They cover construction discipline that lowers defect risk and keeps code easy to inspect.

<when_to_use>
Use them when you implement, change, review, or tune production code.
</when_to_use>

<primary_bias>
Construction quality is not accidental. Code that works once, or that uses a clever idiom, is not finished construction. Choose the option that lowers defect risk and makes the code easier to reason about.
</primary_bias>

<decision_rules>
- Before large construction work, check that requirements, architecture fit, and major risks are clear enough. Also check the error policy, data representation, integration, and test approach.
- When upstream uncertainty remains, build a small validated slice instead of speculative code. Decide deliberately when a choice is expensive to reverse.
- Optimize first for human readers. Clarity, locality, explicitness, and visible control flow beat cleverness, fewer keystrokes, or fashion.
- Keep routines cohesive and precisely named. Separate setup, validation, computation, and side effects when they are different concepts.
- Make the meaning of variables and data explicit. Use names that reveal purpose, small scope, deliberate initialization, and named constants. Use stronger types, and make units and sentinel meanings visible.
- Choose data types that make invalid or ambiguous values hard to represent. Use booleans only for true binary meanings and enumerations for closed sets. Use records, maps, or tables only when their shape carries meaning.
- Keep control flow simple enough to verify. Keep nesting shallow, name complex conditions as predicates, and keep the normal path clear. Make loop initialization, termination, and update obvious. Avoid expressions that depend on side effects, and avoid clever one-liners.
- Use table-driven logic for stable, explicit mappings only when the table is clearer than the branches. The table must stay in sync with the rules and must be validated. Do not hide complex behavior in an obscure encoding.
- Use validation or domain errors for expected external or business failures.
- Handle errors at the right level of abstraction, and keep their diagnostic context. Treat similar failures the same way, and keep the normal path readable. Never continue silently from a corrupted or impossible state.
- Keep classes and modules focused and cohesive. Do not mix persistence, formatting, business, and integration concerns in one place.
- Treat rising complexity as defect risk. Split tangled routines, and reduce what a maintainer must hold in working memory.
- Build in small, verifiable increments. Integrate often enough to expose conflicts early.
- Tune performance only when requirements and evidence justify it. Measure before and after, and keep clarity unless a measured tradeoff warrants the cost.
</decision_rules>

<trigger_rules>
- When coding starts from a proposed solution, first check it against the requirement, the architecture fit, the risks, and the success criteria.
- When a routine is hard to name, mixes phases, or has flag arguments, redesign its interface or split it. Long parameter lists and hidden side effects call for the same fix.
- Readers should not have to decode units, ranges, precision, encoding, ownership, status, or magic values. Move that meaning into names, constants, types, or structures.
- When input crosses a trust boundary, decide what is validated, rejected, recovered from, and kept diagnosable.
- When branches, loops, recursion, exits, or exception paths become hard to verify, simplify them before you add logic.
- When repeated branching maps stable categories, ranges, conversions, or dispatch rules, consider a validated table.
- When a class or module exposes its representation, grows into a god object, or mixes responsibilities, restore the abstraction boundary.
- When you write tests, cover the normal, boundary, and invalid-input cases, not only the happy path.
- When performance work begins, set a target and measure the current behavior. Change one thing at a time, measure again, and report any loss of clarity.
</trigger_rules>

<final_checklist>
- Are requirements, architecture fit, risks, and the construction approach clear enough?
- Do names, routines, data, and classes reduce reader effort?
- Are inputs, errors, contracts, invariants, impossible states, and trust boundaries deliberate?
- Are control flow, loops, tables, recursion, exits, and exception paths simple enough to inspect?
- Do tests, reviews, and tuning rest on evidence?
- Is the change small enough to verify, and would it stand up to careful review?
</final_checklist>
