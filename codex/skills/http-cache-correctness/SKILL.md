---
name: http-cache-correctness
description: "Verify HTTP caching and cache-header changes across browsers, proxies, and applications. Use for Cache-Control, Vary, ETag, Nginx cache, revalidation, or personalized-response caching."
---

Treat caching as a response-correctness contract.

1. Identify every cache on the affected path, which one owns freshness, and the actual request and response headers. Establish whether a cache is private or shared and whether the response depends on identity, tenant, locale, encoding, or request parameters.
2. Define the cache key and variants from verified response dependencies. Do not assume that adding a session identifier to a key is a sufficient or appropriate authorization design.
3. Derive storage, freshness, and revalidation behavior from Cache-Control, validators, Vary, and supported implementation rules. Distinguish no-cache from no-store and private from shared-cache permission.
4. For Nginx, distinguish bypassing a cached read from preventing storage of an upstream response. Inspect proxy_cache_bypass, proxy_no_cache, response-header handling, and any override of upstream instructions.
5. Specify invalidation and stale-response behavior for writes, errors, and background refresh. Check that a cached error or stale success cannot conceal the changed contract.
6. Verify a cold request, a hit, a changed representation, revalidation, and relevant authenticated or cross-tenant requests. Observe the actual body and headers rather than relying on a configuration that appears correct.
7. Measure cache effectiveness only after correctness holds. Compare hit rate, origin work, and latency over equivalent traffic. Do not clear a shared cache merely to obtain a clean benchmark.

Keep existing policies and limits unless the task explicitly changes them. Never cache secrets or personalized output by applying a blanket public policy.

Read [RFC 9111](https://www.rfc-editor.org/rfc/rfc9111.html) and the exact implementation documentation governing the changed cache.

