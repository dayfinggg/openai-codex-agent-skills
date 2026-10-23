# Provenance, signing, and SBOM

The action SHAs point at the release in each comment and need re-resolving before use.

## Contents

- SLSA build levels
- GitHub artifact attestations
- Verifying attestations and releases
- Sigstore signing outside GitHub Actions
- SBOM
- Build once and promote

## SLSA build levels

SLSA 1.2 is the current approved specification ([slsa.dev/spec/v1.2](https://slsa.dev/spec/v1.2/build-requirements)).

| Level | Requirement |
|---|---|
| Build L1 | The build platform generates provenance that identifies the output by digest, and the producer distributes it |
| Build L2 | The build runs on a hosted platform, and the provenance is signed |
| Build L3 | Provenance resists forgery by tenants, each build runs isolated in a fresh environment, and build steps cannot reach the signing key |

- GitHub artifact attestations alone reach Build L2, stated by GitHub in terms of SLSA v1.0.
- For Build L3, build in a reusable workflow and verify with `--signer-workflow` pointing at it.
- PyPI trusted publishing does not work from a reusable workflow, so the build stays there and the PyPI publish job stays in the top-level workflow.
- NIST SP 800-204D asks that attestations come from a component more trusted than the build and only after the build policy passes, so the attestation step follows the tests in the same trusted job.

## GitHub artifact attestations

Sources are the [GitHub Docs on artifact attestations](https://docs.github.com/en/actions/concepts/security/artifact-attestations), the [how-to page](https://docs.github.com/en/actions/how-tos/secure-your-work/use-artifact-attestations/use-artifact-attestations), and the [actions/attest README](https://github.com/actions/attest).

- **Predicate.** Without `sbom-path` or predicate inputs, `actions/attest` creates SLSA build provenance. With `sbom-path`, it attests a JSON SBOM in SPDX or CycloneDX format, at most 16 MB.
- **Subjects.** Files go in `subject-path`, which accepts globs. Images use `subject-name` without a tag plus `subject-digest` as `sha256:<hex>`, and `push-to-registry: true` stores the attestation next to the image.
- **Permissions.** `id-token: write`, `attestations: write`, and `contents: read`. Images on GHCR also need `packages: write`. `artifact-metadata: write` is needed only for the storage record made with `push-to-registry`, which works for organization-owned repositories.
- **Signing.** Public repositories use the Sigstore Public Good instance with a public transparency log. Private repositories use GitHub's own Sigstore instance, which has no transparency log.

Attesting release binaries

```yaml
  attest:
    needs: build
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
      attestations: write
    steps:
      - uses: actions/download-artifact@9000827ccba6bdab643e8b6fd33ac0654aef8333 # v8.0.2
        with:
          name: binaries
          path: dist/
      - uses: actions/attest@1e69f48acb82d1966a394da916b4c1698aa569d6 # v4.2.2
        with:
          subject-path: "dist/*"
```

Attesting a pushed image

```yaml
      - uses: actions/attest@1e69f48acb82d1966a394da916b4c1698aa569d6 # v4.2.2
        with:
          subject-name: ghcr.io/${{ github.repository }}
          subject-digest: ${{ steps.push.outputs.digest }}
          push-to-registry: true
```

## Verifying attestations and releases

```bash
gh attestation verify dist/app-linux-amd64 -R example-org/example-app
gh attestation verify oci://ghcr.io/example-org/example-app:1.4.0 -R example-org/example-app
gh attestation verify dist/app-linux-amd64 -R example-org/example-app --predicate-type https://spdx.dev/Document/v2.3
gh release verify v1.4.0
gh release verify-asset v1.4.0 dist/app-linux-amd64
```

- `-R` or `--owner` is required. The default predicate type is `https://slsa.dev/provenance/v1`.
- `--signer-workflow` enforces which workflow signed the artifact.
- Verifying an `oci://` image needs a prior `docker login` to its registry.
- `gh release verify` checks that a release exists and is immutable. `gh release verify-asset` checks a local file against the release attestation, and cannot verify the source zip or tarball GitHub generates.
- GitHub immutable releases lock the tag to its commit and lock the assets, and generate a release attestation automatically.

## Sigstore signing outside GitHub Actions

Sources are the [Sigstore overview](https://docs.sigstore.dev/about/overview/) and the [cosign verification docs](https://docs.sigstore.dev/cosign/verifying/verify/). Fulcio issues a short-lived certificate bound to the CI's OIDC identity, and Rekor is the transparency log, so no long-lived key exists. Sign images by digest, and verify against the expected identity and issuer rather than the mere presence of a signature.

```bash
cosign sign "registry.example.com/app@${DIGEST}"
cosign verify "registry.example.com/app@${DIGEST}" --certificate-identity="${SIGNER_IDENTITY}" --certificate-oidc-issuer="${OIDC_ISSUER}"
```

## SBOM

- **Formats.** CycloneDX 1.7 is published by Ecma as ECMA-424 2nd edition. SPDX 3.0.1 is the current SPDX release, while ISO/IEC 5962:2021 corresponds to SPDX 2.2.1.
- **Generation.** From the built artifact or pushed image, not from the manifest alone, so it lists what shipped. OWASP Top 10 2025 A03 asks to generate and manage SBOMs centrally.
- **Tool.** `anchore/sbom-action` runs Syft. Its `format` input accepts `spdx`, `spdx-json`, `cyclonedx`, and `cyclonedx-json`, with `spdx-json` as the default. Its `upload-artifact` and `upload-release-assets` inputs default to `true`.

```yaml
      - uses: anchore/sbom-action@66cbf4bc1f1c0d2edc94016e65bc221b6bb0ad6c # v0.24.3
        with:
          image: ghcr.io/${{ github.repository }}@${{ steps.push.outputs.digest }}
          format: cyclonedx-json
          output-file: sbom.cdx.json
      - uses: actions/attest@1e69f48acb82d1966a394da916b4c1698aa569d6 # v4.2.2
        with:
          subject-name: ghcr.io/${{ github.repository }}
          subject-digest: ${{ steps.push.outputs.digest }}
          sbom-path: sbom.cdx.json
          push-to-registry: true
```

## Build once and promote

- NIST SP 800-204D DEPLOY-REQ-3 allows deploying only artifacts from the trusted build process.
- The build job outputs the digest. Every later job, whether test, scan, staging, or production, receives it as a job output and never builds again.
- Before production, verify the attestation of that digest against the expected repository and signer workflow.
