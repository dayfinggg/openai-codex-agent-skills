# Webhooks: sending and receiving

Technical reference snapshot dated 2026-11-17. Check the current Standard Webhooks specification and the provider documentation before applying version-specific headers, limits, or retry behavior. Providers with their own scheme, such as Stripe, document their format and tolerance separately.

## Sending

- Sign each delivery the Standard Webhooks way with three headers: `webhook-id` (unique per message, reused on retries), `webhook-timestamp` (integer Unix seconds) and `webhook-signature`.
- The signed content is `msg_id.timestamp.payload`, joined with `.`. The symmetric scheme is HMAC-SHA256, sent as `v1,` plus the base64 signature. The asymmetric scheme is `v1a`.
- Secrets are base64 and prefixed `whsec_` (symmetric), `whsk_` and `whpk_` (asymmetric secret and public key). Use one key per endpoint, never one shared across customers.
- Rotate secrets without downtime by signing with the old and the new key for a period and sending both signatures, space-separated, in `webhook-signature`.
- Send the exact bytes you signed. Re-serializing the JSON after signing breaks verification.
- Count only 2xx as success. Treat 3xx as failure and do not follow redirects. On 410 Gone disable the endpoint. On 429, 502, 503 and 504 slow down, and honor `Retry-After`.
- Time out each attempt after 15 to 30 seconds.
- Retry over days with exponential backoff and jitter. The specification's example schedule: immediately, then after 5 seconds, 5 minutes, 30 minutes, 2, 5, 10, 14, 20 and 24 hours (about 75 hours in total). After that, disable the endpoint and tell the customer through another channel.
- Send to customer-supplied URLs through an egress proxy that blocks private and cloud-metadata addresses (Stripe's smokescreen is one), and run the workers in a subnet without access to internal services. Otherwise each endpoint URL is an SSRF probe.
- Message IDs and timestamps must not be user-controlled and must not contain `.`, or the signed content can be shifted between fields.

## Receiving

- Verify the signature over the raw request bytes before parsing. A global JSON body parser, re-serializing the parsed body (`JSON.stringify(req.body)`) or trimming whitespace makes every verification fail. Read the raw body (Express `express.raw({ type: 'application/json' })` on that route, Next.js `await request.text()`) and parse after verifying.
- Compare signatures in constant time, accept a match on any signature in the header, and reject timestamps outside a tolerance window to stop replays.
- Deduplicate by the message or event ID, because senders retry and deliver more than once.
- Do not rely on delivery order. Fetch the current state of the object from the provider's API when order matters.
- Answer 2xx quickly and do the work in a queue. A slow handler times out, and the sender retries a delivery that is still being processed.
- Exempt the webhook route from CSRF middleware, and keep the signature check as its authentication.
