# Cron jobs and systemd timers

Technical reference snapshot dated 2026-11-17. Check the host's cron implementation, systemd version, distribution defaults, and current manuals before relying on a scheduling detail.

- Lines in `/etc/crontab` and `/etc/cron.d/*` have a user field after the five time fields. User crontabs (`crontab -e`, `crontab -u www-data -l`) do not.
- Write `%` as `\%` in the command, because cron turns an unescaped `%` into a newline and sends the rest to the command's stdin. `date +%F` in a crontab silently breaks.
- Debian's cron sets `PATH=/usr/bin:/bin`, `SHELL`, `HOME` and `LOGNAME`, and reads `MAILTO`. `/usr/local/bin` and `/usr/sbin` are missing, so set `PATH` at the top of the file or call binaries by absolute path, such as `/usr/bin/php8.4`.
- Debian's cron ignores files in `/etc/cron.d` whose names contain a dot, such as `site.cron` or `site.conf`, and files not owned by root or writable by group or others. Names may hold only letters, digits, underscores and hyphens.
- When both the day-of-month and the day-of-week field are restricted, the job runs when either matches. Debian's cron treats any field that starts with `*`, such as `*/2`, as unrestricted for this rule, so `0 0 */2 * sun` runs only on Sundays with an odd date.
- Run a site's PHP job as the site's user with the same PHP version as its PHP-FPM pool, and redirect output to a log: `*/5 * * * * www-data /usr/bin/php8.4 /var/www/site/current/cron.php >> /var/log/site/cron.log 2>&1`. Otherwise output goes to local mail, which nobody reads.

## Overlap and time zones

- Wrap a job that can outlast its interval in `flock -n /run/lock/<job>.lock <command>`. A held lock exits 1 like many failing jobs do, so add `-E <code>` when the two must differ.
- Debian's and Ubuntu's default `cron` package runs every job in the system time zone and ignores `CRON_TZ` without an error (cronie supports it). A `TZ=` line changes only the environment of the commands. Use a systemd timer with a time zone in `OnCalendar=`, or schedule in the system time zone.

## systemd timers

- A timer starts its service only when the service is not already running, so a timer job never overlaps itself and needs no `flock`.
- `Persistent=true` with `OnCalendar=` runs a missed job right after boot when the host was off at the scheduled time. It has no effect on monotonic timers such as `OnUnitActiveSec=`.
- Write the service as `Type=oneshot` with `User=` and an absolute `ExecStart=`, then `systemctl daemon-reload` and `systemctl enable --now site-job.timer`. Check the next run with `systemctl list-timers site-job.timer` and the output with `journalctl -u site-job.service`.
- Test a calendar expression before using it: `systemd-analyze calendar 'Mon..Fri *-*-* 03:00 Europe/Berlin'` prints the next elapse times.
- `AccuracySec=` defaults to 1 minute, so a timer may fire up to a minute late. Set `AccuracySec=1s` when the minute matters. `RandomizedDelaySec=` spreads jobs of many hosts.
- Before removing a timer that used `Persistent=true`, run `systemctl clean --what=state <name>.timer` to delete its timestamp file.
