# Safe patterns per sink

Project conventions and the documentation of the framework version in use win over this file. The cheat sheet links at the end give depth, so read the one for the sink at hand instead of guessing.

## Contents

- Rules for every language
- Python
- JavaScript and TypeScript
- Java
- C#
- Go
- Cheat sheets

## Rules for every language

### HTML

- Let the template engine or UI framework escape output, and keep data out of dangerous contexts such as `<script>` blocks, event handler attributes, and `style`, where escaping alone does not stop XSS.
- In the DOM assign text with `textContent` or `value`, never with `innerHTML`.
- Sanitize markup that must stay HTML with DOMPurify, and do not modify it after sanitizing.
- Allow only `http` and `https` URLs in `href` and `src` built from input. React 19 blocks `javascript:` URLs in `src` and `href`, which does not replace this check.
- Send a strict CSP as a header, for example `Content-Security-Policy: script-src 'nonce-{RANDOM}' 'strict-dynamic'; object-src 'none'; base-uri 'none'`, with a fresh nonce per response. A CSP is defense in depth, never the primary defense, and `frame-ancestors` works only in the header, not in a `<meta>` tag.

### Processes

- Prefer a library function to an OS command, because a library call cannot be turned into a second command.
- Otherwise run a fixed program from an allow-list with arguments as an array and no shell, validate each argument against an allow-list, and put `--` before untrusted operands when the program supports it. `curl` still treats later arguments as URLs after `--`.
- On Windows, `.bat` and `.cmd` files can run in a shell whatever API launches them, so never pass untrusted arguments to a batch file.

### Paths and uploads

- Store files under names the application generates, and keep the user's file name only as data.
- For a name from input, join it to a fixed absolute base directory, canonicalize the result, and check that it is still inside the base before opening. Joining an absolute name usually replaces the base, and `..` or a symbolic link can leave it, so check after canonicalizing.
- For uploads allow-list extensions, validate the type without trusting the `Content-Type` header, set size and file name length limits, store outside the web root or on another host, allow only authorized users to upload, and scan with antivirus or CDR when available.

### XML

- Disable DTDs entirely. When the format needs them, turn off external entities and external DTD loading and limit entity expansion.

### Deserialization

- Accept only data formats such as JSON into explicit types. Never feed untrusted data to a native object deserializer, and when one is unavoidable, accept only signed messages and an allow-list of classes.

### Outbound requests

- When the destinations are known, match the host against an allow-list from configuration and build the request yourself with a fixed scheme, port, and path. Allow only `https`, or `http` where the target requires it.
- Turn off redirect following, so an allowed host cannot bounce the request elsewhere.
- When users may name any public host, as with webhooks, resolve the name, check every A and AAAA address, connect only to a checked address, and keep the original host name for the `Host` header, SNI, and certificate checks. Apply the same check to retries.
- Reject at least `127.0.0.0/8`, `0.0.0.0/8`, `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, `224.0.0.0/4`, `::1/128`, `fc00::/7`, `fe80::/10`, `ff00::/8`, and the cloud metadata address `169.254.169.254`. Deny-lists are easy to bypass, so prefer the allow-list.
- Set a timeout and a response size limit on every outbound call.

## Python

- **HTML.** Django escapes every variable by default, so never apply the `safe` filter or `{% autoescape off %}` to untrusted data. Jinja does not escape by default, so create the environment with `Environment(autoescape=select_autoescape())`, which escapes `.html`, `.htm`, `.xml`, and string templates.
- **Processes.** Call `subprocess.run([program, *args], check=True, timeout=...)`. The argument list never passes through a shell, while `shell=True` with input is shell injection.
- **Paths.** `Path.is_relative_to` compares strings and ignores `..`, so resolve both paths first.

```python
from pathlib import Path


def resolve_inside(base_dir: Path, name: str) -> Path:
    base = base_dir.resolve()
    target = (base / name).resolve()
    if not target.is_relative_to(base):
        raise PermissionError(f"Path {name!r} escapes {base}")
    return target
