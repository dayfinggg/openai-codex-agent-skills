# Install, replace, and restore

## Choose an installation mode

Run these commands from the repository folder.

Replace mode is the default. It backs up and replaces all non-system skills and custom agents, including files you added yourself. Old global `AGENTS.md`, `AGENTS.override.md`, and `model-instructions.md` are backed up and removed.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

```sh
sh scripts/install.sh
```

To keep unrelated custom skills, agents, and global `AGENTS.md` files, choose Merge:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Mode Merge
```

```sh
sh scripts/install.sh --merge
```

Merge still replaces bundled skill folders, matching agent files, and `base_instructions.md`. It also removes the legacy `model-instructions.md` after backup. Updates reuse the last installation mode.

## Choose the destination

Both installers and updaters honor `CODEX_HOME`. Without it they use `~/.codex`.

To try the setup in a separate folder without changing your active configuration:

```powershell
$env:CODEX_HOME = Join-Path $env:TEMP "codex-agents-preview"
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
Remove-Item Env:CODEX_HOME
```

```sh
CODEX_HOME="$HOME/codex-agents-preview" sh scripts/install.sh
```

The PowerShell installer accepts `-Source` for a local payload folder containing `config.toml`, `base_instructions.md`, `skills`, and `agents`. The shell equivalent is `CODEX_SKILLS_SOURCE`. The default source is the repository's `codex` folder.

## Understand configuration changes

The installer preserves existing configuration values and adds missing keys from [the portable configuration](../codex/config.toml). It sets the top-level `model_instructions_file` to `base_instructions.md` and migrates profile instruction paths that reference `model-instructions.md`.

Existing model choices, permissions, MCP servers, plugins, and project settings are not reset to the author's defaults. To use different access settings on a new installation, edit the portable configuration before running the local installer.

## Restore from a backup

Each run prints its backup folder under `$CODEX_HOME/.openai-codex-agent-skills-backups/`. Install and update use the same location with a unique directory per run.

1. Close Codex.
2. Open the backup folder printed by the run you want to undo.
3. Replace the installed `base_instructions.md`, non-system skills, and custom agents with their backed-up copies. Preserve the active `skills/.system` folder.
4. Restore `config.toml` and legacy instruction files if they exist in that backup. If a managed file or folder did not exist before installation, remove the newly installed copy instead.
5. Restart Codex.

Backups may contain your private configuration. Keep them local and do not upload them to GitHub.

## Update from a different source

The network updaters accept `CODEX_SKILLS_REPO` in `owner/repository` form and `CODEX_SKILLS_BRANCH` for a branch or revision. Defaults are `dayfinggg/openai-codex-agent-skills` and `main`. Only use a repository you trust, because its installer runs locally.

The updater records the downloaded revision in `.openai-codex-agent-skills.version`. Installed payload hashes, including agent definitions, are recorded in `.openai-codex-agent-skills.manifest`.
