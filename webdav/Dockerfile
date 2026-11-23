# Private WebDAV sync store for Super Productivity (the server upstream's
# docker-compose.yaml ships). The official image is FROM scratch: no shell,
# so all settings come from the config file and environment variables.
FROM hacdias/webdav:v5.17.3@sha256:3b70d2a3afd5bb2f8b3aadb621baa3788c2248b30da3a4698352fc96fef0de40

COPY config.yml /etc/webdav/config.yml

# Railway shows the host's CPUs inside a small service: cap Go's threads and heap.
ENV GOMAXPROCS=2 \
    GOMEMLIMIT=192MiB

EXPOSE 8080
ENTRYPOINT ["webdav", "--config", "/etc/webdav/config.yml"]
