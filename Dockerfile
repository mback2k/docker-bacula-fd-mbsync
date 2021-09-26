FROM ghcr.io/mback2k/docker-bacula-fd:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        isync ca-certificates && \
    apt-get clean

VOLUME /var/backups/maildirs

ENV DOCKER_MBSYNC_DIR /run/docker-mbsync.d

ADD docker-entrypoint.d/ /run/docker-entrypoint.d/

CMD ["/usr/sbin/bacula-fd", "-f"]
