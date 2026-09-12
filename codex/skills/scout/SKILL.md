---
name: scout
description: Map relevant code, runtime flow, and ownership for orientation or placement questions. Read-only exploration, without design or implementation.
---

# Scout

Build a compact, evidence-backed map of the relevant code instead of summarizing the repository broadly.

## Explore

Start from the named entry point, or locate it from the requested behavior. Trace calls, data, state, errors, and side effects until ownership is clear. Use targeted reads of source, tests, and configuration rather than directory-wide loading.

Record the role of each important file, the public boundary between components, the authoritative source of data, and any generated or external layer. Distinguish verified behavior from an inference.

## Answer the actual question

For a walkthrough, describe runtime flow in execution order. For a placement question, identify the owning module and the precedent that supports it. For onboarding, give a mental model and a short reading path. For a change investigation, identify likely touch points without proposing an implementation.

## Boundaries

Do not edit files. Do not infer intent from names when implementation or tests can establish it. Do not expand into an architecture review unless the user asks for judgment.

## Output

Answer the requested orientation or placement question using the relevant entry point, flow, file links, and uncertainty. Include a reading path or next action only when requested.
