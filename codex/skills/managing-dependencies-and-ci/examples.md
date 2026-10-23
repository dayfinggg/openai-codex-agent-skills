# Dependency and CI examples

Illustrative pairs. Look up the current release and commit of every action before pinning it.

## Untrusted value in a run step

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

A branch named with `$(...)` would execute in the first version. Through `env`, the value is only data in a quoted variable.

## Stored cloud keys replaced by OIDC

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

No key is stored. Only this job may request the OIDC token, its credentials last for this job, and the production environment can require a reviewer.
