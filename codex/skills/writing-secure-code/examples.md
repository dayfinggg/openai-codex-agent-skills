# Secure code examples

These pairs are illustrative.

## Insecure direct object reference (TypeScript)

Before

```typescript
router.get("/invoices/:invoiceId", requireLogin, async (req, res) => {
  const invoice = await invoices.findById(req.params.invoiceId);
  if (!invoice) {
    return res.status(404).end();
  }
  res.json(toInvoiceResponse(invoice));
});
```

After

```typescript
router.get("/invoices/:invoiceId", requireLogin, async (req, res) => {
  const invoice = await invoices.findByIdForCustomer(req.params.invoiceId, req.user.customerId);
  if (!invoice) {
    return res.status(404).end();
  }
  res.json(toInvoiceResponse(invoice));
});
```

Login proves who the caller is, not which invoices they may read (CWE-639, CWE-862). The scoped query makes a foreign invoice look exactly like a missing one.

## Shell command injection (Python)

Before

```python
import subprocess


def clone_repository(repo_url: str, target_dir: str) -> None:
    subprocess.run(f"git clone --depth 1 {repo_url} {target_dir}", shell=True, check=True)
```

After

```python
import subprocess
from urllib.parse import urlsplit

ALLOWED_GIT_HOSTS = frozenset({"github.com", "gitlab.com"})


def clone_repository(repo_url: str, target_dir: str, timeout_seconds: float) -> None:
    parts = urlsplit(repo_url)
    if parts.scheme != "https" or parts.hostname not in ALLOWED_GIT_HOSTS:
        raise ValueError(f"Repository URL not allowed: {repo_url}")
    subprocess.run(
        ["git", "clone", "--depth", "1", "--", repo_url, target_dir],
        check=True,
        timeout=timeout_seconds,
    )
```

Without a shell, `;` and `$(...)` are plain text, and `--` keeps a value that starts with a dash from becoming an option such as `--upload-pack` (CWE-78, CWE-88). The allow-list blocks other transports and internal hosts.

## Fail-open authorization (C#)

Before

```csharp
public async Task<bool> CanEditAsync(string userId, string documentId)
{
    try
    {
        return await _policyClient.IsAllowedAsync(userId, "document:edit", documentId);
    }
    catch (Exception ex)
    {
        _logger.LogWarning(ex, "Policy service unavailable, allowing edit");
        return true;
    }
}
```

After

```csharp
public async Task<bool> CanEditAsync(string userId, string documentId)
{
    try
    {
        return await _policyClient.IsAllowedAsync(userId, "document:edit", documentId);
    }
    catch (HttpRequestException ex)
    {
        _logger.LogError(ex, "Policy check failed for document {DocumentId}, denying edit", documentId);
        return false;
    }
}
```

An outage granted edit rights to everyone (CWE-636). The check now denies when it cannot decide, and it catches only the expected failure, so other errors reach the global handler (CWE-396).

## Partial writes and leaked errors (Go)

Before

```go
func (s *TransferService) Transfer(ctx context.Context, from, to string, amountMinor int64) error {
	if err := s.accounts.Debit(ctx, from, amountMinor); err != nil {
		return err
	}
	return s.accounts.Credit(ctx, to, amountMinor)
}

func (h *TransferHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	req, err := decodeTransferRequest(r)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	if err := h.service.Transfer(r.Context(), req.From, req.To, req.AmountMinor); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}
```

After

```go
func (s *TransferService) Transfer(ctx context.Context, from, to string, amountMinor int64) error {
	return s.unitOfWork.Run(ctx, func(accounts AccountStore) error {
		if err := accounts.Debit(ctx, from, amountMinor); err != nil {
			return fmt.Errorf("debit %s: %w", from, err)
		}
		if err := accounts.Credit(ctx, to, amountMinor); err != nil {
			return fmt.Errorf("credit %s: %w", to, err)
		}
		return nil
	})
}

func (h *TransferHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	req, err := decodeTransferRequest(r)
	if err != nil {
		http.Error(w, "The transfer request is invalid.", http.StatusBadRequest)
		return
	}
	if err := h.service.Transfer(r.Context(), req.From, req.To, req.AmountMinor); err != nil {
		h.logger.ErrorContext(r.Context(), "transfer failed", "error", err)
		http.Error(w, "The transfer could not be completed.", http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}
```

A failed credit left the debit in place, and the raw error could show SQL or account details (A10 2025, CWE-209). Both steps now commit or roll back together, and the client gets a fixed message while details go to the log.

## JWT validation (Python)

Before

```python
import jwt


def subject_of(token: str) -> str:
    claims = jwt.decode(token, options={"verify_signature": False})
    return claims["sub"]
```

After

```python
import jwt


def subject_of(token: str, public_key: str, issuer: str, audience: str) -> str:
    claims = jwt.decode(
        token,
        public_key,
        algorithms=["RS256"],
        issuer=issuer,
        audience=audience,
        options={"require": ["exp", "iss", "aud", "sub"]},
    )
    return claims["sub"]
```

The fixed algorithm list stops the token from choosing `none` or an HMAC algorithm keyed with the public key (CWE-347). Required claims reject tokens that never expire, and issuer and audience checks reject tokens minted for another service. PyJWT raises a subclass of `jwt.InvalidTokenError` for each failure, which the caller maps to 401.
