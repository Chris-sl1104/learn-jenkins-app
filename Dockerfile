FROM nginx:1.27-alpine
LABEL authors="Chris"
COPY build /usr/share/nginx/html


ENTRYPOINT ["top", "-b"]