# API examples

Illustrative exchanges.

## Validation error

```http
HTTP/1.1 422 Unprocessable Content
Content-Type: application/problem+json

{
  "type": "https://api.example.com/problems/validation-error",
  "title": "Request body is invalid",
  "status": 422,
  "detail": "2 fields failed validation",
  "instance": "/v1/orders",
  "errors": [
    {"field": "items[0].quantity", "message": "must be at least 1"},
    {"field": "customerId", "message": "is required"}
  ]
}
```

## Paginated collection

```http
GET /v1/orders?status=pending&sort=-createdAt&limit=2 HTTP/1.1
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "items": [
    {"id": "ord_1001", "status": "pending", "createdAt": "2026-10-07T14:30:00Z"},
    {"id": "ord_0998", "status": "pending", "createdAt": "2026-10-06T09:12:00Z"}
  ],
  "next": "/v1/orders?status=pending&sort=-createdAt&limit=2&cursor=eyJpZCI6Im9yZF8wOTk4In0"
}
```
