# Shell and PowerShell CLI fit

**Reviewed:** 2026-08-11
**Scope:** POSIX.1-2024 shell utilities, Bash 5.3, and current PowerShell guidance. Resolve the actual target shell and host first.

## POSIX shell and Bash

- Use shell only when its text and process composition is the appropriate retained implementation. Prefer the repository's supported shell and lint or test tooling.
- Quote expansions according to shell semantics, use `--` where a utility supports it, handle filenames without splitting or glob expansion, and avoid `eval`.
- Do not parse human-oriented command output when a stable machine format or API exists.
- Understand pipeline exit behavior, traps, subshells, temporary files, signals, and cleanup for the exact shell. Strict-mode snippets are not universally safe drop-ins.
- Emit data to stdout and diagnostics to stderr. Preserve exit status through wrappers and pipelines.

## PowerShell

- Use approved verb-noun names for reusable commands when the project follows PowerShell conventions. Preserve pipeline object semantics rather than flattening everything to display text.
- Use `-LiteralPath` for literal filesystem targets. Support common parameters and `ShouldProcess` only where the command model and repository require them.
- Distinguish non-terminating and terminating errors. Set process exit status explicitly for script entry points used by automation.
- Avoid string-built native commands. Pass arguments as the installed PowerShell and target executable require, then test spaces, quotes, Unicode, and redirection on supported hosts.
- Do not assume Windows PowerShell and PowerShell 7 have identical behavior or module availability.

## Official sources

- [POSIX.1-2024 Shell Command Language](https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html)
- [Bash 5.3 manual](https://www.gnu.org/software/bash/manual/bash.html)
- [PowerShell cmdlet development guidelines](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)
- [PowerShell about automatic variables](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables)
- [PowerShell about output streams](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_output_streams)
