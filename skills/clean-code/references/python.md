# Python

Read the version from `pyproject.toml`, `.python-version` or `python --version`, and use only syntax that version has.

## Pitfalls

- A default argument is created once, so a list or dict default is shared between calls. Default to `None` and create the value inside the function.
- `if x:` is also false for `0`, `""` and empty containers. Write `if x is not None:` when that is the meaning.
- A bare `except:` also catches `KeyboardInterrupt` and `SystemExit`. Catch the expected exceptions by name, keep the `try` block to the lines that raise, and put the success path in `else`.
- A `lambda` created in a loop sees the last value of the loop variable. Bind the value as a default, as in `lambda n=n: n * 2`.
- `[[0] * 3] * 2` repeats one inner list. Build nested lists with a comprehension.
- `list.sort()` returns `None`. Use `sorted()` for a new list.
- `python -O` removes `assert`. Raise an exception to validate input, and keep `assert` for tests and invariants.
- `shell=True` with interpolated input is command injection. Pass `subprocess.run` a list of arguments and set `check=True`.
- Open files with `with` and an explicit `encoding`.
- A value-returning function returns on every path, with an explicit `return None` where it has nothing to return.

## Preferences

Use `pathlib.Path` for paths, `dataclasses` or typed classes for plain data, `enum` for a closed set of values, and annotations on the parameters and return type of every public function.

## Tools

When the project defines none, use `ruff format` and `ruff check` for style and common errors, `mypy` or `pyright` for types, and `pytest` when the project has a `tests` directory.
