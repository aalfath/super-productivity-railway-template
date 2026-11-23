# Super Productivity web app (official image), served by its own nginx.
FROM johannesjo/super-productivity:v20.1.0@sha256:6592ab5929bad174260cdc07b30c9c9b8943c7dba82596eddcb6a75d439d1756

# Railway shows the host's CPU count inside a 1 vCPU service: keep nginx small.
RUN sed -i 's/^worker_processes .*/worker_processes  2;/' /etc/nginx/nginx.conf

COPY default.conf.template /etc/nginx/templates/default.conf.template
COPY start.sh /usr/local/bin/railway-start.sh
RUN chmod 755 /usr/local/bin/railway-start.sh

ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
