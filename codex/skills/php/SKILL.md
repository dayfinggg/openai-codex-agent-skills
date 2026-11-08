---
name: php
description: Change PHP code or tooling, including Laravel and Symfony behavior.
license: MIT. See the distribution LICENSE for each source and its license.
---

Use composer.json and composer.lock to establish PHP compatibility and installed packages.
Select the framework reference for the code being changed.
- Laravel uses [laravel.md](references/laravel.md), which routes to database, HTTP, async, application, and test guidance.
- Symfony uses [symfony.md](references/symfony.md).
- Doctrine relations and transactions use [symfony-doctrine.md](references/symfony-doctrine.md).

Check version-specific syntax against [PHP release documentation](https://www.php.net/releases/) and support claims against [supported versions](https://www.php.net/supported-versions.php).
Use the project's configured formatter, analyzer, and test runner. Preview automated Rector changes before applying them.
Keep native types precise. Use PHPDoc type annotations only where the requested change needs types PHP cannot express.
Reference versions are snapshots. Confirm compatibility before applying an upgrade or a new framework API.
