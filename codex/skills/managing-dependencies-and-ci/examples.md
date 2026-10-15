# Dependency and CI examples

These pairs are illustrative. Copy the reasoning, not the exact shape, and look up the current release and commit of every action before pinning it.

## Contents

- Unpinned workflow made hardened (GitHub Actions, Python)
- Script injection in a run step (GitHub Actions)
- Pull request code under pull_request_target (GitHub Actions, Node.js)
- Long-lived cloud keys replaced by OIDC (GitHub Actions)
- CI steps that rewrite dependencies (Go and .NET)
- Update bot for the app, the image, and the workflows (dependabot.yml)
- Base image pinned by digest (Dockerfile)

## Unpinned workflow made hardened (GitHub Actions, Python)

Before

```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: actions/setup-python@v7
        with:
          python-version: "3.13"
      - run: pip install -r requirements.txt
      - run: pytest
```

After

```yaml
name: CI

on:
  pull_request:
  push:
    branches:
      - main

permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - uses: actions/setup-python@5fda3b95a4ea91299a34e894583c3862153e4b97 # v7.0.0
        with:
          python-version: "3.13"
      - run: pip install --require-hashes -r requirements.txt
      - run: python -m pytest
```

The token is read-only, each action is fixed to a commit that a moved tag cannot change, and the trailing comment keeps the version readable for people and for Dependabot. The install fails if any requirement is unpinned or its hash does not match.

## Script injection in a run step (GitHub Actions)

Before

```yaml
      - name: Check branch name
        run: |
          if [[ "${{ github.head_ref }}" != feature/* ]]; then
            echo "Branch must start with feature/"
            exit 1
          fi
```

After

```yaml
      - name: Check branch name
        env:
          HEAD_REF: ${{ github.head_ref }}
        run: |
          if [[ "$HEAD_REF" != feature/* ]]; then
            echo "Branch must start with feature/"
            exit 1
          fi
```

The expression is substituted into the script text before the shell runs, so a branch named with `$(...)` would execute. Passed through `env`, the same value is only data in a quoted variable.

## Pull request code under pull_request_target (GitHub Actions, Node.js)

Before

```yaml
on: pull_request_target

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
        with:
          ref: ${{ github.event.pull_request.head.sha }}
      - run: npm ci
      - run: npm test
```

After

```yaml
on: pull_request

permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - run: npm ci
      - run: npm test
```

`pull_request_target` runs with the base repository's token and secrets even for unapproved forks, so an install script in the pull request could steal them. `pull_request` gives fork pull requests a read-only token and no other secrets.

## Long-lived cloud keys replaced by OIDC (GitHub Actions)

Before

```yaml
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: aws-actions/configure-aws-credentials@v6
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: eu-central-1
      - run: ./deploy.sh
```

After

```yaml
  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    permissions:
      contents: read
      id-token: write
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
        with:
          persist-credentials: false
      - uses: aws-actions/configure-aws-credentials@e1253824e5c10ff9df46874f81ed3ec929e19cfd # v6.3.0
        with:
          role-to-assume: arn:aws:iam::123456789012:role/github-deploy
          aws-region: eu-central-1
      - run: ./deploy.sh
```

No access key is stored anywhere. The job exchanges its OIDC token for credentials that last only for this job, only this job may request the token, and the production environment can require a reviewer before it runs.

## CI steps that rewrite dependencies (Go and .NET)

Before

```yaml
      - run: go get -u ./...
      - run: go build ./...
      - run: dotnet restore
```

After

```yaml
      - run: go mod tidy -diff
      - run: go build ./...
      - run: go mod verify
      - run: dotnet restore --locked-mode
```

`go get -u` upgrades dependencies during the build, so CI tests versions nobody reviewed. The new steps fail when `go.mod` or `go.sum` is out of date, check the downloaded modules, and make NuGet restore exactly what `packages.lock.json` lists.

## Update bot for the app, the image, and the workflows (dependabot.yml)

Before

```yaml
version: 2
updates:
  - package-ecosystem: uv
    directory: /
    schedule:
      interval: weekly
```

After

```yaml
version: 2
updates:
  - package-ecosystem: uv
    directory: /
    schedule:
      interval: weekly
  - package-ecosystem: docker
    directory: /
    schedule:
      interval: weekly
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: weekly
    groups:
      github-actions:
        patterns:
          - "*"
```

Dependabot alerts do not cover actions pinned to a SHA, and a pinned image digest never picks up fixes by itself, so version updates are the only way these pins stay current. The default 3 day cooldown already applies, so there is no `cooldown` block.

## Base image pinned by digest (Dockerfile)

Before

```dockerfile
FROM python:latest
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "-m", "app"]
```

After

```dockerfile
FROM python:3.13-slim@sha256:70729b46c69b4f1e97c4822c1af3df53a1476cf5ddc6c087c0c10bc3a5678c2f
WORKDIR /app
COPY requirements.txt .
RUN pip install --require-hashes -r requirements.txt
COPY . .
CMD ["python", "-m", "app"]
```

`latest` can point at a different image on every build. The digest fixes the exact image, the tag still tells readers which version it is, and the `docker` entry in dependabot.yml proposes new digests.
