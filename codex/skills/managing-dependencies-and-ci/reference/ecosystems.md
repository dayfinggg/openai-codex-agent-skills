# Package ecosystems

## npm

- **Lockfile.** `package-lock.json`. Libraries never publish `npm-shrinkwrap.json`.
- **CI install.** `npm ci`, which fails when the lockfile and `package.json` disagree and writes neither. `npm install`, `npm update`, and `npx` may rewrite the lockfile, so keep them out of CI.
- **Install scripts.** `npm ci --ignore-scripts` when the project builds without them.
- **Audit.** `npm audit --audit-level=<lowest failing severity>`. `npm audit signatures` verifies registry signatures and provenance of installed packages.
- **Credentials.** Keep any `.npmrc` with a token out of the repository.

## pnpm

- **Lockfile.** `pnpm-lock.yaml`.
- **CI install.** `pnpm install --frozen-lockfile`.
- **Install scripts.** Dependency build scripts run only for packages approved in `allowBuilds`. Approve only packages whose scripts you have read, and leave `dangerouslyAllowAllBuilds` unset.
- **Cooldown.** `minimumReleaseAge` in `pnpm-workspace.yaml` is in minutes, so `4320` gives 3 days. Urgent exceptions go in `minimumReleaseAgeExclude`.
- **Audit.** `pnpm audit`, with `--prod` for production dependencies and `--audit-level` to hide lower severities.

## Yarn

- **Lockfile.** `yarn.lock`.
- **CI install.** `yarn install --immutable`.
- **Install scripts.** Keep `enableScripts: false` in `.yarnrc.yml` unless a reviewed package needs its script.
- **Cooldown.** `npmMinimalAgeGate` in `.yarnrc.yml`, at 3 days or more.
- **Audit.** `yarn npm audit --all --recursive`. Without `--recursive` only direct dependencies are checked, and without `--all` only the active workspace.

## pip

- **Lockfile.** A `requirements.txt` with every direct and indirect package pinned with `==` and a `--hash`, generated for example with `uv pip compile --generate-hashes`.
- **CI install.** `pip install --require-hashes -r requirements.txt`, then the project itself with `--no-deps`.
- **Audit.** `pip-audit -r requirements.txt`.

## uv

- **Lockfile.** `uv.lock`.
- **CI install.** `uv sync --locked`, which fails on an out-of-date lockfile. `--frozen` skips that check, so prefer `--locked`. `uv lock --check` checks the lockfile alone.
- **Export.** `uv export --format requirements.txt` writes a hashed requirements file.
- **Audit.** `uv audit` is a preview feature. Where the project avoids preview commands, export the lockfile and run `pip-audit -r` on it.

## Poetry

- **Lockfile.** `poetry.lock`.
- **CI install.** `poetry check --lock`, then `poetry sync`.
- **Audit.** Poetry has no audit command. Install pip-audit in the project environment and run `poetry run pip-audit`.

## Go

- **Lockfile.** Commit `go.mod` and `go.sum` for every module, library or application.
- **CI install.** Build commands act as `-mod=readonly` unless a `vendor` directory exists. Leave `GOFLAGS=-mod=mod` out of CI.
- **Consistency.** `go mod tidy -diff` fails when `go.mod` or `go.sum` is not tidy, without writing them. `go mod verify` checks the module cache.
- **Checksum database.** Leave `GOSUMDB` at `sum.golang.org`, because `GOSUMDB=off` accepts any module.
- **Toolchain.** Keep the `toolchain` line in `go.mod`.
- **Audit.** `govulncheck ./...`, installed with `go install golang.org/x/vuln/cmd/govulncheck@<pinned version>`.

## Cargo

- **Lockfile.** `Cargo.lock`.
- **CI install.** `cargo build --locked` and `cargo test --locked`. `--frozen` adds `--offline`.
- **Installing tools.** `cargo install --locked`, because `cargo install` ignores the package's lockfile by default.
- **Audit.** `cargo audit`, installed with `cargo install cargo-audit --locked`.

## Maven

- **Lockfile.** None. Declare exact versions, keep shared versions in `dependencyManagement` or an imported BOM, and declare every plugin version.
- **Enforce pinning.** Maven Enforcer rules `banDynamicVersions`, `requireReleaseDeps`, `requirePluginVersions`, and `dependencyConvergence`.
- **CI build.** `mvn -B -C verify`, where `-C` fails on checksum mismatch.
- **Audit.** OWASP `dependency-check-maven` with the `check` goal during `verify` and `failBuildOnCVSS` set.

## Gradle

- **Lockfile.** `dependencyLocking { lockAllConfigurations() }` writes `gradle.lockfile` per project, committed. A resolved version that differs from the lock fails the build. `lockMode = LockMode.STRICT` also fails configurations without lock state.
- **Writing locks.** `./gradlew dependencies --write-locks`, only when dependencies change.
- **Checksums.** `./gradlew --write-verification-metadata sha256` writes `gradle/verification-metadata.xml`.
- **Audit.** Plugin `org.owasp.dependencycheck`, run with `./gradlew dependencyCheckAnalyze` and `failBuildOnCVSS` set.

## NuGet

- **Lockfile.** `RestorePackagesWithLockFile` set to `true` writes `packages.lock.json`. Commit it for applications, and not for libraries other projects depend on.
- **CI install.** `dotnet restore --locked-mode`. When implicit SDK packages break locked mode, pin the SDK in `global.json` with roll forward disabled.
- **Versions.** No floating versions such as `Version="3.6.*"` in applications.
- **Audit.** NuGet Audit runs during restore. Set `NuGetAuditMode` to `all` for transitive packages, which is the default only from `net10.0`. Make `NU1903` and `NU1904` errors with `WarningsAsErrors`. For a report, run `dotnet list package --vulnerable --include-transitive`.

## Container images

A pinned digest never gets security fixes by itself. Add the `docker` ecosystem to Dependabot, or enable `pinDigests` in Renovate.

## Update bots

- **Dependabot.** `.github/dependabot.yml` with `version: 2` and one `updates` entry per ecosystem and directory. `package-ecosystem` values are `npm` (also pnpm and Yarn), `pip` (also pip-compile, pipenv, and Poetry), `uv`, `gomod`, `cargo`, `maven`, `gradle`, `nuget`, `docker`, and `github-actions`. Version updates wait 3 days by default and security updates do not, so set `cooldown` only to lengthen the wait.
- **Renovate.** `minimumReleaseAge: "3 days"`.
