#!/usr/bin/with-contenv bash

mkdir -p /config

dockerize -template /app/start.sh:/config/start.sh
dockerize -no-overwrite -template /app/Caddyfile:/config/Caddyfile

chmod +x /config/start.sh

chown -R app:users /config
