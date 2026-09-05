# OpenAI Codex Agent Skills

English · [Українська](README.uk.md) · [Русский](README.ru.md)

Twenty skills for production engineering, project architecture, agent workflows, and clear coding, with concise global instructions and a portable Codex configuration.

The `standards` skill routes to small responsibility-focused files under `codex/skills/standards/references/<domain>/`. Research coverage, the analytical video transcript, and before-and-after code examples are under `docs/`.

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

The managed configuration uses `model_instructions_file = "base_instructions.md"`, resolved relative to `config.toml`. New configurations default to GPT-6 Astra with low reasoning effort.

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
