# Production Coding Practices

Repository configuration and official language tooling decide formatting. There is no safe universal line, function, or file limit: widely used standards choose different line lengths. Use a local soft limit only when no rule exists, and break code where readability improves.

Names should express domain intent. Use nouns for values and types, verbs for operations, and affirmative predicates such as `is`, `has`, `can`, or `should`. Avoid vague names unless scope makes meaning obvious. A function should have one cohesive purpose, not an arbitrary number of lines.

DRY applies to duplicated knowledge that must change together, not merely similar syntax. KISS means the simplest complete design. YAGNI rejects hypothetical features and extension points, not necessary refactoring that keeps current code easy to change.

Generated code remains untrusted until APIs, versions, failure behavior, security, tests, and the final diff are verified. Poor legacy code is context, not a standard: characterize behavior, improve the touched seam, and avoid unrelated rewrites.

Primary sources:

- [Google code review: what to look for](https://google.github.io/eng-practices/review/reviewer/looking-for.html)
- [Google code review standard](https://google.github.io/eng-practices/review/reviewer/standard.html)
- [Google small change guidance](https://google.github.io/eng-practices/review/developer/small-cls.html)
- [Martin Fowler on YAGNI](https://martinfowler.com/bliki/Yagni.html)
- [NIST Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final)
- [OWASP Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/stable-en/02-checklist/05-checklist)
