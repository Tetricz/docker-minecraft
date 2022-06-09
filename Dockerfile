# Maintainer https://github.com/Tetricz
ARG OPENJDK_VERSION=17-alpine
# https://hub.docker.com/_/openjdk
FROM openjdk:${OPENJDK_VERSION}
RUN apk add --no-cache jq curl bash
ENV MEMORY=2G

COPY . /

RUN chmod +x /entrypoint.sh
RUN curl -L https://meta.fabricmc.net/v2/versions/loader/1.19/0.14.7/0.11.0/server/jar --output /fabric-server-launch.jar
RUN curl -L https://launcher.mojang.com/v1/objects/e00c4052dac1d59a1188b2aa9d5a87113aaf1122/server.jar --output /server.jar

EXPOSE 25565/tcp 25565/udp 25575/tcp

ENTRYPOINT [ "/entrypoint.sh" ]