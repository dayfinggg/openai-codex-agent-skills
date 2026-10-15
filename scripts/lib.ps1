$script:Utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)

function Copy-CodexBackupPath {
    param(
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][string]$BackupDirectory,
        [Parameter(Mandatory)][string]$RelativePath
    )

    $SourcePath = Join-Path $Destination $RelativePath
    if (-not (Test-Path -LiteralPath $SourcePath)) {
        return
    }

    $BackupPath = Join-Path $BackupDirectory $RelativePath
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $BackupPath) | Out-Null
    Copy-Item -LiteralPath $SourcePath -Destination $BackupPath -Recurse -Force
}

function Get-CodexTomlSection {
    param([Parameter(Mandatory)][AllowEmptyString()][string]$Line)

    if ($Line -match '^\s*\[([^\]]+)\]\s*(?:#.*)?$') {
        return $Matches[1].Trim()
    }
    return $null
}

function Get-CodexTomlKey {
    param([Parameter(Mandatory)][AllowEmptyString()][string]$Line)

    if ($Line -match '^\s*([A-Za-z0-9_.-]+)\s*=') {
        return $Matches[1]
    }
    return $null
}

function Merge-CodexConfig {
    param(
        [Parameter(Mandatory)][string]$SourcePath,
        [Parameter(Mandatory)][string]$DestinationPath,
        [Parameter(Mandatory)][string]$DestinationRoot,
        [Parameter(Mandatory)][string]$BackupDirectory
    )

    $SourceLines = [System.IO.File]::ReadAllLines($SourcePath)
    $SourceEntries = [System.Collections.Generic.List[object]]::new()
    $SourceSections = [System.Collections.Generic.List[string]]::new()
    $SourceSectionHeaders = [System.Collections.Generic.Dictionary[string, string]]::new([System.StringComparer]::Ordinal)
    $SeenSourceSections = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $SourceSection = ""
    $SourceSections.Add("")
    $SeenSourceSections.Add("") | Out-Null

    foreach ($Line in $SourceLines) {
        $Section = Get-CodexTomlSection -Line $Line
        if ($null -ne $Section) {
            $SourceSection = $Section
            if ($SeenSourceSections.Add($Section)) {
                $SourceSections.Add($Section)
                $SourceSectionHeaders[$Section] = $Line
            }
            continue
        }

        $Key = Get-CodexTomlKey -Line $Line
        if ($null -ne $Key) {
            $SourceEntries.Add([pscustomobject]@{
                Section = $SourceSection
                Key = $Key
                Line = $Line
            })
        }
    }

    if (-not (Test-Path -LiteralPath $DestinationPath -PathType Leaf)) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $DestinationPath) | Out-Null
        Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Force
        return $SourceEntries.Count
    }

    $DestinationLines = [System.IO.File]::ReadAllLines($DestinationPath)
    $DestinationKeys = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $DestinationSections = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $DestinationSection = ""
    $DestinationSections.Add("") | Out-Null

    foreach ($Line in $DestinationLines) {
        $Section = Get-CodexTomlSection -Line $Line
        if ($null -ne $Section) {
            $DestinationSection = $Section
            $DestinationSections.Add($Section) | Out-Null
            continue
        }

        $Key = Get-CodexTomlKey -Line $Line
        if ($null -ne $Key) {
            $DestinationKeys.Add("$DestinationSection`0$Key") | Out-Null
        }
    }

    $Missing = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.List[string]]]::new([System.StringComparer]::Ordinal)
    $Added = 0
    $InstructionEntry = $SourceEntries | Where-Object { $_.Section -eq "" -and $_.Key -eq "model_instructions_file" } | Select-Object -First 1
    $DestinationSection = ""
    for ($Index = 0; $Index -lt $DestinationLines.Length; $Index++) {
        $Line = $DestinationLines[$Index]
        $Section = Get-CodexTomlSection -Line $Line
        if ($null -ne $Section) {
            $DestinationSection = $Section
        } elseif ($InstructionEntry -and (($DestinationSection -eq "" -and (Get-CodexTomlKey -Line $Line) -eq "model_instructions_file" -and $Line -ne $InstructionEntry.Line) -or ($DestinationSection -match '^profiles\.' -and $Line -match '^\s*model_instructions_file\s*=\s*([''"])(?:[^''"]*[/\\])?model-instructions\.md\1\s*(?:#.*)?$'))) {
            $DestinationLines[$Index] = $InstructionEntry.Line
            $Added++
        }
    }
    foreach ($Entry in $SourceEntries) {
        if ($DestinationKeys.Contains("$($Entry.Section)`0$($Entry.Key)")) {
            continue
        }
        if (-not $Missing.ContainsKey($Entry.Section)) {
            $Missing[$Entry.Section] = [System.Collections.Generic.List[string]]::new()
        }
        $Missing[$Entry.Section].Add($Entry.Line)
        $Added++
    }

    if ($Added -eq 0) {
        return 0
    }

    $Result = [System.Collections.Generic.List[string]]::new()
    $Emitted = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $CurrentSection = ""

    $EmitMissing = {
        param([string]$SectionName, [bool]$BeforeNextSection)

        if ($Emitted.Contains($SectionName) -or -not $Missing.ContainsKey($SectionName)) {
            return
        }
        while ($BeforeNextSection -and $Result.Count -gt 0 -and [string]::IsNullOrWhiteSpace($Result[$Result.Count - 1])) {
            $Result.RemoveAt($Result.Count - 1)
        }
        foreach ($MissingLine in $Missing[$SectionName]) {
            $Result.Add($MissingLine)
        }
        if ($BeforeNextSection) {
            $Result.Add("")
        }
        $Emitted.Add($SectionName) | Out-Null
    }

    foreach ($Line in $DestinationLines) {
        $Section = Get-CodexTomlSection -Line $Line
        if ($null -ne $Section) {
            if (-not $Emitted.Contains("")) {
                & $EmitMissing "" $true
            }
            if ($CurrentSection -ne "") {
                & $EmitMissing $CurrentSection $true
            }
            $Result.Add($Line)
            $CurrentSection = $Section
            continue
        }
        $Result.Add($Line)
    }

    if (-not $Emitted.Contains("")) {
        & $EmitMissing "" $false
    }
    if ($CurrentSection -ne "") {
        & $EmitMissing $CurrentSection $false
    }

    foreach ($Section in $SourceSections) {
        if ($Section -eq "" -or $DestinationSections.Contains($Section) -or -not $Missing.ContainsKey($Section)) {
            continue
        }
        if ($Result.Count -gt 0 -and -not [string]::IsNullOrWhiteSpace($Result[$Result.Count - 1])) {
            $Result.Add("")
        }
        $Result.Add($SourceSectionHeaders[$Section])
        foreach ($MissingLine in $Missing[$Section]) {
            $Result.Add($MissingLine)
        }
        $Emitted.Add($Section) | Out-Null
    }

    $DestinationPrefix = $DestinationRoot.TrimEnd("\", "/") + [System.IO.Path]::DirectorySeparatorChar
    $RelativeConfigPath = $DestinationPath.Substring($DestinationPrefix.Length)
    Copy-CodexBackupPath -Destination $DestinationRoot -BackupDirectory $BackupDirectory -RelativePath $RelativeConfigPath
    [System.IO.File]::WriteAllLines($DestinationPath, [string[]]$Result, $script:Utf8WithoutBom)
    return $Added
}

