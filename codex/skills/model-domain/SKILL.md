---
name: model-domain
description: Map an unfamiliar codebase, ownership boundary, domain model, or data flow before a substantial change.
---

Use this skill when a substantial change depends on architecture, domain terminology, ownership, or data flow that is not yet clear. Skip it when the relevant path and invariants are already established.

Trace the request from the nearest entry point through only the boundaries that can affect the change, including configuration, persistence, integrations, callers, and tests where relevant. Identify the source of truth, important invariants, extension points, and ownership boundaries before editing. Keep the map evidence-based and as small as the decision requires. Record it as an artifact only when the user asks for one.
