---
name: background-job-change
description: "Change queue consumers, scheduled tasks, or background workers with duplicate-delivery, retry, timeout, shutdown, and commit-boundary verification."
---

Verify the worker's delivery contract and side effects.

1. Establish the queue or scheduler, client and broker versions, message shape, acknowledgment policy, concurrency, and worker lifecycle. Read both producers and consumers of the changed event.
2. Determine the actual delivery semantics and what happens after a process crash. Do not assume exactly-once execution from an acknowledgment setting or deduplication name.
3. Trace writes, external effects, and acknowledgment relative to commit. Define idempotency at the business operation where required. Repeating a non-idempotent external request needs a supported reconciliation strategy.
4. Distinguish transient and permanent failures. Preserve supported event types, ordering requirements, and retry policy. Bound attempts, time, and concurrency using existing operational constraints.
5. Check poison-message handling, dead-letter or failed-job retention, cancellation, and graceful shutdown. Do not acknowledge work before its durable result unless the established contract intentionally does so.
6. Make the smallest correction. Reuse the existing queue framework and transactional outbox or deduplication mechanism when present. Do not introduce a new broker for a local reliability issue.
7. Verify the normal path, duplicate delivery, relevant partial failure, exhausted retry, and interruption between the side effect and acknowledgment. Inspect observable state and message lifecycle rather than only handler return values.

Read the broker and framework documentation matching installed versions. For PHP testing, read the [PHP testing procedure](../php-change/references/testing/guide.md). Use symfony-diagnostics for Symfony-specific operational evidence when needed. Finish with the original delivery contract preserved or an explicitly requested contract change verified.

