# Как изменится код для простого запроса без технических уточнений

Эти примеры показывают не старую и новую версии конкретного продукта, а характерную разницу между минимальным ответом без инженерных стандартов и ответом, который автоматически применяет обновлённые навыки. Улучшенная версия остаётся соразмерной запросу и не добавляет микросервисы, слои или зависимости без необходимости.

## Пример 1. Чтение CSV на Python

Запрос пользователя:

> Напиши функцию на Python, которая читает `users.csv` и возвращает пользователей старше 18 лет, отсортированных по имени.

### До применения навыков

```python
import csv


def get_users(filename):
    rows = csv.DictReader(open(filename))
    return sorted(
        [row for row in rows if int(row["age"]) >= 18],
        key=lambda row: row["name"],
    )
```

Код работает только на идеальном файле. Файл явно не закрывается, результат состоит из словарей строк, кодировка не определена, ошибки заголовков и возраста не дают контекста, а порядок при разном регистре может удивлять пользователя.

### После применения навыков

```python
from __future__ import annotations

import csv
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True, slots=True)
class User:
    name: str
    age: int


class UserCsvError(ValueError):
    """The CSV file does not satisfy the user import contract."""


def load_adult_users(path: Path) -> list[User]:
    with path.open("r", encoding="utf-8", newline="") as stream:
        reader = csv.DictReader(stream)
        required = {"name", "age"}
        missing = required.difference(reader.fieldnames or ())
        if missing:
            raise UserCsvError(f"Missing columns: {', '.join(sorted(missing))}")

        users: list[User] = []
        for row_number, row in enumerate(reader, start=2):
            name = row["name"].strip()
            if not name:
                raise UserCsvError(f"Row {row_number}: name is empty")

            try:
                age = int(row["age"])
            except ValueError as error:
                raise UserCsvError(
                    f"Row {row_number}: age must be an integer"
                ) from error

            if not 0 <= age <= 130:
                raise UserCsvError(f"Row {row_number}: age is outside 0..130")
            if age >= 18:
                users.append(User(name=name, age=age))

    return sorted(users, key=lambda user: user.name.casefold())
```

Функция теперь имеет явный контракт, закрывает ресурс, возвращает типизированные данные и сообщает, в какой строке нарушен формат. Проверки должны охватывать корректный файл, пустой файл, отсутствующие столбцы, некорректный возраст и одинаковые имена в разном регистре.

## Пример 2. Поиск товаров в браузере

Запрос пользователя:

> Сделай страницу с поиском и списком товаров.

### До применения навыков

```html
<input id="search" placeholder="Поиск">
<ul id="products"></ul>

<script>
  async function search() {
    const query = document.querySelector("#search").value;
    const products = await fetch(`/api/products?q=${query}`).then(r => r.json());
    document.querySelector("#products").innerHTML = products
      .map(product => `<li>${product.name} — ${product.price}</li>`)
      .join("");
  }

  document.querySelector("#search").addEventListener("input", search);
</script>
```

Значения попадают в HTML без безопасного вывода. У поля нет нормальной метки, запрос не кодируется, старый медленный ответ может перезаписать новый, а состояния загрузки, ошибки и пустого результата отсутствуют.

### После применения навыков

```html
<form id="product-search" role="search">
  <label for="query">Поиск товаров</label>
  <input id="query" name="query" type="search" autocomplete="off">
  <button type="submit">Найти</button>
</form>

<p id="status" role="status" aria-live="polite"></p>
<ul id="products" aria-labelledby="status"></ul>

<script type="module">
  const form = document.querySelector("#product-search");
  const queryInput = document.querySelector("#query");
  const status = document.querySelector("#status");
  const list = document.querySelector("#products");

  let activeRequest;

  function renderProducts(products) {
    list.replaceChildren();
    for (const product of products) {
      const item = document.createElement("li");
      item.textContent = `${product.name} — ${product.price}`;
      list.append(item);
    }
  }

  form.addEventListener("submit", async event => {
    event.preventDefault();
    activeRequest?.abort();
    activeRequest = new AbortController();

    status.textContent = "Загрузка…";
    list.replaceChildren();

    try {
      const params = new URLSearchParams({ q: queryInput.value.trim() });
      const response = await fetch(`/api/products?${params}`, {
        signal: activeRequest.signal,
      });
      if (!response.ok) {
        throw new Error(`Request failed with status ${response.status}`);
      }

      const products = await response.json();
      renderProducts(products);
      status.textContent = products.length
        ? `Найдено: ${products.length}`
        : "Ничего не найдено";
    } catch (error) {
      if (error.name !== "AbortError") {
        status.textContent = "Не удалось загрузить товары. Повторите попытку.";
      }
    }
  });
</script>
```

