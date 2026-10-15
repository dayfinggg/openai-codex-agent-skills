# Release examples

These pairs are illustrative. Copy the reasoning, not the exact shape. The action SHAs point at the release named in the comment, and need to be re-resolved before use.

## Contents

- Fixing a broken release (npm)
- npm publish workflow with trusted publishing (YAML)
- PyPI publish workflow with trusted publishing (YAML)
- Promoting one image digest instead of rebuilding (YAML)

## Fixing a broken release (npm)

Version 1.4.2 of `example-lib` shipped without its build output. The only commit since the `v1.4.2` tag is `fix(build): include dist files in the package`.

Before

```bash
npm unpublish example-lib@1.4.2
npm publish
```

After

```bash
npm version patch --no-git-tag-version
npm publish --dry-run
```

A released version is never changed, and npm refuses a name and version that existed before, even after unpublish. The fix becomes 1.4.3, a dry run shows the new contents, and the tag, the publish, and `npm deprecate example-lib@1.4.2 "Missing build output, use 1.4.3"` wait until the user asks for them.

## npm publish workflow with trusted publishing (YAML)

Before

```yaml
name: Publish

on:
  push:
    tags: ["v*"]

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          registry-url: https://registry.npmjs.org
      - run: npm install
      - run: npm test
      - run: npm publish --access public
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

After

```yaml
name: Publish

on:
  push:
    tags: ["v*"]

permissions:
  contents: read

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - uses: actions/setup-node@949feb2413d6458794dcd2491c4babbbce0c15c1 # v7.1.0
        with:
          node-version: "24"
          package-manager-cache: false
      - run: npm ci
      - run: npm test
      - run: npm pack
      - uses: actions/upload-artifact@cf430e030ddbb5b0abf93d22962f4752f3646cd9 # v7.0.2
        with:
          name: package
          path: "*.tgz"
          if-no-files-found: error

  publish:
    needs: build
    runs-on: ubuntu-latest
    environment: npm
    permissions:
      contents: read
      id-token: write
    steps:
      - uses: actions/setup-node@949feb2413d6458794dcd2491c4babbbce0c15c1 # v7.1.0
        with:
          node-version: "24"
          registry-url: "https://registry.npmjs.org"
          package-manager-cache: false
      - uses: actions/download-artifact@9000827ccba6bdab643e8b6fd33ac0654aef8333 # v8.0.2
        with:
          name: package
      - run: npm publish ./*.tgz --access public
```

The long-lived `NPM_TOKEN` is gone, and only the gated publish job can mint a short-lived OIDC credential. Node 24 brings an npm that meets the trusted publishing minimum, and npm adds provenance on its own for a public package from a public repository whose `repository.url` matches. The user still has to add the trusted publisher for this workflow file with the `npm` environment and `npm publish` allowed, then disallow tokens and delete the secret.

## PyPI publish workflow with trusted publishing (YAML)

Before

```yaml
name: Release

on:
  release:
    types: [published]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.x"
      - run: pip install build twine
      - run: python -m build
      - run: twine upload dist/*
        env:
          TWINE_USERNAME: __token__
          TWINE_PASSWORD: ${{ secrets.PYPI_API_TOKEN }}
```

After

```yaml
name: Release

on:
  release:
    types: [published]

permissions:
  contents: read

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - uses: actions/setup-python@5fda3b95a4ea91299a34e894583c3862153e4b97 # v7.0.0
        with:
          python-version: "3.x"
      - run: python -m pip install build==1.6.1
      - run: python -m build
      - uses: actions/upload-artifact@cf430e030ddbb5b0abf93d22962f4752f3646cd9 # v7.0.2
        with:
          name: python-package-distributions
          path: dist/
          if-no-files-found: error

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

The build runs without any credential, and the publish job exchanges its OIDC token for a PyPI token that expires after 15 minutes. The PyPA action uploads attestations by default, and the build tool is pinned instead of floating. The publish job stays in this top-level workflow, because trusted publishing does not work from a reusable workflow.

## Promoting one image digest instead of rebuilding (YAML)

Before

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  staging:
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - run: docker build --build-arg API_URL=https://api.staging.example.com -t ghcr.io/example-org/shop:staging .
      - run: docker push ghcr.io/example-org/shop:staging
      - run: ./scripts/deploy.sh ghcr.io/example-org/shop:staging

  production:
    needs: staging
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - run: docker build --build-arg API_URL=https://api.example.com -t ghcr.io/example-org/shop:latest .
      - run: docker push ghcr.io/example-org/shop:latest
      - run: ./scripts/deploy.sh ghcr.io/example-org/shop:latest
```

After

```yaml
name: Deploy

on:
  push:
    branches: [main]

permissions:
  contents: read

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
      id-token: write
      attestations: write
    outputs:
      digest: ${{ steps.push.outputs.digest }}
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - uses: docker/setup-buildx-action@f87e5991a6d7451dcb8d9637bfbc97413f497069 # v4.4.1
      - uses: docker/login-action@dbcb813823bdd20940b903addbd779551569679f # v4.6.0
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@c3c9e263c25d99ce0380d002d59b67737d91b0dc # v7.4.0
        id: push
        with:
          context: .
          push: true
          tags: ghcr.io/example-org/shop:${{ github.sha }}
      - uses: anchore/sbom-action@66cbf4bc1f1c0d2edc94016e65bc221b6bb0ad6c # v0.24.3
        with:
          image: ghcr.io/example-org/shop@${{ steps.push.outputs.digest }}
          format: cyclonedx-json
          output-file: sbom.cdx.json
      - uses: actions/attest@1e69f48acb82d1966a394da916b4c1698aa569d6 # v4.2.2
        with:
          subject-name: ghcr.io/example-org/shop
          subject-digest: ${{ steps.push.outputs.digest }}
          push-to-registry: true
      - uses: actions/attest@1e69f48acb82d1966a394da916b4c1698aa569d6 # v4.2.2
        with:
          subject-name: ghcr.io/example-org/shop
          subject-digest: ${{ steps.push.outputs.digest }}
          sbom-path: sbom.cdx.json
          push-to-registry: true

  staging:
    needs: build
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - run: ./scripts/deploy.sh "$IMAGE"
        env:
          IMAGE: ghcr.io/example-org/shop@${{ needs.build.outputs.digest }}

  production:
    needs: [build, staging]
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - run: ./scripts/deploy.sh "$IMAGE"
        env:
          IMAGE: ghcr.io/example-org/shop@${{ needs.build.outputs.digest }}
```

Production used to run bytes that staging never saw, built with different arguments and shipped under mutable tags. Now one build produces one digest with provenance and a CycloneDX SBOM attached, both environments deploy that exact digest, and the API address comes from each environment's configuration at deploy time instead of a build argument.
