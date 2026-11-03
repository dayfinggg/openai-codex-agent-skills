---
name: symfony-diagnostics
description: "Diagnose Symfony request errors, latency, DI wiring, environment loading, or log patterns using available project tools and the appropriate evidence source. Use when a Symfony application fails, is slow, or injects the wrong service, and the task supplies a request, a profiler token, or a log."
---

Establish the Symfony application, relevant request or time interval, and available project tools. Select the sharpest evidence source already identified by the task.

Read [host integration](../.shared/host-integration.md) once for the imported procedures.

| Symptom or available evidence | Read |
|---|---|
| The cause is unexplained and the evidence source is unknown | [Request triage](references/triage/guide.md) |
| A failed or slow request has a usable profiler token | [Profiler debugging](references/profiler/guide.md) |
| The question spans requests, time, frequency, or log context | [Log investigation](references/logs/guide.md) |
| An injected service, tag, listener, or decorator is wrong | [Service inspection](references/services/guide.md) |
| An environment variable is missing, stale, or loaded unexpectedly | [Environment diagnostics](references/environment/guide.md) |

Skip triage when the task already identifies the correct source. Keep tool-runtime failures separate from application failures. For a suspected Mate PHP runtime problem, use the [PHP environment procedure](../php-change/references/environment/guide.md). For dependency identity or an API-version mismatch, use [PHP dependency versions](../php-change/references/versions/guide.md).

Use the Symfony Mate tools (its CLI and MCP server) when the project has them installed. Otherwise inspect the same evidence through the application's existing CLI, profiler, and logs. Do not install Mate or change production diagnostics merely to satisfy a procedure's example. Never expose raw secret values.

