# Codex instructions and skills

A portable configuration for GPT-6.1 Sol, GPT-6.1 Terra, GPT-6 Astra, and GPT-6 Luna, synchronized with the current local setup.

The payload contains 39 engineering skills with their shared resources, the complete operating instructions, and portable settings. No custom agent definitions are installed. Codex supplies its own system skills and discovers available tools at runtime.

The instructions require complete retrieval and verification within the requested scope, concise answers in the user's language, plain natural wording, and evidence for completion claims. Lists and tables remain available when useful. They do not install response filters, enforcement hooks, or notification integrations.

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
