# Planning with GitHub issues

Use this only when the user asks to turn work into GitHub issues, or the project workflow explicitly authorizes that tracker operation. Issue creation and editing change an external system. A local plan does not authorize those changes by itself.

- Read the project rules and the existing issues first. Check `gh --version` and the installed `gh issue create --help` and `gh issue edit --help`; flags and dependency support vary by CLI and GitHub service.
- Write each issue as one independently verifiable vertical slice. State the user-visible behavior, acceptance criteria, focused check, prerequisites, and out-of-scope behavior. Link prerequisites as blockers only when the installed CLI and target service support the relationship.
- Create or identify prerequisites before dependent issues so each blocker reference resolves to the right issue. If the service lacks dependency links, write a clear `Blocked by` section in the issue body.
- Check existing parent issues and incomplete plans before adding or changing children. Do not overwrite another plan or close unrelated issues to make room.
- Treat `gh issue` numbers, GitHub API database IDs, sub-issue limits, and Enterprise Server support as distinct. Use the CLI's documented commands where possible, and check the current official service documentation before using API endpoints or relying on limits.
- After creating issues, reread them and verify each title, body, parent, blocker, and open state. Report the issue references and any relationship the service could not represent.
