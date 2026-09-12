# Sources

## Version-aware use

The additions below were checked against official documentation on 2026-09-12. Introduction versions are stable facts; support windows, package requirements, and framework APIs must be checked again for the installed release. A `/current/` page is a discovery entry point, not evidence that a legacy dependency supports the same API. The existing examples and talks below are illustrative, not compatibility requirements.

### Compatibility, caching, and runtime additions

- [PHP supported versions](https://www.php.net/supported-versions.php)
- [PHP migration guide index](https://www.php.net/manual/en/appendices.php)
- [PHP 8.0 new features](https://www.php.net/manual/en/migration80.new-features.php)
- [PHP 8.1 new features](https://www.php.net/manual/en/migration81.new-features.php)
- [PHP 8.2 new features](https://www.php.net/manual/en/migration82.new-features.php)
- [PHP 8.4 new features](https://www.php.net/manual/en/migration84.new-features.php)
- [PHP 8.5 new features](https://www.php.net/manual/en/migration85.new-features.php)
- [PHP 8.2 deprecations](https://www.php.net/manual/en/migration82.deprecated.php)
- [PHP 8.4 deprecations](https://www.php.net/manual/en/migration84.deprecated.php)
- [PHP-FIG PER Coding Style](https://www.php-fig.org/per/coding-style/)
- [PHP-FIG PSR-6: Cache pools and items](https://www.php-fig.org/psr/psr-6/)
- [PHP-FIG PSR-16: Simple cache](https://www.php-fig.org/psr/psr-16/)
- [Symfony Cache](https://symfony.com/doc/current/cache.html)
- [Composer configuration: platform and plugins](https://getcomposer.org/doc/06-config.md)
- [Composer autoloader optimization](https://getcomposer.org/doc/articles/autoloader-optimization.md)
- [PHPUnit supported versions](https://phpunit.de/supported-versions.html)
- [PHP OPcache configuration](https://www.php.net/manual/en/opcache.configuration.php)
- [Symfony Messenger](https://symfony.com/doc/current/messenger.html)
- [Doctrine transactions and concurrency](https://www.doctrine-project.org/projects/doctrine-orm/en/current/reference/transactions-and-concurrency.html)
- [PHP JSON decoding](https://www.php.net/manual/en/function.json-decode.php)
- [PHP floating-point precision](https://www.php.net/manual/en/language.types.float.php)
- [PHP DateTimeImmutable](https://www.php.net/manual/en/class.datetimeimmutable.php)
- [PHP unserialize security and behavior](https://www.php.net/manual/en/function.unserialize.php)

### Official specifications and documentation

- [PHP Manual: Type system](https://www.php.net/manual/en/language.types.type-system.php)
- [PHP Manual: Type declarations and strict typing](https://www.php.net/manual/en/language.types.declarations.php)
- [PHP Manual: Exceptions](https://www.php.net/manual/en/language.exceptions.php)
- [PHP Manual: Error basics](https://www.php.net/manual/en/language.errors.basics.php)
- [PHP Manual: `htmlspecialchars`](https://www.php.net/manual/en/function.htmlspecialchars.php)
- [PHP Manual: PDO prepared statements](https://www.php.net/manual/en/pdo.prepared-statements.php)
- [PHP Manual: PDO transactions](https://www.php.net/manual/en/pdo.transactions.php)
- [PHP Manual: session security](https://www.php.net/manual/en/security.sessions.php)
- [PHP Manual: securing session INI settings](https://www.php.net/manual/en/session.security.ini.php)
- [PHP Manual: password hashing](https://www.php.net/manual/en/book.password.php)
- [PHP Manual: handling file uploads](https://www.php.net/manual/en/features.file-upload.php)
- [PHP-FIG PSR-1: Basic Coding Standard](https://www.php-fig.org/psr/psr-1/)
- [PHP-FIG PSR-12: Extended Coding Style](https://www.php-fig.org/psr/psr-12/)
- [PHP-FIG PSR-4: Autoloader](https://www.php-fig.org/psr/psr-4/)
- [PHP-FIG PSR-11: Container interface](https://www.php-fig.org/psr/psr-11/)
- [PHP-FIG PSR-3: Logger interface](https://www.php-fig.org/psr/psr-3/)
- [Composer: Basic usage](https://getcomposer.org/doc/01-basic-usage.md)
- [Composer: `composer.json` schema](https://getcomposer.org/doc/04-schema.md)
- [Composer: CLI commands](https://getcomposer.org/doc/03-cli.md)
- [PHPStan: Getting started](https://phpstan.org/user-guide/getting-started)
- [PHPStan: Rule levels](https://phpstan.org/user-guide/rule-levels)
- [PHPStan: Configuration reference](https://phpstan.org/config-reference)
- [Psalm: Installation](https://psalm.dev/docs/running_psalm/installation/)
- [Psalm: Typing in Psalm](https://psalm.dev/docs/annotating_code/typing_in_psalm/)
- [Psalm: Array types](https://psalm.dev/docs/annotating_code/type_syntax/array_types/)
- [PHPUnit 12: Writing tests](https://docs.phpunit.de/en/12.2/writing-tests-for-phpunit.html)
- [Symfony: Best practices](https://symfony.com/doc/current/best_practices.html)
- [Symfony: Coding standards](https://symfony.com/doc/current/contributing/code/standards.html)

### Maintainer examples

- [Symfony Demo Application](https://github.com/symfony/demo)
- [Symfony Demo `composer.json`](https://github.com/symfony/demo/blob/main/composer.json)
- [Symfony Demo PHPStan configuration](https://github.com/symfony/demo/blob/main/phpstan.dist.neon)
- [Symfony Demo PHPUnit configuration](https://github.com/symfony/demo/blob/main/phpunit.dist.xml)
- [PHPStan source example with strict types and constructor injection](https://github.com/phpstan/phpstan-src/blob/2.1.x/src/Analyser/Analyser.php)

### Practitioner articles

- [Matthias Noback: Road to dependency injection](https://matthiasnoback.nl/2018/06/road-to-dependency-injection/)
- [Matthias Noback: The dependency injection paradigm](https://matthiasnoback.nl/2021/11/the-dependency-injection-paradigm/)

### Maintainer tooling

- [PHP Coding Standards Fixer: Usage](https://cs.symfony.com/doc/usage)
- [PHPMD: Code size rules](https://phpmd.org/rules/codesize.html)
- [PHPMD: Rule index](https://phpmd.org/rules/index.html)
- [PhpMetrics: Metrics](https://www.phpmetrics.org/documentation/index.html)

### Practitioner talks

- [Dave Liddament: Type Safe PHP talk](https://www.daveliddament.co.uk/talks/type-safe-php)
- [PHPSW: Strict typing and static analysis talk](https://phpsw.uk/talks/strict-typing-and-static-analysis)
- [Neos Conference: Writing strongly typed PHP talk](https://www.neoscon.io/talks/writing-strongly-typed-php-let-types-do-the-testing.html)
