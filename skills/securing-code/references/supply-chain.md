# Dependencies, builds and scanners

## Dependencies

Check a new package before you add it. Confirm the exact name against the official source, because a name one letter away or a public name that matches an internal package installs someone else's code. Look at its maintainers, its age and what its install scripts do. Commit the lockfile, install with the command that respects it, and treat a lockfile change that the task did not call for as a finding.

Run the audit tool of the ecosystem and read the advisory before you act on it. A vulnerable function that the project never calls is a lower priority than a flaw in a code path that takes input.

## Builds and pipelines

A workflow that runs code from a pull request with the secrets of the base repository gives those secrets to any contributor. In GitHub Actions this is `pull_request_target` or `workflow_run` combined with a checkout of the pull request. Values such as a branch name or a title are input, so pass them to a script through an environment variable. Pin third-party actions and base images, and give each token the narrowest rights.

Look at what the build publishes. Source maps, debug endpoints, default credentials and example configuration files reach production through the build.

## Scanners

Scanners find known patterns and known advisories, and they miss flaws in logic and authorisation. Run the ones that are installed, read each result in the code, and report only what you confirmed. Check the tool's help for the current options before you rely on a flag.

`semgrep scan` runs static rules on the source. `bandit -r .` covers Python. For PHP, `vendor/bin/psalm --taint-analysis` follows input to sinks. CodeQL builds a database and runs query suites when it is set up for the project.

`npm audit`, `pip-audit`, `composer audit` and `osv-scanner scan -r .` report dependencies with known advisories. `trivy fs .` covers dependencies, secrets and configuration files, and `trivy image` covers a built image. `gitleaks dir .` and `gitleaks git` look for secrets in the tree and in the history.

A secret found in the history is compromised. Tell the user to revoke it, and do not print it.
