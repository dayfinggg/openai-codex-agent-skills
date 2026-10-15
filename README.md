# Codex Agents and Skills

English · [Українська](README.uk.md) · [Русский](README.ru.md)

A portable snapshot of the author's local Codex setup, synchronized on **2026-10-15**. It contains **18 engineering skills, 12 specialist agents**, shared instructions, and a portable configuration.

Skills cover clean and secure code, testing, documentation, architecture, HTTP APIs, databases, interfaces, 3D, observability, resilient services, dependencies, releases, and LLM security. Agents provide focused research, diagnosis, implementation, review, and verification.

This is a personal configuration, not an official OpenAI distribution. Plugin and system skills, credentials, chat history, caches, machine paths, and desktop settings are not included.

## Install or replace an older setup

Download and extract the [ZIP archive](https://github.com/dayfinggg/openai-codex-agent-skills/archive/refs/heads/main.zip), or clone the repository:

```sh
git clone https://github.com/dayfinggg/openai-codex-agent-skills.git
cd openai-codex-agent-skills
```

Run one installer from the extracted or cloned folder. It uses the included files without downloading another copy.

### Windows

Requires Windows PowerShell 5.1 or PowerShell 7.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

### macOS and Linux

Requires a POSIX shell and a SHA-256 utility, such as `sha256sum`, `shasum`, or `openssl`.

```sh
sh scripts/install.sh
```

Restart Codex after installation.

**Replace is the default.** The installer backs up and replaces shared instructions, all non-system skills, and custom agents, removing the old set. It keeps `skills/.system`, plugins, credentials, sessions, and unrelated files. Existing configuration values are preserved, missing defaults are added, and `model_instructions_file` is connected to the installed instructions.

For a new configuration, the snapshot uses `gpt-6.1-sol` with `medium` reasoning, and defaults subagents to `gpt-6-luna` with `max` reasoning. **It also sets `approval_policy = "never"` and `sandbox_mode = "danger-full-access"`.** Review [the configuration](codex/config.toml) before installing if you do not want these access settings.

## Update

To download and install the latest GitHub revision without updating your checkout:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\update.ps1
```

```sh
sh scripts/update.sh
```

Updates require internet access, with `curl` and `tar` additionally required for the shell updater. The last install mode is reused. If you maintain a Git clone instead, run `git pull --ff-only` and rerun the installer.

## Contents and installation details

- [Shared instructions](codex/base_instructions.md)
- [18 skills and their references](codex/skills)
- [12 custom agent definitions](codex/agents)
- [Portable configuration](codex/config.toml)
- [Installation modes, backups, and custom locations](docs/installation.md)

The payload files are copied from the local setup without rewriting their instructions. Only portable configuration keys are exported. The old skill collection, imported skill-creator tools, and outdated research documents have been removed.

The configuration uses `model_instructions_file`, which replaces built-in model instructions rather than merely adding project guidance. See [official OpenAI configuration documentation](https://learn.chatgpt.com/docs/config-file/config-reference) and [custom agent documentation](https://learn.chatgpt.com/docs/agent-configuration/subagents). The installer retains the author's `$CODEX_HOME/skills` layout, which is in use locally, while [current skill documentation](https://learn.chatgpt.com/docs/build-skills) describes `$HOME/.agents/skills` for user-level discovery.

## Verify the installers

Requires Python 3.11 or newer:

```sh
python -m unittest discover -s tests -v
```

Tests use temporary directories, not your real Codex setup. Available Windows PowerShell, PowerShell 7, and POSIX shell implementations are tested; unavailable runtimes are reported as skipped.

Report problems through [GitHub issues](https://github.com/dayfinggg/openai-codex-agent-skills/issues). Repository instructions and scripts use the [MIT License](LICENSE).
