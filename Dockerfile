
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
FROM fanningert/baseimage-alpine
LABEL maintainer fanningert <thomas@fanninger.at>
LABEL caddy_version="0.10.11"

RUN apk update && \
    apk add --no-cache --update bash
RUN apk add --no-cache --update openssh-client

# Clean up apk cache
rm -rf /var/cache/apk/*

# install caddy
COPY --from=builder /install/caddy /usr/bin/caddy

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

ADD root/ /

RUN chmod -v +x /etc/services.d/*/run /etc/cont-init.d/*

VOLUME "/srv"
WORKDIR /srv
EXPOSE 9080 9443
