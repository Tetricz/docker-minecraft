# Maintainer https://github.com/Tetricz
ARG OPENJDK_VERSION=17-alpine
# https://hub.docker.com/_/openjdk
FROM openjdk:${OPENJDK_VERSION}
RUN apk add --no-cache jq curl bash
ENV MEMORY=2G

COPY . /

RUN chmod +x /entrypoint.sh
RUN curl -L curl -OJ https://meta.fabricmc.net/v2/versions/loader/1.19.1/0.14.8/0.11.0/server/jar --output /fabric-server-launch.jar
RUN curl -L https://piston-data.mojang.com/v1/objects/8399e1211e95faa421c1507b322dbeae86d604df/server.jar --output /server.jar

EXPOSE 25565/tcp 25565/udp 25575/tcp

ENTRYPOINT [ "/entrypoint.sh" ]