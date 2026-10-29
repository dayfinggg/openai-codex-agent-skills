# Installation

The default destination is `~/.codex`. Both installers honor `CODEX_HOME`. The PowerShell installer accepts `-Source` and the shell installer accepts `CODEX_SKILLS_SOURCE` for a different local payload directory.

Run `scripts/install.ps1` in PowerShell or `sh scripts/install.sh` on macOS or Linux. The default Replace mode backs up and replaces non-system skills, custom agent files, and operating instructions. It removes legacy global `AGENTS.md`, `AGENTS.override.md`, and `model-instructions.md`. Built-in system skills, sessions, credentials, plugins, and unrelated files remain intact.

PowerShell `-Mode Merge` and shell `--merge` keep unrelated skills, agent definitions, and AGENTS files. Bundled skill folders and operating instructions are still replaced. Both modes set `model_instructions_file` to `base_instructions.md`, migrate the legacy instruction filename in profiles, preserve other existing configuration values, and add missing defaults.

The default configuration uses GPT-6.1 Sol with high reasoning, live web search, low response verbosity, and GPT-6 Luna with maximum reasoning for subagents. It sets `approval_policy = "never"` and `sandbox_mode = "danger-full-access"`. This snapshot declares no custom agent roles. The empty agents marker keeps the installer directory available in Git archives.

Installers print the backup location under `.openai-codex-agent-skills-backups` inside the destination. To restore an earlier setup, use the files in that specific backup and preserve unrelated account and session data.

The updater downloads the default branch, verifies the archive layout, and reuses the last installation mode. Shell updates require curl and tar. The local installer needs no network access. Start a new Codex session to load changed instructions.
