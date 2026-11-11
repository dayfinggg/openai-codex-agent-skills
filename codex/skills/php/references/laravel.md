<overview>
This file is the entry point for Laravel projects. It covers versions, project structure, Artisan, and Pint. The skill's `framework_references` section names the file for each other Laravel topic. The rules target Laravel 13 and still fit Laravel 12.
</overview>

<versions>
Laravel ships one major version a year, around the first quarter. Each major gets bug fixes for 18 months and security fixes for 2 years.

| Version | PHP | Released | Bug fixes until | Security fixes until |
| --- | --- | --- | --- | --- |
| 11 | 8.2-8.4 | March 12, 2024 | September 3, 2025 | March 12, 2026 |
| 12 | 8.2-8.5 | February 24, 2025 | August 13, 2026 | February 24, 2027 |
| 13 | 8.3-8.5 | March 17, 2026 | Q3 2027 | March 17, 2028 |

Laravel 13 is current in November 2026, and Laravel 12 receives only security fixes. Read the installed version from `composer.lock` or with `php artisan --version` before you use a version-sensitive API. Check the API in `vendor/laravel/framework` or in the docs for that version, such as [laravel.com/docs/13.x](https://laravel.com/docs/13.x). Laravel 13 adds the AI SDK, resources for the JSON API specification, `Queue::route()`, `Cache::touch()`, vector queries, and more PHP attributes. Its [release notes](https://laravel.com/docs/13.x/releases) list the details.
</versions>

<project_structure>
Laravel 11 and later use a streamlined structure. Middleware, exception handling, and routing are registered in `bootstrap/app.php`, and service providers in `bootstrap/providers.php`. There is no `app/Http/Kernel.php` or `app/Console/Kernel.php`, and commands in `app/Console/Commands/` register themselves. Scheduled tasks live in `routes/console.php`.

A project that upgraded from Laravel 10 may keep the old structure, and Laravel supports that. If `app/Http/Kernel.php` exists, keep the old layout unless the user asks for a migration. Middleware then registers in `app/Http/Kernel.php` and exceptions in `app/Exceptions/Handler.php`. Commands and the schedule register in `app/Console/Kernel.php`. Rate limits usually sit in `RouteServiceProvider` or `app/Http/Kernel.php`.
</project_structure>

<artisan>
Create files with the `php artisan make:` commands, such as `make:model`, `make:migration`, `make:controller`, `make:enum`, `make:interface`, and `make:class`. The generators apply the project's stubs and naming. Pass `--no-interaction` and the options you need, because Artisan prompts otherwise. `php artisan list` shows the commands, and `php artisan make:model --help` shows the options. A new model usually needs a factory and often a seeder, and `make:model` can create both.
</artisan>

<conventions>
Follow the project's existing pattern where it has one. Deviate only to fix a correctness or security defect, and say so in the report. The defaults below apply where the project has no pattern yet.
- Prefer framework features and the project's existing abstractions over new helpers or packages.
- Generate links to pages with named routes and the `route()` helper.
- Build JSON APIs with Eloquent API resources and versioned routes, unless the existing API routes do otherwise.
- Keep database access out of Blade views.
- Watch for hidden N+1 queries in controllers, resources, jobs, and serialization.
- Define model casts in the `casts()` method, unless the project's models use the `$casts` property.
</conventions>

<pint>
Laravel projects format PHP with [Pint](https://laravel.com/docs/13.x/pint), which uses the `laravel` preset unless `pint.json` sets another one. After you change PHP files, run `vendor/bin/pint` with the paths of the files you changed. `--dirty` also formats files with other uncommitted work, so use it only on a clean working tree. Run `vendor/bin/pint` without `--test` to fix issues, because `--test` only reports them. Pint 1.27 and later switch to a compact `agent` output format on their own when a coding agent runs them. `--blade` also formats Blade templates, which needs Node.js and Prettier.
</pint>
