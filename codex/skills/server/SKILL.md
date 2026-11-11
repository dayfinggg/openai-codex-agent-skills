---
name: server
description: Guides safe work on a remote or production host over SSH, such as a web server, a container host, or a job scheduler. Use it before any command that changes a server, including config edits, service reloads and restarts, firewall and SSH access changes, cron edits, container and volume commands, package upgrades, disk cleanup, and deploys. Use it when you diagnose a live service on a host you reach over SSH.
---

<overview>
A command on a remote host changes a live system that other services and people share, and most of it cannot be undone from the conversation. Treat every host you reach over SSH as production until the user says it is disposable. Read before you change, change one thing at a time, and prove that the service works after each change. The `database` skill covers the data stores on the host.
</overview>

<know_the_host>
Before the first change, find out what the host is and how the thing you will change is managed.
- Confirm the target with `hostname` and the OS release, and list what else runs there, such as the services, the containers, and the listening ports. A shared service such as a web server or a database serves every site on the host, so its restart reaches all of them.
- Find the source of truth for the file or service. A config can come from a repository, a container image, a configuration tool, or a hosting panel, and such a source overwrites a hand edit on its next run. Change the source, or tell the user that the edit will not survive. Deploy the way the project deploys, through its script or pipeline, because a step run by hand skips what that path checks.
- Check free disk space and memory before a change that writes a lot, such as an upgrade, a build, a dump, or an image pull, because a full disk stops it halfway.
- The `shared_systems` block of the coding instructions applies before a heavy command, also a read-only one such as a crawl, a benchmark, a search over a large tree, or a scan of a large table. `nproc`, `free -m`, `uptime`, and the list of scheduled jobs show the cores, the memory, the current load, and what will start beside your command, and the response time of a real page serves as the health signal.
</know_the_host>

<config_changes>
A config change takes these steps.
1. Copy the file with its metadata before the edit, as in `cp -a site.conf /root/site.conf.bak-20261111`, and name the copy in the report. Keep the copy outside the directory the service loads, because some services read every file there.
2. Make the edit.
3. Validate with the service's own check before you apply anything. The table lists common checks, and another service has its own.
4. Apply with a reload where the service supports one, because a restart drops open connections. After a change to a systemd unit file, run `systemctl daemon-reload` first.
5. Prove the result with the service state, its log since the change, and a real request to the service.
6. If the proof fails, restore the copy, validate, apply again, and report what happened.

| Service | Check |
|---|---|
| nginx | `nginx -t` |
| Apache httpd | `apachectl configtest` |
| Caddy | `caddy validate --config <file>` |
| HAProxy | `haproxy -c -f <file>` |
| OpenSSH server | `sshd -t` |
| sudoers | `visudo -c`, or `visudo -cf <file>` for one file |
| systemd unit | `systemd-analyze verify <unit>` |
| PHP-FPM | `php-fpm -t` |
| Docker Compose | `docker compose config --quiet` |
</config_changes>

<access>
A change to the SSH server, the firewall, the network, sudoers, or your own account can cut off the only way in. Keep the current session open, validate the change, apply it, and then open a second connection to prove that login still works before you close the first. Allow the SSH port in a firewall before you enable it or set a default deny. Edit sudoers only through `visudo` or a validated drop-in file. When the host has no second way in, such as a provider console, say so and let the user decide before you apply the change.
</access>

<destructive_commands>
These commands destroy data or take the host down, so you never run them on your own initiative. The list gives examples, and the rule covers every command of this kind.
- `rm -rf` on a path built from a variable or a glob that you have not expanded and listed first
- `docker compose down -v`, which deletes the named volumes of the project, `docker volume rm`, and `docker volume prune` or `docker system prune --volumes`, which delete unused anonymous volumes, and with `docker volume prune -a` the unused named ones too
- `crontab -r`, which removes the whole crontab and asks first only with `-i`
- `chown -R` or `chmod -R` on a broad path
- `kill -9` on a process you have not identified, `reboot`, and `shutdown`
- `rsync --delete` before a run with `--dry-run` showed what it removes
- A distribution upgrade, or the removal of a package that other packages need

If one of these looks necessary, tell the user what it would destroy and on which host. Run it only when the user's request names that command or the user confirms it.

Change a crontab through a file. Save it with `crontab -l > crontab.bak`, edit a copy, and install the copy with `crontab <file>`.

Free disk space by evidence. Find what holds the space with `df -h` and `du -xh --max-depth=1 <dir>`. Delete only what its own tool treats as disposable, through that tool, such as `journalctl --vacuum-size=500M`, the package manager's cache cleanup, or `docker image prune`. Backups, uploads, database files, and volumes wait for the user's word.
</destructive_commands>

<unattended_commands>
A command you send over SSH has no terminal, so a prompt hangs it until it times out.
- Connect with `ssh -o BatchMode=yes -o ConnectTimeout=10 <host> '<command>'`, so a missing key fails at once instead of asking for a password.
- Quote the remote command in single quotes, or send a script on standard input as in `ssh <host> 'bash -s' < script.sh`, so the local shell does not expand what the remote shell should.
- Turn off pagers and prompts, as with `systemctl --no-pager`, `journalctl --no-pager`, `sudo -n`, and the package manager's non-interactive mode. A package upgrade can restart the services it touches, so run one only when the task asks for it.
- Start a long job, such as an upgrade, a dump, or a migration, so that it survives a dropped connection, for example under `systemd-run`, `tmux`, or `nohup`, and send its output to a log file. Note its process id at the start, and wait for it as the `long_running_work` block of the coding instructions describes, not in an open SSH command.
- Keep secrets out of command lines and out of the conversation, as the `secrets` block of the coding instructions describes.
</unattended_commands>

<diagnosis>
Diagnose a live service read-only first. Read the service state, its log for the time of the fault, as with `journalctl -u <unit> --since "1 hour ago"`, the resource use of the host, and what changed recently, such as a deploy, a package update, or an edited config. The `debugging` block of the coding instructions allows a restart only when the evidence supports it. A restart also erases the state that explains the fault, so save the log and the process state first.
</diagnosis>

<report>
End a task that changed a host with these facts in the reply, inside the length the `writing_style` rules set. Name the host, each file you changed with the path of its copy, each command that changed state, the check that proved the result, and the way back. Remove the temporary files you created on the host, and name any you left on purpose.
</report>
