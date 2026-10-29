---
name: web-design-guidelines
description: Review changed web UI for accessibility, interaction, focus, forms, and interface-guideline compliance.
---

Read [local host integration](../.shared/host-integration.md) before applying this imported workflow.

# Web Interface Guidelines

Review files for compliance with Web Interface Guidelines.

## How It Works

1. Fetch the latest guidelines from the source URL below
2. Read the specified files (or prompt user for files/pattern)
3. Check against all rules in the fetched guidelines
4. Output findings in the terse `file:line` format

## Guidelines Source

Fetch fresh guidelines before each review:

```
https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md
```

Use WebFetch to retrieve the latest rules. The fetched content contains all the rules and output format instructions.

## Usage

When a user provides a file or pattern argument:
1. Fetch guidelines from the source URL above
2. Read the specified files
3. Apply all rules from the fetched guidelines
4. Output findings using the format specified in the guidelines

If files are not supplied, derive the changed UI from the task, diff, routes, and repository context. Ask only when unresolved scope would materially change the review.
