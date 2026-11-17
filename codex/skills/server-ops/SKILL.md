---
name: server-ops
description: Diagnose or change remote Linux hosts over SSH, including deployments, disk cleanup, service configuration and backups. Includes PHP, nginx, cron, systemd, and Cloudflare references.
license: MIT
---

# Linux host operations

Read [Remote change safety](references/change-safety.md) before diagnosing or changing a live host. The remainder of this entrypoint and the other references cover PHP sites and Linux job scheduling. Version and platform details are a dated snapshot. Inspect the target host and check current documentation for its installed versions.

The SSH, sync, web-server, cache, and scheduler commands are examples for a Linux host. Use the shell or remote-session tools available in the current Codex session. This skill does not grant capabilities or authorization.

## References

Open the full reference before the first step it covers, even when that step comes later in the task.

- [references/nginx-php-fpm.md](references/nginx-php-fpm.md): read when writing or debugging an nginx server block for PHP, FastCGI caching, headers, "Primary script unknown", "File not found.", 502 or 504 errors, or PHP-FPM pool settings.
- [references/cron-systemd.md](references/cron-systemd.md): read when adding, changing or debugging a crontab, an `/etc/cron.d` file or a systemd timer.
- [references/cloudflare.md](references/cloudflare.md): read when restoring visitor IPs, restricting the origin to Cloudflare, changing cache rules or cache headers, purging, reading `cf-cache-status`, or debugging 520 to 526 errors.

## Check first

- Read what runs on each host before writing config: `nginx -V 2>&1 | grep -o realip`, `systemctl list-units 'php*-fpm*'`, the pool that serves the site (`grep -rn '^listen' /etc/php/*/fpm/pool.d/`), the server block (`nginx -T 2>/dev/null | grep -n server_name`) and `dpkg -l cron cronie`. The PHP that serves the site is the pool's `php-fpm8.x`, which can differ from the `php` CLI on `PATH`.
- Distribution packages lag upstream: Debian 13 ships nginx 1.26.3, Debian 12 1.22.1, Ubuntu 26.04 1.28.3, Ubuntu 24.04 1.24.0 and Ubuntu 22.04 1.18.0. `http2 on;` needs 1.25.1 and `add_header_inherit` needs 1.29.3, so both fail `nginx -t` on the older ones.
- List what the pre-production and production copies of a site share before a write: database, upload and cache directories, Memcached instance and key prefix, error log and cron jobs.
- Upstream nginx before 1.30.6 and 1.31.7 has five CVEs fixed on 2026-10-14, among them buffer overflows with `alias` plus `rewrite` (CVE-2026-15176) and in script evaluation (CVE-2026-93479). On distribution packages, check the package changelog for those CVE numbers.

## Deploys and SSH

- Scripted SSH needs `BatchMode`, which turns a password prompt or an unknown host key into an error instead of a hang, a connect timeout, and one shared connection per host (`ControlMaster auto`, `ControlPath ~/.ssh/cm-%C`, `ControlPersist 10m`), which saves the handshake of every call. See what `~/.ssh/config` already sets with `ssh -G host | grep -i -E 'batchmode|connecttimeout|controlmaster|controlpersist'`, and pass with `-o` only what is missing, so that most calls read `ssh -o BatchMode=yes host cmd`.
- Roll one change out host by host, one loop iteration each: pre-production step, its check, production step, its check. Stop the loop at the first failed check, and test the exit status of every `ssh` call.
- Before editing a config file or running `sed -i` on a host, copy the files to your machine (`scp host:/etc/nginx/sites-available/site.conf backup/`), so the old version can be restored.
- Switch a release by building it in a new directory and replacing the `current` symlink: `ln -s NEW current.tmp && mv -T current.tmp current` is atomic everywhere, and GNU `ln -sfn` (coreutils 8.27+) is too. Without `-n` or `-T` the new link lands inside the old release directory. BusyBox `ln -f` deletes the link first.
- `rsync --link-dest=PREV` hard-links unchanged files into the new release, so editing such a file in place also changes the previous release. `--delay-updates` only narrows the window of an in-place sync and is not atomic.

## Reloads

- Test before every reload, then read the log: `nginx -t && systemctl reload nginx`, then `tail -n 50 /var/log/nginx/error.log`. The Debian and Ubuntu unit reloads with `nginx -s reload` and no test, so a config that fails at reload leaves the old one running while `systemctl` exits 0.
- Test and reload PHP-FPM the same way: `php-fpm8.4 -t && systemctl reload php8.4-fpm`. The Debian unit reloads with `kill -USR2` and no test. Pools live in `/etc/php/<version>/fpm/pool.d/` and the master log in `/var/log/php<version>-fpm.log`.
- Worker stdout and stderr go to `/dev/null` unless the pool sets `catch_workers_output = yes`, and PHP errors land where `php_admin_value[error_log]` points. Find it before concluding that nothing failed.

## Caches after a deploy

- OPcache with the defaults `validate_timestamps=1` and `revalidate_freq=2` picks up changed files one by one within about 2 seconds, so a release of many files mixes old and new code for a moment. With `validate_timestamps=0` nothing changes until PHP-FPM reloads or `opcache_reset()` runs inside a request that PHP-FPM serves.
- With a `current` symlink, set `fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;` and `fastcgi_param DOCUMENT_ROOT $realpath_root;`. Otherwise each worker's realpath cache (`realpath_cache_ttl`, 120 seconds) keeps serving the old release.
- Smarty recompiles a changed template only while compile check is on. With `setCompileCheck(Smarty::COMPILECHECK_OFF)` or `$compile_check = false` in production, clear the compiled-template directory (`templates_c` or the project's equivalent) as part of the deploy.
- Clear one site's Memcached data by changing a version or prefix in that site's keys, or by deleting known keys. Read the instance with `printf 'stats\r\nquit\r\n' | nc 127.0.0.1 11211`, and list keys with `lru_crawler metadump all`, which does not lock the cache.
- Purge Cloudflare only after the origin serves the new content, or the next request caches the old version again. Details are in the Cloudflare reference.

## Gotchas

- `flush_all` empties the whole Memcached instance, every site and every session stored in it. Its delay argument only postpones that.
- `php -r 'opcache_reset();'` runs in the CLI, whose OPcache is off by default (`opcache.enable_cli=0`), and leaves PHP-FPM's cache untouched.
- Since nginx package 1.26.3-3+deb13u4 on Debian 13 and 1.22.1-9+deb12u6 on Debian 12, `fastcgi_params` sets `HTTP_HOST` to `$host`, which drops the port the client sent. A CMS that builds absolute URLs from it behaves differently on hosts with older packages.
- Cloudflare answers 524 when the origin sends no response within 125 seconds, while PHP-FPM keeps running the request. Run long jobs from the CLI or cron, not in a web request.
- OpenSSH 10.1 broke sessions with `ControlPersist` (fixed in 10.2) and warns on stderr when the connection uses a key exchange that is not post-quantum. Silence that warning with `WarnWeakCrypto no-pq-kex` in `~/.ssh/config` or `-o WarnWeakCrypto=no-pq-kex`, not with `2>/dev/null`, which hides real errors too. Since 10.0 `scp` and `sftp` pass `ControlMaster no`, so they reuse an existing master but never start one.
- Behind Cloudflare, `$_SERVER['HTTP_CF_CONNECTING_IP']` in PHP skips nginx's trusted-proxy check, so any client that reaches the origin directly can set it. Read `REMOTE_ADDR` after nginx's realip module has restored it.

Related skills: use `$shell` for command quoting, `$php` for PHP code, `$database` before touching production data, and `$debugging` when the logs do not establish the cause.
