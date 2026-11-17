# Terraform and OpenTofu

Technical reference snapshot dated 2026-11-17. Terraform and OpenTofu features diverge. Confirm the binary, its version, the provider lockfile, and the current product documentation before using a version-specific feature.

## State and secrets

- Lock S3 state with `use_lockfile = true` (Terraform 1.10+, OpenTofu 1.10+). It defaults to `false`, and DynamoDB locking (`dynamodb_table`) is deprecated. The credentials need `s3:GetObject`, `s3:PutObject` and `s3:DeleteObject` on `<key>.tflock`. Set both options while migrating from DynamoDB, since locks are then taken from both.
- Keep secrets out of state and plan files with ephemeral values: `ephemeral` resources, variables and outputs (Terraform 1.10, OpenTofu 1.11) and write-only arguments such as `password_wo` (Terraform 1.11, OpenTofu 1.11). `sensitive = true` only hides a value in output, and the value still lands in state.
- Terraform 1.16+ adds a `store` block on `terraform_data` that holds ephemeral and sensitive values across plan and apply.

## Configuration

- Import declaratively with `import` blocks. They accept `for_each` (1.7 in both tools) and, in Terraform 1.12+, `identity` instead of `id`. Terraform 1.16+ allows `import` blocks inside child modules, earlier versions only in the root module.
- Terraform 1.15+ lets module `source` and `version` reference locals and variables declared with `const = true`. The `terraform` block, including `required_providers` and `backend`, still takes literal values only. OpenTofu 1.8+ accepts variables and locals in module sources and backend blocks without a `const` marker.
- Mark retiring inputs and outputs with `deprecated = "<migration hint>"` (Terraform 1.15, OpenTofu 1.10).
- Terraform only: `action` blocks, list resources in `.tfquery.hcl` files run by `terraform query` (1.14), Terraform Policy through `-policies` (GA in 1.17), `-minimal-refresh` (1.17) and Stacks.
- OpenTofu only: state and plan encryption (1.7), `lifecycle { enabled = <bool> }` instead of the `count = cond ? 1 : 0` toggle (1.11), `for_each` on provider configurations (1.9), `-exclude` (1.9) and `-exclude-file` (1.10), OCI registry sources for modules and providers (1.10), `prevent_destroy` from variables (1.12), and `.tofu` files that replace a same-named `.tf` file so one module can serve both tools (1.8).

## Tests

- `terraform test` and `tofu test` run blocks default to `command = apply`, which creates real infrastructure. Use `command = plan` or `mock_provider` (Terraform 1.7+, OpenTofu 1.8+) for unit tests. Mocking ephemeral resources needs Terraform 1.17.

## Gotchas

- Changing a write-only argument alone does nothing, because its value is never stored or compared. Increment the companion version argument (`password_wo_version`, or the provider's equivalent) in the same change.
- A `removed` block destroys the real object by default. Add `lifecycle { destroy = false }` to only drop it from state. Resources accept the same `destroy = false` lifecycle option in Terraform 1.16+ and OpenTofu 1.12+.
- `prevent_destroy` does not protect a resource whose block is deleted, because lifecycle rules are not stored in state.
- An apply error saying the object already exists (HTTP 409 on many providers) means it exists outside this state, for example after an interrupted apply. Adopt it with an `import` block. Retrying fails again, and renaming the resource to dodge the conflict creates a duplicate.
- `init` through a provider mirror or plugin cache records hashes for the current platform only, so runs on another OS or CPU fail later. Run `terraform providers lock -platform=linux_amd64 -platform=darwin_arm64` with one flag per platform in use. OpenTofu 1.12+ records checksums for every platform at `init` when the registry provides them. Run `init -lockfile=readonly` in CI so it fails instead of rewriting the lock file.
- OpenTofu refuses to read unencrypted state once encryption is configured. Migrate with a `method "unencrypted"` referenced from a `fallback` block, then remove it and set `enforced = true`. Renaming a key provider or method after encryption breaks decryption, so keep the old one in `fallback` or set `encrypted_metadata_alias`. A lost key means lost state, so back up the keys and the unencrypted state before enabling encryption.
- For CI authentication to cloud providers with OIDC, see the `github-actions` skill.
