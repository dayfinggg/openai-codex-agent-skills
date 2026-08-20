# OpenAI Codex Agent Skills

English · [Українська](README.uk.md) · [Русский](README.ru.md)

Thirteen skills for production engineering, project architecture, agent workflows, and clear coding, with concise global instructions and a portable Codex configuration.

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

Use `--merge` or `-Mode Merge` to keep the existing `config.toml` and update only `model-instructions.md` and the skills.

The managed configuration points to `~/.codex/model-instructions.md` through `model_instructions_file`.

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