```

- **XML.** Parse untrusted XML with the `defusedxml` interfaces instead of the standard library parsers. Expat older than 2.7.2 may be open to billion laughs and quadratic blowup, and `pyexpat.EXPAT_VERSION` shows the version in use.
- **Deserialization.** Never call `pickle` or `jsonpickle.decode` on untrusted data. Load YAML with `yaml.safe_load` and register no constructors that create arbitrary objects.
- **Outbound requests.** Check resolved addresses with `ipaddress.ip_address(address).is_global`, which also handles IPv4-mapped IPv6 addresses.
- **Code.** Never pass input to `eval` or `exec`. Parse data with `json.loads` into validated types.

## JavaScript and TypeScript

- **HTML.** Render through JSX or the framework's template bindings. Pass HTML to `dangerouslySetInnerHTML` only as the output of `DOMPurify.sanitize`, and in Node run DOMPurify on a `jsdom` window. Avoid `v-html`, Angular's `bypassSecurityTrustAs*` functions, and Lit's `unsafeHTML` with untrusted data.
- **Processes.** Use `execFile` or `spawn` with an argument array and the default `shell: false`. Never pass input to `exec`, which always runs a shell, and never combine `shell: true` with arguments, which Node deprecates. `execFile` has no timeout by default, so set `timeout`.
- **Paths.** `path.isAbsolute` is not a traversal check. Resolve and compare against the base plus `path.sep`, and call `fs.promises.realpath` on the result when symbolic links can exist.

```typescript
import path from "node:path";

