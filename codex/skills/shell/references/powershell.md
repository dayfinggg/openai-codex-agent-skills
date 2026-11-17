# PowerShell

Rules for PowerShell 7 (`pwsh`) and the differences of Windows PowerShell 5.1.

## Versions

- PowerShell 7.7.0 was released on 2026-11-10, and 7.6 is the LTS release. Check [PowerShell releases](https://github.com/PowerShell/PowerShell/releases) and the [Microsoft support lifecycle](https://learn.microsoft.com/en-us/powershell/scripting/install/powershell-support-lifecycle) for current support dates. The support table may show different dates across time zones.
- The release tags are published as data in `https://raw.githubusercontent.com/PowerShell/PowerShell/master/tools/metadata.json` (`StableReleaseTag`, `LTSReleaseTag`).
- 7.7 makes `New-Guid` return version 7 (time-sortable) UUIDs, as documented in [What's New in PowerShell 7.7](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/what-s-new-in-powershell-77). Use `[guid]::NewGuid()` where a random version 4 value is required.

## Fail fast

- Start scripts with:

```powershell
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
Set-StrictMode -Version 3.0
```

- Without the second line, a native command's non-zero exit does not become a PowerShell error, even under `Stop`. PowerShell 7.4 and later support this preference variable. For a tool such as `robocopy` whose non-zero codes are not errors, set it to `$false` inside a script block and test `$LASTEXITCODE` yourself. See Microsoft's [error handling documentation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_error_handling).
- Pin `Set-StrictMode -Version 3.0`, because `Latest` gets stricter with new releases.

## Exit codes

- `pwsh -File script.ps1` exits 0 after normal termination, or with the number given to `exit`. `pwsh -Command` exits only 0 or 1, taken from `$?` of the last statement, and turns any other native exit code into 1.
- End a `.ps1` or `-Command` string whose caller needs a native command's status with `exit $LASTEXITCODE`.

## Parsing and quoting

- In a double-quoted string, `$name:` reads as a scope or drive prefix, so `"$h:8080"` is an error. Write `"${h}:8080"`.
- `< > @ #` are special only at the start of a token, while `{ }` are special anywhere in argument mode. `git log @{u}` is a parse error and `HEAD@{u}` reaches git as `HEAD@`. Quote such revisions: `'@{u}'`, `'HEAD@{1}'`. An unquoted `#` at the start of a token begins a comment.
- `--%` (stop-parsing token) passes the rest of the line to a native command unchanged, for arguments full of quotes or `@`.

## Output and pipes

- `ConvertTo-Json` stops at depth 2 by default and writes deeper objects as their type name, such as `"System.Collections.Hashtable"`, with only a warning. Pass `-Depth 10` (at most 100). A one-element array piped in comes out as a bare value, so add `-AsArray` or pass `-InputObject $list`.
- Piping a string to a native command appends a newline, `\r\n` on Windows, so `'abc' | tool` sends five bytes. Pass the value as an argument, or write it with `Set-Content -NoNewline` and pass the file.
- Since 7.4, redirecting a native command's stdout to a file or piping it to another native command keeps the raw bytes.

## Aliases and Windows PowerShell 5.1

- `where`, `sort`, `diff`, `tee` and `kill` are aliases of `Where-Object`, `Sort-Object`, `Compare-Object`, `Tee-Object` and `Stop-Process`. Call `where.exe` to locate a program.
- Windows PowerShell 5.1 also maps `curl` and `wget` to `Invoke-WebRequest` and `sc` to `Set-Content`. Call `curl.exe` there.
- In Windows PowerShell 5.1, `2>&1` under `$ErrorActionPreference = 'Stop'` turns a native command's first stderr line, such as git progress output, into a terminating error. PowerShell 7.2 and later leave redirected stderr alone.

## PSScriptAnalyzer

- Run the project-installed `Invoke-ScriptAnalyzer -Path script.ps1` or `-Path . -Recurse`. Do not install it just to run a one-off check; if the project needs it, verify the official module and version before adding it.
