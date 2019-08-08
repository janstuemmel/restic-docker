FROM alpine

# install curl and restic
RUN apk add --no-cache curl restic

# install tinycron
RUN curl -sLo /usr/local/bin/tinycron https://github.com/bcicen/tinycron/releases/download/v0.4/tinycron-0.4-linux-amd64 && \
    chmod +x /usr/local/bin/tinycron

# add the backup script
COPY backup.sh /usr/local/bin/backup
RUN chmod +x /usr/local/bin/backup

RUN adduser restic --disabled-password && \
    mkdir -p /backup /repo && chown restic:restic /backup /repo

# default args
ENV CRON @daily
ENV RESTIC_REPOSITORY /repo
ENV RESTIC_PASSWORD restic

# run as user
USER restic

VOLUME /repo

CMD tinycron "${CRON}" backup
