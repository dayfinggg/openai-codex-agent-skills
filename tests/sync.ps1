$ErrorActionPreference = "Stop"
. (Join-Path (Split-Path -Parent $PSScriptRoot) "scripts\lib.ps1")

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) {
        throw $Message
    }
}

$TestRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("codex-sync-test-" + [guid]::NewGuid())
try {
    $Source = Join-Path $TestRoot "source"
    $Destination = Join-Path $TestRoot "destination"
    $Backup = Join-Path $TestRoot "backup-1"
    $Work = Join-Path $TestRoot "work"
    New-Item -ItemType Directory -Force -Path (Join-Path $Source "skills\new") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $Destination "skills\old") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $Destination "skills\.system\builtin") | Out-Null
    New-Item -ItemType Directory -Force -Path $Work | Out-Null

    Set-Content -LiteralPath (Join-Path $Source "model-instructions.md") -Value "new instructions"
    Set-Content -LiteralPath (Join-Path $Source "skills\new\SKILL.md") -Value "new skill"
    Set-Content -LiteralPath (Join-Path $Source "config.toml") -Value @'
model = "repo"
approval_policy = "never"

[agents]
max_concurrent_threads_per_session = 30

[features]
default_mode_request_user_input = true
'@
    Set-Content -LiteralPath (Join-Path $Destination "model-instructions.md") -Value "old instructions"
    Set-Content -LiteralPath (Join-Path $Destination "skills\old\SKILL.md") -Value "old skill"
    Set-Content -LiteralPath (Join-Path $Destination "skills\.system\builtin\SKILL.md") -Value "system skill"
    Set-Content -LiteralPath (Join-Path $Destination "AGENTS.md") -Value "legacy instructions"
    Set-Content -LiteralPath (Join-Path $Destination "config.toml") -Value @'
model = "local"
custom = 1

[agents]
custom_agent_setting = true

[custom]
value = "keep"
'@

    $Result = Sync-CodexPayload -Source $Source -Destination $Destination -BackupDirectory $Backup -RemoveLegacyPaths
    $Config = Get-Content -LiteralPath (Join-Path $Destination "config.toml") -Raw
    Assert-True ($Result.ConfigAdded -eq 3) "Expected three missing config keys to be added."
    Assert-True ($Config -match 'model\s*=\s*"local"') "Existing config values must be preserved."
    Assert-True ($Config -match 'approval_policy\s*=\s*"never"') "Missing top-level keys must be added."
    Assert-True ($Config -match 'max_concurrent_threads_per_session\s*=\s*30') "Missing keys must be added to existing tables."
    Assert-True ($Config -match '\[features\]') "Missing tables must be added."
    Assert-True ($Config -match '\[custom\][\s\S]*value\s*=\s*"keep"') "Unmanaged config must be preserved."
    Assert-True ($Config.IndexOf("approval_policy") -lt $Config.IndexOf("[agents]")) "Top-level keys must stay outside tables."
    Assert-True ($Config.IndexOf("[agents]") -lt $Config.IndexOf("max_concurrent_threads_per_session")) "Agent keys must be placed in the agents table."
    Assert-True ($Config.IndexOf("max_concurrent_threads_per_session") -lt $Config.IndexOf("[custom]")) "Agent keys must not leak into the next table."
    Assert-True ($Config.IndexOf("[custom]") -lt $Config.IndexOf("[features]")) "Missing tables must be appended without changing custom tables."
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $Destination "skills\old"))) "Retired skills must be removed."
    Assert-True (Test-Path -LiteralPath (Join-Path $Destination "skills\new\SKILL.md")) "Repository skills must be installed."
    Assert-True (Test-Path -LiteralPath (Join-Path $Destination "skills\.system\builtin\SKILL.md")) "System skills must be preserved."
    Assert-True ((Get-Content -LiteralPath (Join-Path $Destination "model-instructions.md") -Raw).Trim() -eq "new instructions") "Instructions must be replaced."
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $Destination "AGENTS.md"))) "Replace mode must remove legacy instructions."
    Assert-True (Test-Path -LiteralPath (Join-Path $Backup "config.toml")) "Changed config must be backed up."
    Assert-True (Test-Path -LiteralPath (Join-Path $Backup "skills\old\SKILL.md")) "Removed skills must be backed up."

    $Before = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Destination "config.toml")).Hash
    New-Item -ItemType Directory -Force -Path (Join-Path $Destination "skills\retired") | Out-Null
    Set-Content -LiteralPath (Join-Path $Destination "skills\retired\SKILL.md") -Value "retired"
    Set-Content -LiteralPath (Join-Path $Destination "AGENTS.md") -Value "unmanaged in merge mode"
    $Second = Sync-CodexPayload -Source $Source -Destination $Destination -BackupDirectory (Join-Path $TestRoot "backup-2")
    $After = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Destination "config.toml")).Hash
    Assert-True ($Second.ConfigAdded -eq 0) "Config merge must be idempotent."
    Assert-True ($Before -eq $After) "An idempotent merge must not rewrite config."
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $Destination "skills\retired"))) "Every run must remove stale skills."
    Assert-True (Test-Path -LiteralPath (Join-Path $Destination "AGENTS.md")) "Merge mode must preserve unrelated legacy paths."
}
finally {
    if (Test-Path -LiteralPath $TestRoot) {
        Remove-Item -LiteralPath $TestRoot -Recurse -Force
    }
}
