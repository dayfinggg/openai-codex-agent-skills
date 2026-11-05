---
name: documentation
description: Writes or updates READMEs, guides, API references, runbooks, ADRs, and changelogs for a specific reader. Use when the user asks for a README, documentation, a guide, a runbook, a changelog, an ADR, or an API reference. Not ordinary chat answers or external-documentation research.
---

1. Identify the reader, task, and existing source of truth. Match each changed behavioral claim to implementation, configuration, a versioned contract, or an executed example. Distinguish shipped behavior, unreleased changes, proposals, and unknowns. Preserve the project's document language and format.

2. Choose the needed form using [Diataxis](https://diataxis.fr/). A tutorial teaches through a guided exercise, a how-to completes a task, a reference specifies facts, and an explanation develops understanding. Keep these reader needs distinct without imposing a repository-wide reorganization. Link to maintained facts rather than copying them.

3. Include the content the requested artifact needs.

- A README identifies purpose, supported setup, the shortest verified route to first use, and links to detailed material.
- A guide states prerequisites, supported versions, working directory, ordered actions, and observable success conditions. Put access requirements and data-changing consequences beside the affected action.
- An API reference specifies actual inputs, defaults, outputs, errors, and access restrictions.
- A runbook starts from a verifiable symptom and conditions, then gives bounded actions, success checks, stopping or escalation conditions, and applicable recovery. Separate read-only diagnostics from state-changing remediation.
- An ADR records one decision's context, status, rationale, and positive and negative consequences. Keep superseded decisions and link their replacements. Never promote a proposal to accepted without evidence of agreement.
- A changelog states user-visible changes, release status, incompatibilities, and necessary migration actions. Do not claim an unreleased change shipped.

4. Validate the changed reading path. Check local links and anchors, referenced paths, exact names, versions, and the relevant existing documentation build or example checks. Run commands only in an authorized safe environment. Destructive commands and external mutations require their own authorization even when printed in a guide. Mark an unexecuted example as such instead of inventing successful output.
