# Sources

Reviewed 2026-08-11. Reported benchmark results are workload-specific and do not establish that one model or prompt will behave the same way in another repository.

- [Orlanski et al., SlopCodeBench](https://arxiv.org/abs/2603.24755) — code erosion across sequential coding-agent changes and limits of prompt-only quality guidance.
- [Zhao et al., SpecBench](https://arxiv.org/abs/2605.21384) — reward hacking and the value of hidden composed tests.
- [Thillen et al., CodeTaste](https://arxiv.org/abs/2603.04177) — LLM refactoring quality and propose-then-implement comparisons.
- [Xu, Yang, and Chen, SWE-Refactor](https://arxiv.org/abs/2602.03712) — behavior-preserving compound-refactor evaluation.
- [Haroon, Khan, and Gulzar, Test Generation Under Software Evolution](https://arxiv.org/abs/2603.23443) — test robustness across evolving code.
- [Cui et al., PERFOPT-Bench](https://arxiv.org/abs/2607.07744) — correctness-aware performance optimization evaluation.
- [Chen et al., Performance-Optimization Benchmark Reliability](https://arxiv.org/abs/2607.01211) — benchmark shortcuts and reliability threats.
- [Liu et al., EvalPlus](https://proceedings.neurips.cc/paper_files/paper/2023/hash/43e9d647ccd3e4b7b5baab53f0368686-Abstract.html) — strengthened hidden test suites for generated code.
- [Wang et al., Mutation-Guided Unit Test Generation](https://arxiv.org/abs/2506.02954) — mutation-guided assessment of test sensitivity.
- [Spracklen et al., We Have a Package for You!](https://arxiv.org/abs/2406.10279) — package hallucinations and dependency-confusion risk.
- [Eghbali and Pradel, De-Hallucinator](https://arxiv.org/abs/2401.01701) — repository-grounded mitigation of API hallucinations.
- [Google, Small CLs](https://google.github.io/eng-practices/review/developer/small-cls.html) — focused, reviewable changes.
- [Google, What to look for in a code review](https://google.github.io/eng-practices/review/reviewer/looking-for.html) — complexity, tests, naming, comments, and documentation review.
- [Google SRE, Operational Simplicity](https://sre.google/sre-book/simplicity/) — simplicity as an operational reliability property.
- [Google Go Style Guide, least mechanism](https://google.github.io/styleguide/go/guide.html) — prefer the least powerful sufficient mechanism.
- [OpenAI, Model guidance](https://developers.openai.com/api/docs/guides/latest-model) — lean prompts and controlled workload-specific evaluations.
- [Semantic Versioning 2.0.0](https://semver.org/) — compatibility implications of public API changes.
