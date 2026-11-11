<smell_baseline>
This file is the smell baseline of the Standards axis. It is a fixed set of Fowler code smells from Refactoring, chapter 3. Each entry says what the smell is and then how to fix it. Match each one against the diff. Every smell is a judgement call, so label it as a heuristic, as in "possible Feature Envy", never as a hard violation. A documented repo standard always wins over the baseline, and anything tooling already enforces is skipped.
- Mysterious Name means a function, variable, or type whose name hides what it does or holds. Rename it, and if no honest name comes, the design is murky.
- Duplicated Code means the same logic shape appears in more than one hunk or file in the change. Extract the shared shape, and call it from both places.
- Feature Envy means a method that reaches into another object's data more than its own. Move the method onto the data it envies.
- Data Clumps means the same few fields or parameters keep travelling together, so a type wants to be born. Bundle them into one type, and pass that.
- Primitive Obsession means a primitive or string stands in for a domain concept that deserves its own type. Give the concept its own small type.
- Repeated Switches means the same `switch` or `if` cascade on the same type recurs across the change. Replace it with polymorphism, or with one map that both sites share.
- Shotgun Surgery means one logical change forces scattered edits across many files in the diff. Gather what changes together into one module.
- Divergent Change means one file or module is edited for several unrelated reasons. Split it, so each module changes for one reason.
- Speculative Generality means abstraction, parameters, or hooks added for needs the spec does not have. Delete it, and inline it back until a real need shows.
- Message Chains means long `a.b().c().d()` navigation that the caller should not depend on. Hide the walk behind one method on the first object.
- Middle Man means a class or function that mostly just delegates onward. Cut it, and call the real target directly.
- Refused Bequest means a subclass or implementer that ignores or overrides most of what it inherits. Drop the inheritance, and use composition.
</smell_baseline>