function Write-CodexManifest {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination
    )

    $SourcePrefix = $Source.TrimEnd("\", "/") + [System.IO.Path]::DirectorySeparatorChar
    $Files = @(
        Get-Item -LiteralPath (Join-Path $Source "base_instructions.md")
        Get-ChildItem -LiteralPath (Join-Path $Source "skills") -File -Recurse
        Get-ChildItem -LiteralPath (Join-Path $Source "agents") -File -Recurse
    ) | Sort-Object FullName
    $Manifest = foreach ($File in $Files) {
        $Relative = $File.FullName.Substring($SourcePrefix.Length).Replace("\", "/")
        $Hasher = [System.Security.Cryptography.SHA256]::Create()
        try {
            $Hash = [BitConverter]::ToString($Hasher.ComputeHash([System.IO.File]::ReadAllBytes($File.FullName))).Replace("-", "").ToLowerInvariant()
        }
        finally {
            $Hasher.Dispose()
        }
        "$Hash`t$Relative"
    }
    [System.IO.File]::WriteAllLines(
        (Join-Path $Destination ".openai-codex-agent-skills.manifest"),
        [string[]]$Manifest,
        $script:Utf8WithoutBom
    )
}

function Sync-CodexPayload {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][string]$BackupDirectory,
        [switch]$RemoveLegacyPaths
    )

    $Source = [System.IO.Path]::GetFullPath($Source).TrimEnd("\", "/")
    $Destination = [System.IO.Path]::GetFullPath($Destination).TrimEnd("\", "/")
    if ($Source -eq $Destination) {
        throw "Source and destination must be different directories."
    }
    foreach ($RequiredPath in @("config.toml", "base_instructions.md", "skills", "agents")) {
        if (-not (Test-Path -LiteralPath (Join-Path $Source $RequiredPath))) {
            throw "Downloaded payload is missing codex/$RequiredPath."
        }
    }

    foreach ($Directory in @("skills", "agents")) {
        $ManagedPath = Join-Path $Destination $Directory
        if ((Test-Path -LiteralPath $ManagedPath) -and ((Get-Item -LiteralPath $ManagedPath -Force).Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
            throw "Managed directory must not be a symbolic link: $ManagedPath"
        }
        if ($Source.StartsWith($ManagedPath + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase) -or $Source -eq $ManagedPath) {
            throw "Source must not be inside a managed destination directory."
        }
    }

    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
    $Removed = 0

    foreach ($RelativePath in @("base_instructions.md", "model-instructions.md", "skills", "agents")) {
        Copy-CodexBackupPath -Destination $Destination -BackupDirectory $BackupDirectory -RelativePath $RelativePath
    }

    $InstructionPath = Join-Path $Destination "base_instructions.md"
    foreach ($InstructionName in @("base_instructions.md", "model-instructions.md")) {
        $PreviousInstructionPath = Join-Path $Destination $InstructionName
        if (Test-Path -LiteralPath $PreviousInstructionPath) {
            Remove-Item -LiteralPath $PreviousInstructionPath -Recurse -Force
            $Removed++
        }
    }

    $DestinationSkills = Join-Path $Destination "skills"
    New-Item -ItemType Directory -Force -Path $DestinationSkills | Out-Null
    $RetiredSkills = @(Get-ChildItem -LiteralPath $DestinationSkills -Force | Where-Object { $_.Name -ne ".system" -and ($RemoveLegacyPaths -or (Test-Path -LiteralPath (Join-Path $Source "skills/$($_.Name)"))) })
    foreach ($RetiredSkill in $RetiredSkills) {
        $Removed += @(Get-ChildItem -LiteralPath $RetiredSkill.FullName -File -Recurse -ErrorAction SilentlyContinue).Count
        if (-not $RetiredSkill.PSIsContainer) {
            $Removed++
        }
        Remove-Item -LiteralPath $RetiredSkill.FullName -Recurse -Force
    }

    if ($RemoveLegacyPaths) {
        foreach ($RelativePath in @("AGENTS.md", "AGENTS.override.md")) {
            $LegacyPath = Join-Path $Destination $RelativePath
            if (Test-Path -LiteralPath $LegacyPath) {
                Copy-CodexBackupPath -Destination $Destination -BackupDirectory $BackupDirectory -RelativePath $RelativePath
                Remove-Item -LiteralPath $LegacyPath -Recurse -Force
                $Removed++
            }
        }
    }

    $DestinationAgents = Join-Path $Destination "agents"
    if ($RemoveLegacyPaths -and (Test-Path -LiteralPath $DestinationAgents)) {
        Remove-Item -LiteralPath $DestinationAgents -Recurse -Force
        $Removed++
    }
    New-Item -ItemType Directory -Force -Path $DestinationAgents | Out-Null
    Get-ChildItem -LiteralPath (Join-Path $Source "agents") -Force |
        Copy-Item -Destination $DestinationAgents -Recurse -Force

    Copy-Item -LiteralPath (Join-Path $Source "base_instructions.md") -Destination $InstructionPath -Force
    Get-ChildItem -LiteralPath (Join-Path $Source "skills") -Force |
        Copy-Item -Destination $DestinationSkills -Recurse -Force

    $Updated = 1 + @(Get-ChildItem -LiteralPath (Join-Path $Source "skills") -File -Recurse).Count + @(Get-ChildItem -LiteralPath (Join-Path $Source "agents") -File -Recurse).Count
    $ConfigAdded = Merge-CodexConfig `
        -SourcePath (Join-Path $Source "config.toml") `
        -DestinationPath (Join-Path $Destination "config.toml") `
        -DestinationRoot $Destination `
        -BackupDirectory $BackupDirectory
    Write-CodexManifest -Source $Source -Destination $Destination

    return [pscustomobject]@{
        Updated = $Updated
        Removed = $Removed
        ConfigAdded = $ConfigAdded
    }
}
