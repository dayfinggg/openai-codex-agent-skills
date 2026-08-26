param(
    [ValidateSet("Merge", "Replace")]
    [string]$Mode = "Merge"
)

$ErrorActionPreference = "Stop"
$Repository = if ($env:CODEX_SKILLS_REPO) { $env:CODEX_SKILLS_REPO } else { "dayfinggg/openai-codex-agent-skills" }
$Branch = if ($env:CODEX_SKILLS_BRANCH) { $env:CODEX_SKILLS_BRANCH } else { "main" }
$Destination = Join-Path $HOME ".codex"
$BackupParent = Join-Path $HOME ".codex-backups"
$Stamp = [DateTime]::UtcNow.ToString("yyyyMMddTHHmmssZ")
$Backup = Join-Path $BackupParent $Stamp
$TemporaryDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("openai-codex-agent-skills-install-" + [guid]::NewGuid())

function Copy-ManagedPath {
    param([string]$Name)
    $SourcePath = Join-Path $Source $Name
    $DestinationPath = Join-Path $Destination $Name
    if (Test-Path -LiteralPath $DestinationPath) {
        New-Item -ItemType Directory -Force -Path $Backup | Out-Null
        Copy-Item -LiteralPath $DestinationPath -Destination $Backup -Recurse -Force
    }
    Copy-Item -LiteralPath $SourcePath -Destination $Destination -Recurse -Force
}

try {
    New-Item -ItemType Directory -Force -Path $TemporaryDirectory | Out-Null
    $Archive = Join-Path $TemporaryDirectory "source.zip"
    Invoke-WebRequest -Uri "https://codeload.github.com/$Repository/zip/$Branch" -OutFile $Archive
    Expand-Archive -Path $Archive -DestinationPath $TemporaryDirectory
    $SourceRoot = Get-ChildItem -Path $TemporaryDirectory -Directory | Select-Object -First 1
    if (-not $SourceRoot) { throw "Downloaded archive is empty." }
    $Source = Join-Path $SourceRoot.FullName "codex"
    New-Item -ItemType Directory -Force -Path $Destination | Out-Null

    if ($Mode -eq "Replace") {
        foreach ($Name in @("config.toml", "AGENTS.md", "AGENTS.override.md", "model-instructions.md", "agents")) {
            $Path = Join-Path $Destination $Name
            if (Test-Path -LiteralPath $Path) {
                New-Item -ItemType Directory -Force -Path $Backup | Out-Null
                Copy-Item -LiteralPath $Path -Destination $Backup -Recurse -Force
                Remove-Item -LiteralPath $Path -Recurse -Force
            }
        }
        $DestinationSkills = Join-Path $Destination "skills"
        if (Test-Path -LiteralPath $DestinationSkills) {
            New-Item -ItemType Directory -Force -Path $Backup | Out-Null
            Copy-Item -LiteralPath $DestinationSkills -Destination $Backup -Recurse -Force
        }
        New-Item -ItemType Directory -Force -Path $DestinationSkills | Out-Null
        Get-ChildItem -LiteralPath $DestinationSkills -Force |
            Where-Object { $_.Name -ne ".system" } |
            Remove-Item -Recurse -Force
        foreach ($Name in @("config.toml", "model-instructions.md")) {
            Copy-Item -LiteralPath (Join-Path $Source $Name) -Destination $Destination -Recurse -Force
        }
        Get-ChildItem -LiteralPath (Join-Path $Source "skills") -Force |
            Copy-Item -Destination $DestinationSkills -Recurse -Force
    }
    else {
        foreach ($Name in @("model-instructions.md", "skills")) { Copy-ManagedPath -Name $Name }
    }

    Set-Content -LiteralPath (Join-Path $Destination ".openai-codex-agent-skills.install-mode") -Value $Mode.ToLowerInvariant()
    Write-Host "Codex setup installed in $Mode mode."
    if (Test-Path -LiteralPath $Backup) { Write-Host "Previous files were backed up to $Backup" }
    Write-Host "Restart Codex to load the new instructions and skills."
}
finally {
    if (Test-Path -LiteralPath $TemporaryDirectory) { Remove-Item -LiteralPath $TemporaryDirectory -Recurse -Force }
}
