# Migration Practices

Decouple schema or contract expansion from consumer switching and destructive contraction. Old and new versions should coexist during the compatibility window. Backfills should be idempotent, resumable, observable, rate-limited, and reconciled against explicit invariants.

Rollback is valid only while old code and data remain compatible. After irreversible transformation, define tested forward repair. Use vendor-supported upgrade paths and verify every intermediate version rather than relying on remembered compatibility.

Primary sources:

- [Martin Fowler on evolutionary database design](https://martinfowler.com/articles/evodb.html)
- [Google small change guidance](https://google.github.io/eng-practices/review/developer/small-cls.html)
- [Semantic Versioning](https://semver.org/)
- [PostgreSQL ALTER TABLE](https://www.postgresql.org/docs/current/sql-altertable.html)
