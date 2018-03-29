#!/usr/bin/with-contenv bash

mkdir -p /conf/cert
mkdir -p /config

dockerize -template /app/start_caddy.sh:/config/start_caddy.sh
dockerize -no-overwrite -template /app/Caddyfile:/conf/Caddyfile

chmod +x /config/start_caddy.sh

chown -R app:users /conf
chown -R app:users /config
chown -R app:users /srv
