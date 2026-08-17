# Application Security Practices

Use a threat-informed, risk-based scope. Favor controls at trusted boundaries and secure defaults. Authentication establishes identity; authorization decides whether that identity may perform this action on this object. Validate permissions on every protected request.

Security errors should aid operators without exposing secrets or internals to untrusted clients. Dependency scanning, static analysis, and checklists support review but do not replace architecture, abuse-case, and runtime analysis.

Primary sources:

- [NIST Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final)
- [OWASP Application Security Verification Standard](https://owasp.org/www-project-application-security-verification-standard/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [OWASP API Security Project](https://owasp.org/API-Security/)
