---
name: documentation-writing
description: Write and maintain project documentation. Use when creating or updating README files, guides, API references, runbooks, architecture decision records, or changelogs, including documentation needed for the current implementation task. Do not use solely to research external documentation or answer an ordinary chat question.
---

Document verified behavior for a specific reader and task. Preserve the user's requirements, the project's language, and its established format. This skill does not authorize additional documents, code changes, publication, or Git operations beyond the requested work.

1. Find the repository rules, existing documentation, and the source of the behavior being described. Compare the implementation, public interface, configuration, dependency versions, and executed checks. Distinguish implemented behavior, proposals, and unknown conditions. Do not document an assumption as an established contract.

2. Choose the form that serves the reader's need. A tutorial supports learning, a how-to guide solves a specific task, a reference describes an interface precisely, and an explanation develops understanding of the design and its reasons. Do not reorganize existing documentation solely to impose this classification. This distinction follows [Diátaxis](https://diataxis.fr/).

3. Update the existing source of truth alongside the related implementation change. Link to maintained material instead of duplicating rules. Correct outdated statements in affected sections while preserving useful historical context. Do not add a README, report, plan, or changelog unless the task or repository rules require it. This approach follows [Google's documentation practices](https://google.github.io/styleguide/docguide/best_practices.html).

4. Lead with the outcome, purpose, or condition of use. State required versions, prerequisites, and the working directory when their omission would make the instructions ambiguous. Use exact parameter names, paths, commands, and interface labels. Follow the project's presentation conventions and the user's requirements. Add structure, tables, and examples only where the requested document needs them.

5. In a how-to guide, put actions in execution order and explain how to verify the result. Keep material limitations, required access, and data-changing consequences beside the affected action. Do not run a destructive command or mutate an external system solely to verify documentation without authorization for that action.

6. For an API reference, describe actual inputs, required fields, defaults, outputs, errors, and access restrictions within the changed contract. For a runbook, cover verifiable starting conditions, outcome checks, and recovery when required by the task. For an architecture decision record, preserve the context, accepted decision, and material consequences. For a changelog, describe user impact and necessary migration steps for incompatibilities. Do not present a proposal as an accepted decision or an unreleased change as a release.

7. Run the available checks relevant to the changed document. Check local links, anchors, paths, parameter names, and version accuracy. Run the existing documentation build, linter, or example checks when relevant. Verify commands in a safe environment when authorized and necessary. Do not invent successful output or treat valid Markdown formatting as proof that the documented behavior works.

8. Review the final diff for accuracy, duplication, secrets, and unrelated changes. Briefly report the result and executed checks. State any required but unperformed check, its concrete reason, and what remains unconfirmed. For authorized commits or publication, use the available [Git workflow skill](../git-change-workflow/SKILL.md). A documentation edit does not authorize a push.
