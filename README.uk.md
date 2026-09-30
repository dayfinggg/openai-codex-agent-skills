# OpenAI Codex Agent Skills

[English](README.md) · Українська · [Русский](README.ru.md)

П'ятнадцять навичок для інженерних завдань, архітектури, дизайну інтерфейсів і справжнього 3D у Codex. Загальна інструкція зберігає правила стилю Silent.

Навичка `writing-code` спрямовує до правил потрібної мови. Навички для прикладних бібліотек зберігають свої додаткові файли. Закриті навички з `.claude/skills/synced` і системні навички Codex не включені. Імпортована `skill-creator` зберігає ліцензію Apache 2.0. Її інструкція використовує засоби Codex. Старі програми перевірки через Claude не призначені для оцінювання GPT.

## Встановлення

Кожен режим створює резервну копію та повністю замінює `base_instructions.md` і всі несистемні навички. Застарілий файл `model-instructions.md` зберігається в резервній копії та видаляється, а шлях до нього в конфігурації оновлюється. Решта наявних значень `config.toml` зберігається, а параметри з репозиторію додаються лише за відсутності відповідних ключів.

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

Керована конфігурація підключає інструкцію через `model_instructions_file = "base_instructions.md"` відносно `config.toml`. У новій конфігурації за замовчуванням використовується `gpt-6.1-sol` з рівнем мислення `high`.

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

Після встановлення або оновлення перезапустіть Codex. Інструкції та програми репозиторію використовують ліцензію MIT. Додані навички зберігають власні ліцензії.