Улучшенная страница использует семантическую форму, доступную метку, безопасный текстовый вывод, кодирование параметров, отмену устаревшего запроса и наблюдаемые состояния. Тесты должны проверять клавиатурную отправку, HTML в названии товара, пустой ответ, сетевую ошибку и гонку двух запросов.

## Пример 3. Создание пользователя через API

Запрос пользователя:

> Сделай `POST /users`, который сохраняет email и пароль пользователя.

### До применения навыков

```python
@app.post("/users")
def create_user(data: dict):
    database.execute(
        f"INSERT INTO users(email, password) "
        f"VALUES ('{data['email']}', '{data['password']}')"
    )
    return data
```

Здесь возможна SQL-инъекция, пароль сохраняется открытым текстом и возвращается клиенту, вход не валидируется, дубликат email превращается в случайную ошибку сервера, а HTTP, бизнес-правило и SQL смешаны.

### После применения навыков

```python
from dataclasses import dataclass
from typing import Protocol

from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel, EmailStr, Field


class CreateUserRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=12, max_length=256)


class UserResponse(BaseModel):
    id: int
    email: EmailStr


@dataclass(frozen=True, slots=True)
class User:
    id: int
    email: str


class DuplicateEmailError(Exception):
    pass


class UserRepository(Protocol):
    def create(self, *, email: str, password_hash: str) -> User: ...


class PasswordHasher(Protocol):
    def hash(self, password: str) -> str: ...


class CreateUser:
    def __init__(self, repository: UserRepository, hasher: PasswordHasher) -> None:
        self._repository = repository
        self._hasher = hasher

    def execute(self, request: CreateUserRequest) -> User:
        email = str(request.email).casefold()
        return self._repository.create(
            email=email,
            password_hash=self._hasher.hash(request.password),
        )


def build_user_router(create_user: CreateUser) -> APIRouter:
    router = APIRouter()

    @router.post(
        "/users",
        response_model=UserResponse,
        status_code=status.HTTP_201_CREATED,
    )
    def create_user_endpoint(request: CreateUserRequest) -> UserResponse:
        try:
            user = create_user.execute(request)
        except DuplicateEmailError as error:
            raise HTTPException(
                status_code=409,
                detail="Email is already registered",
            ) from error

        return UserResponse(id=user.id, email=user.email)

    return router
```

Реальный адаптер репозитория использует параметризованный запрос и транзакцию, а реальный hasher использует поддерживаемую библиотеку для хеширования паролей. Composition root приложения создаёт эти адаптеры. Тесты проверяют невалидный email, короткий пароль, дубликат, откат транзакции, отсутствие исходного пароля в хранилище и ответе и безопасную ошибку сервера. Такая граница оправдана наличием двух самостоятельных политик, а не добавлена ради формального количества слоёв.

## Пример 4. Схема заказов

Запрос пользователя:

> Добавь таблицу заказов покупателей.

### До применения навыков

```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer TEXT,
    product TEXT,
    total REAL,
    status TEXT
);
```

Схема допускает пустые значения, произвольные статусы, неточные деньги и заказы без строк. Имя покупателя и товара дублируется, а необходимые запросы и конкурентные гарантии не выражены.

### После применения навыков

```sql
CREATE TABLE orders (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id bigint NOT NULL REFERENCES customers(id),
    status text NOT NULL CHECK (status IN ('pending', 'paid', 'cancelled')),
    idempotency_key text NOT NULL UNIQUE,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    order_id bigint NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id bigint NOT NULL REFERENCES products(id),
    quantity integer NOT NULL CHECK (quantity > 0),
    unit_price numeric(12, 2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (order_id, product_id)
);

CREATE INDEX orders_customer_created_idx
    ON orders (customer_id, created_at DESC);
```

Эта версия выражает текущие инварианты в базе, использует точный денежный тип, предотвращает повторную обработку команды и индексирует конкретный путь чтения. В реальной миграции сначала добавляются совместимые структуры и безопасный backfill, затем переводятся читатели и писатели и только после проверки удаляется старое представление. Тесты запускают миграцию на пустой и заполненной базе и проверяют ограничения и конкурентное создание заказа.

## Что модель добавит автоматически

При простом запросе без технических уточнений обновлённые навыки заставляют модель сначала определить наблюдаемое поведение и активный стек, затем применить локальные соглашения проекта. Код получает безопасные границы, понятные типы и имена, управляемое время жизни ресурсов, явные ошибки и минимальный набор тестов. Для UI дополнительно учитываются семантика, клавиатура, доступность и состояния. Для базы данных учитываются ограничения, транзакции, миграция и реальные запросы.

Модель не должна автоматически строить Clean Architecture, микросервисы, универсальный repository, event bus или фабрику для простой задачи. Дополнительная граница появляется только при наличии отдельной политики, изменяемой зависимости, риска совместимости, транзакционного инварианта или доказанной потребности в замене.
