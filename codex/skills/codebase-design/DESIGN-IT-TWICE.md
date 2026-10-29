# Design It Twice

When the user wants to explore alternative interfaces for a chosen deepening candidate, use this comparative design procedure. Based on "Design It Twice" (Ousterhout): your first idea is unlikely to be the best.

Uses the vocabulary in [SKILL.md](SKILL.md): **module**, **interface**, **seam**, **adapter**, **leverage**.

## Process

### 1. Frame the problem space

Establish the problem space for the chosen candidate from available code and requirements:

- The constraints any new interface would need to satisfy
- The dependencies it would rely on, and which category they fall into (see [DEEPENING.md](DEEPENING.md))
- A rough illustrative code sketch to ground the constraints, not a proposal, just a way to make the constraints concrete

Keep routine design notes internal. Surface a material unresolved requirement through the host's question tool, and continue independent work.

### 2. Develop independent alternatives

Develop materially different interfaces directly in the current agent. Compare only alternatives that address a real design uncertainty. Separate agents are optional when explicitly authorized.

Give each alternative a separate technical brief (file paths, coupling details, dependency category from [DEEPENING.md](DEEPENING.md), what sits behind the seam). The brief is independent of the user-facing problem-space explanation in Step 1. Evaluate different design constraints:

- Alternative 1 "Minimize the interface: aim for 1–3 entry points max. Maximise leverage per entry point."
- Alternative 2 "Maximise flexibility: support many use cases and extension."
- Alternative 3 "Optimise for the most common caller: make the default case trivial."
- Alternative 4 when applicable "Design around ports & adapters for cross-seam dependencies."

Include both [SKILL.md](SKILL.md) vocabulary and GLOSSARY.md vocabulary in the brief so each alternative names things consistently with the architecture language and the project's domain language.

Record for each alternative:

1. Interface (types, methods, params, plus invariants, ordering, error modes)
2. Usage example showing how callers use it
3. What the implementation hides behind the seam
4. Dependency strategy and adapters (see [DEEPENING.md](DEEPENING.md))
5. Trade-offs: where leverage is high, where it's thin

### 3. Present and compare

Compare alternatives internally and present the selected design and material tradeoffs in the user's requested format. Show alternatives only when requested. Contrast by **depth** (leverage at the interface), **locality** (where change concentrates), and **seam placement**.

After comparing, give your own recommendation: which design you think is strongest and why. If elements from different designs would combine well, propose a hybrid. Be opinionated: the user wants a strong read, not a menu.
