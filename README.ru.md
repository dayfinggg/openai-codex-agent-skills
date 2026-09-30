# OpenAI Codex Agent Skills

[English](README.md) · [Українська](README.uk.md) · Русский

Пятнадцать навыков для инженерных задач, архитектуры, дизайна интерфейсов и настоящего 3D в Codex. Общая инструкция сохраняет правила стиля Silent.

Навык `writing-code` направляет к правилам нужного языка. Навыки для прикладных библиотек сохраняют свои дополнительные файлы. Закрытые навыки из `.claude/skills/synced` и системные навыки Codex не включены. Импортированный `skill-creator` сохраняет лицензию Apache 2.0. Его инструкция использует средства Codex. Старые программы проверки через Claude не предназначены для оценки GPT.

## Установка

Каждый режим создает резервную копию и полностью заменяет `base_instructions.md` и все несистемные навыки. Устаревший файл `model-instructions.md` сохраняется в резервной копии и удаляется, а путь к нему в конфигурации обновляется. Остальные существующие значения `config.toml` сохраняются, а параметры из репозитория добавляются только при отсутствии соответствующих ключей.

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

Режим замены также удаляет устаревшие пути `AGENTS.md`, `AGENTS.override.md` и `agents`. Режим слияния оставляет эти посторонние пути без изменений.

Управляемая конфигурация подключает инструкцию через `model_instructions_file = "base_instructions.md"` относительно `config.toml`. В новой конфигурации по умолчанию используется `gpt-6.1-sol` с уровнем мышления `high`.

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

После установки или обновления перезапустите Codex. Инструкции и программы репозитория используют лицензию MIT. Включенные навыки сохраняют собственные лицензии.
