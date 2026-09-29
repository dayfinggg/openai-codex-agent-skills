# GitHub Actions

- Check the current major version of every action on its releases page before writing a workflow. Remembered versions are usually outdated.
- Pin actions to a full commit SHA with the version in a trailing comment, such as `uses: actions/checkout@<sha> # v7.0.1`. A full SHA is the only immutable reference.
- Set `permissions` at the top of every workflow to the minimum, usually `contents: read`, and raise it per job only where needed. Setting any scope sets the others to `none`.
- Never place `${{ github.event.* }}` or other untrusted input directly in `run:`. Pass it through `env:` and quote the variable: `run: echo "$TITLE"` with `env: TITLE: ${{ github.event.pull_request.title }}`.
- Do not combine `pull_request_target` with checking out the pull request's code.
- Deploy to cloud providers with OIDC (`permissions: id-token: write`) instead of long-lived keys.
- Write step outputs with `echo "name=value" >> "$GITHUB_OUTPUT"`. `::set-output` is deprecated.
- Cache dependencies through the setup action's `cache` input, such as `cache: npm` in `actions/setup-node`.
- The pipeline runs the same format, lint, type check, test and build commands as the project scripts, and fails on any error.
