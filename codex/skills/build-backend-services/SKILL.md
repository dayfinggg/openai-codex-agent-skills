---
name: build-backend-services
description: "Use as primary whenever implementing or concretely specifying backend behavior, including services, handlers, webhooks, workers, consumers, jobs, transactions, retries, and integrations—even without file edits. Always pair $engineer-production-code."
---

# Build Backend Services

Use this as the primary workflow for designing or implementing complete backend behavior in an existing service. Combine it with `$engineer-production-code` and the relevant language or framework skill. Treat verified API contracts and database schemas as inputs unless the request explicitly includes changing them; invoke architecture, API, database, testing, or security skills only for a material specialist decision.

## Understand the Existing Service

- Read applicable instructions, manifests, configuration, entry points, routing, dependency wiring, error handling, persistence and integration code, and nearby tests.
- Trace the affected request, message, or job from ingress through every side effect and response. Identify trust boundaries, ownership of state, cancellation paths, and existing failure behavior.
- Establish the required observable behavior and business invariants. Request material missing requirements instead of inventing endpoints, schemas, credentials, or dependency behavior.
- Reuse the repository's framework, layering, abstractions, configuration facilities, and test harness. Do not introduce a new framework, speculative distributed pattern, or parallel service architecture.

## Implement the Complete Flow

- Keep responsibilities at the project's established boundaries. Parse and validate external data at ingress, authorize before protected effects, enforce invariants at an authoritative boundary, and map errors consistently.
- Use the existing configuration system. Keep secrets out of source and logs, reject invalid required configuration early, and avoid environment-specific defaults that conceal misconfiguration.
- Make each state change atomic at the business boundary. Follow the existing transaction mechanism and avoid holding transactions across remote calls unless the verified contract requires it.
- Implement real integration behavior at existing seams. Do not add fake production adapters, placeholder responses, silent fallbacks, or unfinished branches.
- Preserve existing API and persistence contracts unless their change is requested. Use `design-api-contracts` or `design-databases` when contract or schema design is part of the task.

## Control Failure and Lifecycle

- Define the success, timeout, cancellation, retry, duplicate-delivery, partial-failure, and shutdown outcomes relevant to the changed flow before finalizing the implementation.
- Read [reliability-controls.md](references/reliability-controls.md) when the work includes remote I/O, transactions, parallelism, background execution, retries, shutdown, telemetry, or sensitive data. Apply only the sections relevant to the actual failure model.
- Preserve useful error context without exposing secrets or internal details across public boundaries. Make operational failures observable through the repository's established logging, metrics, and tracing facilities.

## Verify Behavior

- Add focused tests for the successful path and material boundaries. Cover invalid input, authorization, dependency failure, transaction rollback, cancellation, concurrency, repeated delivery, and shutdown only when they are plausible for the changed flow.
- Assert observable contracts and side effects rather than implementation structure. Use the project's real test seams and keep test doubles confined to tests.
- Run the narrow formatter, static checks, tests, and build for the affected service. Inspect the final diff for contract drift, unbounded work, duplicated effects, leaked sensitive data, and changes outside the requested scope.
