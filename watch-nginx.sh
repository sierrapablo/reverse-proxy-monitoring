#!/bin/sh

echo "[INFO] Watching for changes in /etc/nginx/conf.d (.conf only)"

inotifywait -m -e close_write,create,delete,moved_to,moved_from --format '%e %f' /etc/nginx/conf.d |
while read event file; do
    if echo "$file" | grep -qE '^\..*|~$|\.sw[px]*$|4913$'; then
        echo "[DEBUG] Ignored temporary file: $file"
        continue
    fi

    if echo "$file" | grep -q '\.conf$'; then
        echo "[INFO] Relevant event detected: $event $file"
        if nginx -t; then
            echo "[INFO] Reloading nginx"
            nginx -s reload
        else
            echo "[ERROR] nginx config is invalid, reload aborted"
        fi
    else
        echo "[DEBUG] Non-conf file ignored: $file"
    fi
done

