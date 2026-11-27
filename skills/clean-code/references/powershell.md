# PowerShell

Check the edition with `$PSVersionTable.PSVersion`. Windows PowerShell 5.1 has no `&&`, `||`, ternary operator or `??`, which need PowerShell 7. Write for the edition that will run the script, and state it with `#Requires -Version`.

## Pitfalls

- Errors do not stop a script by default. Set `$ErrorActionPreference = 'Stop'` at the top, and add `Set-StrictMode -Version Latest` so that a misspelled variable is an error.
- `try` and `catch` see only terminating errors. Add `-ErrorAction Stop` to a cmdlet whose error must reach the `catch`, and handle or rethrow in every `catch` block.
- A native program raises no error when it fails. Check `$LASTEXITCODE` after each call, or in PowerShell 7.4 and later set `$PSNativeCommandUseErrorActionPreference = $true` so a non-zero exit code follows the error preference.
- Everything a function writes to the output stream is part of its return value. Assign unwanted output, such as a stray expression or a method's return value, to `$null`.
- A comparison operator with an array on the left filters the array, so `$list -eq $null` returns elements. Put `$null` on the left, as in `$null -eq $value`.
- `-Path` treats `[`, `]` and `*` as wildcards. Use `-LiteralPath` for a path that may hold them.
- Call a command with the call operator `&` and an array of arguments in place of `Invoke-Expression`.
- Return data with `Write-Output` and report progress with `Write-Verbose`, keeping `Write-Host` for display only.
- Take passwords as a `PSCredential` or a `SecureString`, never as plain text.
- Pick your own names in place of automatic variables such as `$HOME`, `$PWD`, `$Host`, `$Error`, `$args` or `$input`, because assigning them fails or changes what later commands see.

## Functions

Name a function with an approved verb from `Get-Verb` and a singular noun, as in `Get-Report`. Start it with `[CmdletBinding()]` and a `param()` block with typed parameters, using `[switch]` for an on-off parameter and `[ValidateSet()]` for a closed set of values. A function that changes state declares `SupportsShouldProcess` and honours `-WhatIf`. In a script, write full cmdlet names and named parameters, and keep aliases and positional arguments for the interactive prompt.

## Tools

Run `Invoke-ScriptAnalyzer` from the `PSScriptAnalyzer` module and fix what it reports, and run the tests with `Invoke-Pester` when the project has them.
