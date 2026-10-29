Use the host's actual file, search, shell, and connected-service capabilities. Names such as Bash, Read, or Skill in upstream procedures describe capabilities rather than guaranteed installed tools.

For a root SKILL.md, the resource base is its skill directory. For a procedure moved to references, the resource base is the directory containing that procedure's guide.md. Its nested references, scripts, assets, and checks inherit the same resource base. Resolve {baseDir}, <skill-dir>, and upstream mentions of the skill directory accordingly. In a moved bundle, a reference to its former SKILL.md means guide.md.

Resolve Markdown links from the file containing them. Keep relative script arguments and project working directories distinct from the resource base. Docker helper scripts still run from the application project directory as their usage specifies.

On Windows, use an available compatible shell for Bash procedures or translate the operation accurately using native tools. Do not assume that Bash quoting and environment-assignment syntax work in PowerShell.

Read only the procedure required by the task. Reuse already loaded shared guidance. Follow the current conversation and AGENTS.md for authorization, scope, communication, and temporary-file handling.
