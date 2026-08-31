# OpenAI Codex Agent Skills

[English](README.md) · Українська · [Русский](README.ru.md)

Двадцять навичок для промислової розробки, архітектури проєктів, агентних процесів і зрозумілого коду, стислі загальні інструкції та переносима конфігурація Codex.

## Встановлення

Кожен режим створює резервну копію та повністю замінює `model-instructions.md` і всі несистемні навички. Наявні значення `config.toml` зберігаються, а параметри з репозиторію додаються лише за відсутності відповідних ключів.

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

Режим заміни також видаляє застарілі шляхи `AGENTS.md`, `AGENTS.override.md` і `agents`. Режим злиття залишає ці сторонні шляхи без змін.

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
