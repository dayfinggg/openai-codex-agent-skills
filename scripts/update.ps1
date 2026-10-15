$ErrorActionPreference = "Stop"

$Repository = if ($env:CODEX_SKILLS_REPO) { $env:CODEX_SKILLS_REPO } else { "dayfinggg/openai-codex-agent-skills" }
$Branch = if ($env:CODEX_SKILLS_BRANCH) { $env:CODEX_SKILLS_BRANCH } else { "main" }
$TemporaryDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("openai-codex-agent-skills-" + [guid]::NewGuid())

try {
    New-Item -ItemType Directory -Path $TemporaryDirectory | Out-Null
    try {
        $Nonce = [DateTime]::UtcNow.Ticks
        $Commit = (Invoke-RestMethod `
            -Headers @{ Accept = "application/vnd.github+json"; "Cache-Control" = "no-cache"; "User-Agent" = "openai-codex-agent-skills-updater" } `
            -Uri "https://api.github.com/repos/$Repository/commits/$Branch`?update=$Nonce").sha
    }
    catch {
        $Commit = $Branch
    }

    $Archive = Join-Path $TemporaryDirectory "source.zip"
    Invoke-WebRequest -UseBasicParsing -Uri "https://codeload.github.com/$Repository/zip/$Commit" -OutFile $Archive
    Expand-Archive -Path $Archive -DestinationPath $TemporaryDirectory
    $SourceRoot = Get-ChildItem -Path $TemporaryDirectory -Directory | Select-Object -First 1
    if (-not $SourceRoot) {
        throw "Downloaded archive is empty."
    }

    $Source = Join-Path $SourceRoot.FullName "codex"
    $UserProfile = [Environment]::GetFolderPath("UserProfile")
    $Destination = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $UserProfile ".codex" }
    $InstallModePath = Join-Path $Destination ".openai-codex-agent-skills.install-mode"
    $InstallMode = if (Test-Path -LiteralPath $InstallModePath) {
        (Get-Content -LiteralPath $InstallModePath -Raw).Trim().ToLowerInvariant()
    }
    else {
        "replace"
    }
    $Mode = if ($InstallMode -eq "merge") { "Merge" } else { "Replace" }
    & (Join-Path $SourceRoot.FullName "scripts/install.ps1") -Source $Source -Mode $Mode

    $Utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText(
        (Join-Path $Destination ".openai-codex-agent-skills.version"),
        "$Commit`n",
        $Utf8WithoutBom
    )
    Write-Host "Codex source revision: $Commit"
}
finally {
    if (Test-Path -LiteralPath $TemporaryDirectory) {
        Remove-Item -LiteralPath $TemporaryDirectory -Recurse -Force
    }
}
