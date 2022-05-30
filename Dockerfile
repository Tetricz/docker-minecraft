# Maintainer https://github.com/Tetricz
ARG OPENJDK_VERSION=17-alpine
# https://hub.docker.com/_/openjdk
FROM openjdk:${OPENJDK_VERSION}
RUN apk add --no-cache jq curl bash
ENV MEMORY=2G

COPY . /

RUN chmod +x /entrypoint.sh

EXPOSE 25565/tcp 25565/udp 25575/tcp

ENTRYPOINT [ "/entrypoint.sh" ]