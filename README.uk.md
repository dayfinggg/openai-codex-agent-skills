# OpenAI Codex Agent Skills

[English](README.md) · Українська · [Русский](README.ru.md)

Двадцять навичок для промислової розробки, архітектури проєктів, агентних процесів і зрозумілого коду, стислі загальні інструкції та переносима конфігурація Codex.

## Встановлення

Режим заміни створює резервну копію та замінює керовані файли Codex.

### macOS і Linux

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

Використовуйте `--merge` або `-Mode Merge`, щоб зберегти наявний `config.toml` і оновити лише `model-instructions.md` та навички.

Керована конфігурація підключає інструкцію через `model_instructions_file = '~/.codex/model-instructions.md'`.

## Оновлення

### macOS і Linux

```sh
cd openai-codex-agent-skills
sh scripts/update.sh
```

### Windows PowerShell

```powershell
Set-Location openai-codex-agent-skills
powershell -ExecutionPolicy Bypass -File .\scripts\update.ps1
```

Після встановлення або оновлення перезапустіть Codex. Ліцензія MIT.
