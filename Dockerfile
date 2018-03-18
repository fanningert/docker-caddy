#
# Builder
#
FROM abiosoft/caddy:builder as builder

ARG version="0.10.11"
ARG plugins="cors,expires,filter,ipfilter,locale,ratelimit,realip"

RUN VERSION=${version} PLUGINS=${plugins} /bin/sh /usr/bin/builder.sh

#
# Final stage
#
FROM alpine:3.7
LABEL maintainer fanningert <thomas@fanninger.at>
LABEL caddy_version="0.10.11"

RUN apk update && \
    apk add --no-cache --update bash
RUN apk add --no-cache --update openssh-client tar php-fpm

# essential php libs
RUN apk add php-curl php-gd php-zip php-iconv php-sqlite3 php-mysql php-mysqli php-json

# allow environment variable access.
RUN echo "clear_env = no" >> /etc/php/php-fpm.conf

# install caddy
COPY --from=builder /install/caddy /usr/bin/caddy

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

RUN mkdir /etc/caddy
COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html /srv/index.php

VOLUME ["/etc/caddy", "/srv"]
WORKDIR /srv
EXPOSE 80 443

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/caddy/Caddyfile", "--log", "stdout"]
