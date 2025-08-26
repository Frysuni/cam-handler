FROM alpine:3.20

RUN apk add --no-cache openssh bash shadow
RUN rm -rf /var/cache/apk/*

RUN useradd -m -d /home/cam -s /bin/sh cam
RUN usermod -p '*' cam

EXPOSE 22