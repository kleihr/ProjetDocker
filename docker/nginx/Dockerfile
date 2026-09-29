FROM nginx:alpine

COPY app/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY app/nginx/ssl /etc/nginx/ssl

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]