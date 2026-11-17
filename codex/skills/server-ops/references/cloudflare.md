# Cloudflare in front of a PHP site

Technical reference snapshot dated 2026-11-17. Cloudflare policies, product limits, cache defaults, and published address ranges can change. Check current Cloudflare documentation and account settings before changing rules or origin access.

- Cloudflare caches by file extension, not by MIME type. CSS, JS, images, fonts, archives and `robots.txt` are cached, HTML and JSON are not, so PHP pages come back `DYNAMIC` unless a Cache Rule makes them eligible.
- With no `Cache-Control` or `Expires` from the origin, a cacheable file is kept 120 minutes for 200, 206 and 301, 20 minutes for 302 and 303, 3 minutes for 404 and 410. Other status codes are not cached.
- On Free, Pro and Business, Origin Cache Control is always on: `no-cache`, `max-age=0` and `s-maxage=0` mean "cache and revalidate every time", not "do not cache". Only `no-store` and `private` keep a response out of the cache. A `Set-Cookie` header, a method other than GET and `Vary: *` also prevent caching. Fractional TTLs such as `max-age=2.5` are ignored.
- `Cloudflare-CDN-Cache-Control` beats `CDN-Cache-Control`, which beats `Cache-Control`, for the edge. `s-maxage` turns off `stale-while-revalidate`.
- A Cache Rule with "Eligible for cache" turns on Cache Everything, so a rule on `/` caches HTML for every visitor, logged-in pages included, unless the origin sends `private`, `no-store` or `Set-Cookie`. With such a rule an origin `no-store` gives `BYPASS`. An Edge TTL rule set to ignore the origin's headers overrides even `no-store`.
- Page Rules are deprecated but still run. Cache Rules override them for the same path, and the automatic migration has no fixed date.
- The default cache key holds the scheme, host, path and full query string, so `?a=1&b=2` and `?b=2&a=1` are two entries unless Sort Query String is on. Ignore Query String makes `?v=1` and `?v=2` share one entry and breaks `?v=` cache busting. Changing the SSL mode between Off or Flexible and Full busts the cache.
- Development Mode bypasses the edge cache for three hours, does not purge anything and does not touch browser caches. Use a Bypass Cache Rule for longer.
- The Browser Cache TTL defaults to 4 hours and replaces a shorter origin value. A purge never clears what browsers already hold.

## `cf-cache-status`

| Value | Meaning |
| --- | --- |
| `HIT` | Served from Cloudflare's cache |
| `MISS` | Eligible but not in cache, fetched from the origin |
| `EXPIRED` | In cache but expired, fetched from the origin |
| `STALE` | Expired, served from cache because the origin did not answer |
| `REVALIDATED` | The origin confirmed the cached copy with a conditional request |
| `UPDATING` | Expired, served from cache while the origin refreshes it |
| `DYNAMIC` | Not eligible at request time, no cache lookup (HTML and JSON by default, Bypass rules, Development Mode) |
| `BYPASS` | Eligible, but the origin response was not cacheable (`no-store`, `private`, `Set-Cookie`, `Vary: *`, size limit) |
| `NONE` or `UNKNOWN` | Cloudflare answered before the cache (WAF block, redirect rule, Worker without a subrequest) |

## Purging

- Purge after the origin serves the new content, because the next request otherwise caches the old version again.
- `POST https://api.cloudflare.com/client/v4/zones/$ZONE_ID/purge_cache` with a token that has the Cache Purge permission and exactly one of `{"files":[...]}`, `{"prefixes":[...]}`, `{"tags":[...]}`, `{"hosts":[...]}` or `{"purge_everything":true}`. All plans have every type.
- A 200 with `success: true` means the request was accepted, not that anything was removed. Request the URL afterwards and check `cf-cache-status`. With Tiered Cache the first request after a purge can show `EXPIRED` instead of `MISS`.
- A URL purge must match the cached key exactly: scheme, host, case-sensitive path and every query string variant. Wildcards do not work. A prefix purge (`www.example.com/blog/`, no scheme, no `?`) covers every query string under the path. Purging a redirect purges only the redirect, not its target.
- Limits are per account: at most 100 URLs or prefixes per request on Free, Pro and Business. Prefix, host, tag and purge-everything calls are limited to 5 per minute on Free, 5 per second on Pro, 10 per second on Business.
- Purge by tag needs the origin to send a `Cache-Tag` header, which Cloudflare strips before the visitor sees it.

## Origin behind Cloudflare

- An origin that answers any address lets a client skip Cloudflare's protection and send its own `CF-Connecting-IP`. Allowing only Cloudflare's ranges is rated "moderately secure", because other Cloudflare customers reach the origin from the same ranges. Cloudflare Tunnel and Authenticated Origin Pulls (Full or Full strict SSL) are rated "very secure".
- Cloudflare publishes its address ranges as plain lists at `https://www.cloudflare.com/ips-v4` and `https://www.cloudflare.com/ips-v6`. They change over time, so regenerate the `set_real_ip_from` include and the firewall rules from those lists on a schedule, then test and reload. The IPv4 list includes `131.0.72.0/22`, which older copies lack.
- `CF-Connecting-IP` holds one address and is preferred over `X-Forwarded-For`, which a client can pre-fill. With Pseudo IPv4 set to overwrite headers, the real IPv6 address is in `CF-Connecting-IPv6`. The "Remove visitor IP headers" Managed Transform removes the header.

## 52x errors

| Code | Cloudflare saw | Check first |
| --- | --- | --- |
| 520 | An empty, malformed or unknown origin response | PHP crashes, response headers over 128 KB (often cookies), a firewall resetting Cloudflare |
| 521 | The origin refused the connection | Web server down, Cloudflare ranges blocked, port 80 (Flexible) or 443 (Full) closed |
| 522 | No SYN+ACK within 19 seconds or no ACK within 90 seconds | Firewall or rate limit on Cloudflare ranges, overloaded origin, wrong origin IP in DNS |
| 523 | No route to the origin | Wrong A or AAAA record |
| 524 | Connected, but no HTTP response within 125 seconds | Long PHP requests, which keep running after Cloudflare gives up |
| 525 | TLS handshake failed in Full or Full strict | Port 443, SNI, certificate present, ciphers |
| 526 | Invalid origin certificate in Full strict | Expired, self-signed or wrong-name certificate, incomplete chain. Switching to Full only hides it |
