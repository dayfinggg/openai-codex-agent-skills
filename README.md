# OpenAI Codex Agent Skills

English · [Українська](README.uk.md) · [Русский](README.ru.md)

Sixteen production engineering and design skills, concise global instructions, and a minimal Codex configuration.

## Install

Replace mode backs up and replaces the managed Codex files.

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

Use `--merge` or `-Mode Merge` to keep the existing `config.toml` and add only `AGENTS.override.md` and the skills.

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

Restart Codex after installation or update. MIT License.
