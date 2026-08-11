# Review Evidence

Reviewed: 2026-08-11.

Use repository rules, the requested contract, and the changed system's definitions before these general references.

[Google Engineering Practices, What to look for in a code review](https://google.github.io/eng-practices/review/reviewer/looking-for.html) supports reviewing correctness, design, complexity, tests, naming, comments, documentation, and style in context. Its central behavioral implication here is to distinguish technical defects from personal preference and to require enough surrounding evidence to judge the change.

[Google Engineering Practices, Small CLs](https://google.github.io/eng-practices/review/developer/small-cls.html) supports self-contained changes and separating unrelated refactoring. Its example line counts are review heuristics, not universal gates. Review the actual contract and risk rather than rejecting a change by size alone.

[Semantic Versioning 2.0.0](https://semver.org/) applies only when the project has adopted SemVer for a declared public API. It can support a compatibility finding about an unversioned breaking public change. It does not make every internal symbol public or impose SemVer on a repository that uses another release contract.
