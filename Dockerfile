FROM alpine:latest
RUN apk update && apk add --no-cache  bind-tools curl # for dig
RUN mkdir -p /app
RUN chmod 777 /app
WORKDIR /app
COPY . .
RUN chmod 777 /app
ENTRYPOINT /bin/sh /app/updater.sh
