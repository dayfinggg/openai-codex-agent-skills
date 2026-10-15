import hashlib
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import tomllib
import unittest


ROOT = Path(__file__).resolve().parents[1]


class PayloadChecks:
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="codex-agents-test-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.source = self.root / "source payload"
        self.destination = self.root / "codex home"
        self.backup = self.root / "backup"
        self.work = self.root / "work"
        self.work.mkdir()
        self.write(self.source / "base_instructions.md", "Current instructions\n")
        self.write(self.source / "config.toml", 'model = "current-model"\nmodel_instructions_file = "base_instructions.md"\n[agents]\nmax_concurrent_threads_per_session = 30\n')
        self.write(self.source / "skills/demo/SKILL.md", "Current skill\n")
        self.write(self.source / "agents/demo.toml", 'name = "demo"\n')

    def write(self, path, content):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")

    def sync(self, replace=True, check=True):
        environment = dict(os.environ, TEST_SOURCE=self.source.as_posix(),
                           TEST_DESTINATION=self.destination.as_posix(),
                           TEST_BACKUP=self.backup.as_posix(), TEST_WORK=self.work.as_posix(),
                           TEST_REPLACE=str(int(replace)), TEST_REPO=ROOT.as_posix())
        return subprocess.run(self.command, env=environment, capture_output=True,
                              text=True, check=check, timeout=60)

    def test_installs_agent_definitions(self):
        self.sync()

        self.assertEqual((self.destination / "agents/demo.toml").read_bytes(),
                         (self.source / "agents/demo.toml").read_bytes())

    def test_replaces_old_skills_and_agents_but_keeps_system_and_private_data(self):
        self.write(self.destination / "skills/obsolete/SKILL.md", "old")
        self.write(self.destination / "agents/obsolete.toml", "old")
        self.write(self.destination / "skills/.system/keep.txt", "system")
        self.write(self.destination / "auth.json", "private fixture")

        self.sync()

        self.assertFalse((self.destination / "skills/obsolete").exists())
        self.assertFalse((self.destination / "agents/obsolete.toml").exists())
        self.assertEqual((self.destination / "skills/.system/keep.txt").read_text(), "system")
        self.assertEqual((self.destination / "auth.json").read_text(), "private fixture")
        self.assertEqual((self.backup / "agents/obsolete.toml").read_text(), "old")

    def test_merge_keeps_unrelated_skills_and_agents(self):
        self.write(self.destination / "skills/custom/SKILL.md", "custom")
        self.write(self.destination / "agents/custom.toml", "custom")

        self.sync(replace=False)

        self.assertTrue((self.destination / "skills/custom/SKILL.md").exists())
        self.assertTrue((self.destination / "agents/custom.toml").exists())
        self.assertTrue((self.destination / "agents/demo.toml").exists())

    def test_preserves_config_values_and_connects_new_instructions(self):
        original = 'model = "personal-model"\nmodel_instructions_file = "custom.md"\n[plugins.demo]\nenabled = true\n'
        self.write(self.destination / "config.toml", original)

        self.sync()

        config = tomllib.loads((self.destination / "config.toml").read_text())
        self.assertEqual(config["model"], "personal-model")
        self.assertEqual(config["model_instructions_file"], "base_instructions.md")
        self.assertTrue(config["plugins"]["demo"]["enabled"])
        self.assertEqual(config["agents"]["max_concurrent_threads_per_session"], 30)
        self.assertEqual((self.backup / "config.toml").read_text(), original)

    def test_removes_legacy_instructions_after_backup(self):
        self.write(self.destination / "model-instructions.md", "old instructions")
        self.write(self.destination / "AGENTS.md", "old global guidance")
        self.write(self.destination / "AGENTS.override.md", "old override")

        self.sync()

        self.assertFalse((self.destination / "model-instructions.md").exists())
        self.assertFalse((self.destination / "AGENTS.md").exists())
        self.assertFalse((self.destination / "AGENTS.override.md").exists())
        self.assertEqual((self.backup / "AGENTS.md").read_text(), "old global guidance")

    def test_manifest_tracks_agent_hashes(self):
        self.sync()

        digest = hashlib.sha256((self.source / "agents/demo.toml").read_bytes()).hexdigest()
        manifest = (self.destination / ".openai-codex-agent-skills.manifest").read_text()
        self.assertIn(digest + "\tagents/demo.toml", manifest)

    def test_incomplete_payload_does_not_change_existing_installation(self):
        shutil.rmtree(self.source / "agents")
        self.write(self.destination / "base_instructions.md", "keep existing")

        result = self.sync(check=False)

        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((self.destination / "base_instructions.md").read_text(), "keep existing")

    def test_rejects_source_equal_to_destination_before_deleting(self):
        self.destination = self.source

        result = self.sync(check=False)

        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((self.source / "base_instructions.md").read_text(), "Current instructions\n")

    def install(self):
        environment = dict(os.environ, CODEX_HOME=self.destination.as_posix(),
                           CODEX_SKILLS_SOURCE=self.source.as_posix(),
                           TEST_SOURCE=self.source.as_posix(), TEST_REPO=ROOT.as_posix())
        return subprocess.run(self.install_command, env=environment, capture_output=True,
                              text=True, check=True, timeout=60)

    def test_default_installer_replaces_old_set_in_codex_home(self):
        self.write(self.destination / "skills/obsolete/SKILL.md", "old")
        self.write(self.destination / "agents/obsolete.toml", "old")

        self.install()

        self.assertFalse((self.destination / "skills/obsolete").exists())
        self.assertFalse((self.destination / "agents/obsolete.toml").exists())
        self.assertTrue((self.destination / "agents/demo.toml").exists())
        self.assertEqual((self.destination / ".openai-codex-agent-skills.install-mode").read_text(), "replace\n")

    def test_reinstall_keeps_config_valid_and_creates_distinct_backups(self):
        self.write(self.destination / "base_instructions.md", "previous")
        self.install()
        original = tomllib.loads((self.destination / "config.toml").read_text())

        self.install()

        self.assertEqual(tomllib.loads((self.destination / "config.toml").read_text()), original)
        self.assertEqual(len(list((self.destination / ".openai-codex-agent-skills-backups").iterdir())), 2)


