# OpenAI Codex Agent Skills

[English](README.md) · [Українська](README.uk.md) · Русский

Шестнадцать навыков для промышленной разработки и дизайна, краткие общие инструкции и минимальная конфигурация Codex.

## Установка

Режим замены создает резервную копию и заменяет управляемые файлы Codex.

### macOS и Linux

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

Используйте `--merge` или `-Mode Merge`, чтобы сохранить существующий `config.toml` и добавить только `AGENTS.override.md` и навыки.

## Обновление

### macOS и Linux

```sh
cd openai-codex-agent-skills
sh scripts/update.sh
```

### Windows PowerShell

```powershell
Set-Location openai-codex-agent-skills
powershell -ExecutionPolicy Bypass -File .\scripts\update.ps1
```

После установки или обновления перезапустите Codex. Лицензия MIT.
