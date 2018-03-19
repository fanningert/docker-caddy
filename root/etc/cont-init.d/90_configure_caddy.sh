#!/usr/bin/with-contenv bash

mkdir -p /config/cert

dockerize -template /app/start_caddy.sh:/config/start_caddy.sh
dockerize -no-overwrite -template /app/Caddyfile:/config/Caddyfile

chmod +x /config/start_caddy.sh

chown -R app:users /config
chown -R app:users /srv
