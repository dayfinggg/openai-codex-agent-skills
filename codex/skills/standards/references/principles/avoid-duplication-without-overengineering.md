# Avoid duplication without overengineering

- Remove duplicated knowledge first, then check whether the proposed abstraction increases coupling or hides intent.
- Prefer visible semantic repetition over a generic framework with unused hooks.
- Do not add factories, plugin registries, dependency containers, or directory hierarchies without a current problem they solve.
- Do not add a dependency for a trivial operation when its weight, lifecycle, or API cost exceeds its benefit.
- Do not optimize a suspected hotspot before measuring it unless a hard budget or safety requirement already proves the constraint.
- Evolutionary design means making small changes, checking behavior, and refactoring when evidence supports a better boundary.
- Fowler's [Is Design Dead?](https://martinfowler.com/articles/designDead.html) connects simplicity, testing, refactoring, and gradual architecture instead of speculative flexibility.
- Ousterhout's [strategic-programming notes](https://web.stanford.edu/~ouster/cgi-bin/cs190-winter18/lecture.php?topic=working) distinguish continual design investment from tactical shortcuts that accumulate complexity.
