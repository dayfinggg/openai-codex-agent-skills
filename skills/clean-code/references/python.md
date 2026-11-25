# Python

Check the Python version first, in `pyproject.toml`, `.python-version` or with `python --version`, and use only syntax that version has.

## Pitfalls

A default argument is created once, when the function is defined. A list or a dict as a default is shared between calls. Use `None` as the default and create the value inside the function.

Compare with `None` using `is` and `is not`. `if x:` is also false for `0`, `""` and an empty list, so write `if x is not None:` when that is what you mean.

Catch the exceptions you expect by name. A bare `except:` also catches `KeyboardInterrupt` and `SystemExit`. Keep the `try` block to the lines that can raise, and put the success path in `else`.

A closure looks its variables up when it runs. A `lambda` created in a loop sees the last value of the loop variable. Bind the value as a default, as in `lambda n=n: n * 2`.

`[[0] * 3] * 2` makes two references to the same inner list. Use a comprehension. `list.sort()` returns `None`, and `sorted()` returns a new list.

A function returns a value on every path or on none. Write `return None` where a value-returning function has nothing to return.

`assert` is removed under `python -O`. Use it for tests and invariants, and raise an exception for input validation.

Pass a list of arguments to `subprocess.run` and set `check=True`. `shell=True` with interpolated input is command injection.

Open files with `with`, and give an explicit `encoding`.

## Preferences

Use `pathlib.Path` for paths, f-strings for formatting, `dataclasses` or typed classes for plain data, and `enum` for a closed set of values. Annotate the parameters and the return type of every public function. Write a named function with `def` where a `lambda` would be assigned to a name.

## Tools

When the project defines none, use `ruff format` and `ruff check` for style and common errors, and `mypy` or `pyright` for types. Run the tests with `pytest` when the project has a `tests` directory.
