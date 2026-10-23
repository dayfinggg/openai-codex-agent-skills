# Safe patterns per sink

The documentation of the framework version in use wins over this file. Read the cheat sheet for the sink at hand when more depth is needed.

## Contents

- Safe default per sink
- Details for every language
- Python, JavaScript and TypeScript, Java, C#, Go
- C, C++, and unsafe code
- Cheat sheets

## Safe default per sink

| Sink | Safe default | CWE |
|---|---|---|
| HTML | Contextual autoescaping, `textContent` in the DOM, DOMPurify for markup that stays HTML, a strict CSP. No untrusted data in `innerHTML`, `dangerouslySetInnerHTML`, `v-html`, or raw template output | CWE-79 |
| Links and redirects | Only `https` and `http` in links built from input, redirects only to relative paths or allow-listed hosts | CWE-601 |
| Processes | A library call when one exists, otherwise a fixed program with an argument array, no shell, and `--` before untrusted operands | CWE-78, CWE-77 |
| File paths | Generated names. A name from input is resolved against a fixed base, canonicalized, and opened only if it stays inside | CWE-22 |
| Uploads | Allow-listed extensions, a type check that ignores the client's `Content-Type`, a size limit, a generated name, storage outside the web root | CWE-434 |
| Dynamic code | No `eval`, `exec`, `new Function`, or templates compiled from input. Map input to allow-listed operations | CWE-94 |
| XML | DTDs disabled, or external entities and external DTD loading off | CWE-611 |
| Deserialization | JSON or another data-only format into explicit types, no native object deserialization of untrusted data | CWE-502 |
| Outbound URLs | Scheme and host from a configured allow-list, redirects off, a timeout, a response size limit | CWE-918 |
| SQL and NoSQL | Bound parameters and allow-listed identifiers, per working-with-databases | CWE-89 |

## Details for every language

- HTML. Keep data out of `<script>` blocks, event handler attributes, and `style`, where escaping alone does not stop XSS. Leave markup unchanged after DOMPurify. React 19 blocks `javascript:` URLs in `src` and `href`, which does not replace the scheme check. A strict CSP is sent as a header, for example `Content-Security-Policy: script-src 'nonce-{RANDOM}' 'strict-dynamic'; object-src 'none'; base-uri 'none'`, with a fresh nonce per response. It is defense in depth, and `frame-ancestors` works only in the header, not in a `<meta>` tag.
- Processes. Run programs from an allow-list and validate each argument against an allow-list. `curl` still treats later arguments as URLs after `--`. On Windows, `.bat` and `.cmd` files run in a shell whatever API launches them, so untrusted arguments never go to a batch file.
- Paths. Keep the user's file name only as data. Joining an absolute name usually replaces the base, and `..` or a symbolic link can leave it, so check after canonicalizing.
- Uploads. Also limit the file name length, allow only authorized users to upload, and scan with antivirus or CDR when available.
- XML. When the format needs DTDs, also limit entity expansion.
- Deserialization. When a native deserializer is unavoidable, accept only signed messages and an allow-list of classes.
- Outbound requests. Build the request with a fixed scheme, port, and path, and allow only `https`, or `http` where the target requires it. When users may name any public host, as with webhooks, resolve the name, check every A and AAAA address, connect only to a checked address, keep the original host name for the `Host` header, SNI, and certificate checks, and repeat the check on retries. Reject at least `127.0.0.0/8`, `0.0.0.0/8`, `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, `224.0.0.0/4`, `::1/128`, `fc00::/7`, `fe80::/10`, `ff00::/8`, and the cloud metadata address `169.254.169.254`. Deny-lists are easy to bypass, so prefer the allow-list.

## Python

- HTML. Django escapes every variable, so the `safe` filter and `{% autoescape off %}` never get untrusted data. Jinja does not escape by default, so create the environment with `Environment(autoescape=select_autoescape())`.
- Processes. `subprocess.run([program, *args], check=True, timeout=...)`. `shell=True` with input is shell injection.
- Paths. `Path.is_relative_to` compares strings and ignores `..`, so resolve both paths first.

```python
from pathlib import Path


def resolve_inside(base_dir: Path, name: str) -> Path:
    base = base_dir.resolve()
    target = (base / name).resolve()
    if not target.is_relative_to(base):
        raise PermissionError(f"Path {name!r} escapes {base}")
    return target
