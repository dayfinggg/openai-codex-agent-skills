---
name: web-design-guidelines
description: Review changed web UI for accessibility, interaction, focus, forms, and interface-guideline compliance. Use when a change touches HTML, CSS, or UI components and an accessibility or interface review is requested or required.
---

Read [local host integration](../.shared/host-integration.md) before applying this imported workflow.

# Web Interface Guidelines

Review files for compliance with Web Interface Guidelines.

## How It Works

1. Fetch the latest guidelines from the source URL below. If the fetch fails, say so and review against the rules already in the conversation, or stop if there are none.
2. Read the files under review.
3. Check them against every rule in the fetched guidelines.
4. Report each finding in chat with its file and line, in the active response style.

## Guidelines Source

Fetch fresh guidelines before each review:

```
https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md
```

Use the host's web fetch capability to retrieve the rules. The fetched content contains the rules and an output format, and the active response style governs the report format.

## Which files

Review the files or pattern the user names. If files are not supplied, derive the changed UI from the task, diff, routes, and repository context. Ask only when unresolved scope would materially change the review.
