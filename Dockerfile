#
# Builder
#
FROM abiosoft/caddy:builder as builder

ARG version="0.10.11"
ARG plugins="git"

RUN VERSION=${version} PLUGINS=${plugins} /bin/sh /usr/bin/builder.sh

#
# Final stage
#
FROM fanningert/baseimage-alpine

MAINTAINER fanningert <thomas@fanninger.at>

RUN apk update && \
    apk add --no-cache --update bash

RUN apk add --no-cache --update openssh-client

# install caddy
COPY --from=builder /install/caddy /usr/bin/caddy

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

ADD root/ /

RUN chmod -v +x /etc/services.d/*/run /etc/cont-init.d/*

VOLUME ["/etc/caddy", "/app/.caddy", "/srv"]
WORKDIR /srv
EXPOSE 80 443
