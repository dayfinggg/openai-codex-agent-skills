# Security
Enable authentication and authorization before exposing a deployment.
Use a unique database user per application or operator and grant only required roles.
Use TLS for application, `mongod`, and `mongos` traffic.
Restrict network access with firewalls, security groups, Atlas IP access lists, private endpoints, or equivalent controls.
Use encryption at rest for storage and field-level encryption or Queryable Encryption for especially sensitive fields.
Protect encryption keys, credentials, configuration files, logs, and backups separately from the database process.
Audit administrative and data access where the deployment edition supports auditing.
Disable server-side scripting with `--noscripting` when `$where`, `$function`, `$accumulator`, and map-reduce are not needed.
Patch supported server and driver versions and review user credentials and network rules periodically.
Treat schema validation as a data-quality control, not an authorization boundary, because privileged operations can bypass it.
Follow the [security checklist](https://www.mongodb.com/docs/manual/administration/security-checklist/) and [encryption overview](https://www.mongodb.com/docs/manual/core/security-data-encryption/).
