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
RUN apk add --no-cache --update openssh-client

# essential php libs
RUN apk add --no-cache --update php7-fpm
RUN apk add --no-cache --update php7-bcmath php7-curl php7-exif php7-fileinfo php7-gd php7-gettext php7-iconv php7-intl php7-json php7-mbstring php7-mcrypt php7-mysqli php7-opcache php7-pdo php7-pdo_mysql php7-pdo_sqlite php7-pear php7-soap php7-sqlite3 php7-xml php7-xmlrpc php7-xsl php7-zip php7-zlib

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
