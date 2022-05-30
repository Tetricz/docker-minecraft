# Maintainer https://github.com/Tetricz
ARG OPENJDK_VERSION=17-alpine
# https://hub.docker.com/_/openjdk
FROM openjdk:${OPENJDK_VERSION}
RUN apk add --no-cache jq curl bash
ENV MEMORY=2G

COPY . /

RUN chmod +x /entrypoint.sh
RUN curl -L https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.14.6/0.10.2/server/jar --output /fabric-server-launch.jar
RUN curl -L https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar --output /server.jar

EXPOSE 25565/tcp 25565/udp 25575/tcp

ENTRYPOINT [ "/entrypoint.sh" ]