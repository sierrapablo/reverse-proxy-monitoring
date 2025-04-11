FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY ssl /etc/nginx/ssl
COPY .htpasswd /etc/nginx/.htpasswd

