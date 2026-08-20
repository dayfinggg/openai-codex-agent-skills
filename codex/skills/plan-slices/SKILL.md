---
name: plan-slices
description: Break multi-layer work into small, independently verifiable vertical slices.
---

Use this skill when a change spans several files, layers, services, or user-visible behaviors.

Create a small execution plan whose slices cross the smallest complete path through the affected system. Give every slice one observable acceptance criterion, one focused verification, and explicit blockers. Order slices by risk and dependency, keep exactly one active task, and update the plan as evidence changes. Prefer one complete tracer slice over a horizontal batch of unrelated edits. Do not expose the internal plan unless the user asks for it.
