---
name: php-fpm-opcache-diagnostics
description: "Diagnose PHP-FPM and OPcache for 502/504 errors, slow requests, worker exhaustion, or stale code after deployment. Use for PHP runtime, php.ini, and FPM pool issues."
---

Find the failure in the actual Nginx, FastCGI, PHP-FPM, and application request path.

1. Establish the service, environment, time range, and affected request. Identify the serving FPM binary, pool, FastCGI endpoint, process user, and loaded configuration. Do not infer FPM settings from CLI PHP.
2. Correlate Nginx, FPM, and application logs by time and request identity. Distinguish refused connections, queue delay, execution timeout, process crashes, and application exceptions.
3. For worker exhaustion, inspect the process-manager mode, queue, busy workers, process limits, measured process memory, and service or container memory limit. Derive capacity from measurements while reserving capacity for the system and dependencies. Do not blindly raise pm.max_children.
4. For slow requests, use available slowlogs, profiles, and metrics. Check database waits, session locks, external requests, and filesystem I/O. A larger timeout does not establish a root-cause fix.
5. For stale code, inspect timestamp validation, realpath caching, preloading, and the file publication strategy. Verify OPcache in the request-serving SAPI. Resetting CLI OPcache does not prove FPM was refreshed.
6. Prepare the smallest correction, validate it with the appropriate binary, and apply it within existing authorization. Use the supported graceful-update mechanism and account for active requests.
7. Verify the application revision, the original request, worker health, and error rate. Keep a practical restoration path for the preceding configuration.

Do not expose a diagnostic endpoint or phpinfo to obtain configuration. Read version-matched [PHP-FPM](https://www.php.net/manual/en/install.fpm.configuration.php) and [OPcache](https://www.php.net/manual/en/opcache.configuration.php) documentation.

