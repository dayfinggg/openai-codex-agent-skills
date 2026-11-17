---
name: autonomous-run
description: Carry an explicitly unattended, headless, or multi-session task through its stated finish condition. Use when the user says to continue without check-ins, work until a result, or resume long-running work after compaction. Do not infer a persistent Codex Goal from an ordinary task.
license: MIT
---

# Unattended runs

Use this skill when the user expects work to proceed without routine check-ins, through a headless run, or across compaction. Ordinary interactive tasks do not need a progress log solely because they take several steps.

Define the finish condition from the user's request and the check that would prove it. Read applicable project instructions and existing run records before continuing earlier work. Make reversible choices within scope and keep moving on work that does not depend on user input. Do not broaden authorization, contact people, or make hard-to-reverse external changes beyond what the request permits.

For a run likely to span sessions or compaction, read [Long-run record and stopping conditions](references/long-runs.md) before setting up its records. Use the runtime's Goal tools only when the user explicitly requests a persisted goal or the environment has already established one. Never create a Goal merely because this workflow is active.
