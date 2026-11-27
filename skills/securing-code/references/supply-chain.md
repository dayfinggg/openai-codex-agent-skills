# Dependencies, builds and scanners

## Dependencies

Confirm a new package's exact name against the official source, because a name one letter off or a public name matching an internal package installs someone else's code. Check its maintainers, its age and its install scripts. Commit the lockfile, install with the command that respects it, and treat an unexpected lockfile change as a finding.

Read each audit advisory before acting on it. A vulnerable function the project never calls ranks below a flaw in a path that takes input.

## Builds and pipelines

`pull_request_target` or `workflow_run` combined with a checkout of the pull request hands the base repository's secrets to any contributor. Pass branch names and titles to scripts through environment variables, pin actions and base images, and give each token the narrowest rights. Check what the build publishes for source maps, debug endpoints, default credentials and example configuration.

## Scanners

Scanners find known patterns and advisories and miss logic and authorisation flaws, so confirm each result in the code before reporting it. Run the installed ones. `semgrep scan` runs static rules, `bandit -r .` covers Python, and `vendor/bin/psalm --taint-analysis` follows input to sinks in PHP. `npm audit`, `pip-audit`, `composer audit` and `osv-scanner scan -r .` report known advisories. `trivy fs .` covers dependencies, secrets and configuration, and `trivy image` a built image. `gitleaks dir .` and `gitleaks git` search the tree and the history.

A secret found in the history is compromised. Report its location and type and have it revoked.
