[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/super-productivity-1?utm_medium=integration&utm_source=button&utm_campaign=super-productivity)

# Super Productivity on Railway

One-click Railway template for [Super Productivity](https://github.com/super-productivity/super-productivity) (MIT), a to-do list and time tracker with timeboxing, Pomodoro and Jira/GitHub/GitLab issue import, plus a private WebDAV server so your tasks sync between browsers and devices.

## What it deploys

| Service | Built from | What it does | Volume |
|---|---|---|---|
| **Super Productivity** | `app/` – official `johannesjo/super-productivity:v20.1.0@sha256:6592ab5929bad174260cdc07b30c9c9b8943c7dba82596eddcb6a75d439d1756` | Serves the web app on the public domain, answers `/healthz`, and proxies `/webdav/` to the WebDAV service over the private network | none (static app) |
| **WebDAV** | `webdav/` – `hacdias/webdav:v5.17.3@sha256:3b70d2a3afd5bb2f8b3aadb621baa3788c2248b30da3a4698352fc96fef0de40` | Password-protected sync store (the server upstream's own `docker-compose.yaml` ships) | `/data` |

Both services build from this repository, so when we bump a version on `main`, Railway shows deployers an "update available" notice and they choose when to apply it.

## Variables

| Service | Variable | Default | Notes |
|---|---|---|---|
| WebDAV | `WEBDAV_USERNAME` | `sync` | Sync login name |
| WebDAV | `WEBDAV_PASSWORD` | `${{secret(32,…)}}` | Generated on deploy; the server refuses to start without it |
| Super Productivity | `PORT` | `8080` | nginx port |
| Super Productivity | `WEBDAV_HOST` | `${{WebDAV.RAILWAY_PRIVATE_DOMAIN}}` | Private address of the WebDAV service |
| Super Productivity | `WEBDAV_PORT` | `8080` | WebDAV port |
| Super Productivity | `WEBDAV_USERNAME` | `${{WebDAV.WEBDAV_USERNAME}}` | Pre-fills the sync dialog where the app supports it |

Nothing to fill in at deploy time.

## After deploy

1. Open the public URL of the **Super Productivity** service and start adding tasks. Your data lives in the browser (IndexedDB); the app works offline.
2. To sync (and keep a server-side copy), click **Sync** → **Use WebDAV, Dropbox or a folder** → choose **WebDAV** and enter:
   - **Base URL:** `https://YOUR-DOMAIN/webdav/`
   - **Username:** `sync` (or your `WEBDAV_USERNAME`)
   - **Password:** the `WEBDAV_PASSWORD` value from the WebDAV service's Variables tab
   - **Sync Folder Path:** `super-productivity`
3. Click **Save & Enable Sync**, then do the same on each other browser or device (the desktop and mobile apps can use the same URL).

The web app itself has no login because it stores nothing on the server; everything on the server sits in WebDAV behind the generated password.

## Resources

Both services fit easily in Railway's Free plan (0.5 GB RAM / 1 vCPU each): measured idle use is a few MiB each. nginx runs 2 workers and the WebDAV server is capped with `GOMAXPROCS=2` and `GOMEMLIMIT=192MiB`. If either process stops unexpectedly it exits non-zero, so Railway's on-failure restart brings it back.

## Not included

**SuperSync**, upstream's own sync server, is left out: it is marked beta, needs Postgres and an SMTP server for every sign-up, and WebDAV covers the same need with no outside service.

## Updates

We pin each image by version and digest. A new upstream release becomes a commit on `main` with a `CHANGELOG.md` entry (breaking changes first). Railway then offers the update in your project; read the changelog and apply it when you're ready. Your WebDAV data stays on its volume.
