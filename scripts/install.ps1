param(
    [ValidateSet("Merge", "Replace")]
    [string]$Mode = "Replace",
    [string]$Source = (Join-Path (Split-Path -Parent $PSScriptRoot) "codex")
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "lib.ps1")

$UserProfile = [Environment]::GetFolderPath("UserProfile")
$Destination = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $UserProfile ".codex" }
$Destination = [System.IO.Path]::GetFullPath($Destination)
$Backup = Join-Path $Destination (".openai-codex-agent-skills-backups/" + [DateTime]::UtcNow.ToString("yyyyMMddTHHmmssfffffffZ"))

$Result = Sync-CodexPayload `
    -Source $Source `
    -Destination $Destination `
    -BackupDirectory $Backup `
    -RemoveLegacyPaths:($Mode -eq "Replace")

[System.IO.File]::WriteAllText(
    (Join-Path $Destination ".openai-codex-agent-skills.install-mode"),
    "$($Mode.ToLowerInvariant())`n",
    $script:Utf8WithoutBom
)
Write-Host "Codex setup installed in $Mode mode: updated=$($Result.Updated) removed=$($Result.Removed) config_added=$($Result.ConfigAdded)."
if (Test-Path -LiteralPath $Backup) {
    Write-Host "Previous files were backed up to $Backup"
}
Write-Host "Restart Codex to load the new instructions, skills, and configuration."
