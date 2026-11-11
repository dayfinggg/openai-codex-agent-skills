---
name: handoff
description: Compacts the current conversation into a handoff document that a fresh agent or session can pick up. Use when the user wants to continue the work in a new session or hand it to another agent.
---

<handoff>
Write a handoff document that sums up the current conversation, so a fresh agent can continue the work. Save it where the user names. Otherwise save it to the session's scratchpad or the system's temporary directory, not the current workspace. That directory is `$TMPDIR`, else `/tmp`, and `%TEMP%` on Windows. Give the user the document's absolute path.

The document states the goal, where the work stands, the decisions made and their reasons, the approaches that failed, the checks that were run with their results, and the next unfinished step. Name the skills the next agent should read or invoke through its available skill mechanism.

Do not duplicate content that other artifacts already hold, such as specs, plans, ADRs, issues, commits, and diffs. Reference them by path or URL instead.

Redact sensitive information, such as API keys, passwords, and personally identifiable information.

If the user passed arguments, they describe what the next session will focus on. Tailor the document to that focus.
</handoff>
