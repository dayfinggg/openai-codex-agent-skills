# Suite architecture

- Keep fast deterministic tests numerous and place slower integration and end-to-end tests at the boundaries where they add unique evidence.
- Separate test categories by dependencies and runtime cost so developers and CI can run the appropriate feedback loop deliberately.
- Share stable helpers, not hidden mutable fixtures or an inheritance hierarchy that obscures setup.
- Treat a test that is difficult to arrange as evidence about dependencies, ownership, or responsibility, then improve the design rather than adding a more powerful mocking framework first.
- Quarantine is a temporary containment action for a diagnosed flaky test, not a final state. Record an owner and remove or repair it promptly.
- Delete obsolete tests when a contract is intentionally removed. Do not preserve assertions for dead behavior.
- Keep production data out of test environments unless an explicit privacy-safe process has transformed and approved it. Prefer deterministic synthetic fixtures that can be recreated from a known state.
- Run expensive instrumentation, sanitizers, model checking, or broad analysis at a cadence proportional to cost when they cannot block every commit, and make their failures owned and actionable.
