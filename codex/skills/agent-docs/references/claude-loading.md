# Claude Code instruction loading

This Claude Code-only reference describes Claude Code 2.1.325 and some newer version-gated behavior. Treat these mechanics as a dated snapshot. Check the installed `claude --version` and the [current Claude Code documentation](https://code.claude.com/docs) before acting on any version-sensitive claim. None of these rules describes Codex discovery.

## `AGENTS.md` compatibility

In the source snapshot, Claude Code reads project `AGENTS.md` files only when no recognized `CLAUDE.md` or `CLAUDE.local.md` exists at or above the working directory. Claude's own user and managed instructions, along with `.claude/rules/`, are separate. A `CLAUDE.md` sentence that merely asks Claude to read `AGENTS.md` does not guarantee that file is loaded; use the currently documented import or setting. A nested `AGENTS.md` may load when Claude reads a file there, depending on nearer Claude instructions and current settings. Do not symlink shared instruction files without checking Windows checkout behavior.

The source also described an `AGENTS.md` integration setting named `instructionFiles`, available through a plugin config in Claude settings. Its name, values, plugin ID, and how it interacts with `CLAUDE.local.md` are version-sensitive. Verify them in current Claude documentation rather than copying the old settings block.

## Load order and imports

The source snapshot says Claude combines `CLAUDE.md` from the filesystem root to the working directory, with `CLAUDE.local.md` after `CLAUDE.md` at each level. These files are additive rather than true precedence overrides, so contradictory instructions can both remain active. Nested instructions and path-scoped rules load on demand. Size limits and compaction behavior depend on the installed release and model.

Claude `@path` imports expand in place, with relative paths based on the importing file. Import depth, quoting, comments, approvals for external paths, and reload behavior are subject to the current Claude implementation. A hook that prints an instruction file can duplicate content when Claude also reads that file directly.

## Rules and memory

The source describes `.claude/rules/` files with optional `paths:` frontmatter for path-scoped instructions. A malformed rule may become unscoped in some versions, so validate its metadata before relying on path boundaries. Check the current documentation for pattern roots, YAML behavior, external symlinks, and load timing.

Claude auto memory and topic files are machine-local. The source lists a `MEMORY.md` load cap and separate user, feedback, project, and reference notes; confirm current limits before using them. Audit memory along with instruction files when stale advice may explain behavior. A remembered preference is not a substitute for a repository rule when the user asks to change the repository.

The source snapshot describes exclusions and additional-directory settings such as `claudeMdExcludes` and `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD`. Verify their current spelling, scope, and limits before changing them. Do not print session logs or memory wholesale when a narrow lookup will answer the question.

## Other runtimes

Claude Code, Codex, Gemini CLI, Cursor, and other agents do not share one instruction discovery algorithm. Before writing a shared instruction file, check each runtime's current official documentation and test its actual discovery behavior. Do not infer a project's live load chain from filenames alone.
