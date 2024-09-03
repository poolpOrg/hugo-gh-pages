FROM chabad360/hugo

RUN apk update && \
apk add --no-cache \
    gcompat \
    libc6-compat && \
    ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2

COPY ./docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
