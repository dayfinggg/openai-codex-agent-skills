# Security

Use a maintained Node.js LTS release and keep Express and its dependencies current. [E3]
Use TLS directly or through a trusted reverse proxy, and configure `trust proxy` for the actual topology.
Install Helmet before routes and other middleware that emit responses. [E1][E4]
Use secure, HttpOnly, scoped cookies and an explicit same-site policy.
Do not trust redirect targets, host headers, forwarded headers, query strings, or object keys.
Prevent open redirects and validate filesystem paths before any file operation.
Apply authentication before authorization and enforce authorization in each protected router.
Rate-limit login, token, upload, search, and resource-amplifying endpoints.
Use conservative CORS, CSRF, upload, and content-security policies for the deployment model.
Audit dependencies, remove unused middleware, and never log credentials or tokens.
Disable fingerprinting and avoid default session cookie names in production. [E4]
