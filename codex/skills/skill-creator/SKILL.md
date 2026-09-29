---
name: skill-creator
description: Create, revise or evaluate a reusable skill and improve its task-specific trigger description. Use when the user asks for skill instructions or a skill evaluation.
---

# Skill Creator

This workflow comes from Claude's skill-creator and uses the tools actually available in Codex. Preserve the user's skill name and destination. A narrow edit does not need a full evaluation campaign.

## Define and write

Use the conversation and existing artifacts to establish the task, trigger boundary, expected result and required tools. Ask only for missing information that changes the result. Write a concise SKILL.md with name and description in YAML frontmatter. Describe the real workflow and when it applies, without pushy catchall triggers or assumptions about model weaknesses.

Keep non-obvious decisions and essential constraints in the main file. Route detailed modes, schemas and reusable mechanics to existing references or scripts, loading them only when the task needs them. Explain why a fragile operation requires its sequence. Let Codex choose ordinary implementation details.

Preserve scope, permissions and project conventions. Do not require unrelated deliverables, automatic external actions, a fixed number of steps or permanent evaluation artifacts for a simple edit.

## Evaluate when needed

Use realistic requests, including a close negative case for the description. Check observable outcomes, not whether the model repeats prescribed wording. Compare against the original skill or a no-skill baseline when that comparison answers the user's question.

Run evaluation tasks with authorized tools and side effects. Use Codex subagents only when session rules allow delegation. Give an independent evaluator the request and raw artifacts, not the desired answer or prior conclusions. When independent execution is unavailable, distinguish a local check from a benchmark.

Read [agents/grader.md](agents/grader.md) to grade expectations, [agents/comparator.md](agents/comparator.md) for blind comparison and [agents/analyzer.md](agents/analyzer.md) for benchmark analysis. Read [references/schemas.md](references/schemas.md) only when producing the corresponding evaluation files.

Use scripts/aggregate_benchmark.py for existing compatible run results. Use eval-viewer/generate_review.py or assets/eval_review.html when the user requests a review artifact. Inspect help, dependencies and output paths before running them. Prefer a static report if no display is available.

The copied scripts/run_eval.py, scripts/run_loop.py and scripts/improve_description.py call Claude and do not evaluate Codex. Do not run them as a GPT benchmark or substitute another provider. Use the session's authorized Codex execution facilities instead, and report when the required evaluation capability is missing.

## Improve and finish

Review actual failures and feedback. Remove ineffective or redundant guidance before adding more rules. Keep descriptions short and discriminating. Avoid overfitting one example or turning a one-off preference into a universal restriction.

Validate frontmatter, names, reference paths and required resources. Run scripts/quick_validate.py when its dependencies are available. Test changed executable resources through their supported interface. Package with scripts/package_skill.py only when packaging is requested.

Report completed changes and what was actually checked. Treat claimed quality improvements as unverified until representative usage supports them. Stop when the requested result is achieved or a concrete blocker prevents it, not only after a mandatory human-review loop.
