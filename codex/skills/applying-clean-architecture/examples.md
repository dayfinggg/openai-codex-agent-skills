# Example, registering a user (Python)

This example is illustrative. It shows one use case through every layer with the standard library only.

## Contents

- Domain
- Use case and ports
- Adapters
- Composition root
- Use case test

## Domain

`domain/user.py`

```python
from dataclasses import dataclass


class InvalidEmail(ValueError):
    pass


@dataclass(frozen=True)
class User:
    id: str
    email: str
    password_hash: str

    def __post_init__(self):
        if "@" not in self.email:
            raise InvalidEmail(self.email)
```

## Use case and ports

`application/register_user.py`

```python
import uuid
from dataclasses import dataclass
from typing import Protocol

from domain.user import User


class UserRepository(Protocol):
    def exists_with_email(self, email: str) -> bool: ...

    def add(self, user: User) -> None: ...


class PasswordHasher(Protocol):
    def hash(self, password: str) -> str: ...


class EmailAlreadyTaken(Exception):
    pass


@dataclass(frozen=True)
class RegisterUserRequest:
    email: str
    password: str


@dataclass(frozen=True)
class RegisterUserResponse:
    user_id: str


class RegisterUser:
    def __init__(self, users: UserRepository, hasher: PasswordHasher):
        self._users = users
        self._hasher = hasher

    def execute(self, request: RegisterUserRequest) -> RegisterUserResponse:
        if self._users.exists_with_email(request.email):
            raise EmailAlreadyTaken(request.email)
        user = User(
            id=str(uuid.uuid4()),
            email=request.email,
            password_hash=self._hasher.hash(request.password),
        )
        self._users.add(user)
        return RegisterUserResponse(user_id=user.id)
```

The use case declares the ports it needs and knows nothing about SQL, HTTP, or the hashing library.

## Adapters

`adapters/sqlite_user_repository.py`

```python
import sqlite3

from domain.user import User


class SqliteUserRepository:
    def __init__(self, connection: sqlite3.Connection):
        self._connection = connection

    def exists_with_email(self, email: str) -> bool:
        row = self._connection.execute(
            "SELECT 1 FROM users WHERE email = ?", (email,)
        ).fetchone()
        return row is not None

    def add(self, user: User) -> None:
        self._connection.execute(
            "INSERT INTO users (id, email, password_hash) VALUES (?, ?, ?)",
            (user.id, user.email, user.password_hash),
        )
        self._connection.commit()
```

`adapters/scrypt_password_hasher.py`

```python
import hashlib
import os


class ScryptPasswordHasher:
    def hash(self, password: str) -> str:
        salt = os.urandom(16)
        digest = hashlib.scrypt(password.encode(), salt=salt, n=2**14, r=8, p=1)
        return f"{salt.hex()}:{digest.hex()}"
```

`adapters/register_controller.py`

```python
from application.register_user import EmailAlreadyTaken, RegisterUser, RegisterUserRequest
from domain.user import InvalidEmail


class RegisterController:
    def __init__(self, register_user: RegisterUser):
        self._register_user = register_user

    def handle(self, body: dict) -> tuple[int, dict]:
        request = RegisterUserRequest(email=body["email"], password=body["password"])
        try:
            response = self._register_user.execute(request)
        except InvalidEmail:
            return 400, {"error": "invalid email"}
        except EmailAlreadyTaken:
            return 409, {"error": "email already registered"}
        return 201, {"id": response.user_id}
```

The controller translates between the web format and the use case format, and maps domain errors to status codes.

## Composition root

`main.py`

```python
import sqlite3

from adapters.register_controller import RegisterController
from adapters.scrypt_password_hasher import ScryptPasswordHasher
from adapters.sqlite_user_repository import SqliteUserRepository
from application.register_user import RegisterUser


def build_register_controller(db_path: str) -> RegisterController:
    connection = sqlite3.connect(db_path)
    register_user = RegisterUser(SqliteUserRepository(connection), ScryptPasswordHasher())
    return RegisterController(register_user)
```

This is the only place that knows every concrete class.

## Use case test

`tests/unit/test_register_user.py`

```python
import pytest

from application.register_user import EmailAlreadyTaken, RegisterUser, RegisterUserRequest


class InMemoryUsers:
    def __init__(self):
        self.saved = {}

    def exists_with_email(self, email):
        return email in self.saved

    def add(self, user):
        self.saved[user.email] = user


class PlainHasher:
    def hash(self, password):
        return f"hashed:{password}"


def test_registers_new_user():
    users = InMemoryUsers()
    register_user = RegisterUser(users, PlainHasher())

    response = register_user.execute(RegisterUserRequest("ann@example.com", "secret"))

    assert users.saved["ann@example.com"].id == response.user_id


def test_rejects_taken_email():
    users = InMemoryUsers()
    register_user = RegisterUser(users, PlainHasher())
    register_user.execute(RegisterUserRequest("ann@example.com", "secret"))

    with pytest.raises(EmailAlreadyTaken):
        register_user.execute(RegisterUserRequest("ann@example.com", "other"))
```

The test runs without a database or web server because the use case depends only on its ports.
