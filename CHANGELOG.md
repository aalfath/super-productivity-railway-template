# Changelog

## v20.1.0 (2026-11-23)

- First release of the template.
- Super Productivity `v20.1.0` (official image, pinned by digest) served by nginx on `$PORT` with a `/healthz` check.
- Private WebDAV sync server `hacdias/webdav v5.17.3` on its own volume, reached through `/webdav/` on the app's domain, with a generated password.
