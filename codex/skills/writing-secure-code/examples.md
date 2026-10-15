# Secure code examples

These pairs are illustrative. Copy the reasoning, not the exact shape.

## Contents

- Insecure direct object reference (TypeScript)
- Shell command injection (Python)
- Path traversal (Java)
- Server-side request forgery (TypeScript)
- Fail-open authorization (C#)
- Partial writes and leaked errors (Go)
- JWT validation (Python)

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

Login proves who the caller is, not which invoices they may read, so any customer could walk through other customers' IDs (CWE-639, CWE-862). Scoping the query to the caller makes a foreign invoice look exactly like a missing one, and the 404 does not confirm that it exists.

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

Without a shell, characters such as `;` and `$(...)` in the URL are plain text, and `--` keeps a value that starts with a dash from becoming an option such as `--upload-pack` (CWE-78, CWE-88). The scheme and host allow-list also blocks other transports and internal hosts, and the timeout bounds a hanging clone.

## Path traversal (Java)

Before

```java
public byte[] readAttachment(String fileName) throws IOException {
    return Files.readAllBytes(Path.of(ATTACHMENT_DIR, fileName));
}
```

After

```java
public byte[] readAttachment(String fileName) throws IOException {
    Path baseDir = Path.of(ATTACHMENT_DIR).toRealPath();
    Path file = baseDir.resolve(fileName).toRealPath();
    if (!file.startsWith(baseDir)) {
        throw new AccessDeniedException(fileName);
    }
    return Files.readAllBytes(file);
}
```

A name such as `../../etc/passwd` climbs out of the directory, and an absolute name replaces it entirely (CWE-22). `toRealPath` removes `..` and follows symbolic links, and `startsWith` compares whole name elements, so a sibling such as `attachments-old` does not pass as inside `attachments`. Storing attachments under generated IDs avoids user file names in paths altogether.

## Server-side request forgery (TypeScript)

Before

```typescript
export async function deliverWebhook(callbackUrl: string, payload: unknown): Promise<void> {
  await fetch(callbackUrl, { method: "POST", body: JSON.stringify(payload) });
}
```

After

```typescript
export interface WebhookConfig {
  allowedHosts: ReadonlySet<string>;
  timeoutMs: number;
}

export async function deliverWebhook(
  callbackUrl: string,
  payload: unknown,
  config: WebhookConfig,
): Promise<void> {
  const url = new URL(callbackUrl);
  if (url.protocol !== "https:" || !config.allowedHosts.has(url.hostname)) {
    throw new Error(`Webhook host not allowed: ${url.hostname}`);
  }
  const response = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
    redirect: "error",
    signal: AbortSignal.timeout(config.timeoutMs),
  });
  if (!response.ok) {
    throw new Error(`Webhook to ${url.hostname} failed with status ${response.status}`);
  }
}
```

Before, any user could make the server call `http://169.254.169.254/` or an admin port on `localhost` (CWE-918). The scheme and host now come from an allow-list in configuration, a redirect from an allowed host is rejected instead of followed inward, and the timeout bounds the call. When customers may register any public host, resolve the name and connect only to a checked public address, as the sinks reference describes.

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

An outage, or a request crafted to make the policy service fail, granted edit rights to everyone (CWE-636). The check now denies when it cannot decide, and it catches only the failure it expects, so other errors reach the global handler instead of being swallowed (CWE-396).

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

A failed credit used to leave the debit in place, so money vanished, and the raw error could show SQL, table names, or account details to the caller (A10 2025, CWE-209). Both steps now commit or roll back together inside one unit of work, and the client gets a fixed message while the details go to the log.

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

Without signature verification anyone can write their own claims (CWE-347). The fixed algorithm list stops the token from choosing `none` or an HMAC algorithm keyed with the public key, the required claims reject tokens that never expire, and the issuer and audience checks reject tokens minted for another service. PyJWT raises a subclass of `jwt.InvalidTokenError` for each failure, which the caller maps to 401.
