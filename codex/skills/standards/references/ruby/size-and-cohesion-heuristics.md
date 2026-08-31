# Size and cohesion heuristics

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
