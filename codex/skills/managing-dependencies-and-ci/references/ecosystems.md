# Package ecosystems

Project conventions and the documentation for the tool version in use win over this file. Each command here was checked against the tool's official documentation.

## Contents

- npm
- pnpm
- Yarn
- pip
- uv
- Poetry
- Go
- Cargo
- Maven
- Gradle
- NuGet
- Container images
- Update bots

## npm

- **Lockfile.** `package-lock.json`, committed for applications. Libraries never publish `npm-shrinkwrap.json`.
- **CI install.** `npm ci`. It requires an existing lockfile, exits with an error when the lockfile and `package.json` disagree, and never writes to either. `npm install`, `npm update`, and `npx` may rewrite the lockfile, so keep them out of CI.
- **Install scripts.** `npm ci --ignore-scripts` runs no scripts from `package.json` files. Use it when the project builds without them.
- **Audit.** `npm audit`, with `--audit-level` set to the lowest severity that should fail the build. `npm audit signatures` verifies registry signatures and the provenance attestations of installed packages.
- **Credentials.** Never commit an `.npmrc` that contains a token.

## pnpm

- **Lockfile.** `pnpm-lock.yaml`.
- **CI install.** `pnpm install --frozen-lockfile`, which fails when the lockfile is missing or out of sync with the manifest. It is already the default in CI, and writing it keeps the intent visible.
- **Install scripts.** pnpm blocks dependency build scripts for packages not approved in `allowBuilds`. Approve only packages whose scripts you have read, and never set `dangerouslyAllowAllBuilds`.
- **Cooldown.** `minimumReleaseAge` in `pnpm-workspace.yaml` is in minutes. Set it to `4320` for a 3 day cooldown, and list urgent exceptions in `minimumReleaseAgeExclude`.
- **Audit.** `pnpm audit`, with `--prod` for production dependencies only and `--audit-level` to hide lower severities.

## Yarn

- **Lockfile.** `yarn.lock`.
- **CI install.** `yarn install --immutable`, which aborts when the lockfile would change. It is the default in CI.
- **Install scripts.** `enableScripts` in `.yarnrc.yml` decides whether third-party postinstall scripts run. Keep it `false` unless a reviewed package needs its script.
- **Cooldown.** `npmMinimalAgeGate` in `.yarnrc.yml` sets the minimum age of a version before Yarn installs it. Keep it at 3 days or more.
- **Audit.** `yarn npm audit --all --recursive`. Without `--recursive` only direct dependencies are checked, and without `--all` only the active workspace. `--severity` sets the lowest severity reported.

## pip

- **Lockfile.** A `requirements.txt` where every package, direct and indirect, is pinned with `==` and carries a `--hash`. Generate it with a tool, for example `uv pip compile --generate-hashes`.
- **CI install.** `pip install --require-hashes -r requirements.txt`. Hash-checking mode fails on any requirement that is not pinned and hashed. Install the project itself afterwards with `--no-deps`.
- **Audit.** `pip-audit -r requirements.txt`. pip-audit is maintained by the Python Packaging Authority, and with no arguments it audits the current environment.

## uv

- **Lockfile.** `uv.lock`.
- **CI install.** `uv sync --locked`, which raises an error instead of updating an out-of-date lockfile. `uv lock --check` checks the lockfile alone. `--frozen` skips the up-to-date check, so prefer `--locked` in CI.
- **Export.** `uv export --format requirements.txt` writes a requirements file with hashes for tools that need one.
- **Audit.** `uv audit` checks the project's dependencies against OSV but is marked experimental. Where the project avoids experimental commands, export the lockfile and run `pip-audit -r` on the result.

## Poetry

- **Lockfile.** `poetry.lock`.
- **CI install.** `poetry check --lock` verifies that `poetry.lock` exists for the current `pyproject.toml`. Then `poetry sync` installs the locked versions and removes packages the lock file does not track.
- **Audit.** Poetry has no audit command. Install pip-audit in the project environment and run `poetry run pip-audit`, which audits the installed packages.

## Go

