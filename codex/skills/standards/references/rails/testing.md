# Testing

- Keep tests focused on observable behavior and use the Rails test type that matches the boundary under test.
- Test models for validations, associations, scopes, constraints, and domain behavior.
- Test requests or integration flows for routing, authorization, parameters, status codes, and rendered outcomes.
- Test jobs with the Active Job test helpers and assert both enqueueing and meaningful work.
- Use system tests for a small set of critical browser workflows, not for every branch or form field.
- Prefer fast unit, model, request, and job tests for most cases, then cover high-value end-to-end paths.
- Keep fixtures or factories consistent with the repository and make records valid by default.
- Test failure paths explicitly, including rollback, retry, authorization denial, malformed input, and missing records.
- Assert query counts or instrumentation in hot paths when query behavior is an intentional contract.
- Run tests against the supported database adapter because constraint and transaction behavior can differ.
- Parallelize only when tests isolate data, time, filesystem state, and global configuration.
- Do not make tests depend on callback order or private implementation details unless that order is the contract.
- Keep tests deterministic, independent, and safe to rerun after a failed job or rollback.
