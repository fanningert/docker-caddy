#!/usr/bin/with-contenv bash

mkdir -p /config/cert

dockerize -template /app/start.sh:/config/start.sh
dockerize -no-overwrite -template /app/Caddyfile:/config/Caddyfile

chmod +x /config/start.sh

chown -R app:users /config
chown -R app:users /srv
