# Source ledger

Reviewed 2026-08-11. Recheck living framework documentation for the project's installed version before changing this skill. Research entries support risk controls and do not replace repository tests or an approved behavior contract.

| Source | Status on review date | Applied scope |
|---|---|---|
| [OpenAI model guidance for GPT-5.6](https://developers.openai.com/api/docs/guides/latest-model) | Living official guidance | Lean instructions, explicit evidence, and representative evaluation |
| [OpenAI Build skills](https://learn.chatgpt.com/docs/build-skills) | Living official guidance | Focused workflow and progressive disclosure |
| [Martin Fowler, TestDrivenDevelopment](https://martinfowler.com/bliki/TestDrivenDevelopment.html) | First-party author page | Red-green-refactor cycle and incremental behavior development |
| [Martin Fowler, Mocks Aren't Stubs](https://martinfowler.com/articles/mocksArentStubs.html) | First-party author article | Distinguishing state and interaction testing and avoiding mock-heavy design |
| [Gerard Meszaros, xUnit Test Patterns](https://xunitpatterns.com/) | First-party book site | Fixture lifecycle, test doubles, smells, and test organization vocabulary |
| [pytest fixtures](https://docs.pytest.org/en/stable/how-to/fixtures.html) | Living official framework documentation | Fixture scope, dependency, teardown, and isolation for projects using pytest |
| [Testing Library guiding principles](https://testing-library.com/docs/guiding-principles/) | Living official project guidance | User-observable seams and resistance to implementation-coupled tests |
| [EvalPlus, NeurIPS 2023](https://proceedings.neurips.cc/paper_files/paper/2023/hash/43e9d647ccd3e4b7b5baab53f0368686-Abstract.html) | Peer-reviewed research | Expanded hidden tests expose incorrect code that a narrow visible suite misses |
| [SpecBench](https://arxiv.org/abs/2605.21384) | 2026 preprint | Risk of visible-test saturation and fixture-specific reward hacking |
| [Mutation-Guided Unit Test Generation](https://arxiv.org/abs/2506.02954) | Accepted in IEEE TSE, preprint record reviewed | Failure sensitivity is stronger evidence than coverage alone |
