Read when investigating 502/504 responses, slow FastCGI requests, worker exhaustion, or stale PHP code after deployment.

1. Trace the actual web server, FastCGI endpoint, FPM binary, pool, process user, loaded configuration, and application revision. CLI PHP does not establish request-serving FPM configuration or OPcache state. Match the PHP version before selecting settings or binary validation options.

2. Correlate web-server, FPM, and application evidence by request and timestamp. Distinguish refused connections or socket permissions, queue delay, execution timeouts, worker crashes, and application exceptions. Inspect the first failing boundary before changing another layer's timeout.

3. For saturation, inspect process-manager mode, listen queue, busy workers, `pm.max_children`, measured worker memory, and container or service memory limits. Derive capacity from measurements with room for the system and dependencies. Do not blindly increase the worker count. Use existing private status access only, never expose a diagnostic endpoint or `phpinfo()`.

4. For slow work, use available slowlogs, profiles, and metrics to distinguish database waits, session locks, outbound calls, and filesystem I/O. In PHP 8.5, `request_slowlog_timeout` controls when a request backtrace is written to `slowlog`. Enabling or changing collection on a live pool requires authorization and bounded overhead. Increasing an execution timeout is not proof of a cause-directed fix.

5. For stale code, inspect the request-serving SAPI's `opcache.validate_timestamps`, `opcache.revalidate_freq`, realpath caching, preloading, and publication strategy. With timestamp validation disabled, filesystem changes alone do not refresh cached code. A CLI cache reset does not prove FPM was refreshed. Preserve the evidence that identifies stale cached code before selecting an authorized invalidation or supported graceful update.

6. Validate the correction with the actual serving binary and configuration, checking its documented validation options first. Apply the supported graceful-update mechanism only within existing authorization, accounting for active requests. Retain a restoration path for the old configuration. Verify the serving application revision, original request, queue and worker health, and error rate afterward.

The PHP manual documents [FPM settings](https://www.php.net/manual/en/install.fpm.configuration.php) and [OPcache settings](https://www.php.net/manual/en/opcache.configuration.php), including version-specific availability. Check the serving version against [supported PHP branches](https://www.php.net/supported-versions.php) without inferring it from CLI PHP.
