# Multi-ticket implementation and review loops

Use this workflow only when the task explicitly calls for multiple implementation tickets or workers and a tracked integration loop. Ordinary code changes and single reviews do not need a ledger or repeated agent rounds.

## Before dispatch

Record the current base revision and the relevant check result. Write down known failures so that later reports do not attribute them to the new work. Give a reviewer the task text, acceptance conditions, base revision, changed-file boundaries, and the actual diff. Do not include a worker's speculation as a review instruction.

## Ledger

Keep a short ledger in the session scratchpad for multi-step work that must survive handoffs. Record completed tasks, checks, review findings, user decisions, and remaining blockers. Use source files, command output, and revision identifiers as evidence. Do not claim a check passed unless it ran and observed the relevant input.

## Fix rounds

Review the first implementation against every acceptance condition. Give confirmed issues to the owning implementer with the exact finding and a check that would expose it. Review only the follow-up diff and do not repeat findings that were already resolved. If the same issue persists across two focused attempts, stop patching and reassess the underlying approach. Keep scope and approval boundaries unchanged during every round.

## Closing

Integrate only changes that fit the user's request and pass the appropriate combined check. Report unresolved findings or checks honestly. A ledger does not authorize commits, pushes, deployment, or external changes.
