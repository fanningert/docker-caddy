#!/usr/bin/with-contenv bash

mkdir -p /config/cert
mkdir -p /conf

dockerize -template /app/start_caddy.sh:/conf/start_caddy.sh
dockerize -no-overwrite -template /app/Caddyfile:/config/Caddyfile

chmod +x /conf/start_caddy.sh

chown -R app:users /conf
chown -R app:users /config
chown -R app:users /srv
