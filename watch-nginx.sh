#!/bin/sh

echo "[INFO] Watching for changes in /etc/nginx/conf.d (.conf only)"

inotifywait -m -e close_write,create,delete,moved_to,moved_from --format '%e %f' /etc/nginx/conf.d |
while read -r event file; do

    echo "$file" | grep -qE '^\..*|~$|\.sw[px]*$|4913$'
    if [ $? -eq 0 ]; then
        echo "[DEBUG] Ignored temporary file: $file"
        continue
    fi

    echo "$file" | grep -q '\.conf$'
    if [ $? -ne 0 ]; then
        echo "[DEBUG] Non-conf file ignored: $file"
        continue
    fi

    echo "[INFO] Relevant event detected: $event $file"

    nginx -t
    if [ $? -eq 0 ]; then
        echo "[INFO] Reloading nginx"
        nginx -s reload
    else
        echo "[ERROR] nginx config is invalid, reload aborted"
    fi
done

