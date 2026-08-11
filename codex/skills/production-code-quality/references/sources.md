# Sources

Reviewed 2026-08-11. Prefer current project, platform, and language documentation when it governs the changed behavior. These sources support engineering judgment. They do not replace repository policy or evidence from the system under change. Book entries record partial public author or publisher material unless the linked work is openly complete, and they do not claim full access to paid texts. Tool defaults are recorded as provenance for fallback review policy, not as universal language limits.

## Engineering and operations

- [Google Engineering Practices](https://google.github.io/eng-practices/) — small, reviewable changes and evidence-focused review.
- [Software Engineering at Google](https://abseil.io/resources/swe-book) — sustainable software over time, scale, and trade-offs.
- [Google SRE Book](https://sre.google/sre-book/table-of-contents/) — reliability, incident response, release engineering, and postmortems.
- [DORA software delivery performance metrics](https://dora.dev/guides/dora-metrics/) — outcome measures for continuous improvement.
- [Jeff Erickson, *Algorithms*](https://jeffe.cs.illinois.edu/teaching/algorithms/book/Algorithms-JeffE.pdf) — algorithm selection, complexity, dynamic programming, graphs, flows, and explicit worst-case limits.
- [Pat Morin, *Open Data Structures*](https://www.aupress.ca/app/uploads/120226_99Z_Morin_2013-Open_Data_Structures.pdf) — operation-sensitive data-structure costs and measured algorithmic trade-offs.
- [Allen B. Downey, *The Little Book of Semaphores*](https://greenteapress.com/semaphores/LittleBookOfSemaphores.pdf) — synchronization invariants, bounded buffers, progress, and concurrency failure patterns.
- [NIST SP 800-204A](https://csrc.nist.gov/pubs/sp/800/204/a/final) — security, resiliency, traffic control, and observability for service-to-service systems.
- [NIST SP 800-204C](https://csrc.nist.gov/pubs/sp/800/204/c/final) — risk-based DevSecOps controls and observable delivery gates.

## Readability and design

- [Dustin Boswell and Trevor Foucher, *The Art of Readable Code*](https://www.oreilly.com/library/view/the-art-of/9781449318482/) — reader-oriented naming, control flow, and expression design.
- [Robert C. Martin, *Clean Code, 2nd Edition*](https://www.informit.com/store/clean-code-a-handbook-of-agile-software-craftsmanship-9780135398517) — function responsibilities, naming, and structural clarity.
- [John Ousterhout, *A Philosophy of Software Design, 2nd Edition*](https://web.stanford.edu/~ouster/cgi-bin/aposd.php) — deep modules, information hiding, interface simplicity, and total complexity.
- [Steve McConnell, *Code Complete, 2nd Edition*](https://www.informit.com/store/code-complete-9780735619678) — construction design, cohesion, abstraction, and defensive programming.
- [David Thomas and Andrew Hunt, *The Pragmatic Programmer, 20th Anniversary Edition*](https://imagery.pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/) — authoritative knowledge, shared state, and bounded feedback steps.
- [Mark Seemann, *Code That Fits in Your Head*](https://www.informit.com/store/code-that-fits-in-your-head-heuristics-for-software-9780137464319) — cognitive load, troubleshooting, and change safety.
- [Brian W. Kernighan and Rob Pike, *The Practice of Programming*](https://www.cs.princeton.edu/~bwk/tpop.webpage/) — simplicity, interfaces, testing, debugging, and performance measurement.

## Code shape, naming, and file roles

- [ESLint size and complexity rules](https://eslint.org/docs/latest/rules/) and [Checkstyle size checks](https://checkstyle.org/checks/sizes/) — tool-specific defaults and counting semantics for functions, files, depth, complexity, parameters, and line width.
- [PEP 8](https://peps.python.org/pep-0008/), [Black code style](https://black.readthedocs.io/en/stable/the_black_code_style/current_style.html), [Prettier options](https://prettier.io/docs/options.html#print-width), and [Google Java Style](https://google.github.io/styleguide/javaguide.html) — incompatible but authoritative ecosystem conventions showing why repository configuration has priority.
- [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments#line-length) and [Effective Go](https://go.dev/doc/effective_go) — semantic readability and formatting without a universal Go source-line maximum.
- [PMD 7.0.0 release notes](https://pmd.github.io/2024/03/22/PMD-7.0.0/) — removal of raw excessive class and method length rules in favor of structural measures.
- [Sonar metric definitions](https://docs.sonarsource.com/sonarqube-cloud/digging-deeper/metric-definitions) and Sonar's [default-threshold rationale](https://community.sonarsource.com/t/s3776-reason-for-the-current-default-value-of-15/127103) — distinction between cyclomatic and cognitive complexity and the empirical, configurable nature of thresholds.
- [Nest CLI](https://docs.nestjs.com/cli/usages), [Nest modules](https://docs.nestjs.com/modules), and [Nest database integration](https://docs.nestjs.com/techniques/database) — TypeScript role suffixes, feature modules, and the non-mandatory nature of repository wrappers.
- [Next.js project structure](https://nextjs.org/docs/app/getting-started/project-structure), [FastAPI larger applications](https://fastapi.tiangolo.com/tutorial/bigger-applications/), [Python packaging layouts](https://packaging.python.org/en/latest/discussions/src-layout-vs-flat-layout/), [Node package entry points](https://nodejs.org/api/packages.html#package-entry-points), and [Go code organization](https://go.dev/doc/code) — framework and ecosystem-specific file contracts.
- [Prisma migration histories](https://www.prisma.io/docs/orm/prisma-migrate/understanding-prisma-migrate/migration-histories), [pytest good practices](https://docs.pytest.org/en/stable/explanation/goodpractices.html), and [Nest testing](https://docs.nestjs.com/fundamentals/testing) — migration immutability and runner-specific test discovery and placement.

## Formatter and DSL mechanics

- [Ruff formatter](https://docs.astral.sh/ruff/formatter/), [Black style](https://black.readthedocs.io/en/stable/the_black_code_style/current_style.html), [Prettier options](https://prettier.io/docs/options.html), and [Prettier CLI](https://prettier.io/docs/cli.html) — configured resolution, non-mutating checks, indentation defaults, and the distinction between a wrapping target and a hard maximum.
- [Effective Go](https://go.dev/doc/effective_go), [Rust Style Guide](https://doc.rust-lang.org/style-guide/), [Google Java Style](https://google.github.io/styleguide/javaguide.html), and [Kotlin conventions](https://kotlinlang.org/docs/coding-conventions.html) — mechanically or explicitly defined indentation, width, naming, and file conventions where those ecosystems actually provide them.
- [`dotnet format`](https://learn.microsoft.com/dotnet/core/tools/dotnet-format), [C# identifier naming](https://learn.microsoft.com/dotnet/csharp/fundamentals/coding-style/identifier-names), [ClangFormat](https://clang.llvm.org/docs/ClangFormat.html), [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/), and [`swift-format`](https://github.com/swiftlang/swift-format) — formatter checks, naming morphology, configuration discovery, and explicit evidence that Swift formatter output is not a universal language style.
- [SQLFluff configuration](https://docs.sqlfluff.com/en/stable/configuration/setting_configuration.html), [`shfmt`](https://github.com/mvdan/sh), [PSScriptAnalyzer](https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/using-scriptanalyzer), and [YAML 1.2.2](https://yaml.org/spec/1.2.2/) — dialect-sensitive SQL, shell formatting and analysis, PowerShell rules, and YAML's spaces-only indentation requirement.
- [Dockerfile reference](https://docs.docker.com/reference/dockerfile), [Docker build checks](https://docs.docker.com/reference/build-checks/), [NGINX command-line parameters](https://nginx.org/en/docs/switches.html), and [NGINX configuration syntax](https://nginx.org/en/docs/beginners_guide.html) — canonical syntax, case conventions, and parser checks without inventing a formatter standard.

## Simplicity and agent-generated change

- [OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model) — compact non-duplicative instructions, representative evaluation, and evidence-led agent behavior.
- [Google review guidance on over-engineering](https://google.github.io/eng-practices/review/reviewer/looking-for.html), [small changes](https://google.github.io/eng-practices/review/developer/small-cls.html), [Go least mechanism](https://google.github.io/styleguide/go/guide.html), and [Google SRE simplicity](https://sre.google/sre-book/simplicity/) — current requirements before generality, bounded diffs, and the least sufficient mechanism.
- [SlopCodeBench v2](https://arxiv.org/abs/2603.24755), [SpecBench](https://arxiv.org/abs/2605.21384), [SWE-Refactor](https://arxiv.org/abs/2602.03712), and [CodeTaste v2](https://arxiv.org/abs/2603.04177) — 2026 preprints on accumulated structural erosion, visible-test overfitting, compound-refactor risk, and proposal selection.
- [De-Hallucinator](https://arxiv.org/abs/2401.01701) and [We Have a Package for You!](https://arxiv.org/abs/2406.10279) — empirical evidence for grounding project APIs and verifying package identity before adding dependencies.

## Performance evidence

- [Google Benchmark user guide](https://google.github.io/benchmark/user_guide.html), [Brendan Gregg's performance methodology](https://www.brendangregg.com/methodology.html), and [Google SRE monitoring](https://sre.google/sre-book/monitoring-distributed-systems/) — benchmark setup, bottleneck localization, resource signals, and result interpretation.
- [PERFOPT-Bench](https://arxiv.org/abs/2607.07744) and [Are Performance-Optimization Benchmarks Reliably Measuring Coding Agents?](https://arxiv.org/abs/2607.01211) — 2026 preprints supporting repeated controlled measurement, independent correctness, and caution about unstable benchmark rankings.

## Language practice

- [Brett Slatkin, *Effective Python, 3rd Edition*](https://effectivepython.com/) — Python-specific readability, iteration, packaging, exceptions, migration, and typing candidates.
- [Joshua Bloch, *Effective Java, 3rd Edition*](https://www.informit.com/store/effective-java-9780134686059) — Java generics, resources, API contracts, exceptions, and concurrency candidates.
- [Dan Vanderkam, *Effective TypeScript, 2nd Edition*](https://effectivetypescript.com/) — TypeScript inference, assertions, domain modeling, unsafe-type containment, and compiler configuration candidates.
- [J. Guy Davidson and Kate Gregory, *Beautiful C++*](https://www.informit.com/store/beautiful-c-plus-plus-30-core-guidelines-for-writing-9780137647910) — rationale-led application of the C++ Core Guidelines.
- [Python documentation](https://docs.python.org/3/), [PEP 8](https://peps.python.org/pep-0008/), and [Python typing](https://typing.python.org/) — current Python language, style, packaging, and static-typing contracts.
- [Java Language Specification](https://docs.oracle.com/javase/specs/), [Dev.java generics](https://dev.java/learn/generics/), and [Java SE API](https://docs.oracle.com/en/java/javase/25/docs/api/) — current Java language and library contracts.
- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html) and [TSConfig reference](https://www.typescriptlang.org/tsconfig/) — current TypeScript type-system and compiler-option contracts.
- [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines) — current C++ ownership, global-state, resource, interface, and safety guidance.

## Secure development

- [NIST Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final) — secure development practices and common vocabulary.
- [OWASP Developer Guide](https://owasp.org/www-project-developer-guide/) — practical security orientation for developers.
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/) — focused implementation guidance.
- [OWASP Application Security Verification Standard](https://owasp.org/www-project-application-security-verification-standard/) — versioned security verification requirements for web applications and APIs.

## Change, refactoring, and delivery

- [Michael Feathers, *Working Effectively with Legacy Code*](https://www.oreilly.com/library/view/working-effectively-with/0131177052/) — characterization, seams, and safe changes in unfamiliar code.
- [Martin Fowler, *Refactoring*](https://martinfowler.com/books/refactoring.html) — small behavior-preserving transformations.
- [David Farley, Continuous Delivery](https://continuousdelivery.com/) — deployable software, small batches, and low-risk release practice.

## Lectures and talks

- [Modern Software Engineering — Dave Farley](https://www.youtube.com/watch?v=80LbSyTCKas) — feedback, small steps, experimentation, and empirical engineering.
- [Working Effectively with Legacy Code — Michael Feathers](https://www.youtube.com/watch?v=P_6eDL1aqtA) — characterization, seams, and bounded change in unfamiliar systems.
- [Software Engineering at Google — Titus Winters](https://www.youtube.com/watch?v=NNMnbBf0Itw) — engineering across time, scale, and trade-offs.
- [Canon TDD — Kent Beck](https://www.youtube.com/watch?v=90VBvjYedWI) — the test-first cycle and the limits of the method.
- [Martin Fowler's videos](https://martinfowler.com/videos.html) — first-party talk index for refactoring, testing, architecture, and delivery.
