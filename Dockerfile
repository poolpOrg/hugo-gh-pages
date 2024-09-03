FROM chabad360/hugo

RUN apk update && \
  apk add --no-cache hugo && \
  rm ./node_modules/hugo-bin/vendor/hugo && \
  ln -s /usr/bin/hugo ./node_modules/hugo-bin/vendor/hugo

COPY ./docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
