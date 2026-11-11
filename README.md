# Codex instructions and skills

A portable configuration for GPT-6.1 Sol, GPT-6.1 Terra, GPT-6 Astra, and GPT-6 Luna, synchronized with the current local setup.

The payload contains 24 engineering skills, the Concise operating instructions, and portable settings. Each skill keeps its entry point in `SKILL.md`, guidance in `references`, runnable helpers in `scripts`, and reusable examples in `assets`. Source attribution and redistribution terms live in the distribution `LICENSE`. No custom agent definitions are installed. Codex supplies its own system skills and discovers available tools at runtime.

The skills and operating rules follow Concise 0.33.0, including its complete writing style and configured Russian response language. The base starts from the GPT-6.1 Sol instruction template shipped to Codex 0.167.1 on November 11, 2026. Targeted replacements remove conflicting presentation defaults and adapt Claude tools and paths to Codex. Skill descriptions, entry points, references, scripts, and assets retain the source workflows, with Codex-specific invocation guidance.

One set of writing rules covers every text written for people, including subagent reports unless their task requests another form. Replies open with the answer and use plain paragraphs, with numbered lists only for steps the user performs. Notes appear only when the plan changes, a problem appears, or the work reaches its next stage. Skills load only when their descriptions cover the work, and relevant references are read completely. Checks and reviews follow the source's risk-based rules, with no repeated checks after the result already covers the current state. The base also carries the source's rules for work on shared systems, for secrets in command output, for waiting on jobs, and for work that another agent delegated. See [synchronization details](docs/synchronization.md) for source accounting, adaptations, and official documentation.

## Install

Clone this repository or download its archive, then run the installer from the repository folder.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

```sh
sh scripts/install.sh
```

Replace mode backs up and replaces non-system skills, custom agents, and shared instructions, removing retired entries and legacy global AGENTS files. Credentials, sessions, plugins, system skills, and unrelated files remain in place. Existing configuration values are preserved and missing defaults are added. The instruction file is connected as `base_instructions.md`.

The portable defaults select GPT-6.1 Sol with high reasoning, low response verbosity, live web search, and GPT-6 Luna with maximum reasoning for subagents. They also set `approval_policy = "never"` and `sandbox_mode = "danger-full-access"`. Review [the configuration](codex/config.toml) before installation.

Start a new Codex session after installation. See [installation details](docs/installation.md) for merge mode and custom locations.

## Update

Run `scripts/update.ps1` in PowerShell or `sh scripts/update.sh` on macOS or Linux. A Git checkout can instead use `git pull --ff-only` followed by the installer. Updates reuse the last installation mode.

## Contents

- [Operating instructions](codex/base_instructions.md)
- [Engineering skills](codex/skills)
- [Portable configuration](codex/config.toml)

Machine paths, project trust entries, account state, session history, generated system skills, and desktop settings are excluded. Telegram notifications remain available for future repository updates. This is an independent configuration, not an official OpenAI distribution.
