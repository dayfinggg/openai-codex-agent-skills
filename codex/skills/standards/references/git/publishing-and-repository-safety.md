# Publishing and repository safety

- Protect important branches against accidental force-push and deletion on the server. Client hooks are convenience checks, not trust boundaries, because clients can omit or bypass them.
- Use system credential helpers, OAuth, or another approved secret store. Do not normalize plaintext credential storage, disabled TLS verification, unauthenticated `git://`, or plain HTTP.
- Before publishing a submodule update, inspect `.gitmodules`, verify the exact submodule commit, and ensure that commit is reachable from the submodule's published remote.
- Before destructive repository maintenance, create and verify a recoverable backup when reflog and remote history cannot restore all affected state.
- Do not recommend `filter-branch` for routine history rewriting. Use a maintained purpose-built tool and coordinate the resulting object and reference replacement.