export function resolveInside(baseDir: string, name: string): string {
  const base = path.resolve(baseDir);
  const target = path.resolve(base, name);
  if (!target.startsWith(base + path.sep)) {
    throw new Error(`Path ${name} escapes ${base}`);
  }
  return target;
}
```

- **Deserialization and code.** Parse with `JSON.parse` and validate the result against a schema before use. Never run input through `eval` or `new Function`, and do not treat `node:vm` as a sandbox, because Node states it is not a security mechanism.
- **Outbound requests.** Pass `redirect: "error"` and `signal: AbortSignal.timeout(ms)` to `fetch`.

## Java

- **HTML.** Use the template engine's escaped output. When writing HTML by hand, encode with the OWASP Java Encoder (`org.owasp.encoder:encoder`) method for the context, such as `Encode.forHtmlContent`.
- **Processes.** Use `ProcessBuilder` with the program and each argument as separate strings, as in `new ProcessBuilder("git", "clone", "--", url, dir)`. Never start `sh -c` or `cmd /c` with input.
- **Paths.** `Path.resolve` returns the argument when it is absolute, and `normalize` ignores symbolic links, so use `toRealPath` for existing files and compare with `Path.startsWith`, which matches whole name elements.

```java
static Path resolveInside(Path baseDir, String name) throws IOException {
    Path base = baseDir.toRealPath();
    Path target = base.resolve(name).toRealPath();
    if (!target.startsWith(base)) {
        throw new AccessDeniedException(name);
    }
    return target;
}
```

- **XML.** On `DocumentBuilderFactory` and `SAXParserFactory` call `setFeature("http://apache.org/xml/features/disallow-doctype-decl", true)` and set `XMLConstants.FEATURE_SECURE_PROCESSING`. On `XMLInputFactory` set `XMLInputFactory.SUPPORT_DTD` and `XMLInputFactory.IS_SUPPORTING_EXTERNAL_ENTITIES` to `false`.
- **Deserialization.** Never read untrusted data with `ObjectInputStream` or `XMLDecoder`. Where Java serialization cannot be removed, install a class allow-list filter such as `ObjectInputFilter.Config.createFilter("example.*;java.base/*;!*")`, knowing that filtering alone does not make it safe. Use Jackson without polymorphic typing.
- **Outbound requests.** Validate hosts and addresses against the allow-list before the request, and set connect and request timeouts on the client.

## C#

- **HTML.** Razor encodes every `@` expression. Never wrap untrusted data in `HtmlString`, use `HtmlEncoder`, `JavaScriptEncoder`, or `UrlEncoder` from dependency injection when encoding in code, and put untrusted values in query strings, not URL paths.
- **Processes.** Fill `ProcessStartInfo.ArgumentList`, which escapes each argument, instead of concatenating `Arguments`, and keep `UseShellExecute` false.
- **Paths.** `Path.GetFullPath(path, basePath)` returns `path` unchanged when it is fully qualified, so check the result against the base.

```csharp
static string ResolveInside(string baseDirectory, string name)
{
    var basePath = Path.GetFullPath(baseDirectory).TrimEnd(Path.DirectorySeparatorChar) + Path.DirectorySeparatorChar;
    var fullPath = Path.GetFullPath(name, basePath);
    if (!fullPath.StartsWith(basePath, StringComparison.Ordinal))
    {
        throw new UnauthorizedAccessException($"Path {name} escapes {basePath}");
    }
    return fullPath;
}
```

- **XML.** Read through `XmlReader` with `XmlReaderSettings { DtdProcessing = DtdProcessing.Prohibit }`. On .NET Framework, `XmlDocument` and `XmlTextReader` are safe only from 4.5.2, and ASP.NET uses the lower of the build target and `httpRuntime` `targetFramework`.
- **Deserialization.** Never use `BinaryFormatter`, `SoapFormatter`, `NetDataContractSerializer`, `LosFormatter`, or `ObjectStateFormatter`. From .NET 9 `BinaryFormatter` throws on use. Use `System.Text.Json`, or Json.NET with `TypeNameHandling.None`.
- **Outbound requests.** Validate hosts against the allow-list before the request, and set `HttpClient.Timeout` and the handler's redirect setting explicitly.

## Go

- **HTML.** Render with `html/template`, which escapes by context in HTML, JavaScript, CSS, and URLs. Never convert untrusted data to `template.HTML` or related types, and never use `text/template` for HTML.
- **Processes.** `os/exec` never invokes a shell or expands globs. Use `exec.CommandContext(ctx, program, args...)`, which kills the process when the context ends, and never run `sh -c` with input.
- **Paths.** From Go 1.24 open files through `os.OpenRoot` or `os.OpenInRoot`, which reject names that escape the directory through `..` or symbolic links.

```go
func openInside(baseDir, name string) (*os.File, error) {
	return os.OpenInRoot(baseDir, name)
}
```

- **Deserialization.** `encoding/gob` is not hardened against adversarial input, so decode untrusted data with `encoding/json` into structs, and cap request bodies with `http.MaxBytesReader`.
- **Outbound requests.** `http.Client` has no timeout when `Timeout` is zero, which is the default, so always set it. Stop redirects with a `CheckRedirect` function that returns `http.ErrUseLastResponse`.

## Cheat sheets

- [Input Validation](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)
- [Cross Site Scripting Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
- [DOM based XSS Prevention](https://cheatsheetseries.owasp.org/cheatsheets/DOM_based_XSS_Prevention_Cheat_Sheet.html)
- [Content Security Policy](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html)
- [HTTP Headers](https://cheatsheetseries.owasp.org/cheatsheets/HTTP_Headers_Cheat_Sheet.html)
- [Unvalidated Redirects and Forwards](https://cheatsheetseries.owasp.org/cheatsheets/Unvalidated_Redirects_and_Forwards_Cheat_Sheet.html)
- [OS Command Injection Defense](https://cheatsheetseries.owasp.org/cheatsheets/OS_Command_Injection_Defense_Cheat_Sheet.html)
- [Injection Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Injection_Prevention_Cheat_Sheet.html)
- [File Upload](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html)
- [XML External Entity Prevention](https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html)
- [Deserialization](https://cheatsheetseries.owasp.org/cheatsheets/Deserialization_Cheat_Sheet.html)
- [Server Side Request Forgery Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html)
- [Server Side Template Injection Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Template_Injection_Prevention_Cheat_Sheet.html)
- [Prototype Pollution Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Prototype_Pollution_Prevention_Cheat_Sheet.html)
- [Denial of Service](https://cheatsheetseries.owasp.org/cheatsheets/Denial_of_Service_Cheat_Sheet.html)
- [Error Handling](https://cheatsheetseries.owasp.org/cheatsheets/Error_Handling_Cheat_Sheet.html)
- [Authorization](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html)
- [Insecure Direct Object Reference Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Insecure_Direct_Object_Reference_Prevention_Cheat_Sheet.html)
- [C-Based Toolchain Hardening](https://cheatsheetseries.owasp.org/cheatsheets/C-Based_Toolchain_Hardening_Cheat_Sheet.html)
- [OpenSSF Compiler Options Hardening Guide for C and C++](https://best.openssf.org/Compiler-Hardening-Guides/Compiler-Options-Hardening-Guide-for-C-and-C++.html)
