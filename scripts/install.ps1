param(
    [ValidateSet("Merge", "Replace")]
    [string]$Mode = "Merge"
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "lib.ps1")

$Repository = if ($env:CODEX_SKILLS_REPO) { $env:CODEX_SKILLS_REPO } else { "dayfinggg/openai-codex-agent-skills" }
$Branch = if ($env:CODEX_SKILLS_BRANCH) { $env:CODEX_SKILLS_BRANCH } else { "main" }
$UserProfile = [Environment]::GetFolderPath("UserProfile")
$Destination = Join-Path $UserProfile ".codex"
$BackupParent = Join-Path $UserProfile ".codex-backups"
$Stamp = [DateTime]::UtcNow.ToString("yyyyMMddTHHmmssZ")
$Backup = Join-Path $BackupParent $Stamp
$TemporaryDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("openai-codex-agent-skills-install-" + [guid]::NewGuid())

try {
    New-Item -ItemType Directory -Force -Path $TemporaryDirectory | Out-Null
    $Archive = Join-Path $TemporaryDirectory "source.zip"
    Invoke-WebRequest -Uri "https://codeload.github.com/$Repository/zip/$Branch" -OutFile $Archive
    Expand-Archive -Path $Archive -DestinationPath $TemporaryDirectory
    $SourceRoot = Get-ChildItem -Path $TemporaryDirectory -Directory | Select-Object -First 1
    if (-not $SourceRoot) {
        throw "Downloaded archive is empty."
    }

    $Source = Join-Path $SourceRoot.FullName "codex"
    $Result = Sync-CodexPayload `
        -Source $Source `
        -Destination $Destination `
        -BackupDirectory $Backup `
        -RemoveLegacyPaths:($Mode -eq "Replace")

    $Utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText(
        (Join-Path $Destination ".openai-codex-agent-skills.install-mode"),
        "$($Mode.ToLowerInvariant())`n",
        $Utf8WithoutBom
    )
    Write-Host "Codex setup installed in $Mode mode: updated=$($Result.Updated) removed=$($Result.Removed) config_added=$($Result.ConfigAdded)."
    if (Test-Path -LiteralPath $Backup) {
        Write-Host "Previous files were backed up to $Backup"
    }
    Write-Host "Restart Codex to load the new instructions, skills, and configuration."
}
finally {
    if (Test-Path -LiteralPath $TemporaryDirectory) {
        Remove-Item -LiteralPath $TemporaryDirectory -Recurse -Force
    }
}
