# Test purpose and boundaries

- State the behavior, scenario, and observable outcome before choosing the test type.
- Trace important tests to a material requirement, invariant, failure mode, or design decision so the suite protects intended behavior rather than incidental implementation.
- Use a unit test for deterministic behavior owned by the code under test and an integration or contract test where framework, serialization, persistence, network, process, or runtime behavior matters.
- Test through a supported public or module boundary. Do not expose or reflect into private implementation solely to make a test possible.
- Keep a focused end-to-end path for critical user outcomes even when lower layers have comprehensive tests.
- A regression test should fail for the original defect and pass only after the behavior is corrected.
- Prefer the cheapest test that can actually detect the risk. Do not mock away the behavior whose compatibility you need to prove.
- Use a small number of end-to-end tests to prove that entry points and real adapters are wired, broad service or use-case tests for behavior through stable application boundaries, and focused domain tests where combinatorial rules need faster feedback.
- Treat error handling, rollback, degraded operation, and recovery as behaviors that require tests, not as operational documentation outside the product contract.
- Test representative authorization profiles across allowed and denied read, write, bulk, delete, administrative, and temporary-access operations when those capabilities exist.
- When adopting or upgrading version-sensitive third-party behavior with real compatibility risk, write a small executable learning or contract test for the exact property the code relies on. Keep volatile vendor types behind an adapter when that risk justifies it, and retain the test as evidence for future upgrades.
