# OpenAI Codex Agent Skills

[English](README.md) · [Українська](README.uk.md) · Русский

Двадцать навыков для промышленной разработки, архитектуры проектов, агентных процессов и ясного кода, краткие общие инструкции и переносимая конфигурация Codex.

Навык `standards` направляет к небольшим файлам по зонам ответственности в `codex/skills/standards/references/<domain>/`. Реестр чтения, аналитическая транскрибация видео и примеры кода до и после улучшений находятся в `docs/`.

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

Управляемая конфигурация подключает инструкцию через `model_instructions_file = "base_instructions.md"` относительно `config.toml`. В новой конфигурации по умолчанию используется GPT-6 Astra с уровнем мышления `low`.

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
