<credits>
This skill merges three MIT-licensed sources. Each text was edited to match the plugin's style. Outdated facts were corrected against the official PostgreSQL and MySQL documentation.

The core of `../SKILL.md` comes from the `safe-migrations` skill by nuttakulsv at [github.com/nuttakulsv/safe-migrations](https://github.com/nuttakulsv/safe-migrations). It supplies the dangerous operations, safe rewrites, lock timeouts, expand and contract, and batched backfills. It also supplies the ORM traps, the commands never to run, and the migration report. Its `credits.md` file is copied unchanged as `credits.md` in this folder.

The files `postgres-schema.md`, `postgres-queries.md`, and `postgres-operations.md` come from the `supabase-postgres-best-practices` skill by Supabase at [github.com/supabase/agent-skills](https://github.com/supabase/agent-skills). Supabase-specific notes were removed, and several rule files were merged or left out.

The files `mysql-online-ddl.md` and `mysql-transactions.md` come from the `mysql` skill references by PlanetScale at [github.com/planetscale/database-skills](https://github.com/planetscale/database-skills). They use the online-ddl, isolation-levels, deadlocks, row-locking-gotchas, and connection-management references, without the PlanetScale and Vitess notes.

The sections on data safety, backups, and parameterized queries are new text for this plugin. So is the N+1 section for Eloquent, Doctrine, and SQLAlchemy.
</credits>

<licenses>
The Supabase source carries this license.

```
MIT License

Copyright (c) 2026 Supabase

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

The PlanetScale source carries this license.

```
MIT License

Copyright (c) 2026 PlanetScale

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

The safe-migrations source carries the same MIT text with the line "Copyright (c) 2026 nuttakulsv", in `credits.md`.
</licenses>

Upstream redistribution terms follow.

```text
MIT License

Copyright (c) 2026 nuttakulsv

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
