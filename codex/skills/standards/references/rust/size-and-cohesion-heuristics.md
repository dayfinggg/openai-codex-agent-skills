# Size and cohesion heuristics

There is no universal function or module line limit; cohesion, coupling, and reviewability are better signals.
Split a function when it mixes validation, I/O, policy, transformation, and formatting that can change independently.
Split a module when its items serve different domain concepts, invariants, owners, or reasons to change.
Keep a small wrapper intact when splitting it would hide the control flow or create a pass-through abstraction.
Treat repeated fixtures, unrelated imports, long parameter lists, and difficult lifetimes as cohesion warnings.
Treat many public re-exports, feature conditions, or dependency edges as boundary warnings.
Prefer one clear ownership story per function and one clear invariant per type.
Use compile time, test time, and navigation cost as practical signals when deciding whether a boundary helps.
Revisit a boundary when callers need private details, when tests duplicate internals, or when changes require edits across many modules.
