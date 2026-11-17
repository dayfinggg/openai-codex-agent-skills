# Credentials in Git history

Read this when push protection blocks a push, a credential was committed or shared, or a user requests a history cleanup. Do not include the secret in a command, search query, report, or scanner output.

- If a real credential may have left the machine, tell the owner to revoke or rotate it first. Removing a file or rewriting Git history does not invalidate the credential or erase other people's copies.
- Remove the value from every commit that will be pushed. A later commit that deletes the value does not remove it from earlier commits.
- Use redacted scanner output. Before a scanner validates credentials against an external provider, check whether it sends the credential outside the machine and use a local-only mode when exposure is not explicitly intended.
- Rewrite shared history only with the user's explicit authorization. First identify every affected path, ref, pull request, fork, signature, and collaborator, and use a fresh clone so unrelated local work is not lost. Coordinate a stop on pushes, verify rewritten refs, and tell collaborators that their old branches must not reintroduce the secret.
- A provider may retain cached commits after a rewrite. Check the provider's current documented cleanup process rather than claiming that a force push purged all copies.
- Confirm the installed Git and scanner versions and read their current help before running a history rewrite or scanning command. Never bypass push protection to make the push succeed.
