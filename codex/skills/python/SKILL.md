---
name: python
description: Change Python code or tooling, including Django and FastAPI behavior.
license: MIT for SKILL.md (uv, ruff, and ty guidance from astral-sh/claude-code-plugins). Apache-2.0 for references/django-performance.md, adapted from getsentry/skills django-perf-review with headings and checklists converted to XML sections and prose, code comments moved to prose, the report template rewritten as prose, Sentry tooling references removed, one model example fixed, and a Django 6.1 fetch mode note added. See the distribution LICENSE.
---

Establish the supported Python version, environment manager, and tools from the project configuration and lockfile.
Use that environment for commands. Keep Poetry, PDM, pip, or uv projects on their existing toolchain.
For uv, Ruff, and ty options, use the installed command's help and [Astral documentation](https://docs.astral.sh/).
Check language changes against the target version's [Python documentation](https://docs.python.org/3/whatsnew/).
Select the reference for the affected framework behavior.
- Django uses [django.md](references/django.md).
- Slow Django queries and views use [django-performance.md](references/django-performance.md).
- FastAPI uses [fastapi.md](references/fastapi.md).

Reference versions are snapshots, not upgrade targets. Preview formatter or automated fixes and keep changes within scope.
Use the project's type checker and test runner rather than adding a preferred replacement.
