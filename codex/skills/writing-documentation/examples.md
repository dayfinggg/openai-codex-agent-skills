# Documentation examples

These pairs are illustrative.

## README that mixes tutorial and reference

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

The argument table moves to reference, the eviction design to explanation, and the install alternatives go because a quickstart needs one path.

## Git log dump rewritten as a changelog

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

Hashes, merge commits, refactoring, CI, dependency bumps, and the typo fix go because no user notices them. The breaking change says what clients must do and links the migration guide.
