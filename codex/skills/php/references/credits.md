<sources>
The Laravel reference files come from [laravel/boost](https://github.com/laravel/boost) by Taylor Otwell, under the MIT license in `credits.md`. The files `laravel.md`, `laravel-database.md`, `laravel-http.md`, `laravel-async.md`, and `laravel-app.md` adapt the `laravel-best-practices` skill and its 20 rule files. The files `laravel-testing.md` and `laravel-testing-data.md` adapt the `testing-best-practices` skill and its 9 rule files. Parts of `.ai/laravel/core.blade.php`, `.ai/laravel/12/core.blade.php`, `.ai/laravel/11/core.blade.php`, `.ai/pint/core.blade.php`, `.ai/pest/core.blade.php`, and `.ai/phpunit/core.blade.php` are also included.

The Symfony reference files come from [makfly/superpowers-symfony](https://github.com/makfly/superpowers-symfony), under the MIT license in `credits.md`. That license names no copyright holder beyond the year 2024. The file `symfony.md` merges the skills interfaces-and-autowiring, symfony-messenger, form-types-validation, symfony-voters, value-objects-and-dtos, and quality-checks, with short parts of messenger-retry-failures and controller-cleanup. The file `symfony-doctrine.md` merges doctrine-relations and doctrine-fetch-modes, with short parts of doctrine-batch-processing and doctrine-transactions.

The PHP language facts in `../SKILL.md` start from `.ai/php/core.blade.php`, `.ai/php/8.4/core.blade.php`, and `.ai/php/8.5/core.blade.php` in laravel/boost. The rest of `../SKILL.md` is new text, checked against php.net, php-fig.org, phpunit.de, phpstan.org, getrector.com, and the Composer releases.
</sources>

<changes>
The Blade templates were rendered to plain Markdown. Calls such as `$assist->artisanCommand('x')` became `php artisan x`, and branches on installed packages became text for any project. References to the Boost `search-docs` tool, agent workflows, and plugin commands were removed. Text that repeats the plugin's coding instructions was removed. Headings, bold text, and code comments became XML sections and prose. Version facts were checked against laravel.com, symfony.com, doctrine-project.org, pestphp.com, and phpunit.de for November 2026, and outdated claims were fixed.
</changes>

Upstream redistribution terms follow.

```text
The MIT License (MIT)

Copyright (c) Taylor Otwell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

Upstream redistribution terms follow.

```text
MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
