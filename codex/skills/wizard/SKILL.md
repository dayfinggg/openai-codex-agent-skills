---
name: wizard
description: Create an interactive script for manual setup steps the agent cannot perform.
---

Identify the human-only steps and the values they produce. Use existing project configuration for variable names.
For each value, name its source, destination, and whether it is secret.
Verify dashboard paths and commands against current vendor documentation.
Read [template.sh](scripts/template.sh). Keep its helpers unchanged and replace the stages in run_wizard.
Use the harness's secret-input tool when available, otherwise hidden local input. Never collect credentials in chat.
Keep irreversible actions behind an explicit confirmation.
Save the script to a scratch directory unless a reusable repository wizard is requested.
Check syntax and trace every value to its destination. State that interactive execution remains unverified until the user runs it.
