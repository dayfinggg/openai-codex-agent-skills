Verify observable PHP behavior with the repository's existing test tools.

1. Establish PHP, PHPUnit or Pest versions from the lockfile and installed packages. Read runner configuration, bootstrap, scripts, and nearby tests.
2. Choose the boundary that observes the contract. A pure calculation does not need a database. Transactions, ORM, queues, and middleware need the dependencies that determine their behavior.
3. Derive expected outcomes independently from requirements, established invariants, or known-good behavior. Do not recompute expectations using the algorithm under test.
4. For a defect, reproduce it before the fix where feasible and verify that failure matches the reported symptom. A trivial deterministic change may use an adequate existing check rather than adding a redundant test.
5. Isolate database, queue, filesystem, clock, and external HTTP state. Preserve realistic transaction semantics. A test enclosed in a rollback transaction does not prove after-commit behavior.
6. Execute the target with the installed runner. Check the number of executed tests, skips, and warnings. A successful exit with an empty filter is not verification.
7. Run related checks according to the change's impact. Broaden testing when new uncertainty warrants it, not to repeat checks that already passed.

Avoid assertions about private structure, weakened expectations, and replacing the integration under test with mocks. Use attributes, configuration, and extensions supported by the installed runner.

Read version-matched [PHPUnit](https://docs.phpunit.de/) or [Pest](https://pestphp.com/docs) documentation. Finish with the actual test outcome and material coverage gaps.

