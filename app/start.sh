#!/bin/sh
# Railway wrapper for the official Super Productivity image.
# - nginx listens on $PORT and answers /healthz without login.
# - /webdav/ is proxied over the private network to the WebDAV service.
# - The app's sync settings are pre-filled with this deployment's WebDAV URL
#   and username (upstream's sync-config-default-override.json mechanism).
set -eu

: "${PORT:=8080}"
: "${WEBDAV_HOST:?WEBDAV_HOST must point at the WebDAV service}"
: "${WEBDAV_PORT:=8080}"
export PORT WEBDAV_HOST WEBDAV_PORT

# Railway's private DNS lives in /etc/resolv.conf (IPv6). nginx needs it as a
# resolver so it starts even before the WebDAV service resolves.
NGINX_LOCAL_RESOLVERS=$(awk 'BEGIN{ORS=" "} $1=="nameserver" {if ($2 ~ ":") {print "["$2"]"} else {print $2}}' /etc/resolv.conf)
NGINX_LOCAL_RESOLVERS="${NGINX_LOCAL_RESOLVERS% }"
[ -n "$NGINX_LOCAL_RESOLVERS" ] || NGINX_LOCAL_RESOLVERS=127.0.0.11
export NGINX_LOCAL_RESOLVERS

if [ -z "${WEBDAV_BASE_URL:-}" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  WEBDAV_BASE_URL="https://${RAILWAY_PUBLIC_DOMAIN}/webdav/"
fi
export WEBDAV_BASE_URL="${WEBDAV_BASE_URL:-}"

# Only substitute our own variables into the nginx template.
export NGINX_ENVSUBST_FILTER='^(PORT|WEBDAV_HOST|WEBDAV_PORT|NGINX_LOCAL_RESOLVERS)$'
export NGINX_ENTRYPOINT_QUIET_LOGS=1

# Upstream entrypoint: writes the sync override JSON, then runs nginx in the
# foreground. nginx exits non-zero if it can't start, so Railway restarts it.
exec /usr/local/bin/docker-entrypoint.sh
