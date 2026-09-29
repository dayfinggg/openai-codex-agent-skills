# OpenAI Codex Agent Skills

English · [Українська](README.uk.md) · [Русский](README.ru.md)

Fourteen skills copied from the main folders of the user's `.claude/skills`, adapted for Codex without adding or renaming skills, with global instructions following the user's Silent output style.

The `writing-code` skill routes to the relevant language guides, and framework skills retain their supporting files. Proprietary skills from `.claude/skills/synced` and Codex-managed `.system` skills are not included. The imported `skill-creator` retains its Apache 2.0 license. Its instructions use Codex facilities, while its legacy Claude CLI evaluation drivers are not a GPT evaluation workflow.

## Install

Every mode backs up and strictly replaces `base_instructions.md` and all non-system skills. The legacy `model-instructions.md` file is backed up and removed, and its configuration path is updated. Other existing `config.toml` values are preserved, and repository parameters are added only when their keys are missing.

### macOS and Linux

```sh
git clone https://github.com/dayfinggg/openai-codex-agent-skills.git
cd openai-codex-agent-skills
sh scripts/install.sh --replace
```

### Windows PowerShell

```powershell
git clone https://github.com/dayfinggg/openai-codex-agent-skills.git
Set-Location openai-codex-agent-skills
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Mode Replace
```

Replace mode also removes the legacy `AGENTS.md`, `AGENTS.override.md`, and `agents` paths. Merge mode leaves those unrelated paths intact.

The managed configuration uses `model_instructions_file = "base_instructions.md"`, resolved relative to `config.toml`. New configurations default to `gpt-6.1-sol` with high reasoning effort.

## Update

### macOS and Linux

```sh
cd openai-codex-agent-skills
sh scripts/update.sh
```

### Windows PowerShell

```powershell
Set-Location openai-codex-agent-skills
powershell -ExecutionPolicy Bypass -File .\scripts\update.ps1
```

Restart Codex after installation or update. Repository instructions and scripts use the MIT License. Bundled skills retain their own license notices.
