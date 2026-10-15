# API examples

These exchanges are illustrative.

## Contents

- Create a resource
- Validation error
- Paginated collection
- Partial update with JSON Merge Patch
- Conditional update

## Create a resource

```http
POST /v1/orders HTTP/1.1
Content-Type: application/json
Idempotency-Key: 7f3c2a1e-5b8d-4e2f-9a6c-1d0b3e4f5a6b

{"customerId": "cus_42", "items": [{"productId": "prd_7", "quantity": 2}]}
```

```http
HTTP/1.1 201 Created
Location: /v1/orders/ord_1001
Content-Type: application/json
ETag: "a1"

{
  "id": "ord_1001",
  "status": "pending",
  "total": {"amountMinor": 4598, "currency": "EUR"},
  "createdAt": "2026-10-07T14:30:00Z"
}
```

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

## Partial update with JSON Merge Patch

```http
PATCH /v1/orders/ord_1001 HTTP/1.1
Content-Type: application/merge-patch+json
If-Match: "a1"

{"note": "Leave at the door", "couponCode": null}
```

A field set to `null` is removed, and fields not mentioned stay unchanged.

```http
HTTP/1.1 200 OK
Content-Type: application/json
ETag: "a2"

{"id": "ord_1001", "status": "pending", "note": "Leave at the door"}
```

## Conditional update

Another client updated the order after this one read it.

```http
HTTP/1.1 412 Precondition Failed
Content-Type: application/problem+json

{
  "type": "https://api.example.com/problems/stale-resource",
  "title": "Resource was modified by another request",
  "status": 412,
  "detail": "Fetch the latest version of order ord_1001 and retry"
}
```