```

- XML. Parse untrusted XML with `defusedxml`. Expat older than 2.7.2 may be open to billion laughs and quadratic blowup, and `pyexpat.EXPAT_VERSION` shows the version in use.
- Deserialization. No `pickle` or `jsonpickle.decode` on untrusted data. Load YAML with `yaml.safe_load` and register no constructors that create arbitrary objects.
- Outbound requests. Check resolved addresses with `ipaddress.ip_address(address).is_global`, which also handles IPv4-mapped IPv6 addresses.

## JavaScript and TypeScript

- HTML. Render through JSX or template bindings. `dangerouslySetInnerHTML` gets only the output of `DOMPurify.sanitize`, and in Node DOMPurify runs on a `jsdom` window. Keep untrusted data out of `v-html`, Angular's `bypassSecurityTrustAs*` functions, and Lit's `unsafeHTML`.
- Processes. `execFile` or `spawn` with an argument array and the default `shell: false`. `exec` always runs a shell, and Node deprecates `shell: true` with arguments. `execFile` has no timeout by default, so set `timeout`.
- Paths. `path.isAbsolute` is not a traversal check. Resolve and compare against the base plus `path.sep`, and call `fs.promises.realpath` on the result when symbolic links can exist.

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

- Deserialization and code. `JSON.parse` followed by schema validation. `node:vm` is not a sandbox, as Node states.
- Outbound requests. Pass `redirect: "error"` and `signal: AbortSignal.timeout(ms)` to `fetch`.

## Java

- HTML. Use the template engine's escaped output, and for hand-written HTML the OWASP Java Encoder (`org.owasp.encoder:encoder`) method for the context, such as `Encode.forHtmlContent`.
- Processes. `ProcessBuilder` with each argument as a separate string, as in `new ProcessBuilder("git", "clone", "--", url, dir)`. No `sh -c` or `cmd /c` with input.
- Paths. `Path.resolve` returns the argument when it is absolute, and `normalize` ignores symbolic links, so use `toRealPath` for existing files and compare with `Path.startsWith`, which matches whole name elements.

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

- XML. On `DocumentBuilderFactory` and `SAXParserFactory` call `setFeature("http://apache.org/xml/features/disallow-doctype-decl", true)` and set `XMLConstants.FEATURE_SECURE_PROCESSING`. On `XMLInputFactory` set `XMLInputFactory.SUPPORT_DTD` and `XMLInputFactory.IS_SUPPORTING_EXTERNAL_ENTITIES` to `false`.
- Deserialization. No `ObjectInputStream` or `XMLDecoder` on untrusted data. Where Java serialization cannot be removed, install a class allow-list filter such as `ObjectInputFilter.Config.createFilter("example.*;java.base/*;!*")`, which alone does not make it safe. Use Jackson without polymorphic typing.
- Outbound requests. Check hosts and addresses against the allow-list before the request, and set connect and request timeouts.

## C#

- HTML. Razor encodes every `@` expression. Untrusted data never goes into `HtmlString`. Encode in code with `HtmlEncoder`, `JavaScriptEncoder`, or `UrlEncoder` from dependency injection, and put untrusted values in query strings, not URL paths.
- Processes. Fill `ProcessStartInfo.ArgumentList`, which escapes each argument, instead of concatenating `Arguments`, and keep `UseShellExecute` false.
- Paths. `Path.GetFullPath(path, basePath)` returns `path` unchanged when it is fully qualified, so check the result against the base.

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

- XML. Read through `XmlReader` with `XmlReaderSettings { DtdProcessing = DtdProcessing.Prohibit }`. On .NET Framework, `XmlDocument` and `XmlTextReader` are safe only from 4.5.2, and ASP.NET uses the lower of the build target and `httpRuntime` `targetFramework`.
- Deserialization. No `BinaryFormatter`, `SoapFormatter`, `NetDataContractSerializer`, `LosFormatter`, or `ObjectStateFormatter`. From .NET 9 `BinaryFormatter` throws on use. Use `System.Text.Json`, or Json.NET with `TypeNameHandling.None`.
- Outbound requests. Check hosts against the allow-list before the request, and set `HttpClient.Timeout` and the handler's redirect setting explicitly.

## Go

- HTML. `html/template` escapes by context. Untrusted data never becomes `template.HTML` or a related type, and `text/template` never renders HTML.
- Processes. `os/exec` invokes no shell and expands no globs. Use `exec.CommandContext(ctx, program, args...)`, which kills the process when the context ends. No `sh -c` with input.
- Paths. From Go 1.24 open files with `os.OpenRoot` or `os.OpenInRoot`, which reject names that escape the directory through `..` or symbolic links.
- Deserialization. `encoding/gob` is not hardened against adversarial input, so decode untrusted data with `encoding/json` into structs, and cap request bodies with `http.MaxBytesReader`.
- Outbound requests. `http.Client` has no timeout when `Timeout` is zero, the default, so always set it. Stop redirects with a `CheckRedirect` function that returns `http.ErrUseLastResponse`.

## C, C++, and unsafe code

These rules cover CWE-787, CWE-125, CWE-416, CWE-120, CWE-121, CWE-122, and CWE-476.

- For a new component whose language the project does not dictate, choose a memory-safe language such as Rust, Go, Java, C#, or Python, as the CISA and NSA guidance of June 2025 urges. Rewrite existing C or C++ only when asked, and suggest it at module boundaries, starting with network-facing and parsing code.
- C++ uses `std::vector`, `std::string`, `std::array`, `std::span`, and `std::unique_ptr` or `std::shared_ptr` instead of raw arrays, pointer arithmetic, and `new` and `delete`, and passes no array as a single pointer (C++ Core Guidelines I.13). C passes a length with every buffer and checks every index and size before a read or copy.
- Keep `unsafe` Rust blocks small behind a safe API and run their tests under Miri.
- Build with the OpenSSF Compiler Options Hardening Guide options, run tests under AddressSanitizer and the other available sanitizers, and fuzz parsers and every function that reads external data.

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
