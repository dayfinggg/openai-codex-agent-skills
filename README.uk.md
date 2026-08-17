# OpenAI Codex Agent Skills

[English](README.md) · Українська · [Русский](README.ru.md)

Шістнадцять навичок для промислової розробки й дизайну, стислі загальні інструкції та мінімальна конфігурація Codex.

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

Використовуйте `--merge` або `-Mode Merge`, щоб зберегти наявний `config.toml` і додати лише `AGENTS.override.md` та навички.

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
