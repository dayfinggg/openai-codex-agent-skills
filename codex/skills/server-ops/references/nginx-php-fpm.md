# nginx with PHP-FPM

Technical reference snapshot dated 2026-11-17. Check the exact Linux distribution package, nginx and PHP-FPM versions, active configuration, and current official documentation before relying on defaults or version-dependent directives.

- Debian's `fastcgi.conf` sets `SCRIPT_FILENAME` and `fastcgi_params` does not. A location that includes only `fastcgi_params` without its own `fastcgi_param SCRIPT_FILENAME ...;` line gives "Primary script unknown" in the log and "File not found." in the browser.
- Check that the script exists before passing it on, with `try_files $uri =404;` or Debian's `snippets/fastcgi-php.conf` (which runs `try_files $fastcgi_script_name =404;` and includes `fastcgi.conf`). Without it, any path ending in `.php`, uploaded files included, reaches PHP-FPM.
- Behind a release symlink, use `$realpath_root` instead of `$document_root` in `SCRIPT_FILENAME` and `DOCUMENT_ROOT`, so PHP sees the resolved release path.
- 502 means nginx could not talk to PHP-FPM: the socket path in `fastcgi_pass` differs from the pool's `listen`, the socket's `listen.owner` or `listen.mode` keeps nginx out, or the pool hit `pm.max_children` (the PHP-FPM log says "server reached pm.max_children setting"). 504 means PHP-FPM accepted the request and did not answer within `fastcgi_read_timeout` (60 seconds by default).

## Headers and conditions

- One `add_header` in a `location` drops every `add_header` inherited from `server` and `http`. On 1.29.3 and later `add_header_inherit merge;` appends the inherited ones instead. Headers reach error responses only with `always`.
- `try_files` is not inherited into the implicit location that `if` creates inside a `location`. Build conditional values with `map` and keep `if` to `return`, `rewrite` and `set`.
- `http2 on;` (1.25.1+) replaces the `http2` parameter of `listen`, which is deprecated.

## FastCGI cache

- `fastcgi_cache_key` has no default. Set it to `$scheme$host$request_uri` or more, and bypass the cache for logged-in cookies and POST with both `fastcgi_cache_bypass` and `fastcgi_no_cache`, or one user's page is served to everyone.
- nginx does not cache a response that carries `Set-Cookie`. Adding `Set-Cookie` to `fastcgi_ignore_headers` caches it, and the cached copy then hands one visitor's session cookie to everyone.

## Visitor addresses behind Cloudflare

- Restore the visitor address with `real_ip_header CF-Connecting-IP;` and one `set_real_ip_from` line per Cloudflare range. The ranges are published as plain lists at `https://www.cloudflare.com/ips-v4` and `https://www.cloudflare.com/ips-v6`. Read both lists when writing these lines or firewall rules.
- Generate the include file from both lists in one step and write it only after both downloads succeeded and each line parsed as an address range. An empty file trusts no proxy, and every visitor then appears with a Cloudflare address.

## PHP-FPM pools

- Settings that `php_admin_value` or `php_admin_flag` sets cannot be changed by `ini_set()`, while `php_value` settings can. Put limits the application must not raise, such as `memory_limit` or `disable_functions`, in `php_admin_value`.
- INI_SYSTEM settings such as `opcache.memory_consumption` belong in `php.ini`. OPcache's shared memory exists before any pool starts, and since PHP 8.5 changing its size afterwards reports a failure instead of silently doing nothing.
- Give each site its own pool with its own `user`, `listen` socket and `php_admin_value[open_basedir]`, so one compromised site cannot read another site's files.
- `pm = ondemand` with `pm.process_idle_timeout` suits many small sites on one host. `pm = dynamic` or `static` suits one busy site. Size `pm.max_children` from available memory divided by the resident size of a worker under load.
- `request_terminate_timeout` kills a worker that runs too long, which `max_execution_time` does not do for time spent outside PHP, such as waiting on a database or HTTP call.
