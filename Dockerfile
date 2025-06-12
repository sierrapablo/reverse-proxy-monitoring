FROM nginx:alpine

RUN apk add --no-cache inotify-tools bash

COPY ./watch-nginx.sh /usr/local/bin/watch-nginx.sh
RUN chmod +x /usr/local/bin/watch-nginx.sh

CMD ["sh", "-c", "nginx && /usr/local/bin/watch-nginx.sh"]
