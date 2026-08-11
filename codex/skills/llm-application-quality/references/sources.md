# Sources

Reviewed 2026-08-11. These sources motivate evaluation, safety, and change-control procedures. They do not transfer a reported result automatically to GPT-5.6 or to a different application.

- [OpenAI, Model guidance](https://developers.openai.com/api/docs/guides/latest-model) — lean instructions, controlled comparisons, representative evaluations, and workload-specific configuration.
- [OpenAI, Working with evals](https://developers.openai.com/api/docs/guides/evals) — datasets, graders, comparisons, and reproducible evaluation.
- [OpenAI, Safety best practices](https://developers.openai.com/api/docs/guides/safety-best-practices) — adversarial testing, oversight, and constrained inputs and outputs.
- [OpenAI, Function calling](https://developers.openai.com/api/docs/guides/function-calling) — schemas and tool-call handling.
- [NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework) — risk governance, measurement, and lifecycle controls.
- [Orlanski et al., SlopCodeBench](https://arxiv.org/abs/2603.24755) — longitudinal code erosion and the limits of prompt-only quality guidance.
- [Zhao et al., SpecBench](https://arxiv.org/abs/2605.21384) — reward hacking and the need for hidden composed checks.
- [Thillen et al., CodeTaste](https://arxiv.org/abs/2603.04177) — refactoring quality and evidence for propose-then-implement workflows.
- [Spracklen et al., We Have a Package for You!](https://arxiv.org/abs/2406.10279) — package hallucinations and dependency-confusion risk.
- [Google, Small CLs](https://google.github.io/eng-practices/review/developer/small-cls.html) — focused, reviewable, independently verifiable changes.
- [Lewis et al., Retrieval-Augmented Generation](https://arxiv.org/abs/2005.11401) — separation of retrieval and generation in knowledge-intensive tasks.
- [Asai et al., Self-RAG](https://arxiv.org/abs/2310.11511) — evidence that retrieval should be conditional and evaluated for relevance and support.
- [Schick et al., Toolformer](https://arxiv.org/abs/2302.04761) — learned tool use as a conditional capability rather than a universal action loop.
- [Yao et al., ReAct](https://arxiv.org/abs/2210.03629) — interleaved action and observation for applicable interactive tasks, with transfer limits.
