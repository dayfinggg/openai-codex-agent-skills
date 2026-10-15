# Documentation examples

These pairs are illustrative. Copy the reasoning, not the exact shape.

## Contents

- README that mixes tutorial and reference (Markdown, Python)
- Git log dump rewritten as a changelog (Markdown)
- Vague how-to guide rewritten in Google style (Markdown, shell, YAML)
- Migration guide (Markdown, TypeScript)

## README that mixes tutorial and reference (Markdown, Python)

Before

````markdown
# tidecache

tidecache is a caching library. We built it because the caches we tried were slow under load, and it uses segmented LRU, which we think is better than plain LRU because hot keys survive a burst of one-off reads.

## Getting started

Install it with pip, or with Poetry, or build it from source if you prefer.

The Cache class takes these arguments.

| Argument | Type | Default |
|---|---|---|
| max_items | int | 1000 |
| ttl_seconds | float | None |
| eviction | str | "slru" |

Now let's create a cache. Internally every set goes to the probation segment first, and a second hit promotes the key.

```python
from tidecache import Cache
cache = Cache()
cache.set("user:42", {"name": "Ada"})
```

For more info click [here](docs/api.md).
````

After

````markdown
# tidecache

tidecache is an in-process cache for Python applications with per-entry expiry.

## Install

```sh
pip install tidecache
```

## Quickstart

```python
from tidecache import Cache

cache = Cache(max_items=1000)
cache.set("user:42", {"name": "Ada"})
print(cache.get("user:42"))
```

The script prints `{'name': 'Ada'}`.

## Documentation

- [Cache API responses in a Flask app](docs/tutorials/cache-api-responses.md)
- [Use the Redis backend](docs/how-to/use-redis-backend.md)
- [Cache class reference](docs/reference/cache.md)
- [About segmented LRU eviction](docs/explanation/segmented-lru.md)

## Get help

Ask questions and report bugs in the [tidecache issue tracker](https://github.com/example-org/tidecache/issues).

## Contributing

See [Contributing to tidecache](CONTRIBUTING.md).

## License

tidecache is released under the [MIT License](LICENSE).
````

The argument table moves to the reference page, the eviction design moves to an explanation page, and the install alternatives go away because a quickstart needs one path. The README keeps a quickstart that was run and shows its real output, and the vague "click here" becomes link text that names each page.

## Git log dump rewritten as a changelog (Markdown)

Before

```markdown
# Changelog

## v3.0.0

- 9f1c2ab feat(api): add cursor pagination to order list
- 1d4e8f0 fix: typo
- 77a0b31 chore(deps): bump express from 4.21.1 to 4.21.2
- c3b9e12 refactor(billing): extract TaxPolicy
- 5e6f7a8 feat(auth)!: require email verification before login
- 0b1c2d3 Merge branch 'main' into feature/pagination
- 4f5a6b7 fix(cart): keep total at zero for discounts over 100%
- 2e3f4a5 feat(api): deprecate page parameter on order list
- a1b2c3d fix(auth): reject expired password reset tokens
- 8c9d0e1 ci: cache node_modules
```

After

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.0.0] - 2026-10-08

### Added

- Cursor pagination for `GET /orders`. Pass the `cursor` query parameter and follow the `next` link in each response.

### Changed

- Login requires a verified email address. Unverified accounts receive 403 with the `email_not_verified` error type, so clients must handle that error. See [Upgrade from version 2 to version 3](docs/how-to/upgrade-to-v3.md).

### Deprecated

- The `page` query parameter of `GET /orders`. Use `cursor` instead.

### Fixed

- Cart totals stay at zero when a discount exceeds 100%.

### Security

- Expired password reset tokens are rejected.

[unreleased]: https://github.com/example-org/shop-api/compare/v3.0.0...HEAD
[3.0.0]: https://github.com/example-org/shop-api/compare/v2.2.0...v3.0.0
```

Hashes, merge commits, refactoring, CI, and the typo fix disappear because no user notices them, and each remaining commit becomes a sentence about its effect under one of the six types. The breaking change now says what clients must do and links the migration guide, and the date and comparison links make the version easy to place and inspect.

## Vague how-to guide rewritten in Google style (Markdown, shell, YAML)

Before

```markdown
## Deployment

Deploying is pretty easy. The config should be set up first, it's in the deploy folder. Then the deploy script can be run and hopefully it will work. If you're on staging you might want the dry run flag. Click here for more info on environment variables.
```

After

````markdown
# Deploy the app to staging

This guide shows you how to deploy the app to the staging environment. To deploy to production, see [Deploy the app to production](deploy-to-production.md).

Before you begin, make sure that you can push images to the staging registry and that your working copy is on the `main` branch.

1. Copy the example configuration file.

   ```sh
   cp deploy/staging.example.yaml deploy/staging.yaml
   ```

2. In `deploy/staging.yaml`, set `image_tag` to the tag that you want to deploy.

   ```yaml
   environment: staging
   image_tag: 2026.10.11-1
   replicas: 2
   ```

3. Optional: Preview the changes without applying them.

   ```sh
   ./scripts/deploy.sh --env staging --dry-run
   ```

   The script lists the resources that it would change and exits.

4. Run the deployment.

   ```sh
   ./scripts/deploy.sh --env staging
   ```

   The script prints `Deployment complete` when the new version serves traffic.

For every setting in the file, see the [deployment configuration reference](../reference/deploy-config.md).
````

The title names the goal, the reader is "you", and the conditions come before the steps. Each step holds one action that starts with an imperative verb and ends with its result, the flags and messages are copied from the script and its `--help` output, and the full settings list stays in reference behind a descriptive link.

## Migration guide (Markdown, TypeScript)

Before

```markdown
## Upgrading to v3

v3 has a new client API. Things were refactored and some options were renamed, so update your code accordingly. See the changelog for details.
```

After

````markdown
# Upgrade from version 2 to version 3

This guide shows you how to update an application that uses `@example/shop-client` version 2 to version 3.

1. Update the package.

   ```sh
   npm install @example/shop-client@3
   ```

2. Update the `ShopClient` options. Version 3 renames `apiKey` to `token` and replaces `timeout` in seconds with `timeoutMs` in milliseconds.

   Version 2

   ```typescript
   const client = new ShopClient({ apiKey: process.env.SHOP_TOKEN, timeout: 10 });
   ```

   Version 3

   ```typescript
   const client = new ShopClient({ token: process.env.SHOP_TOKEN, timeoutMs: 10_000 });
   ```

3. Replace `listOrders(page)` with `listOrders({ cursor })`, and pass the `nextCursor` of each response to the next call.

   ```typescript
   let cursor: string | undefined;
   do {
     const page = await client.listOrders({ cursor });
     page.orders.forEach((order) => console.log(order.id));
     cursor = page.nextCursor;
   } while (cursor);
   ```

4. Handle the 403 response with the `email_not_verified` error type that login now returns for unverified accounts.

5. Run your test suite against version 3.

For every change in this release, see the [changelog entry for version 3.0.0](../../CHANGELOG.md).
````

A migration guide is a how-to guide with one goal, so it lists only what the reader must change, in order, with old and new code side by side. Every renamed option and unit is named exactly as in the source, and the full list of changes stays in the changelog.
