FROM alpine

# add user with uid 1000
RUN addgroup app && adduser -h /app -S -u 1000 -s /bin/bash app -G app

# install curl and restic
RUN apk add --update --no-cache curl restic ca-certificates fuse openssh-client

# install tinycron
RUN curl -sLo /usr/local/bin/tinycron https://github.com/bcicen/tinycron/releases/download/v0.4/tinycron-0.4-linux-amd64 && \
    chmod +x /usr/local/bin/tinycron

# add the backup script
COPY backup.sh /usr/local/bin/backup
RUN chmod +x /usr/local/bin/backup

VOLUME /repo

USER app

CMD tinycron "${CRON}" backup
