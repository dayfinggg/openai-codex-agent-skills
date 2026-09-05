---
name: scout
description: Map an unfamiliar codebase, trace runtime flow, locate ownership, and identify the files that matter. Use for codebase orientation, onboarding, placement questions, and investigation before planning. This is a read-only skill and does not design or implement changes.
---

# Scout

Follow the governing instructions and the user's requirements for communication, code style, authorization, and delegation. This skill supplies task-specific guidance, not permission to expand the task. Its workflow and output fields describe internal checks and relevant content, not a mandatory response layout or a progress report. When used within broader authorized work, continue that work through completion rather than stopping to deliver this skill's intermediate result.

Build a compact, evidence-backed map of the relevant code instead of summarizing the repository broadly.

## Explore

Start from the observable entry point named by the user. Trace calls, data, state, errors, and side effects until responsibility becomes clear. Read tests and configuration only where they explain behavior. Prefer searches and targeted reads over directory-wide loading.

Record the role of each important file, the public boundary between components, the authoritative source of data, and any generated or external layer. Distinguish verified behavior from an inference.

## Answer the actual question

For a walkthrough, describe runtime flow in execution order. For a placement question, identify the owning module and the precedent that supports it. For onboarding, give a mental model and a short reading path. For a change investigation, identify likely touch points without proposing an implementation.

## Boundaries

Do not edit files. Do not infer intent from names when implementation or tests can establish it. Do not expand into an architecture review unless the user asks for judgment.

## Output

Answer the requested orientation or placement question using the relevant entry point, flow, file links, and uncertainty. Include a reading path or next action only when requested.
