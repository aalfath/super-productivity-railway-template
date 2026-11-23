# Deploy and Host Super Productivity on Railway

Super Productivity is an open-source (MIT) to-do list and time tracker. It combines tasks, projects, timeboxing, a Pomodoro timer, break reminders and work-time reports, and imports issues from Jira, GitHub, GitLab and other trackers. It runs in the browser and keeps your data locally, with optional sync.

## About Hosting Super Productivity

This template deploys two services. **Super Productivity** serves the official web app (v20.1.0) with nginx on a public Railway domain and answers a `/healthz` health check. **WebDAV** is a private sync server on its own volume, reached through `/webdav/` on the same domain and protected by a generated password. Nothing needs to be filled in at deploy time. After deploy, open the URL and start adding tasks. To sync between devices, click Sync, choose WebDAV, and enter `https://YOUR-DOMAIN/webdav/`, the username `sync`, the `WEBDAV_PASSWORD` from the WebDAV service's variables, and the folder `super-productivity`. Both services fit Railway's Free plan.

## Common Use Cases

* Plan your day with tasks, timeboxing and a Pomodoro timer, and track how long each task takes
* Pull assigned issues from Jira, GitHub or GitLab into one personal task list
* Sync the same task list across browsers, the desktop app and the mobile app through your own WebDAV server

## Dependencies for Super Productivity Hosting

* Super Productivity web app (official `johannesjo/super-productivity` image)
* WebDAV server (`hacdias/webdav`) with a volume for synced data

### Deployment Dependencies

* [Super Productivity on GitHub](https://github.com/super-productivity/super-productivity)
* [hacdias/webdav](https://github.com/hacdias/webdav)
* [Template repository](https://github.com/aalfath/super-productivity-railway-template)

### Implementation Details

The web app stores your tasks in the browser and has no login of its own, because it keeps no data on the server. All server-side data is in the WebDAV service, behind the generated password. SuperSync, upstream's beta sync server, is left out because it needs Postgres and SMTP for every sign-up.

Both services build from the template repository with images pinned by version and digest. When a new version lands on its `main` branch, Railway shows an update notice in your project; read `CHANGELOG.md` and apply it when you're ready. Your WebDAV data stays on its volume.

## Why Deploy Super Productivity on Railway?

<!-- Recommended: Keep this section as shown below -->
Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Super Productivity on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
<!-- End recommended section -->
