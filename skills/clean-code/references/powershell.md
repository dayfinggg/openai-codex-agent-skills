# PowerShell

Check the edition first with `$PSVersionTable.PSVersion`. Windows PowerShell 5.1 has no `&&`, `||`, ternary operator or `??`. Those need PowerShell 7. Write for the edition that will run the script, and state it with `#Requires -Version`.

## Pitfalls

Errors do not stop a script by default. Set `$ErrorActionPreference = 'Stop'` at the top, and add `Set-StrictMode -Version Latest` so that a misspelled variable is an error.

`try` and `catch` see only terminating errors. A cmdlet that writes a non-terminating error needs `-ErrorAction Stop` to reach the `catch`. Do not leave a `catch` block empty.

A native program does not raise an error when it fails. Check `$LASTEXITCODE` after each call. In PowerShell 7.4 and later, `$PSNativeCommandUseErrorActionPreference = $true` makes a non-zero exit code follow the error preference.

Everything a function writes to the output stream is part of its return value. A stray expression or a method that returns a value adds to the result. Assign unwanted output to `$null`.

Comparison operators on an array filter the array. `$list -eq $null` returns the matching elements. Put `$null` on the left, as in `$null -eq $value`.

Use `-LiteralPath` for a path that can hold `[`, `]` or `*`. `-Path` treats them as wildcards.

Do not use `Invoke-Expression`. Call a command with the call operator `&` and pass arguments as an array.

Do not use `Write-Host` for data. Return objects with `Write-Output`, and report progress with `Write-Verbose`.

Never put a password in plain text. Take a `PSCredential` or a `SecureString`.

Do not use an automatic variable such as `$HOME`, `$PWD`, `$Host`, `$Error`, `$args` or `$input` as a name for your own value. Pick another name, because the assignment fails or changes what later commands see.

## Functions

Name a function with an approved verb and a singular noun, as in `Get-Report`. `Get-Verb` lists the verbs. Start it with `[CmdletBinding()]` and a `param()` block with typed parameters. Use `[switch]` for an on-off parameter and `[ValidateSet()]` for a closed set of values. A function that changes state declares `SupportsShouldProcess` and honours `-WhatIf`.

In a script, write full cmdlet names and named parameters. Aliases and positional arguments belong to the interactive prompt.

## Tools

Run `Invoke-ScriptAnalyzer` from the `PSScriptAnalyzer` module and fix what it reports. Run the tests with `Invoke-Pester` when the project has them.