- **Lockfile.** `go.sum` holds hashes of direct and indirect dependencies. Commit `go.mod` and `go.sum` for every module, library or application.
- **CI install.** Build commands act as if `-mod=readonly` were set, unless a `vendor` directory is present, and report an error when `go.mod` needs changes. Never set `GOFLAGS=-mod=mod` in CI.
- **Consistency checks.** `go mod tidy -diff` prints the needed changes without writing them and exits non-zero when `go.mod` or `go.sum` is not tidy. `go mod verify` checks that downloaded modules in the cache have not been modified.
- **Checksum database.** Leave `GOSUMDB` at its default `sum.golang.org`. `GOSUMDB=off` accepts all unrecognized modules.
- **Toolchain.** Keep the `toolchain` line in `go.mod`, which records the suggested Go toolchain.
- **Audit.** `govulncheck ./...`, installed with `go install golang.org/x/vuln/cmd/govulncheck@<version>` at a pinned version rather than `@latest`. It reports only vulnerabilities in functions the code actually reaches.

## Cargo

- **Lockfile.** `Cargo.lock`. `cargo new` tracks it in version control by default. Only `Cargo.toml` affects the consumers of a library.
- **CI install.** `cargo build --locked` and `cargo test --locked`, which fail when the lockfile is missing or would change. `--frozen` adds `--offline`.
- **Installing tools.** `cargo install --locked`, because `cargo install` ignores the package's `Cargo.lock` by default.
- **Audit.** `cargo audit` from the RustSec project, installed with `cargo install cargo-audit --locked`, checks dependencies against the RustSec Advisory Database.

## Maven

- **Lockfile.** Maven has no lockfile. Declare exact versions, keep shared versions in `dependencyManagement` or an imported BOM, and declare every plugin version.
- **Enforce pinning.** Add the Maven Enforcer rules `banDynamicVersions`, which bans version ranges, `RELEASE`, `LATEST`, and SNAPSHOT versions, plus `requireReleaseDeps`, `requirePluginVersions`, and `dependencyConvergence`.
- **CI build.** `mvn -B -C verify`, where `-C` (`--strict-checksums`) fails the build when checksums do not match.
- **Audit.** OWASP Dependency-Check through the `dependency-check-maven` plugin with the `check` goal, run during `mvn verify`, and `failBuildOnCVSS` set to the project's threshold.

## Gradle

- **Lockfile.** Enable locking with `dependencyLocking { lockAllConfigurations() }`. Locks live in `gradle.lockfile` in each project and are checked into source control.
- **Writing locks.** Run `./gradlew dependencies --write-locks` only when dependencies change. A resolved version that differs from the lock fails the build, so CI needs no extra flag. `lockMode = LockMode.STRICT` also fails locked configurations that have no lock state.
- **Checksums.** Dependency verification in `gradle/verification-metadata.xml`, generated with `./gradlew --write-verification-metadata sha256`.
- **Audit.** The OWASP Dependency-Check plugin `org.owasp.dependencycheck`, run with `./gradlew dependencyCheckAnalyze` and `failBuildOnCVSS` set.

## NuGet

- **Lockfile.** Set `RestorePackagesWithLockFile` to `true` to write `packages.lock.json`. Commit it for applications. NuGet's guidance is not to commit it for libraries that other projects depend on.
- **CI install.** `dotnet restore --locked-mode` restores exactly the locked packages or fails. When implicit SDK packages break locked mode, pin the SDK in `global.json` with roll forward disabled.
- **Versions.** No floating versions such as `Version="3.6.*"` in applications.
- **Audit.** NuGet Audit runs during restore. Set `NuGetAuditMode` to `all` to include transitive packages, which is the default only for projects targeting `net10.0` or later. Turn `NU1903` and `NU1904`, the high and critical findings, into errors with `WarningsAsErrors`. For a report, run `dotnet list package --vulnerable --include-transitive`.

## Container images

- **Pin by digest.** Write `FROM python:3.13-slim@sha256:<digest>`. The tag documents intent and the digest fixes the content.
- **Keep digests fresh.** A pinned digest never receives security fixes by itself. Add the `docker` ecosystem to Dependabot, which updates base image tags and digests, or enable `pinDigests` in Renovate.

## Update bots

- **Dependabot.** `.github/dependabot.yml` with `version: 2` and one `updates` entry per ecosystem and directory. The `package-ecosystem` values are `npm` (also for pnpm and Yarn), `pip` (also for pip-compile, pipenv, and Poetry), `uv`, `gomod`, `cargo`, `maven`, `gradle`, `nuget`, `docker`, and `github-actions`. Version updates wait 3 days by default, and security updates do not wait. Configure `cooldown` only to lengthen the wait.
- **Renovate.** Set `minimumReleaseAge` to `"3 days"`.
