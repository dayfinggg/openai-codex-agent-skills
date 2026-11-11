<overview>
This file lists, for each package manager, how to look a package up, how a minimum release age and install scripts are configured, how to install from the lockfile, and how to audit. The facts were checked against each manager's own documentation and release notes on November 11, 2026. Read the installed version first, because several defaults changed in 2026.
</overview>

<contents>
This file has these sections, in order.
- lookup
- release age
- install scripts
- lockfile installs
- audit
</contents>

<lookup>
These commands show a package's registry metadata before an install.

| Manager | Command |
|---|---|
| npm | `npm view <pkg>`, and `npm view <pkg> time` for the publish date of each version |
| pnpm | `pnpm view <pkg>` |
| Yarn | `yarn npm info <pkg>` |
| Bun | `bun info <pkg>` |
| pip | `python -m pip index versions <pkg>` |
| uv | No such command. Read `https://pypi.org/pypi/<project>/json`, which gives each file's `upload_time` |
| Composer | The package page on packagist.org, and `composer show <vendor/package>` once it is installed |
| Cargo | `cargo info <crate>` |
| Go | `go list -m -versions <module>` |
</lookup>

<release_age>
A minimum release age, also called a cooldown, makes the manager skip a version until it has been public for a set time. The wait gives the registry and its scanners time to detect and remove a malicious release.

| Tool | Setting | Default |
|---|---|---|
| npm | `min-release-age` in days, from 11.10. `min-release-age-exclude` from 11.17 | Off |
| pnpm | `minimumReleaseAge` in minutes, from 10.16. `minimumReleaseAgeExclude` | 1440, which is one day, from 11.0 |
| Yarn | `npmMinimalAgeGate` as a duration, from 4.10. `npmPreapprovedPackages` | `1d` from 4.15 |
| Bun | `minimumReleaseAge` in seconds under `[install]` in `bunfig.toml`, from 1.3. `minimumReleaseAgeExcludes` | Off |
| uv | `exclude-newer` as a date, or as a duration such as `7 days` from 0.9.17. `exclude-newer-package` | Off |
| pip | `--uploaded-prior-to` as a datetime from 26.0, or as days such as `P7D` from 26.1 | Off |
| Composer | `config.policy.cooldown.period`, such as `"7 days"`, from 2.11 | Off |
| Dependabot | `cooldown` in `dependabot.yml` | 3 days for version updates since July 2026. Security updates are exempt |
| Renovate | `minimumReleaseAge`, such as `"3 days"` | Off |

Cargo documents `registry.global-min-publish-age` for version 1.100. The stable Cargo book did not have it on the check date.
</release_age>

<install_scripts>
A dependency's install script runs arbitrary code during the install, so current managers block it unless the project allows that package.

| Manager | Behavior |
|---|---|
| npm | From 12.0, the scripts of dependencies are blocked unless the `allowScripts` policy of the root `package.json` allows them. `npm install-scripts approve <pkg>` records an approval, and `npm rebuild` then runs the script. npm 11 runs the scripts unless `ignore-scripts` is set |
| pnpm | From 10.0, the scripts of dependencies do not run by default. pnpm 10 allows a package through `onlyBuiltDependencies`. pnpm 11 replaced that setting with the `allowBuilds` map, and an install fails while a package with a script is not listed there |
| Yarn | `enableScripts` is `false` by default from 4.14 |
| Bun | Dependencies run no install scripts, apart from a built-in list of popular packages. `trustedDependencies` in `package.json` replaces that list |
| Composer | A plugin loads only when `allow-plugins` names it. `--no-plugins` and `--no-scripts` turn both off for one command |
</install_scripts>

<lockfile_installs>
These commands install exactly what the lockfile holds and fail when it does not match the manifest, which is what a CI job needs.

| Manager | Command |
|---|---|
| npm | `npm ci` |
| pnpm | `pnpm install --frozen-lockfile`, which is the default in CI |
| Yarn | `yarn install --immutable`, which is the default in CI |
| Bun | `bun install --frozen-lockfile`, or `bun ci` |
| uv | `uv sync --locked` |
| Composer | `composer install`, which installs the versions in `composer.lock` |
| Cargo | `cargo build --locked` |
</lockfile_installs>

<audit>
These commands check the installed packages against known vulnerabilities.

| Manager | Command |
|---|---|
| npm | `npm audit` |
| pnpm | `pnpm audit` |
| Yarn | `yarn npm audit` |
| Bun | `bun audit` |
| Composer | `composer audit`, or `composer audit --locked` for the lockfile |
| uv | `uv audit`, a preview feature that asks the OSV database |
| pip | `pip-audit`, a separate tool from the PyPA |
| Cargo | `cargo audit` from the RustSec project, installed with `cargo install cargo-audit`. `cargo deny check` also covers licenses and sources |
| Go | `govulncheck ./...`, which reports only the vulnerabilities that the code can reach |
</audit>