POWERSHELL_SYNC = '$ErrorActionPreference = "Stop"; . "$env:TEST_REPO/scripts/lib.ps1"; Sync-CodexPayload -Source $env:TEST_SOURCE -Destination $env:TEST_DESTINATION -BackupDirectory $env:TEST_BACKUP -RemoveLegacyPaths:($env:TEST_REPLACE -eq "1")'
SHELL_SYNC = 'set -eu; . "$TEST_REPO/scripts/lib.sh"; codex_sync_payload "$TEST_SOURCE" "$TEST_DESTINATION" "$TEST_BACKUP" "$TEST_REPLACE" "$TEST_WORK"'


@unittest.skipUnless(shutil.which("powershell"), "Windows PowerShell is unavailable")
class WindowsPowerShellTests(PayloadChecks, unittest.TestCase):
    command = ["powershell", "-NoProfile", "-NonInteractive", "-Command", POWERSHELL_SYNC]
    install_command = ["powershell", "-NoProfile", "-NonInteractive", "-Command",
                       '& "$env:TEST_REPO/scripts/install.ps1" -Source $env:TEST_SOURCE']


@unittest.skipUnless(shutil.which("pwsh"), "PowerShell 7 is unavailable")
class PowerShellTests(PayloadChecks, unittest.TestCase):
    command = ["pwsh", "-NoProfile", "-NonInteractive", "-Command", POWERSHELL_SYNC]
    install_command = ["pwsh", "-NoProfile", "-NonInteractive", "-Command",
                       '& "$env:TEST_REPO/scripts/install.ps1" -Source $env:TEST_SOURCE']


@unittest.skipUnless(shutil.which("sh"), "POSIX shell is unavailable")
class ShellTests(PayloadChecks, unittest.TestCase):
    command = ["sh", "-c", SHELL_SYNC]
    install_command = ["sh", str(ROOT / "scripts/install.sh")]
