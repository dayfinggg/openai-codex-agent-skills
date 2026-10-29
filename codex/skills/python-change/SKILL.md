---
name: python-change
description: "Implement, fix, or refactor Python with environment, typing, async cancellation, and resource verification. Use for Python application or package changes."
---

Use the project environment and verify behavior on its supported Python versions.

1. Read manifests, lockfiles, analysis settings, and test configuration. Identify the actual interpreter and existing environment manager. Do not mix system dependencies into the application environment.
2. Find the changed contract and its callers. Inspect exceptions, result shapes, mutable state, and missing-value handling. Preserve external formats and minimum Python compatibility.
3. For async changes, identify task ownership, cancellation, and cleanup. Do not swallow CancelledError through a broad handler. Preserve cancellation semantics after necessary cleanup.
4. Check whether blocking clients run on the event loop. Use a supported async client or the project's existing mechanism for blocking work. Moving an operation to a thread does not automatically make it cancellable.
5. Manage files, connections, and sessions with clear lifetimes. Check ORM-session scope and sharing between tasks. Do not change concurrency for hypothetical performance gains.
6. Make the smallest change and run configured formatting, linting, typing, and relevant tests. For defects, exercise the regression and cleanup after failure.
7. For packages, check the supported version matrix when API availability or packaging changes.

Do not introduce a package manager, framework, or stricter configuration without task justification. For Django, FastAPI, or SQLAlchemy, consult the changed behavior in the installed version's official documentation.

Verify task, timeout, and cancellation semantics against [Python asyncio](https://docs.python.org/3/library/asyncio-task.html).

