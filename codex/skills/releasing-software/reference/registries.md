# Registries

Trusted publishing setup per registry, from each registry's documentation. Confirm the details on the linked page before writing a workflow, and re-resolve the action SHAs. Every workflow sets `permissions: contents: read` at the top.

## Contents

- npm
- PyPI
- crates.io
- RubyGems
- NuGet
- Maven Central
- Container registries

## npm

Source is [docs.npmjs.com/trusted-publishers](https://docs.npmjs.com/trusted-publishers).

- **Tool versions.** Trusted publishing needs npm CLI 11.5.1 or later and Node 22.14.0 or later. Node 22 releases bundle npm 10, which is below that minimum, so use a Node 24 release or check `npm --version` in the job. Managing dist-tags through OIDC needs a newer npm, as listed on the page.
- **CI providers.** GitHub Actions on GitHub-hosted runners, GitLab CI/CD on GitLab.com shared runners, and CircleCI cloud. Self-hosted runners are not supported.
- **Registry setup.** On the package settings, add a trusted publisher with the owner, the repository, the workflow file name in `.github/workflows/` with its `.yml` or `.yaml` extension, and optionally the environment. npm does not validate it on save, so a mismatch shows up only as a failed publish. A new configuration expires unless it publishes successfully within 2 days, and existing ones cannot be edited, only deleted and recreated.
- **Allowed actions.** `npm stage publish` is always allowed. `npm publish` and `npm dist-tag` are separate opt-ins on the configuration. A stage-only publisher with tokens disallowed is the strictest setup, because a maintainer then approves each staged version with 2FA before it goes public.
- **Workflow.** The job needs `id-token: write`. A reusable workflow needs it in both the caller and the called workflow. `package.json` must have `repository.url` matching the GitHub repository exactly.
- **Provenance.** Generated automatically, without `--provenance`, when publishing through OIDC from GitHub Actions or GitLab CI/CD, from a public repository, for a public package. A private repository gets no provenance, and CircleCI does not support it.
- **Afterwards.** In the package's Settings, under Publishing access, choose "Require two-factor authentication and disallow tokens". Trusted publishers keep working. Revoke the old automation tokens and delete the `NPM_TOKEN` secret.
- **Private dependencies.** Trusted publishing covers only publishing. Installing private packages in the same workflow still needs a read-only granular token.

## PyPI

Sources are [docs.pypi.org/trusted-publishers](https://docs.pypi.org/trusted-publishers/), [docs.pypi.org/attestations/producing-attestations](https://docs.pypi.org/attestations/producing-attestations/), and the [pypa/gh-action-pypi-publish README](https://github.com/pypa/gh-action-pypi-publish).

- **Token.** The OIDC token is exchanged for an API token that is valid for 15 minutes.
- **Registry setup.** Add a trusted publisher on the PyPI project with the owner, repository, workflow file name, and the environment, which PyPI strongly encourages. The Python Packaging User Guide adds manual approval on the `pypi` environment.
- **Workflow.** `id-token: write` at job level, which PyPI strongly encourages over workflow level. Use `pypa/gh-action-pypi-publish` with no `user` or `password`. It cannot use trusted publishing from inside a reusable workflow, so the publishing job lives in a top-level workflow.
- **Attestations.** The action generates and uploads attestations by default through its `attestations` input. Leave it on. GitLab CI/CD and Google Cloud need a manual `pypi-attestations sign` step instead.
- **TestPyPI.** Use a separate trusted publisher on test.pypi.org and `repository-url: https://test.pypi.org/legacy/`.
- **Afterwards.** Long-lived API tokens stay valid until someone revokes them, so ask the user to revoke them and delete the `PYPI_API_TOKEN` secret.

```yaml
  publish:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: pypi
      url: https://pypi.org/p/example-package
    permissions:
      id-token: write
    steps:
      - uses: actions/download-artifact@9000827ccba6bdab643e8b6fd33ac0654aef8333 # v8.0.2
        with:
          name: python-package-distributions
          path: dist/
      - uses: pypa/gh-action-pypi-publish@dc37677b2e1c63e2034f94d8a5b11f265b73ba33 # v1.14.2
```

## crates.io

Sources are the [crates.io development update of July 2025](https://blog.rust-lang.org/2025/07/11/crates-io-development-update-2025-07) and the [rust-lang/crates-io-auth-action README](https://github.com/rust-lang/crates-io-auth-action). The crates.io page at crates.io/docs/trusted-publishing is the current reference and lists any further CI providers.

- **First release.** Publish the first version of a crate manually with an API token, then configure trusted publishing in the crate settings with the owner, repository, workflow file name, and optionally the environment.
- **Workflow.** The job needs `id-token: write`. `rust-lang/crates-io-auth-action` exchanges the OIDC token for a short-lived crates.io token, exposes it as the `token` output, and revokes it in its post step when the job ends. Pass it to `cargo publish` as `CARGO_REGISTRY_TOKEN`.

```yaml
  publish:
    runs-on: ubuntu-latest
    environment: release
    permissions:
      contents: read
      id-token: write
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - uses: rust-lang/crates-io-auth-action@c6f97d42243bad5fab37ca0427f495c86d5b1a18 # v1.0.5
        id: auth
      - run: cargo publish --locked
        env:
          CARGO_REGISTRY_TOKEN: ${{ steps.auth.outputs.token }}
```

## RubyGems

Source is [guides.rubygems.org/trusted-publishing](https://guides.rubygems.org/trusted-publishing/) and the [rubygems/release-gem README](https://github.com/rubygems/release-gem).

- **Registry setup.** On the gem page, open Trusted publishers and add the owner, repository, workflow file name, and the environment, where the guide suggests `release`. For a gem that does not exist yet, create a pending trusted publisher from the profile, and it turns into a normal one after the first push.
- **Workflow.** The job needs `id-token: write`. `rubygems/release-gem` also needs `contents: write`, because `rake release` pushes the release tag, which is another outside effect to run only when the user asks. The project needs Bundler and its release tasks.

```yaml
  publish:
    runs-on: ubuntu-latest
    environment: release
    permissions:
      contents: write
      id-token: write
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - uses: ruby/setup-ruby@e81a8fa391b11a595c1b7ed84177cc0fe02faf83 # v1.328.0
        with:
          bundler-cache: true
          ruby-version: ruby
      - uses: rubygems/release-gem@7f9650160c1a4e7989fdc9855807bdbd421d8b6b # v1.4.1
```

## NuGet

Source is [learn.microsoft.com/nuget/nuget-org/trusted-publishing](https://learn.microsoft.com/en-us/nuget/nuget-org/trusted-publishing).

- **CI providers.** GitHub Actions and GitLab CI/CD, for nuget.org.
- **Registry setup.** On nuget.org, open Trusted Publishing from the user menu and add a policy with the repository owner, the repository, the workflow file name only (`release.yml`, without `.github/workflows/`), and optionally the environment. A policy can start as temporarily active for 7 days, typically for private repositories, and becomes permanent after the first successful publish binds it to the repository's immutable IDs.
- **Workflow.** The job needs `id-token: write`. `NuGet/login` takes the nuget.org profile name, never the email, in `user`, and returns a temporary key in the `NUGET_API_KEY` output. The key is valid for 1 hour, so request it right before the push.

```yaml
  publish:
    needs: build
    runs-on: ubuntu-latest
    environment: nuget
    permissions:
      id-token: write
    steps:
      - uses: actions/download-artifact@9000827ccba6bdab643e8b6fd33ac0654aef8333 # v8.0.2
        with:
          name: nupkg
      - uses: NuGet/login@8d196754b4036150537f80ac539e15c2f1028841 # v1.2.0
        id: login
        with:
          user: ${{ vars.NUGET_USER }}
      - run: dotnet nuget push ./*.nupkg --api-key "$NUGET_API_KEY" --source https://api.nuget.org/v3/index.json
        env:
          NUGET_API_KEY: ${{ steps.login.outputs.NUGET_API_KEY }}
```

## Maven Central

Trusted publishing for Maven Central was not confirmed on Sonatype's own documentation. Read the Central Portal documentation at central.sonatype.org for the current authentication and signing requirements before writing the workflow. If it still needs a token, follow the rule for registries without trusted publishing in SKILL.md, with the token stored only as a secret of the gated publishing environment.

## Container registries

- **GitHub Container Registry.** The job that pushes the image logs in with `GITHUB_TOKEN` and needs `packages: write`. Attesting the image adds `id-token: write` and `attestations: write`.
- **Cloud registries.** Authenticate through OIDC federation to the cloud provider, as the managing-dependencies-and-ci skill describes, never with stored access keys.
- **Digest.** Read the pushed digest from the `digest` output of `docker/build-push-action`, attest that digest, and deploy by it. The provenance file shows the attestation step.
