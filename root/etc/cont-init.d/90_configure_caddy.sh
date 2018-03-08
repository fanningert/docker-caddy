#!/usr/bin/with-contenv bash

mkdir -p /config

dockerize -template /app/start.sh:/config/start.sh
dockerize -no-overwrite -template /app/Caddyfile:/config/Caddyfile

chown -R app:users /config
