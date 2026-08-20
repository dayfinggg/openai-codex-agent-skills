# Official sources

Use the source that matches the language, platform, or risk. Project guidance and current official documentation take precedence over this summary.

| Source | Use it for |
| --- | --- |
| [OpenAI GPT-5.6 model guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-5.6) | Lean instructions, context, hard constraints, approval boundaries, and success criteria |
| [Google code review practices](https://google.github.io/eng-practices/review/reviewer/looking-for.html) | Design, functionality, complexity, tests, naming, documentation, consistency, and code health |
| [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html) | Readability, complexity, short-function heuristics, safe language features, and measured optimization |
| [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) | Long-term maintainability, consistency, strict dependencies, and automated formatting |
| [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html) | Source layout, naming, line width, formatting, and public documentation |
| [Python PEP 8](https://peps.python.org/pep-0008/) | Readability, local consistency, layout, imports, naming, and compatibility |
| [Rust Style Guide](https://doc.rust-lang.org/style-guide/) | Formatter-first style, line width, small diffs, readability, and consistent layout |
| [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/) | Predictable APIs, type safety, validation, error behavior, interoperability, and future-proofing |
| [Microsoft C# coding conventions](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions) | Current language features, analyzers, editor configuration, correctness, and consistency |
| [.NET Runtime coding style](https://github.com/dotnet/runtime/blob/main/docs/coding-guidelines/coding-style.md) | Repository-local consistency, formatting, naming, and preserving existing file style |
| [Effective Go](https://go.dev/doc/effective_go) | Simplicity, idiomatic construction, formatter use, naming, and explicit error handling |
| [TypeScript Do's and Don'ts](https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html) | Safe types, avoiding `any`, sound callbacks, and clear public declarations |
| [OWASP Secure Coding with AI](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Coding_with_AI_Cheat_Sheet.html) | AI-specific dependency, prompt-injection, test-integrity, scope, secret, and supply-chain risks |
| [OWASP Input Validation Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html) | Boundary validation, allowlists, type and length limits, canonicalization, and server-side checks |
| [OWASP Error Handling Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Error_Handling_Cheat_Sheet.html) | Safe failure responses, controlled disclosure, logging, and error boundaries |

Use these sources to guide decisions, not to paste a language-specific rule into an unrelated project. Prefer evidence from the actual repository and its toolchain.

## Universal foundations

| Source | Use it for |
| --- | --- |
| [NIST Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final) | Security requirements, protected source and builds, component provenance, verification, and response |
| [OWASP Business Logic Security](https://cheatsheetseries.owasp.org/cheatsheets/Business_Logic_Security_Cheat_Sheet.html) | Semantic validation, state transitions, resource limits, and abuse-resistant workflows |
| [MITRE CWE-362](https://cwe.mitre.org/data/definitions/362.html) | Shared-state races, check-and-act hazards, and synchronization decisions |
| [Google SRE monitoring](https://sre.google/sre-book/monitoring-distributed-systems/) | Workload-based measurement, user impact, and performance evidence |
| [Parnas modularization paper](https://doi.org/10.1145/361598.361623) | Information hiding, change isolation, cohesion, and comprehensible interfaces |
| [Matt Pocock codebase design](https://github.com/mattpocock/skills/blob/main/skills/engineering/codebase-design/SKILL.md) | Deep modules, narrow public seams, deletion tests, and avoiding speculative abstraction |
| [Cursor agent best practices](https://cursor.com/blog/agent-best-practices) | Narrow context, lightweight planning, local verification, and incremental agent work |
