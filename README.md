# OpenAI Codex Agent Skills

English · [Українська](README.uk.md) · [Русский](README.ru.md)

Instructions and skills for OpenAI Codex.

## Add to an existing configuration

Back up `~/.codex`, clone the repository, and copy the managed files.

### macOS and Linux

```bash
cp -R "$HOME/.codex" "$HOME/.codex.backup-$(date +%Y%m%d-%H%M%S)" 2>/dev/null || true
git clone https://github.com/dayfinggg/openai-codex-agent-skills.git
mkdir -p "$HOME/.codex/skills"
cp -R openai-codex-agent-skills/codex/skills/. "$HOME/.codex/skills/"
cp openai-codex-agent-skills/codex/model-instructions.md "$HOME/.codex/"
```

### Windows PowerShell

```powershell
if (Test-Path "$HOME\.codex") { Copy-Item -Recurse "$HOME\.codex" "$HOME\.codex.backup-$(Get-Date -Format yyyyMMdd-HHmmss)" }
git clone https://github.com/dayfinggg/openai-codex-agent-skills.git
New-Item -ItemType Directory -Force "$HOME\.codex\skills" | Out-Null
Copy-Item -Recurse -Force .\openai-codex-agent-skills\codex\skills\* "$HOME\.codex\skills\"
Copy-Item -Force .\openai-codex-agent-skills\codex\model-instructions.md "$HOME\.codex\"
```

Add this top-level line to `~/.codex/config.toml`:

```toml
model_instructions_file = "model-instructions.md"
```

## Replace the managed files

This replaces `config.toml`, `model-instructions.md`, and `skills`, and removes legacy repository agents.

### macOS and Linux

```bash
cp -R "$HOME/.codex" "$HOME/.codex.backup-$(date +%Y%m%d-%H%M%S)" 2>/dev/null || true
git clone https://github.com/dayfinggg/openai-codex-agent-skills.git
rm -rf "$HOME/.codex/agents" "$HOME/.codex/skills"
mkdir -p "$HOME/.codex"
cp -R openai-codex-agent-skills/codex/skills "$HOME/.codex/"
cp openai-codex-agent-skills/codex/model-instructions.md openai-codex-agent-skills/codex/config.toml "$HOME/.codex/"
```

### Windows PowerShell

```powershell
if (Test-Path "$HOME\.codex") { Copy-Item -Recurse "$HOME\.codex" "$HOME\.codex.backup-$(Get-Date -Format yyyyMMdd-HHmmss)" }
git clone https://github.com/dayfinggg/openai-codex-agent-skills.git
Remove-Item -Recurse -Force "$HOME\.codex\agents", "$HOME\.codex\skills" -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force "$HOME\.codex" | Out-Null
Copy-Item -Recurse -Force .\openai-codex-agent-skills\codex\skills "$HOME\.codex\"
Copy-Item -Force .\openai-codex-agent-skills\codex\model-instructions.md, .\openai-codex-agent-skills\codex\config.toml "$HOME\.codex\"
```

Restart Codex after installation.

## Contents

23 engineering and product-design skills, shared instructions, and a portable Codex configuration. MIT License.
